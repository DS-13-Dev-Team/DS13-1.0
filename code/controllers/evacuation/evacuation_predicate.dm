/datum/evacuation_predicate/New()
	return

/datum/evacuation_predicate/Destroy(force = FALSE)
	if(!force)
		return

	return ..()

/datum/evacuation_predicate/proc/is_valid()
	return FALSE

/datum/evacuation_predicate/proc/can_call(var/user)
	return TRUE

/datum/evacuation_predicate/timer
	var/ready_at

/datum/evacuation_predicate/timer/New(time)
	ready_at = world.time + time

/datum/evacuation_predicate/is_valid()
	return TRUE

/datum/evacuation_predicate/timer/can_call(user)
	if(world.time >= ready_at)
		return TRUE
	else
		to_chat(user, SPAN_DANGER("There is no viable site within range for evacuation at the present time. ETA: [gameTimestamp("hh:mm:ss", ready_at-world.time)]"))
