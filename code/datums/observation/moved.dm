/********************
* Movement Handling *
********************/

/atom/movable/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	var/old_loc = loc
	SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, loc, NewLoc)
	. = ..()
	if(.)
		SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, loc)

/atom/movable/forceMove(atom/destination, var/special_event, glide_size_override=0)
	var/old_loc = loc
	SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, loc, destination)
	. = ..()
	if(.)
		SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, destination)

