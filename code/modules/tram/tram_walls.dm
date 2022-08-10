/*
 * Tram Walls
 */
/obj/structure/tramwall
	name = "bulkhead"
	desc = "A huge chunk of metal used to separate rooms."
	anchored = TRUE
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "tram"
	layer = LOW_OBJ_LAYER
	density = TRUE
	opacity = TRUE
	atom_flags = ATOM_FLAG_INDESTRUCTIBLE

/obj/structure/tramwall/Initialize()
	.=..()

	update_connections(1)
	update_icon()

	update_nearby_tiles(need_rebuild=1)
	update_nearby_icons()

/obj/structure/tramwall/Destroy()
	set_density(0)
	update_nearby_tiles()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_connections()
		W.update_icon()

/obj/structure/tramwall/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//This proc is used to update the icons of nearby "walls". It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/tramwall/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

/obj/structure/tramwall/update_icon()
	overlays.Cut()
	var/image/I

	for(var/i = 1 to 4)
		if(other_connections[i] != "0")
			I = image('icons/turf/wall_masks.dmi', "tram_other[connections[i]]", dir = 1<<(i-1))
		else
			I = image('icons/turf/wall_masks.dmi', "tram[connections[i]]", dir = 1<<(i-1))
		overlays += I

/obj/structure/tramwall/can_visually_connect()
	return TRUE

/obj/structure/tramwall/can_visually_connect_to(obj/structure/S)
	return (istype(S, /obj/structure/tramwall) || istype(S, /obj/structure/window) || istype(S, /obj/structure/grille) || istype(S, /obj/structure/wall_frame) || istype(S, /obj/machinery/door/airlock))

/obj/structure/tramwall/update_connections(propagate = 0)
	var/list/dirs = list()
	var/list/other_dirs = list()

	if(!anchored)
		return

	for(var/obj/structure/S in orange(src, 1))
		if(can_visually_connect_to(S))
			if(S.can_visually_connect())
				if(propagate)
					S.update_connections()
					S.update_icon()
				dirs += get_dir(src, S)

	for(var/obj/machinery/door/airlock/S in orange(src, 1))
		dirs += get_dir(src, S)

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0
		for(var/b_type in blend_objects)
			if(istype(T, b_type))
				success = 1
				if(propagate)
					var/turf/simulated/wall/W = T
					if(istype(W))
						W.update_connections(1)
						W.update_icon()
				if(success)
					break
			if(success)
				break
		if(!success)
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if(istype(O, b_type))
						success = 1
						for(var/obj/structure/S in T)
							if(istype(S, src))
								success = 0
						for(var/nb_type in noblend_objects)
							if(istype(O, nb_type))
								success = 0

					if(success)
						break
				if(success)
					break

		if(success)
			dirs += get_dir(src, T)
			other_dirs += get_dir(src, T)

	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)
