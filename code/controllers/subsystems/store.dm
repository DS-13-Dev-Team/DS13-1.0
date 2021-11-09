#define FREE_SCHEMATICS 20
#define SCHEMATICS_LOSS 0.05

SUBSYSTEM_DEF(store)
	name = "Store"
	init_order = SS_INIT_STORE

	//Design caches
	var/list/known_designs
	var/list/unknown_designs

	var/list/pending_schematics = list()

	//A list of mind datums whose credit amounts have changed recently, and are queued for updates
	//These are batched into one per mind per minute, as needed, to reduce database load.
	//So we're not sending a flurry of requests if someone is shuffling around chips in their inventory
	var/list/credits_to_update = list()

/datum/controller/subsystem/store/stat_entry(msg)
	return "Click to debug!"

/datum/controller/subsystem/store/fire(resumed = 0)
	for (var/datum/mind/M as anything in credits_to_update)
		update_lastround_credits(M)

	credits_to_update = list()

/*
	Credit Handling
*/
/datum/controller/subsystem/store/proc/credits_changed(var/datum/mind/M)
	credits_to_update |= M

//Mob level helper
/mob/proc/credits_changed()
	if (mind)
		SSstore.credits_changed(mind)

//Item helper
/obj/item/proc/credits_changed()
	var/mob/M = get_holding_mob()
	if(M)
		M.credits_changed()

/*
	This proc cleans out the credit_lastround table, and converts it into actual changes to each character's stored credits,
	which are committed to the credit_records table
	This is called exactly twice per round:	World boot, and end of round
	In most cases, the end of round call will handle everything and the table will be empty next round
	However, in case of a crash, the endround processing may not happen, so its run at the start to cover last round's changes
*/
/datum/controller/subsystem/store/proc/process_pending_credits()
	log_debug("Updating pending credits")
	log_debug("------------------------------------")
	var/successes = 0
	var/attempts = 0
	if(!SSdbcore || !SSdbcore.IsConnected())
		log_debug("No database connection, failed")
		return null

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT * FROM credit_lastround")
	query.Execute()

	//Lets fetch the records for each character
	while(query.NextRow())
		attempts++
		var/id = text2num(query.item[1])
		var/stored = text2num(query.item[2])
		var/carried = text2num(query.item[3])
		var/status = text2num(query.item[4])

		log_debug("Uploading credits: id:[id] Stored: [stored]	Carried: [carried]	Status: [status]")



		if (!id)
			log_debug("No ID, cannot update")
			continue	//Failsafe

		var/total_fees = 0

		//Lets process the held credits first.
		//There are three status, living, dead, and escaped. But we're only interested in the first one
		//In the case that they died, the processing needed happened instantly on death, we dont repeat it here
		//In the case that they escaped, we don't take any of their credits.
		//So here, we're only applying a fee to held credits if they lived to the end of the round, but did not escape the ship.
			//This includes going afk/cryo/hiding out on aegis
		if (status == STATUS_LIVING)
			total_fees += carried * FEE_NEUTRAL
			carried *= 1 - FEE_NEUTRAL

		//Next, the stored credits, this is simple
		total_fees += stored * FEE_NEUTRAL
		stored *= 1 - FEE_NEUTRAL

		//Add them up
		var/total = carried + stored

		//And lets write the new value back to the database
		var/qstring = "UPDATE credit_records	SET credits = [total] WHERE character_id = [id];"
		var/datum/db_query/upload_query = SSdbcore.NewQuery(qstring)
		var/result = upload_query.Execute()
		qdel(upload_query)
		log_debug("Update credit query: [qstring]\n\
		\n\
		result is [result]")
		if (result == TRUE)
			successes++

		if (total_fees)
			message_character(id, SPAN_NOTICE("CEC has charged you a total of [total_fees] credits in holding fees."))


	qdel(query)

	log_debug("Finished uploading credits, [successes]/[attempts] successful")
	//Alright we are done with the pending stuff, wipe it
	query = SSdbcore.NewQuery("TRUNCATE TABLE credit_lastround;")
	query.Execute()
	qdel(query)



/*
	Schematic Handling
	See store_schematic and store_designs for more info

*/

