// We don't want to check for subtypes, hence why we don't call is_path_in_list(), etc.
/atom/movable/proc/HasMovementHandler(var/handler_path)
	if(!LAZYLEN(movement_handlers))
		return FALSE
	if(ispath(movement_handlers[1]))
		return (handler_path in movement_handlers)
	else
		for(var/mh in movement_handlers)
			var/datum/MH = mh
			if(MH.type == handler_path)
				return TRUE
	return FALSE

/atom/movable/proc/AddMovementHandler(var/handler_path, var/handler_path_to_add_before)
	INIT_MOVEMENT_HANDLERS

	. = new handler_path(src)

	// If a handler_path_to_add_before was given, attempt to find it and insert our handler just before it
	if(handler_path_to_add_before && LAZYLEN(movement_handlers))
		var/index = 0
		for(var/handler in movement_handlers)
			index++
			var/datum/H = handler
			if(H.type == handler_path_to_add_before)
				LAZYINSERT(movement_handlers, ., index)
				return

	// If no handler_path_to_add_after was given or found, add first
	LAZYINSERT(movement_handlers, ., 1)

/atom/movable/proc/RemoveMovementHandler(var/handler_path)
	INIT_MOVEMENT_HANDLERS

	if(ispath(handler_path))
		for(var/handler in movement_handlers)
			var/datum/H = handler
			if(H.type == handler_path)
				REMOVE_AND_QDEL(H)
				break
	else if (handler_path in movement_handlers)
		REMOVE_AND_QDEL(handler_path)

/atom/movable/proc/RemoveMovementHandlerDatum(var/datum/movement_handler/thing)
	INIT_MOVEMENT_HANDLERS

	for(var/handler in movement_handlers)
		var/datum/H = handler
		if(H == thing || movement_handlers[H] == thing)
			REMOVE_AND_QDEL(H)
			return

/atom/movable/proc/ReplaceMovementHandler(var/handler_path)
	RemoveMovementHandler(handler_path)
	AddMovementHandler(handler_path)

/atom/movable/proc/GetMovementHandler(var/handler_path)
	INIT_MOVEMENT_HANDLERS

	for(var/handler in movement_handlers)
		var/datum/H = handler
		if(H.type == handler_path)
			return H
