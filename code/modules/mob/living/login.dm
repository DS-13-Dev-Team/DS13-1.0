
/mob/living/Login()
	..()
	//Mind updates
	mind_initialize()	//updates the mind (or creates and initializes one if one doesn't exist)
	mind.active = 1		//indicates that the mind is currently synced with a client
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)

	//These three procs instantly create the blinding/sleep overlay
	handle_regular_status_updates() //This checks paralysis and sets stat
	handle_disabilities() //This checks stat and sets eye_blind
	handle_regular_hud_updates() //This checks eye_blind and adds or removes the hud overlay
	return .
