//
//	Observer Pattern Implementation
//
//	Implements a basic observer pattern with the following main procs:
//
//	/decl/observ/proc/is_listening(var/event_source, var/datum/listener, var/proc_call)
//		event_source: The instance which is generating events.
//		listener: The instance which may be listening to events by event_source
//		proc_call: Optional. The specific proc to call when the event is raised.
//
//		Returns true if listener is listening for events by event_source, and proc_call supplied is either null or one of the proc that will be called when an event is raised.
//
//	/decl/observ/proc/has_listeners(var/event_source)
//		event_source: The instance which is generating events.
//
//		Returns true if the given event_source has any listeners at all, globally or to specific event sources.
//
//	/decl/observ/proc/register(var/event_source, var/datum/listener, var/proc_call)
//		event_source: The instance you wish to receive events from.
//		listener: The instance/owner of the proc to call when an event is raised by the event_source.
//		proc_call: The proc to call when an event is raised.
//
//		It is possible to register the same listener to the same event_source multiple times as long as it is using different proc_calls.
//		Registering again using the same event_source, listener, and proc_call that has been registered previously will have no additional effect.
//			I.e.: The proc_call will still only be called once per raised event. That particular proc_call will only have to be unregistered once.
//
//		When proc_call is called the first argument is always the source of the event (event_source).
//		Additional arguments may or may not be supplied, see individual event definition files (destroyed.dm, moved.dm, etc.) for details.
//
//		The instance making the register() call is also responsible for calling unregister(), see below for additonal details, including when event_source is destroyed.
//			This can be handled by listening to the event_source's destroyed event, unregistering in the listener's Destroy() proc, etc.
//
//	/decl/observ/proc/unregister(var/event_source, var/datum/listener, var/proc_call)
//		event_source: The instance you wish to stop receiving events from.
//		listener: The instance which will no longer receive the events.
//		proc_call: Optional: The proc_call to unregister.
//
//		Unregisters the listener from the event_source.
//		If a proc_call has been supplied only that particular proc_call will be unregistered. If the proc_call isn't currently registered there will be no effect.
//		If no proc_call has been supplied, the listener will have all registrations made to the given event_source undone.
//
//	/decl/observ/proc/register_global(var/datum/listener, var/proc_call)
//		listener: The instance/owner of the proc to call when an event is raised by any and all sources.
//		proc_call: The proc to call when an event is raised.
//
//		Works very much the same as register(), only the listener/proc_call will receive all relevant events from all event sources.
//		Global registrations can overlap with registrations made to specific event sources and these will not affect each other.
//
//	/decl/observ/proc/unregister_global(var/datum/listener, var/proc_call)
//		listener: The instance/owner of the proc which will no longer receive the events.
//		proc_call: Optional: The proc_call to unregister.
//
//		Works very much the same as unregister(), only it undoes global registrations instead.
//
//	/decl/observ/proc/raise_event(src, ...)
//		Should never be called unless implementing a new event type.
//		The first argument shall always be the event_source belonging to the event. Beyond that there are no restrictions.

/decl/observ
	var/name = "Unnamed Event"          // The name of this event, used mainly for debug/VV purposes. The list of event managers can be reached through the "Debug Controller" verb, selecting the "Observation" entry.
	var/expected_type = /datum          // The expected event source for this event. register() will CRASH() if it receives an unexpected type.
	var/list/event_sources = list()     // Associative list of event sources, each with their own associative list. This associative list contains an instance/list of procs to call when the event is raised.

	var/events_raised = 0	//A tally, used for optimisation data

/decl/observ/New()
	GLOB.all_observable_events += src
	..()

/decl/observ/proc/is_listening(event_source, datum/listener, proc_call)
	if (!(event_source in event_sources))
		return FALSE

	// Get and check the listeners for the reuqested event.
	var/listeners = event_sources[event_source]
	if (!(listener in listeners))
		return FALSE

	// Return true unless a specific callback needs checked.
	if (!proc_call)
		return TRUE

	// Check if the specific callback exists.
	var/list/callback = listeners[listener]
	if (!callback)
		return FALSE

	return (proc_call in callback)

/decl/observ/proc/has_listeners(event_source)
	return is_listening(event_source)

