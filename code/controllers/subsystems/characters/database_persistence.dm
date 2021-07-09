/*
	This system handles persistent content and player vars which are stored in an external database
	It loads them as soon as possible when the server boots
	It also saves things back to the database, generally at a minimum interval of once a minute, but it can do it on demand

	Currently used for:
		Characters, generally
		Persistent credits
		Store schematics

	Planned future uses:
		Skills?
*/

//TODO: Fix depositing credits from chip to rig
SUBSYSTEM_DEF(database)
	name = "Database"
	init_order = SS_INIT_MISC_LATE
	wait = 1 MINUTE

	//A cache, stores the value from get_unknown_designs
	var/list/unknown_designs

	//A list of mind datums whose credit amounts have changed recently, and are queued for updates
	//These are batched into one per mind per minute, as needed, to reduce database load.
	//So we're not sending a flurry of requests if someone is shuffling around chips in their inventory
	var/list/credits_to_update = list()




/datum/controller/subsystem/database/Initialize()



/datum/controller/subsystem/database/fire(resumed = 0)
	for (var/datum/mind/M as anything in credits_to_update)
		update_lastround_credits(M)

	credits_to_update = list()










/*
	Credit Handling
*/
/datum/controller/subsystem/database/proc/credits_changed(var/datum/mind/M)
	credits_to_update |= M

//Mob level helper
/mob/proc/credits_changed()
	world << "[src] credits changed"
	if (mind)
		SSdatabase.credits_changed(mind)

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
/datum/controller/subsystem/database/proc/process_pending_credits()

	var/DBQuery/query = dbcon.NewQuery("SELECT * FROM credit_lastround")
	query.Execute()

	//Lets fetch the records for each character
	while(query.NextRow())
		var/id = text2num(query.item[1])
		var/stored = text2num(query.item[2])
		var/carried = text2num(query.item[3])
		var/status = text2num(query.item[4])



		if (!id)
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
		query = dbcon.NewQuery("UPDATE credit_records	SET credits = [total] WHERE character_id = [id];")
		query.Execute()

		if (total_fees)
			message_character(id, SPAN_NOTICE("CEC has charged you a total of [total_fees] credits in holding fees."))



	//Alright we are done with the pending stuff, wipe it
	query = dbcon.NewQuery("TRUNCATE TABLE credit_lastround;")
	query.Execute()


//Called at server start
/hook/database_connected/proc/handle_lastround_credits()
	SSdatabase.process_pending_credits()

	return TRUE	//Needed to let the hook know we handled things okay

//Called at round end
/hook/roundend/proc/handle_endround_credits()
	SSdatabase.process_pending_credits()










/*
	Schematic Handling
	See store_schematic and store_designs for more info

*/

//This returns a list of all design IDs which are not known to the store. These can thusly be used for assigning to new schematics
/proc/get_unknown_designs()
	if (!SSdatabase.unknown_designs)


		//This gets a list of every design that exists
		var/list/designs = SSresearch.design_ids.Copy()

		//We need to filter it to contain only designs that are valid for store use
		for (var/id in designs)
			var/datum/design/D = designs[id]
			if (!(D.build_type & STORE))
				designs -= id


		//Now lets get the list of all persisting schematics in the database
		var/DBQuery/query = dbcon.NewQuery("SELECT * FROM store_schematics;")
		query.Execute()

		//We loop through the db results and subtract any design in it, from the all-list.
		while (query.NextRow())
			var/schematic_id = query.item[1]
			designs -= schematic_id

		//Now designs only contains things which aren't in the DB

		//Cache this
		SSdatabase.unknown_designs	=	designs

	//TODO: Null this out when a new schematic is uploadeds
	return SSdatabase.unknown_designs



/proc/upload_design(var/id)

	var/DBQuery/query = dbcon.NewQuery("INSERT INTO store_schematics	(store_schematic)	VALUES([id]);")
	query.Execute()

	//We loop through the db results and subtract any design in it, from the all-list.
	while (query.NextRow())