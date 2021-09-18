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
