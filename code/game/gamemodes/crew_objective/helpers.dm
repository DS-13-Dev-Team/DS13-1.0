/*
	This complicated proc automated the process of messing with the event manager window to trigger a crew objective
*/
/proc/trigger_crew_objective(var/objective_type)
	//Grab the objective datum for the specified type
	var/datum/crew_objective/CO = GLOB.all_crew_objectives[objective_type]

	//Make sure its initialized, that generates the event data
	if (!CO.initialized)
		CO.Initialize()

	//Grab the global event container for major severity
	var/datum/event_container/EC = SSevent.event_containers[EVENT_LEVEL_MAJOR]

	//Set this objective's event as the next one
	EC.next_event = CO.EM

	//And shoot
	EC.start_event()


/proc/get_crew_objective(var/objective_type)
	return GLOB.all_crew_objectives[objective_type]

/*
	A debug verb for testing the shop with events
*/
/*
/client/verb/necroshop_test()
	//Startup marker
	activate_marker()

	//Make us into the master signal
	mob.join_marker()
	var/obj/machinery/marker/marker  = get_marker()
	marker.become_master_signal(mob)

	//Start the event
	trigger_crew_objective(/datum/crew_objective/ads)
*/


/*
	A debug verb for testing the ADS console
*/
/*
/client/verb/console_test()
	trigger_crew_objective(/datum/crew_objective/ads)

	mob.forceMove(GLOB.asteroidcannon.console.loc)
	cmd_dev_bst()
*/