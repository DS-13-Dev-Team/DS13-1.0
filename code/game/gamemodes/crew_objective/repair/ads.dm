/*
	The Asteroid Defense System
*/
/datum/crew_objective/ads


/datum/crew_objective/ads/on_activate()
	/*
		The autotargeting breaks, no more protection from meteors
	*/
	GLOB.asteroid_cannon.break_down()


/datum/crew_objective/ads/announce_activate()
	.=..()
	command_announcement.Announce("Warning: Asteroid Defense System failure. Automated targeting is now offline. Engineering support requested immediately to Asteroid Defense Housing, Deck 5, Fore.", "System Failure")


/datum/crew_objective/ads/announce_fade()
	.=..()
	command_announcement.Announce("Asteroid Defense System is now restored to full functionality. Please repair any damage suffered in the interim.", "System Failure")

/datum/crew_objective/ads/get_epicentre()
	return GLOB.asteroid_cannon