/*
	/datum/extension/loadout is a datum which acts as an umbrella to handle all the things a human will wear just before spawning in.

	It is typically stored on a mob after it is created, where it can be populated with more data before it is applied.
	Typically, it will be deleted after applying to a mob spawned into the world

	Loadout holders are not serialized. They are created at runtime to hold gear loaded from disk

	It is comprised of two main components:
	1. Outfit. Typically taken from the assigned job, a baseline outfit is retrieved and copied into here. It must be copied
	because it will be edited

	2. Gear datums, IE the usual loadout stuff.

	Before anything is put onto the player, these two types of things are gathered and mixed, they work out their differences.
	Typically, gear datums take precedence, and may disable or displace parts of the outfit

	This datum also validates the gear, making sure the user isn't trying to take two rigs, two pairs of shoes, or
	patron items when they're not a patron

	After the mixing is done, then the whole loadout is equipped onto the player in this order:,
		1. modified-outfit
		2. gear datums
		3. Stored items
*/
/datum/extension/loadout
	flags = EXTENSION_FLAG_IMMEDIATE

	var/gear_slot = 1	//Which gear slot is this for

	var/list/gear_list 			//Custom/fluff item loadouts.
	var/decl/hierarchy/outfit/outfit			//Our modified version of the job outfit
	var/decl/hierarchy/outfit/outfit_original //The base job outfit
	var/equip_adjustments = 0	//Bitfield for adjustement instructions sent to the outfit, compiled from gear datums

	var/datum/job/job	//Job datum

	var/is_patron	= FALSE	//The player has patron status

	var/datum/preferences/prefs

	var/points
	var/max_points

	var/list/gear_tags = list()

	var/mob/living/carbon/human/H



	//Used for human handling
	var/rank
	var/assignment

	//Set during equipping
	var/list/spawn_in_storage = list()
	var/list/loadout_taken_slots = list()


/datum/extension/loadout/Destroy()
	if (prefs && prefs.loadout == src)
		prefs.loadout = null
	outfit = null
	outfit_original = null
	prefs = null
	H = null
	job = null
	gear_list = list()
	.=..()

/*
	Setup
*/
//Takes a preference input and sets ourself up
/datum/extension/loadout/proc/set_prefs(var/datum/preferences/input)

	prefs = input

	//Set patron status
	is_patron = FALSE
	var/datum/player/P = get_player_from_key(prefs.client_ckey)
	if (P.patron)
		is_patron = TRUE


	clear_data()


	gear_slot = input.gear_slot




	//Lets validate and add all the gear
	for (var/thing in prefs.Gear())

		//This is a list of gear names, we must retrieve the datums from a global list, they are singletons
		var/datum/gear/G = GLOB.gear_datums[thing]

		//Each retrieved thing is added to our loadout datum
		//If this returns false, adding failed, the item was invalid. In this case it must be removed from preferences too
		if (!add_gear(G))
			prefs.gear_list[gear_slot] -= thing

//Takes a job datum or a job name,
/datum/extension/loadout/proc/set_job(var/datum/job/newjob, var/set_rank = TRUE)
	if (job == newjob)
		return

	if (!istype(newjob))
		newjob = job_master.GetJob(newjob) //We might have been supplied a jobname instead of a datum

	if (istype(newjob))
		job = newjob
		if (set_rank)
			set_rank_and_assignment()
		set_outfit(set_rank)

//Called whenever mob, job or outfit are set. A cascading series of priorities that determines the rank and assignment used for IDs and pdas
/datum/extension/loadout/proc/set_rank_and_assignment()
	if (job)
		rank = job.title

	if (H)
		assignment = H.mind ? H.mind.role_alt_title : ""


	if (outfit)
		//This rank mess needs sorting out
		rank = outfit.id_pda_assignment || rank
		assignment = outfit.id_pda_assignment || assignment || rank
		/*
		var/obj/item/weapon/card/id/W = outfit.equip_id(H, rank, assignment, equip_adjustments)
		if(W)
			rank = W.rank
			assignment = W.assignment*/


