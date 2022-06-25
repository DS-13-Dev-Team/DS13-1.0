/turf/var/list/zstructures //A list of structures that may allow or interfere with ztransitions
GLOBAL_DATUM_INIT(openspace_backdrop_one_for_all, /atom/movable/openspace_backdrop, new)

/atom/movable/openspace_backdrop
	name = "openspace_backdrop"

	anchored = TRUE

	icon = 'icons/turf/floors.dmi'
	icon_state = "grey"
	plane = OPENSPACE_BACKDROP_PLANE
	layer = 5

	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_ID

/atom/proc/CanZPass()
	return TRUE

/turf/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		.= direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			.= FALSE
		if(direction == DOWN) //on a turf above, trying to enter
			.= !density
		if (LAZYLEN(zstructures))
			var/highest_priority = 0
			for (var/atom/B in zstructures)
				if (zstructures[B] > highest_priority)
					var/result=B.CanZPass(A, direction)
					if (result != ZTRANSITION_MAYBE)
						highest_priority = zstructures[B]
						.=result

/turf/simulated/open/CanZPass(atom/A, direction)
	.=TRUE
	if (LAZYLEN(zstructures))
		var/highest_priority = 0
		for (var/atom/B in zstructures)
			if (zstructures[B] > highest_priority)
				var/result=B.CanZPass(A, direction)
				if (result != ZTRANSITION_MAYBE)
					highest_priority = zstructures[B]
					.=result

/turf/space/CanZPass(atom/A, direction)
	.=TRUE
	if (LAZYLEN(zstructures))
		var/highest_priority = 0
		for (var/atom/B in zstructures)
			if (zstructures[B] > highest_priority)
				var/result=B.CanZPass(A, direction)
				if (result != ZTRANSITION_MAYBE)
					highest_priority = zstructures[B]
					.=result

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = FALSE
	pathweight = INFINITY //Seriously, don't try and path over this one numbnuts
	is_hole = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/turf/simulated/open/Initialize(mapload)
	..()
	//overlays += GLOB.openspace_backdrop_one_for_all //Special grey square for projecting backdrop darkness filter on it.
	return INITIALIZE_HINT_LATELOAD

/turf/simulated/open/LateInitialize()
	.=..()
	AddElement(/datum/element/turf_z_transparency)

/turf/simulated/open/update_dirt()
	return FALSE

/turf/simulated/open/Entered(atom/movable/mover, atom/oldloc)
	..()
	mover.fall(oldloc)

// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(atom/movable/AM)
	. = ..()
	AM.fall()


// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)

/turf/simulated/open/examine(mob/user, distance, infix, suffix)
	. = ..()
	if(distance <= 2)
		var/depth = 1
		for(var/T = GetBelow(src); isopenspace(T); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return TRUE


/turf/simulated/open/take_damage(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist = FALSE)
	return 0	//You can't damage what doesn't exist