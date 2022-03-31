
/atom/proc/make_indestructible()
	//If it is already, we do nothing
	if (atom_flags & ATOM_FLAG_INDESTRUCTIBLE)
		return

	atom_flags |= ATOM_FLAG_INDESTRUCTIBLE

/atom/proc/remove_indestructible()
	atom_flags -= ATOM_FLAG_INDESTRUCTIBLE


/turf/make_indestructible()
	.=..()
	for (var/atom/A in contents)
		if (isairlock(A) || iswindow(A))
			A.make_indestructible()

#define set_invisibility(amount) invisibility = amount

#ifndef set_invisibility
/atom/proc/set_invisibility(amount)
	SEND_SIGNAL(src, COMSIG_ATOM_INVISIBILITY_SET, invisibility, amount)
	invisibility = amount
#endif

/atom/movable/proc/move_to_turf(atom/movable/am, old_loc, new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

// Similar to above but we also follow into nullspace
/atom/movable/proc/move_to_turf_or_null(atom/movable/am, old_loc, new_loc)
	var/turf/T = get_turf(new_loc)
	if(T != loc)
		forceMove(T)

/atom/proc/recursive_dir_set(atom/a, old_dir, new_dir)
	if (new_dir != old_dir)
		set_dir(new_dir)

/datum/proc/qdel_self()
	qdel(src)

/atom/movable/proc/recursive_move(atom/movable/am, old_loc, new_loc)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, new_loc)

/mob/living/set_stat(new_stat)
	var/old_stat = stat
	. = ..()
	if(stat != old_stat)
		SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, old_stat, new_stat)

/atom/movable/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	var/old_loc = loc
	SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, loc, NewLoc)
	. = ..()
	if(.)
		SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, loc)

/atom/movable/forceMove(atom/destination, special_event, glide_size_override=0)
	var/old_loc = loc
	SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, loc, destination)
	. = ..()
	if(.)
		SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, destination)

/atom/set_density(new_density)
	var/old_density = density
	. = ..()
	if(density != old_density && isturf(loc))
		//We may have just changed our turf's clear status, set it to maybe
		if (isturf(loc))
			var/turf/T = loc
			T.content_density_set(density)

/turf/set_density(new_density)
	. = ..()
	content_density_set(density)

/turf/ChangeTurf()
	var/old_density = density
	. = ..()
	if(density != old_density)
		content_density_set(density)

/turf/Entered(atom/A)
	.=..()
	if (A.density)
		if (clear)	//If clear was previously true, null it
			clear = null

		//If this turf was not already dense, maybe it is now. notify everyone of that possibility
		if (!density && A.density)
			content_density_set(A.density)

/turf/Exited(atom/A, atom/newloc)
	.=..()
	if (A.density)
		if (!clear)	//If clear was previously true, null it
			clear = null

		//If this turf was not naturally dense, maybe this object was the only thing blocking it, lets fire off an event
		if (!density && A.density)
			content_density_set(A.density)

/turf/proc/content_density_set(newdensity)
	//Set clear to null if its possibly changed. Don't recalculate its exact value, thats done on demand
	if (!isnull(clear))
		if (clear != newdensity)
			clear = null

	SEND_SIGNAL(src, COMSIG_TURF_CLARITY_SET)

/mob/proc/set_sight(var/new_sight)
	var/old_sight = sight
	if(old_sight != new_sight)
		sight = new_sight
		SEND_SIGNAL(src, COMSIG_MOB_SIGHT_SET, old_sight, new_sight)

/atom/proc/set_opacity(new_opacity)
	if(new_opacity != opacity)
		var/old_opacity = opacity
		opacity = new_opacity
		SEND_SIGNAL(src, COMSIG_TURF_OPACITY_SET, old_opacity, new_opacity)
		return TRUE
	else
		return FALSE

/turf/ChangeTurf()
	var/old_opacity = opacity
	. = ..()
	if(opacity != old_opacity)
		SEND_SIGNAL(src, COMSIG_TURF_OPACITY_SET, old_opacity, opacity)

/atom/Entered(atom/movable/enterer, atom/old_loc)
	.=..()
	RegisterSignal(src, COMSIG_ATOM_ENTERED, enterer, old_loc)

/mob/Login()
	.=..()
	SEND_SIGNAL(src, COMSIG_MOB_LOGIN)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_MOB_LOGGED_IN, src)

/atom/set_dir()
	var/old_dir = dir
	. = ..()
	SEND_SIGNAL(src, COMSIG_ATOM_DIR_CHANGE, old_dir, dir)

/atom/movable/Entered(atom/movable/am, atom/old_loc)
	. = ..()
	am.RegisterSignal(src, COMSIG_ATOM_DIR_CHANGE, .proc/recursive_dir_set)

/atom/movable/Exited(atom/movable/am, atom/old_loc)
	. = ..()
	am.UnregisterSignal(src, COMSIG_ATOM_DIR_CHANGE)

/mob/living/add_to_dead_mob_list()
	. = ..()
	if(.)
		SEND_SIGNAL(src, COMSIG_LIVING_DEATH)

/mob/Logout()
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT, my_client)
	.=..()

/obj/item/equipped(var/mob/user, var/slot)
	. = ..()
	SEND_SIGNAL(src, COMSIG_ITEM_EQUIPPED, user, slot)

/obj/item/dropped(var/mob/user)
	.=..()
	SEND_SIGNAL(src, COMSIG_ITEM_UNEQUIPPED, user)

/mob/proc/set_see_in_dark(var/new_see_in_dark)
	var/old_see_in_dark = sight
	if(old_see_in_dark != new_see_in_dark)
		see_in_dark  = new_see_in_dark
		SEND_SIGNAL(src, COMSIG_MOB_SEE_IN_DARK_SET, old_see_in_dark, new_see_in_dark)

/mob/proc/set_see_invisible(var/new_see_invisible)
	var/old_see_invisible = see_invisible
	if(old_see_invisible != new_see_invisible)
		see_invisible = new_see_invisible
		SEND_SIGNAL(src, COMSIG_MOB_SEE_INVISIBLE_SET, old_see_invisible, new_see_invisible)
