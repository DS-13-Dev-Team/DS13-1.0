/*
	Crew objectives piggyback on the event system for scheduling and admin interfacing

	The logic that actually runs the repairing, spawning and other gameplay is not here, this is just an entry and exitpoint
*/

//Create an event for us and put it in the major event list
/datum/crew_objective/proc/setup_event()
	EM = new (EVENT_LEVEL_MAJOR, event_name = src.name, type = /datum/event/crew_objective, event_weight = src.weight, is_one_shot = src.oneshot, objective_type = src.type)
	EM.name = src.name
	var/datum/event_container/EC = SSevent.event_containers[EVENT_LEVEL_MAJOR]
	EC.available_events |= EM

/*
	Special event meta subtype
*/
/datum/event_meta/crew_objective
	var/datum/crew_objective/objective_type

/datum/event_meta/crew_objective/New(var/event_severity, var/event_name, var/datum/event/type, var/event_weight, var/list/job_weights, var/is_one_shot = 0, var/min_event_weight = 0, var/max_event_weight = 0, var/add_to_queue = 1, var/objective_type = /datum/crew_objective)
	src.objective_type = objective_type
	.=..()


/*
	The Event
*/
/datum/event/crew_objective
	startWhen = 0
	endWhen = INFINITY	//This won't end naturally, only when crew finish the objective,
	// but it can be force-stopped by admins

	var/datum/crew_objective/CO


/datum/event/crew_objective/setup()
	//Grab the relevant objective and start it
	var/datum/event_meta/crew_objective/EMCO = event_meta
	CO = GLOB.all_crew_objectives[EMCO.objective_type]
	CO.event = src
	CO.trigger()


/datum/event/crew_objective/kill()
	// If this event was forcefully killed prematurely end the objective
	if(isRunning)
		CO.fade()

	.=..()



