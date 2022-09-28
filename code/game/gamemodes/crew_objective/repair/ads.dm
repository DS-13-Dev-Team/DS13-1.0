/*
	The Asteroid Defense System
*/
/datum/crew_objective/ads
	name = "Asteroid Defense System"
	areas = list(AREA_SPAWNING = list(/area/necrospawn/ads/channel_port,
	/area/necrospawn/ads/channel_starboard,
	/area/necrospawn/ads/cannon_housing = 0.51),
	AREA_COMBAT = list(/area/ishimura/external/channel,
	/area/ishimura/external/channel/second,
	/area/ishimura/eva/ADS,
	/area/ishimura/eva/prep/ADS,
	/area/ishimura/eva/airlock/ADS,)
	)//This third one opens just after the halfway point


	//Progress Values:
	/*Values:
		0: Nobody has entered the channel
		0.1: People have entered the channel
		0.25: People have gotten halfway along the channel
		0.5: People have entered the cannon housing
		0.51: Repairs on the cannon have started
		1: Cannon repair complete
	*/


	necromorphs = list(SPECIES_NECROMORPH_SLASHER = 1.5,
	SPECIES_NECROMORPH_LEAPER = 2,
	SPECIES_NECROMORPH_LURKER = 1,
	SPECIES_NECROMORPH_SPITTER = 1,
	SPECIES_NECROMORPH_BRUTE = 1)


	biomass_payouts = list(
		list("quantity" = OBJECTIVE_BIOMASS_VERY_LOW, threshold = 0),
		list("quantity" = OBJECTIVE_BIOMASS_LOW, threshold = 0.25),
		list("quantity" = OBJECTIVE_BIOMASS_LOW, threshold = 0.51),
		list("quantity" = OBJECTIVE_BIOMASS_MED, threshold = 0.75))


/datum/crew_objective/ads/on_activate()
	/*
		The autotargeting breaks, no more protection from meteors
	*/
	GLOB.asteroidcannon.break_down()


/datum/crew_objective/ads/announce_activate()
	.=..()
	command_announcement.Announce("Warning: Asteroid Defense System failure. Automated targeting is now offline. Engineering support requested immediately to Asteroid Defense Housing, Deck 5, Fore.", "System Failure", new_sound = 'sound/misc/redalert1.ogg')


/datum/crew_objective/ads/announce_fade()
	.=..()
	command_announcement.Announce("Asteroid Defense System is now restored to full functionality. Please repair any damage suffered in the interim.", "System Failure")

/datum/crew_objective/ads/get_epicentre()
	return GLOB.asteroidcannon



/datum/crew_objective/ads/get_progress()
	.=0

	//We work backwards

	//Gun working? we're done
	if (GLOB.asteroidcannon.operational)
		SET_PROGRESS(1)

	//If the repair is underway, we are between 0.51 to 0.9999
	else if (GLOB.asteroidcannon.console.rebooting)

		//The granular value isnt currently important though
		SET_PROGRESS(Interpolate(0.51, 0.99, GLOB.asteroidcannon.console.progress))

	//Alright now we get into checking areas
	else
		//Are they in the cannon housing?
		var/area/A = locate(/area/ishimura/eva/ADS)
		if (A && area_contains_crew(A))
			SET_PROGRESS(0.5)
		else
			A = locate(/area/ishimura/external/channel/second)
			if (A && area_contains_crew(A))
				SET_PROGRESS(0.25)
			else
				A = locate(/area/ishimura/external/channel)
				if (A && area_contains_crew(A))
					SET_PROGRESS(0.1)

	return max(., min_progress)




/*
	Spawning Areas
*/
/area/necrospawn/ads/channel_port
	name = "ADS Channel: Port"

/area/necrospawn/ads/channel_starboard
	name = "ADS Channel: Starboard"

/area/necrospawn/ads/cannon_housing
	name = "ADS Cannon Housing"
