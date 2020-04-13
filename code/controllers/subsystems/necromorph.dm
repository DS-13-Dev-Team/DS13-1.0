SUBSYSTEM_DEF(necromorph)
	name = "Necromorph"
	init_order = SS_INIT_DEFAULT
	flags = SS_NO_FIRE

	//Necromorph Lists
	var/list/major_vessels = list()	//Necromorphs that need a player to control them. they are inert husks without one.
	var/list/minor_vessels	=	list()	//Necromorphs that have AI and don't need a player, but can be posessed anyway if someone wants to do manual control

	//Signal Lists
	var/list/signals	=	list()	//List of all signal players
	var/list/necroqueue = list()	//This is a list of signal players who are waiting to be put into the first available major vessel

	//Marker
	var/obj/machinery/marker/marker

	//Players
	var/list/necromorph_players = list()	//This is a list of keys and mobs of players on the necromorph team

	//Sightings of prey. See  code/modules/necromorph/corruption/eye.dm
	var/list/sightings = list()


/datum/controller/subsystem/necromorph/proc/join_necroqueue(var/mob/observer/eye/signal/M)
	if (is_marker_master(M))
		//The master may not queue. They can still posess things if really needed though
		return FALSE
	necroqueue |= M
	M.verbs -= /mob/observer/eye/signal/proc/join_necroqueue
	M.verbs |= /mob/observer/eye/signal/proc/leave_necroqueue
	to_chat(M, SPAN_NOTICE("You are now in the necroqueue. When a necromorph vessel is available, you will be automatically placed in control of it. You can still manually posess necromorphs."))



/datum/controller/subsystem/necromorph/proc/remove_from_necroqueue(var/mob/observer/eye/signal/M)
	M.verbs |= /mob/observer/eye/signal/proc/join_necroqueue
	M.verbs -= /mob/observer/eye/signal/proc/leave_necroqueue
	necroqueue -= M




/datum/controller/subsystem/necromorph/proc/fill_vessel_from_queue(var/mob/vessel, var/vessel_id)
	for (var/mob/observer/eye/signal/M in necroqueue)
		if (!M.client || !M.key)
			continue	//Gotta be connected

		//The id is used to check preferences
		if (vessel_id in M.client.prefs.never_be_special_role)
			continue	//They don't wanna be this kind of necro, skip them

		//If we get here, they'll do.
		vessel.key = M.key	//Move into the mob and delete the old
		qdel(M)
		GLOB.unitologists.add_antagonist(vessel.mind)
		return TRUE
	return FALSE	//Return false if we failed to find anyone



//Sighting handling
//-----------------------
/*
	Keeping track of last known locations of live humans
*/
/datum/controller/subsystem/necromorph/proc/update_sighting(var/mob/living/AM, var/obj/structure/corruption_node/eye/spotter)
	//We don't record dead mobs, remove them from this list
	if (AM.stat == DEAD || QDELETED(AM))
		sightings.Remove(AM)
		return 0	//This is numerically zero, not just false

	//If we've ever seen this mob before, get their data from the list
	var/datum/sighting/S = sightings[AM]
	if (!istype(S))
		//If we get here, they're new
		S = new()
		S.thing = AM
		sightings[AM] = S

	var/last_time = S.last_time

	S.last_time = world.time
	S.last_location = get_turf(AM)

	var/difference = S.last_time - last_time

	//Message all the necros with a useable jumplink
	if (istype(spotter))
		if (difference >= spotter.minimum_notify_delay)
			for (var/key in SSnecromorph.necromorph_players)
				var/mob/M = SSnecromorph.necromorph_players[key]
				to_chat(M, SPAN_WARNING("[AM] detected at [jumplink_public(M, S.last_location)]"))


	//We will return the difference between last and current time. Eyes may do something with this
	return (difference)







//Possible future todo: Allow this to take some kind of faction id in order to allow a necros vs necros gamemode
/proc/get_marker()
	if (SSnecromorph)
		return SSnecromorph.marker


//Updates the energy holders of all necromorph players, refreshing their spell list
/datum/controller/subsystem/necromorph/proc/update_all_ability_lists(var/clear = FALSE)
	for (var/key in GLOB.players)
		var/datum/player/P = GLOB.players[key]
		var/datum/extension/psi_energy/PE = P.get_energy_extension()
		if (PE)
			PE.build_ability_list(clear)
			to_chat(P.get_mob(), "<span class='necromarker'>The marker has awoken, new abilities are unlocked. Check your abilities menu!</span>")