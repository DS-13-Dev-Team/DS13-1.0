
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

/atom/proc/set_invisibility(amount)
	SEND_SIGNAL(src, COMSIG_ATOM_INVISIBILITY_SET, invisibility, amount)
	invisibility = amount

/atom/movable/proc/move_to_turf(atom/movable/am, old_loc, new_loc)
	SIGNAL_HANDLER
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

// Similar to above but we also follow into nullspace
/atom/movable/proc/move_to_turf_or_null(atom/movable/am, old_loc, new_loc)
	SIGNAL_HANDLER
	var/turf/T = get_turf(new_loc)
	if(T != loc)
		forceMove(T)

/datum/proc/qdel_self()
	SIGNAL_HANDLER
	qdel(src)

/atom/movable/forceMove(atom/destination, special_event, glide_size_override=0)
	var/old_loc = loc
	SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, loc, destination)
	.=..()
	if(.)
		SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, old_loc, destination)

/turf/set_density(new_density)
	. = ..()
	content_density_set(density)

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

/atom/Entered(atom/movable/enterer, atom/old_loc)
	.=..()
	SEND_SIGNAL(src, COMSIG_ATOM_ENTERED, enterer, old_loc)

/mob/proc/set_see_in_dark(var/new_see_in_dark)
	var/old_see_in_dark = sight
	if(old_see_in_dark != new_see_in_dark)
		see_in_dark = new_see_in_dark
		SEND_SIGNAL(src, COMSIG_MOB_SEE_IN_DARK_SET, old_see_in_dark, new_see_in_dark)

/mob/proc/set_see_invisible(var/new_see_invisible)
	var/old_see_invisible = see_invisible
	if(old_see_invisible != new_see_invisible)
		see_invisible = new_see_invisible
		SEND_SIGNAL(src, COMSIG_MOB_SEE_INVISIBLE_SET, old_see_invisible, new_see_invisible)
