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
	var/list/global_listeners = list()  // Associative list of instances that listen to all events of this type (as opposed to events belonging to a specific source) and the proc to call.

/decl/observ/New()
	GLOB.all_observable_events += src
	..()

/decl/observ/proc/is_listening(var/event_source, var/datum/listener, var/proc_call)
	// Return whether there are global listeners unless the event source is given.
	if (!event_source)
		return !!global_listeners.len

	// Return whether anything is listening to a source, if no listener is given.
	if (!listener)
		return global_listeners.len || (event_source in event_sources)

	// Return false if nothing is associated with that source.
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

/decl/observ/proc/has_listeners(var/event_source)
	return is_listening(event_source)

/decl/observ/proc/register(var/datum/event_source, var/datum/listener, var/proc_call)
	// Sanity checking.
	if (!(event_source && listener && proc_call))
		return FALSE
	if (istype(event_source, /decl/observ))
		return FALSE

	// Crash if the event source is the wrong type.
	if (!istype(event_source, expected_type))
		CRASH("Unexpected type. Expected [expected_type], was [event_source.type]")

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
	return TRUE

/decl/observ/proc/unregister(var/event_source, var/datum/listener, var/proc_call)
	// Sanity.
	if (!(event_source && listener && (event_source in event_sources)))
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
	if (!callbacks)
		return FALSE

	// See if the callback exists.
	if(!callbacks.Remove(proc_call))
		return FALSE

	if (!callbacks.len)
		listeners -= listener
	if (!listeners.len)
		event_sources -= event_source
	return TRUE

/decl/observ/proc/register_global(var/datum/listener, var/proc_call)
	// Sanity.
	if (!(listener && proc_call))
		return FALSE

	// Make sure the callbacks are setup.
	var/list/callbacks = global_listeners[listener]
	if (!callbacks)
		callbacks = list()
		global_listeners[listener] = callbacks

	// Add the callback and return true.
	callbacks |= proc_call
	return TRUE

/decl/observ/proc/unregister_global(var/datum/listener, var/proc_call)
	// Return false unless the listener is set as a global listener.
	if (!(listener && (listener in global_listeners)))
		return FALSE

	// Remove all callbacks if no specific one is given.
	if (!proc_call)
		global_listeners -= listener
		return TRUE

	// See if the listener is registered.
	var/list/callbacks = global_listeners[listener]
	if (!callbacks)
		return FALSE

	// See if the callback exists.
	if(!callbacks.Remove(proc_call))
		return FALSE

	if (!callbacks.len)
		global_listeners -= listener
	return TRUE

/decl/observ/proc/raise_event()
	// Sanity
	if (!args.len)
		return FALSE

	// Call the global listeners.
	for (var/datum/listener in global_listeners)
		var/list/callbacks = global_listeners[listener]
		for (var/proc_call in callbacks)

			// If the callback crashes, record the error and remove it.
			try
				call(listener, proc_call)(arglist(args))
			catch (var/exception/e)
				error("[e.name] - [e.file] - [e.line]")
				error(e.desc)
				unregister_global(listener, proc_call)

	// Call the listeners for this specific event source, if they exist.
	var/source = args[1]
	if (source in event_sources)
		var/list/listeners = event_sources[source]
		for (var/datum/listener in listeners)
			var/list/callbacks = listeners[listener]
			for (var/proc_call in callbacks)

				// If the callback crashes, record the error and remove it.
				try
					call(listener, proc_call)(arglist(args))
				catch (var/exception/e)
					error("[e.name] - [e.file] - [e.line]")
					error(e.desc)
					unregister(source, listener, proc_call)

	return TRUE

/**
 * Register to listen for a observation from the passed in listener
 *
 * This sets up a listening relationship such that when the listener object emits a observation
 * the source datum this proc is called upon, will recieve a callback to the given proctype
 * Return values from procs registered must be a bitfield
 *
 * Arguments:
 * * datum/source_event The source_event to listen for observations from
 * * obs_type_or_types Either a string observation name, or a list of observation names (strings)
 * * proctype The proc to call back when the observation is emitted
 * * override If a previous registration exists you must explicitly set this
 */