// listener - src, event_source - target, src - sig_type
/decl/observ/proc/register(datum/event_source, datum/listener, proc_call)
	if(QDELETED(src) || QDELETED(event_source))
		return FALSE

	// Crash if the event source is the wrong type.
	if (!istype(event_source, expected_type))
		CRASH("Unexpected type. Expected [expected_type], was [event_source.type]")

	var/list/procs = listener.observation_procs

	if(!procs)
		listener.observation_procs = procs = list()

	if(!procs[event_source])
		procs[event_source] = list()

	var/list/observations = event_source.observations
	if(!observations)
		event_source.observations = observations = list()

	// Setup the listeners for this source if needed.
	var/list/listeners = event_sources[event_source]
	if (!listeners)
		listeners = list()
		event_sources[event_source] = listeners

	// Make sure the callbacks are a list.
	var/list/callbacks = listeners[listener]
	if (!callbacks)
		callbacks = list()
		listeners[listener] = callbacks

	// If the proc_call is already registered skip
	if(proc_call in callbacks)
		return FALSE

	// Add the callback, and return true.
	callbacks += proc_call

	procs[event_source][src] = proc_call

	if(!observations[src]) // Nothing has registered here yet
		observations[src] = listener
	else if(observations[src] == listener) // We already registered here
		return TRUE
	else if(!length(observations[src])) // One other thing registered here
		observations[src] = list(observations[src]=TRUE)
		observations[src][listener] = TRUE
	else // Many other things have registered here
		observations[src][listener] = TRUE

	return TRUE

/decl/observ/proc/unregister(datum/event_source, datum/listener, proc_call)
	var/list/observations = event_source.observations
	if(!listener.observation_procs || !listener.observation_procs[event_source] || !observations)
		return FALSE

	// Return false if nothing is listening for this event.
	var/list/listeners = event_sources[event_source]
	if (!listeners)
		return FALSE

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		if(listeners.Remove(listener))
			// Perform some cleanup and return true.
			if (!listeners.len)
				event_sources -= event_source
			return TRUE
		return FALSE

	// See if the listener is registered.
	var/list/callbacks = listeners[listener]


	if(!callbacks?.Remove(proc_call))
		return FALSE

	switch(length(observations[src]))
		if(2)
			observations[src] = (observations[src]-listener)[1]
		if(1)
			crash_with("[event_source] ([event_source.type]) somehow has single length list inside observations")
			if(src in observations[src])
				observations -= src
				if(!length(observations))
					event_source.observations = null
		if(0)
			if(observations[src] == listener)
				observations -= src
				if(!length(observations))
					event_source.observations = null
		else
			observations[src] -= listener

	if (!length(callbacks))
		listeners -= listener
	if (!length(listener))
		event_sources -= event_source

	listener.observation_procs[event_source] -= src
	if(!listener.observation_procs[event_source].len)
		listener.observation_procs -= event_source

	return TRUE


/decl/observ/proc/RaiseEvent(datum/listener, list/arguments)
	events_raised++

	var/target = listener.observations[src]
	if(!length(target))
		var/datum/listening_datum = target
		return NONE | call(listening_datum, listening_datum.observation_procs[listener][src])(arglist(arguments))
	. = NONE
	// This exists so that even if one of the observation receivers unregisters the observation,
	// all the objects that are receiving the observation get the observation this final time.
	// AKA: No you can't cancel the observation reception of another object by doing an unregister in the same observation.
	var/list/queued_calls = list()
	for(var/datum/listening_datum as anything in target)
		queued_calls[listening_datum] = listening_datum.observation_procs[listener][src]
	for(var/datum/listening_datum as anything in queued_calls)
		. |= call(listening_datum, queued_calls[listening_datum])(arglist(arguments))

/decl/observ/proc/raise_event()

	events_raised++

	// Call the listeners for this specific event source, if they exist.
	var/source = args[1]
	var/list/listeners = event_sources[source]
	if (listeners)
		for (var/datum/listener as anything in listeners)
			var/list/callbacks = listeners[listener]
			for (var/proc_call in callbacks)

				// If the callback crashes, record the error and remove it.
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					log_debug("[e.name] - [e.file] - [e.line]")
					log_debug(e.desc)
					unregister(source, listener, proc_call)

	return TRUE
