SUBSYSTEM_DEF(necromorph)
	name = "Necromorph"
	init_order = SS_INIT_DEFAULT
	flags = SS_NO_FIRE

	//Necromorph Lists
	var/list/major_vessels = list()	//Necromorphs that need a player to control them. they are inert husks without one.
	var/list/minor_vessels	=	list()	//Necromorphs that have AI and don't need a player, but can be posessed anyway if someone wants to do manual control

	//Signal Lists
	var/list/necroqueue = list()	//This is a list of signal players who are waiting to be put into the first available major vessel

	//Marker
	var/obj/machinery/marker/marker

	//Players
	var/list/necromorph_players = list()	//This is a list of keys and mobs of players on the necromorph team


/datum/controller/subsystem/necromorph/proc/join_necroqueue(var/mob/M)
	if (is_marker_master(M))
		//The master may not queue. They can still posess things if really needed though
		return FALSE
	necroqueue |= M
	to_chat(M, SPAN_NOTICE("You are now in the necroqueue. When a necromorph vessel is available, you will be automatically placed in control of it. You can still manually posess necromorphs."))



/datum/controller/subsystem/necromorph/proc/remove_from_necroqueue(var/mob/M)
	necroqueue -= M



/datum/controller/subsystem/necromorph/proc/fill_vessel_from_queue(var/mob/vessel)
	for (var/mob/observer/eye/signal/M in necroqueue)
		if (!M.client || !M.key)
			continue	//Gotta be connected

		//TODO here: Preferences checks to see if they're willing to play this type

		//If we get here, they'll do.
		vessel.key = M.key	//Move into the mob and delete the old
		qdel(M)
		return TRUE
	return FALSE	//Return false if we failed to find anyone


/proc/message_necromorphs(var/message)
	for (var/key in SSnecromorph.necromorph_players)
		var/mob/M = SSnecromorph.necromorph_players[key]
		to_chat(M, message)