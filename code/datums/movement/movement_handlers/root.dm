/datum/movement_handler/root
	var/finish_time = INFINITY

/datum/movement_handler/root/New(atom/movable/host, duration)
	.=..()
	if (duration)
		finish_time  = world.time + duration
		addtimer(CALLBACK(src, /datum/movement_handler/proc/remove), duration)


// Asks the handlers if the mob may move, ignoring destination, if attempting a DoMove()
/datum/movement_handler/root/MayMove(mob/mover, is_external)
	if (world.time < finish_time)
		return MOVEMENT_STOP
	return MOVEMENT_PROCEED