//This returns a list of all design IDs which are not known to the store. These can thusly be used for assigning to new schematics
/datum/controller/subsystem/store/proc/update_store_designs()

	known_designs = list()
	unknown_designs = list()

	//This gets a list of every design that exists
	var/list/designs = SSresearch.design_ids.Copy()

	if (!length(designs))
		return	//Fatal error

	//We need to filter it to contain only designs that are valid for store use
	for (var/id in designs)
		var/datum/design/D = designs[id]
		if (!(D.build_type & STORE))
			designs -= id

		//Custom items, they dont belong in normal lists
		if (D.patron_only || D.whitelist)
			designs -= id

	if(SSdbcore && SSdbcore.IsConnected())


		//Now lets get the list of all persisting schematics in the database
		var/datum/db_query/query = SSdbcore.NewQuery("SELECT * FROM store_schematics;")
		query.Execute()

		//We loop through the db results and subtract any design in it, from the all-list.
		while (query.NextRow())
			var/schematic_id = query.item[1]
			if (!(schematic_id in designs))
				//Garbage ID, remove from database
				var/datum/db_query/Q2 = SSdbcore.NewQuery("DELETE FROM store_schematics WHERE store_schematic=\"[schematic_id]\";")
				Q2.Execute()
				qdel(Q2)
				continue

			designs -= schematic_id
			SSstore.known_designs += schematic_id

		//Now designs only contains things which aren't in the DB

		//Cache this
		unknown_designs	=	designs
		qdel(query)
	else
		SSstore.known_designs = designs

	//And now reload the database for individual stores
	load_store_database()


	//Now all thats done, if there were any schematics waiting on this moment, lets allow them to do their thing now
	for (var/obj/item/store_schematic/SS in pending_schematics)
		SS.get_design()
	pending_schematics.Cut()



/datum/controller/subsystem/store/proc/upload_design(var/id)

	if(!SSdbcore || !SSdbcore.IsConnected())
		return null

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT * FROM store_schematics	WHERE (store_schematic = \"[id]\");")
	query.Execute()

	//If this returns anything, then that schematic already existed, return false
	if (query.NextRow())
		return FALSE

	query = SSdbcore.NewQuery("INSERT INTO store_schematics	(store_schematic)	VALUES(\"[id]\");")
	query.Execute()

	qdel(query)

	//We're uploading something new, lets update this
	update_store_designs()

	return TRUE




//Handle end of round loss
/hook/roundend/proc/handle_endround_schematics()
	SSstore.handle_endround_schematics()
	return TRUE

/datum/controller/subsystem/store/proc/handle_endround_schematics()

	if(!SSdbcore || !SSdbcore.IsConnected())
		return null

	//Now lets get the list of all persisting schematics in the database
	var/datum/db_query/query = SSdbcore.NewQuery("SELECT * FROM store_schematics	ORDER BY upload_date ASC;")
	query.Execute()

	var/total = query.RowCount()
	total -= FREE_SCHEMATICS

	qdel(query)

	if (total <= 0)
		//not enough, we're done
		return

	var/list/data = query.GetData()


	var/num_to_remove = round(total * SCHEMATICS_LOSS, 1)
	//Always remove at least one
	if (num_to_remove < 1)
		num_to_remove = 1


	var/list/deleted_ids = list()

	while(num_to_remove > 0)
		num_to_remove--
		//Lets pick one from the list, averaged towards the earlier items
		var/index = clamp(round(rand()*0.75*length(data),1), 1, length(data))

		//This is a list of ID and date
		var/list/record = data[index]
		var/schematic_id = record[1]

		//Store a note of what we removed
		deleted_ids += schematic_id

		//Remove from database
		var/datum/db_query/Q2 = SSdbcore.NewQuery("DELETE FROM store_schematics WHERE store_schematic=\"[schematic_id]\";")
		Q2.Execute()

		qdel(Q2)

		//Remove from that data list too
		data.Cut(index, index+1)

		if (length(data) < 1)
			break	//Shouldn't happen

	if (length(deleted_ids))
		command_announcement.Announce("Data Corruption detected in schematic database. [length(deleted_ids)] schematics corrupted.", new_sound = sound('sound/misc/interference.ogg', volume=25))
