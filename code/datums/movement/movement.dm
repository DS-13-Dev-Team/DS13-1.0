var/const/MOVEMENT_HANDLED = 0x0001 // If no further movement handling should occur after this
var/const/MOVEMENT_REMOVE  = 0x0002

var/const/MOVEMENT_PROCEED = 0x0004
var/const/MOVEMENT_STOP    = 0x0008



/atom/movable
	var/list/movement_handlers




/atom/movable/proc/DoMove(var/direction, var/mob/mover, var/is_external)
	INIT_MOVEMENT_HANDLERS
	SET_MOVER(mover)
	SET_IS_EXTERNAL(mover)

	for(var/mh in movement_handlers)
		var/datum/movement_handler/movement_handler = mh
		if(movement_handler.MayMove(mover, is_external) & MOVEMENT_STOP)
			return MOVEMENT_HANDLED

		. = movement_handler.DoMove(direction, mover, is_external)
		if(. & MOVEMENT_REMOVE)
			REMOVE_AND_QDEL(movement_handler)
		if(. & MOVEMENT_HANDLED)
			return

// is_external means that something else (not inside us) is asking if we may move
// This for example includes mobs bumping into each other
/atom/movable/proc/MayMove(var/mob/mover, var/is_external)
	INIT_MOVEMENT_HANDLERS
	SET_MOVER(mover)
	SET_IS_EXTERNAL(mover)

	for(var/mh in movement_handlers)
		var/datum/movement_handler/movement_handler = mh
		var/may_move = movement_handler.MayMove(mover, is_external)
		if(may_move & MOVEMENT_STOP)
			return FALSE
		if((may_move & (MOVEMENT_PROCEED|MOVEMENT_HANDLED)) == (MOVEMENT_PROCEED|MOVEMENT_HANDLED))
			return TRUE
	return TRUE

// Base
/atom/movable/Destroy()
	if(LAZYLEN(movement_handlers) && !ispath(movement_handlers[1]))
		QDEL_NULL_LIST(movement_handlers)
	. = ..()


