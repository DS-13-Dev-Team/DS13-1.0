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
	var/datum/outfit/outfit		//The base job outfit

	var/is_patron	= FALSE	//The player has patron status

	var/datum/preferences/prefs

	var/points
	var/max_points

	var/list/tags = list()
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
		var/list/shared = G.exclusion_tags & tags
		if (shared && shared.len)
			return FALSE	//We have one of the tags which excludes it

	if (G.required_tags.len)
		var/list/shared = G.required_tags & tags
		if (!shared || shared.len != G.required_tags.len)
			return FALSE

	if (points < G.cost)
		return FALSE

	if (G.patron_only && !is_patron)
		return FALSE
	//TODO: Safety Checks

	gear_list += G
	update_gear()
	return TRUE

/datum/extension/loadout/proc/remove_gear(var/datum/gear/G)
	if (!(G in gear_list))
		return FALSE

	//TODO: Safety Checks
	gear_list -= G
	update_gear()
	return TRUE


//Called when something is added or removed
//This updates point totals, exclusion tags, and any other stuff
//Safety checking is already done by this point
/datum/extension/loadout/proc/update_gear()
	points = max_points
	tags = list()
	for (var/datum/gear/G in gear_list)
		points -= G.cost
		tags |= G.tags



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