/datum/proc/RegisterObservation(datum/event_source, obs_type_or_types, proctype, override = FALSE)
	if(QDELETED(src) || QDELETED(event_source))
		return

	var/list/procs = observation_procs
	if(!procs)
		observation_procs = procs = list()
	if(!procs[event_source])
		procs[event_source] = list()
	var/list/lookup = event_source.observation_datum
	if(!lookup)
		event_source.observation_datum = lookup = list()

	var/list/obs_types = islist(obs_type_or_types) ? obs_type_or_types : list(obs_type_or_types)
	for(var/decl/observ/obs_type in obs_types)
		if(!override && procs[event_source][obs_type])
			crash_with("[obs_type] overridden. Use override = TRUE to suppress this warning")
		obs_type.RegisterObservation(event_source, src, proctype) //Call register singleton

	observation_enabled = TRUE

/decl/observ/RegisterObservation(datum/event_source, listener, proctype)
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

	var/list/procs = observation_procs
	var/list/lookup = event_source.observation_datum

	procs[event_source][src] = proctype

	if(!lookup[src]) // Nothing has registered here yet
		lookup[src] = listener
	else if(!length(lookup[src])) // One other thing registered here
		lookup[src] = list(lookup[src]=TRUE)
		lookup[src][listener] = TRUE
	else if(lookup[src] != listener)// Many other things have registered here
		lookup[src][listener] = TRUE

	// If the proc_call is already registered skip
	if(proctype in callbacks)
		return

	// Add the callback, and return true.
	callbacks += proctype

/**
 * Stop listening to a given observation from event_source
 *
 * Breaks the relationship between event_source and source datum, removing the callback when the observation fires
 *
 * Doesn't care if a registration exists or not
 *
 * Arguments:
 * * datum/event_source Datum to stop listening to observations from
 * * obs_typeor_types observation string key or list of observation keys to stop listening to specifically
 */
/datum/proc/UnregisterObservation(datum/event_source, obs_type_or_types)
	var/list/lookup = event_source.observation_datum
	if(!observation_procs || !observation_procs[event_source] || !lookup)
		return
	if(!islist(obs_type_or_types))
		obs_type_or_types = list(obs_type_or_types)
	for(var/decl/observ/obs in obs_type_or_types)
		if(!observation_procs[event_source][obs])
			continue
		switch(length(lookup[obs]))
			if(2)
				lookup[obs] = (lookup[obs]-src)[1]
			if(1)
				crash_with("[event_source] ([event_source.type]) somehow has single length list inside observations")
				if(src in lookup[obs])
					lookup -= obs
					if(!length(lookup))
						event_source.observation_datum = null
						break
			if(0)
				lookup -= obs
				if(!length(lookup))
					event_source.observation_datum = null
					break
			else
				lookup[obs] -= src

	observation_procs[event_source] -= obs_type_or_types
	if(!observation_procs[event_source].len)
		observation_procs -= event_source

/**
 * Internal proc to handle most all of the observationing procedure
 *
 * Will runtime if used on datums with an empty observation list
 *
 * Use the [RAISE_EVENT] define instead
 */
/datum/proc/RaiseEvent(decl/observ/obstype, list/arguments)
	var/source = observation_datum[obstype]
	if(!length(source))
		return obstype.RaiseEvent(source, arguments)
	. = NONE
	for(var/I in source)
		. |= obstype.RaiseEvent(source, src, arguments)

/decl/observ/RaiseEvent(source, listener, list/arguments)
	var/datum/C = source
	if(!C.observation_enabled)
		return NONE
	var/proctype = C.observation_procs[listener][src]
	return NONE | CallAsync(C, proctype, arguments)