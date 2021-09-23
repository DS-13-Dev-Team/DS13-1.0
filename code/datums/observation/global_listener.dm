/*
		A subtype of observation that supports the rarely used global-listener behaviour
		Formerly part of the base type, this is moved out to save performance for all but the tiny minority that need it

	Currently, only logged_in uses this subtype
	Moved used to, but it has been removed from that as all the uses were unimportant junk
*/
/decl/observ/global_listener

			var/list/global_listeners = list()	// Associative list of instances that listen to all events of this type (as opposed to events belonging to a specific source) and the proc to call.

/decl/observ/global_listener/raise_event()
	.=..(arglist(args))
	if (!.)
		return
	// Call the global listeners.
	for (var/datum/listener in global_listeners)
		var/list/callbacks = global_listeners[listener]
		for (var/proc_call in callbacks)

			// If the callback crashes, record the error and remove it.
			try
				call(listener, proc_call)(arglist(args))
			catch (var/exception/e)
				log_debug("[e.name] - [e.file] - [e.line]")
				log_debug(e.desc)
				unregister_global(listener, proc_call)



/decl/observ/global_listener/proc/register_global(var/datum/listener, var/proc_call)
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

/decl/observ/global_listener/proc/unregister_global(var/datum/listener, var/proc_call)
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



/decl/observ/global_listener/is_listening(var/event_source, var/datum/listener, var/proc_call)
	// Return whether there are global listeners unless the event source is given.
	if (!event_source ||	!listener)
		if (global_listeners.len)
			return TRUE

	.=..()