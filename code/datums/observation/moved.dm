//	Observer Pattern Implementation: Moved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has moved using Move() or forceMove().
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that moved
//			/atom/old_loc: The loc before the move.
//			/atom/new_loc: The loc after the move.
//	moved(var/atom/movable/moving_instance, var/atom/old_loc, var/atom/new_loc)

//The moved event once supported global listeners but it no longer does so, due to the performance cost of these

GLOBAL_DATUM_INIT(moved_event, /decl/observ/moved, new)

/decl/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/decl/observ/moved/register(var/atom/movable/mover, var/datum/listener, var/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(mover.loc, expected_type))
		register(mover.loc, mover, /atom/movable/proc/recursive_move)

/********************
* Movement Handling *
********************/

/atom/Entered(atom/movable/am, atom/old_loc)
	. = ..()
	RAISE_EVENT(am, moved_event, old_loc, am.loc)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	if(GLOB.moved_event.has_listeners(am))
		GLOB.moved_event.register(src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	GLOB.moved_event.unregister(src, am, /atom/movable/proc/recursive_move)

//TODO Here: Add a flag to check if this thing has any move listeners
// Entered() typically lifts the moved event, but in the case of null-space we'll have to handle it.
/atom/movable/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	var/old_loc = loc
	RAISE_EVENT(src, pre_move_event, loc, NewLoc)
	. = ..()
	if(. && !loc)
		RAISE_EVENT(src, moved_event, old_loc, null)

/atom/movable/forceMove(atom/destination, var/special_event, glide_size_override=0)
	var/old_loc = loc
	RAISE_EVENT(src, pre_move_event, loc, destination)
	. = ..()
	if(. && !loc)
		RAISE_EVENT(src, moved_event, old_loc, null)
