/*********************
* Direction Handling *
*********************/

/atom/set_dir()
	var/old_dir = dir
	. = ..()
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, old_dir, dir)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	am.RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, .proc/recursive_dir_set)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	am.UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)
