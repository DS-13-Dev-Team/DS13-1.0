/datum
	var/tmp/gc_destroyed //Time when this object was destroyed.
	var/tmp/datum/controller/subsystem/processing/is_processing = FALSE
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
	/// Lazy associated list in the structure of `observations:proctype` that are run when the datum receives that observation
	var/list/list/datum/callback/observation_procs

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

	//BEGIN: ECS SHIT
	if(extensions)
		for(var/expansion_key in extensions)
			var/list/extension = extensions[expansion_key]
			if(islist(extension))
				extension.Cut()
			else
				qdel(extension)
		extensions = null

	clear_signal_refs()
	//END: ECS SHIT

	return QDEL_HINT_QUEUE

///Only override this if you know what you're doing. You do not know what you're doing
///This is a threat
/datum/proc/clear_signal_refs()

	for(var/target in observation_procs)
		var/decl/observ/O = observation_procs[target]
		O.unregister(target, src)

/datum/proc/Process()
	set waitfor = 0
	return PROCESS_KILL

/datum/proc/CanProcCall(procname)
	return TRUE