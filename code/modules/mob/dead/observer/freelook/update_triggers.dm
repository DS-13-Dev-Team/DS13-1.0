//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

// TURFS

/proc/updateVisibility(atom/A, var/opacity_check = 1)
	if(SSticker)
		for(var/datum/visualnet/VN in GLOB.visual_nets)
			VN.update_visibility(A, opacity_check)

/turf/drain_power()
	return -1

/atom/Destroy()
	if(opacity)
		updateVisibility(src)
	. = ..()

/atom/movable/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()
	if(opacity && .)
		updateVisibility(src)

/atom/movable/forceMove(atom/destination, var/special_event, glide_size_override=0)
	. = ..()
	if(opacity && .)
		updateVisibility(src)

// DOORS

// Simply updates the visibility of the area when it opens/closes/destroyed.
/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..(need_rebuild)
	// Glass door glass = 1
	// don't check then?
	if(!glass)
		updateVisibility(src, FALSE)

/turf/ChangeTurf()
	. = ..()
	if(.)
		updateVisibility(src, FALSE)
