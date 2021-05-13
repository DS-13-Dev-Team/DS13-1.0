/datum
	var/tmp/gc_destroyed //Time when this object was destroyed.
	var/tmp/is_processing = FALSE
	var/list/active_timers  //for SStimer
	var/implements_dummy = FALSE	//If true, this datum has an argument named "dummy" in its new proc
	var/dummy = FALSE	//Set true if this datum is a dummy and should not perform its normal functions
	//Used by mob previews

	/// Datum level flags
	var/datum_flags = NONE

	/**
	  * Any datum registered to receive observations from this datum is in this list
	  *
	  * Lazy associated list in the structure of `observation:registree/list of registrees`
	  */
	var/list/observations
	/**
	  * Is this datum capable of sending observations?
	  *
	  * Set to true when a observation has been registered
	  */
	var/observation_enabled = FALSE

#ifdef TESTING
	var/tmp/running_find_references
	var/tmp/last_find_references = 0
#endif

// The following vars cannot be edited by anyone
/datum/VV_static()
	return ..() + list("gc_destroyed", "is_processing")

// Default implementation of clean-up code.
// This should be overridden to remove all references pointing to the object being destroyed.
// Return the appropriate QDEL_HINT; in most cases this is QDEL_HINT_QUEUE.
/datum/proc/Destroy(force=FALSE)
	tag = null
	SSnano && SSnano.close_uis(src)
	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent)
			continue
		qdel(timer)

	//Unregister need because we will UNREGISTER ALL OBSERVATION_DATUM, NO PROC CALL //TO DO make unregister on OBSERVATION_DATUM
	for(var/observ in observations)
		UnregisterObservation(observations[observ], observ)

	return QDEL_HINT_QUEUE

/datum/proc/Process()
	set waitfor = 0
	return PROCESS_KILL

/datum/proc/CanProcCall(procname)
	return TRUE