/datum
	var/tmp/gc_destroyed //Time when this object was destroyed.
	var/tmp/datum/controller/subsystem/processing/is_processing = FALSE
	var/list/active_timers  //for SStimer
	var/implements_dummy = FALSE	//If true, this datum has an argument named "dummy" in its new proc
	var/dummy = FALSE	//Set true if this datum is a dummy and should not perform its normal functions
	//Used by mob previews

	/// Datum level flags
	var/datum_flags = NONE

	/// A weak reference to another datum
	var/datum/weakref/weak_reference

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
/datum/proc/Destroy(force=FALSE, ...)
	SHOULD_CALL_PARENT(TRUE)
	tag = null
	datum_flags &= ~DATUM_FLAG_WEAKREF_USE_TAG //In case something tries to REF us
	weak_reference = null //ensure prompt GCing of weakref.

	SSnano && SSnano.close_uis(src)
	var/list/timers = active_timers
	active_timers = null
	for(var/thing in timers)
		var/datum/timedevent/timer = thing
		if (timer.spent)
			continue
		qdel(timer)
	return QDEL_HINT_QUEUE

/datum/proc/Process(delta_time)
	set waitfor = FALSE
	return PROCESS_KILL

/datum/proc/CanProcCall(procname)
	return TRUE