//Attempts to fetch our outfit from the job datum
//If the human mob is already set, outfit fetching will have more accurate results
/datum/extension/loadout/proc/set_outfit(var/set_rank = TRUE)
	if (!job)
		return

	if (H)
		outfit_original = job.get_outfit(H, H.mind ? H.mind.role_alt_title : "", H.char_branch, H.char_rank)
	else
		outfit_original = job.get_outfit()

	outfit = outfit_original.copy()

	if (set_rank)
		set_rank_and_assignment()

/*
	Resets our outfit back to the unmodified default.
	This is called when things are removed from the gear list (but not when they're added)
*/
/datum/extension/loadout/proc/reset_outfit()
	if (outfit_original)
		outfit = outfit_original.copy()

/*
	Sets the human this outfit will be applied to, allowing us to get more accurate job outfits.
	This is not an inherent property since loadouts are first created in abstract, in the character setup screen, and only later applied to a mob

*/
/datum/extension/loadout/proc/set_human(var/mob/living/carbon/human/newhuman)
	if (H == newhuman)
		return

	if (istype(newhuman))
		H = newhuman
		set_rank_and_assignment()




//Clears out old data in preparation for changing prefs or slot
/datum/extension/loadout/proc/clear_data()

	reset_points()
	gear_list = list()	//Reset this
	update_gear()

/datum/extension/loadout/proc/reset_points()
	max_points = config.max_gear_cost

	//Possible todo here: support for varying max points
	points = max_points




/*
	Gear Handling
*/
//This takes a gear item into our list, after checking it for validity
/datum/extension/loadout/proc/add_gear(var/datum/gear/G)
	if (G.exclusion_tags.len)
		var/list/shared = G.exclusion_tags & gear_tags
		if (shared && shared.len)
			return FALSE	//We have one of the tags which excludes it

	if (G.required_tags.len)
		var/list/shared = G.required_tags & gear_tags
		if (!shared || shared.len != G.required_tags.len)
			return FALSE

	if (points < G.cost)
		return FALSE

	if (G.patron_only && !is_patron)
		return FALSE
	//TODO: Safety Checks

	gear_list += G
	if (gear_list.len >= 2)
		sortTim(gear_list, /proc/cmp_gear_priority)
	update_gear()
	mix_gear()
	return TRUE

/datum/extension/loadout/proc/remove_gear(var/datum/gear/G)
	if (!(G in gear_list))
		return FALSE

	//TODO: Safety Checks
	gear_list -= G
	reset_outfit()	//When we remove gear, we must reset our changes to the outfit
	update_gear()
	mix_gear()
	return TRUE


//Called when something is added or removed
//This updates point totals, exclusion tags, and any other stuff
//Safety checking is already done by this point
/datum/extension/loadout/proc/update_gear()
	points = max_points
	gear_tags = list()
	equip_adjustments = 0
	for (var/datum/gear/G in gear_list)
		points -= G.cost
		gear_tags |= G.tags
		equip_adjustments |= G.equip_adjustments


/*
	Called when we have both outfit and gear.
	This is a one way, destructive process which removes things from the outfit
	To undo its, call reset_outfit and then mix again with a new gear list
*/
/datum/extension/loadout/proc/mix_gear()
	if (!outfit || !gear_list.len)
		return

	var/list/outfit_data = outfit.get_slotted_item_paths()

	//First of all, slot overriding
	//Here we handle deleting things from the outfit which claim a slot that the loadout has also claimed. Loadout gets preference
	for (var/datum/gear/G in gear_list)
		//This gear doesnt want to override
		if (!G.override_slot)
			continue

		//This gear claims no slot
		if (!G.slot)
			continue

		//This gear claims a slot which doesn't do overriding
		if ((G.slot in LOADOUT_SLOT_STORE))
			continue

		//This gear claims multiple possible slots, too complex to handle here
		if (islist(G.slot))
			continue


		//Alright, once we get here, we have a gear item which is claiming a specific slot, and wants to evict any existing outfit
		// item from that slot, in order to take control.
		for (var/list/outfit_item in outfit_data)
			//Outfit item is a sublist in the format: list(inventory slot, outfit_slot,typepath, quantity)

			//We only care if we match the inventory slot
			if (G.slot == outfit_item[1])

				//We've found the thing that was blocking us, we're gonna remove it
				var/outfit_slot = outfit_item[2]

				//And thats it, the outfit no longer contains the offending item
				outfit.vars[outfit_slot] = null



		//Right next up is tag handling. The outfit does this to itself, we pass it a list of tags to exclude
		outfit.filter_loadout_tags(gear_tags)


