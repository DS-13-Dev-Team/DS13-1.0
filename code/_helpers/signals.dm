/**
 * Register to listen for a signal from the passed in target
 *
 * This sets up a listening relationship such that when the target object emits a signal
 * the source datum this proc is called upon, will receive a callback to the given proctype
 * Return values from procs registered must be a bitfield
 *
 * Arguments:
 * * datum/target The target to listen for signals from
 * * sig_type_or_types Either a string signal name, or a list of signal names (strings)
 * * proctype The proc to call back when the signal is emitted
 * * override If a previous registration exists you must explicitly set this
 */
/datum/proc/RegisterSignal(datum/target, sig_type_or_types, proctype, override = FALSE)
	if(QDELETED(src) || QDELETED(target))
		return

	var/list/procs = signal_procs
	if(!procs)
		signal_procs = procs = list()
	if(!procs[target])
		procs[target] = list()
	var/list/lookup = target.comp_lookup
	if(!lookup)
		target.comp_lookup = lookup = list()

	var/list/sig_types = islist(sig_type_or_types) ? sig_type_or_types : list(sig_type_or_types)
	for(var/sig_type in sig_types)
		if(!override && procs[target][sig_type])
			crash_with("[sig_type] overridden. Use override = TRUE to suppress this warning")

		procs[target][sig_type] = proctype

		if(!lookup[sig_type]) // Nothing has registered here yet
			lookup[sig_type] = src
		else if(lookup[sig_type] == src) // We already registered here
			continue
		else if(!length(lookup[sig_type])) // One other thing registered here
			lookup[sig_type] = list(lookup[sig_type]=TRUE)
			lookup[sig_type][src] = TRUE
		else // Many other things have registered here
			lookup[sig_type][src] = TRUE

/**
 * Stop listening to a given signal from target
 *
 * Breaks the relationship between target and source datum, removing the callback when the signal fires
 *
 * Doesn't care if a registration exists or not
 *
 * Arguments:
 * * datum/target Datum to stop listening to signals from
 * * sig_typeor_types Signal string key or list of signal keys to stop listening to specifically
 */
/datum/proc/UnregisterSignal(datum/target, sig_type_or_types)
	var/list/lookup = target.comp_lookup
	if(!signal_procs || !signal_procs[target] || !lookup)
		return
	if(!islist(sig_type_or_types))
		sig_type_or_types = list(sig_type_or_types)
	for(var/sig in sig_type_or_types)
		if(!signal_procs[target][sig])
			if(!istext(sig))
				crash_with("We're unregistering with something that isn't a valid signal \[[sig]\], you fucked up")
			continue
		switch(length(lookup[sig]))
			if(2)
				lookup[sig] = (lookup[sig]-src)[1]
			if(1)
				crash_with("[target] ([target.type]) somehow has single length list inside comp_lookup")
				if(src in lookup[sig])
					lookup -= sig
					if(!length(lookup))
						target.comp_lookup = null
						break
			if(0)
				if(lookup[sig] != src)
					continue
				lookup -= sig
				if(!length(lookup))
					target.comp_lookup = null
					break
			else
				lookup[sig] -= src

	signal_procs[target] -= sig_type_or_types
	if(!signal_procs[target].len)
		signal_procs -= target

/**
 * Internal proc to handle most all of the signaling procedure
 *
 * Will runtime if used on datums with an empty component list
 *
 * Use the [SEND_SIGNAL] define instead
 */
/datum/proc/_SendSignal(sigtype, list/arguments)
	LINE_PROFILE_START
	var/target = comp_lookup[sigtype]
	if(!length(target))
		var/datum/listening_datum = target
		PROFILE_TICK
		return NONE | call(listening_datum, listening_datum.signal_procs[src][sigtype])(arglist(arguments))
	PROFILE_TICK
	. = NONE
	// This exists so that even if one of the signal receivers unregisters the signal,
	// all the objects that are receiving the signal get the signal this final time.
	// AKA: No you can't cancel the signal reception of another object by doing an unregister in the same signal.
	var/list/queued_calls = list()
	for(var/datum/listening_datum as anything in target)
		queued_calls[listening_datum] = listening_datum.signal_procs[src][sigtype]
	PROFILE_TICK
	for(var/datum/listening_datum as anything in queued_calls)
		. |= call(listening_datum, queued_calls[listening_datum])(arglist(arguments))
	PROFILE_TICK
	LINE_PROFILE_STOP
