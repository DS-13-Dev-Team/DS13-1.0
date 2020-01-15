/*
	//The master signal is the player who controls the marker. Essentially the leader of the necromorphs
*/
/mob/observer/eye/signal/master
	icon = 'icons/mob/eye.dmi'
	icon_state = "AI-eye"


/mob/observer/eye/signal/verb/become_master_signal_verb()
	set name = "Become Master Signal"
	set category = SPECIES_NECROMORPH

	if (!GLOB.marker)
		to_chat(src, "ERROR: No marker found")
		return

	if (GLOB.marker.player)
		to_chat(src, "[GLOB.marker.player] is already controlling the marker.")

		//TODO: Check here if the current marker player has been afk/disconnected for too long, and if so allow replacing them

		return

	//Possible todo: Start a poll among signal players?

	//For now, just succeed
	GLOB.marker.become_master_signal(src)



//Finds out if the passed thing is the marker player.
//The thing can be a mob, client, or ckey. They will all work
/proc/is_marker_master(var/check)
	if (!istype(GLOB.marker) || !GLOB.marker.player)
		return FALSE	//If theres no marker there cant be a master

	//This all works on key checking anyways, so lets start by finding the key
	var/check_key
	if (ismob(check))
		var/mob/M = check
		if (!M.key)
			//If theres no key its not the master
			return FALSE
		check_key = M.key
	else if (isclient(check))
		var/client/C = check
		check_key = C.ckey
	else
		check_key = check

	if (!check_key)
		return FALSE

	//Okay we have a key, lets see if it matches
	//Possible future todo: Support for multiple markers here. For now, just one
	if (GLOB.marker.player == check_key)
		//It matches! At last,
		return TRUE

	else
		return FALSE