/*
	Actually equip the loadout, after all setup
*/
/datum/extension/loadout/proc/equip_to_mob()

	//Some additional preparation, lets divide the gear into two lists based on whether or not they have any job/role restrictions. This is critical
	var/list/unrestricted_gear = list()
	var/list/restricted_gear = list()
	for(var/datum/gear/G in gear_list)
		if (G.allowed_roles || G.allowed_branches || G.whitelisted || G.priority > 1)
			//Items with a larger than normal priority go here too, since they may depend on something else
			restricted_gear += G

		else
			unrestricted_gear += G

	//Let the outfit know its about to be equipped
	outfit.pre_equip(H)

	//Right lets start equipping

	//First of all, we equip the base of the outfit
	outfit.equip_base(H, equip_adjustments, TRUE)


	//Secondly, we'll equip our unrestricted gear items
	for(var/datum/gear/G in unrestricted_gear)
		equip_gear(G, FALSE)


	//Thirdly, we'll equip the ID, this may change our access, hence why we cut the gear list in two
	var/obj/item/weapon/card/id/W = outfit.equip_id(H, rank, assignment, equip_adjustments)
	if(W)
		rank = W.rank
		assignment = W.assignment


	//Fourthly, we equip any restricted gear
	for(var/datum/gear/G in restricted_gear)
		equip_gear(G)


	//Fifth, the PDA if applicable
	outfit.equip_pda(H, rank, assignment, equip_adjustments)


	//Sixth, stored items
	outfit.equip_stored(H, equip_adjustments)
	for(var/datum/gear/G in spawn_in_storage)
		G.spawn_in_storage_or_drop(H, prefs.Gear()[G.display_name])

	//Seventh: Some finishing touches
	if(!(OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP & equip_adjustments))
		outfit.post_equip(H)
	H.regenerate_icons()
	if(W) // We set ID info last to ensure the ID photo is as correct as possible.
		H.set_id_info(W)







/datum/extension/loadout/proc/equip_gear(var/datum/gear/G, var/check_job = TRUE)
	if (check_job && !G.job_permitted(H, job))
		to_chat(H, "<span class='warning'>Your current species, job, branch or whitelist status does not permit you to spawn with [G]!</span>")
		return

	//Gear doesnt claim a slot, or its slot is taken by another gear, into storage it goes
	if(!G.slot || G.slot == slot_tie || (G.slot in loadout_taken_slots))
		spawn_in_storage.Add(G)
		return

	//Gear wants to do its own snowflake equipping routine. Let it do so, and assume it succeeded
	if (G.slot == GEAR_EQUIP_SPECIAL)
		G.spawn_special(H, prefs.Gear()[G.display_name])
		return	//This cannot fail so no need for checks

	//Normal spawning into a mob's equipment slots
	else if (!G.spawn_on_mob(H, prefs.Gear()[G.display_name]))
		//If that fails, it goes into storage
		spawn_in_storage.Add(G)
		return

	else
		//If success, we add its slot to the taken slots
		loadout_taken_slots.Add(G.slot)



/datum/extension/loadout/proc/sanitize()
	//Processes through the gear list, checks for invalid things




	/*
	for(var/index = 1 to config.loadout_slots)
		var/list/gears = pref.gear_list[index]

		if(istype(gears))
			for(var/gear_name in gears)
				if(!(gear_name in gear_datums))
					gears -= gear_name

			var/total_cost = 0
			for(var/gear_name in gears)
				if(!gear_datums[gear_name])
					gears -= gear_name
				else if(!(gear_name in valid_gear_choices()))
					gears -= gear_name
				else
					var/datum/gear/G = gear_datums[gear_name]

					//If patron status is needed, check that we have it
					if (P && G.patron_only && !P.patron)
						gears -= gear_name
						continue

					if(total_cost + G.cost > config.max_gear_cost)
						gears -= gear_name
					else
						total_cost += G.cost
		else
			pref.gear_list[index] = list()
*/