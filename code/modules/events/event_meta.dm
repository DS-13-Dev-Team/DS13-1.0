/datum/event_meta
	var/name 		= ""
	var/enabled 	= 1	// Whether or not the event is available for random selection at all
	var/weight 		= 0 // The base weight of this event. A zero means it may never fire, but see get_weight()
	var/min_weight	= 0 // The minimum weight that this event will have. Only used if non-zero.
	var/max_weight	= 0 // The maximum weight that this event will have. Only use if non-zero.
	var/severity 	= 0 // The current severity of this event
	var/one_shot	= 0	// If true, then the event will not be re-added to the list of available events
	var/add_to_queue= 1	// If true, add back to the queue of events upon finishing.
	var/list/role_weights = list()
	var/datum/event/event_type

/datum/event_meta/New(var/event_severity, var/event_name, var/datum/event/type, var/event_weight, var/list/job_weights, var/is_one_shot = 0, var/min_event_weight = 0, var/max_event_weight = 0, var/add_to_queue = 1)
	name = event_name
	severity = event_severity
	event_type = type
	one_shot = is_one_shot
	weight = event_weight
	min_weight = min_event_weight
	max_weight = max_event_weight
	src.add_to_queue = add_to_queue
	if(job_weights)
		role_weights = job_weights

/datum/event_meta/proc/get_weight(var/list/active_with_role)
	if(!enabled)
		return 0

	var/job_weight = 0
	for(var/role in role_weights)
		if(role in active_with_role)
			job_weight += active_with_role[role] * role_weights[role]

	var/total_weight = weight + job_weight

	// Only min/max the weight if the values are non-zero
	if(min_weight && total_weight < min_weight) total_weight = min_weight
	if(max_weight && total_weight > max_weight) total_weight = max_weight

	return total_weight

/datum/event_meta/extended_penalty
	var/penalty = 100 // A simple penalty gives admins the ability to increase the weight to again be part of the random event selection

/datum/event_meta/extended_penalty/get_weight()
	return ..() - (SSticker && istype(SSticker.mode, /datum/game_mode/extended) ? penalty : 0)
