
/mob/living/Login()
	..()
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)

	//These three procs instantly create the blinding/sleep overlay
	handle_regular_status_updates() //This checks paralysis and sets stat
	handle_disabilities() //This checks stat and sets eye_blind
	handle_regular_hud_updates() //This checks eye_blind and adds or removes the hud overlay
	return .
