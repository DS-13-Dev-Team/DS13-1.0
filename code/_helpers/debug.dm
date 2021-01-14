//Test
/proc/debug_mark_turf(turf/T, time = 10, color = "#00FF00")
	new /obj/effect/pixelmarker/tile (T, time, color)

//Draws a line representing a vector
/proc/debug_mark_vector(atom/origin, vector2/line, length = WORLD_ICON_SIZE*3, lifespan = 1 SECOND, color = "#00FF00")
	var/obj/effect/projectile/tether/debug/linetether = new /obj/effect/projectile/tether/debug(get_turf(origin))
	var/vector2/start = origin.get_global_pixel_loc()
	var/vector2/end = (line*length)
	end.SelfAdd(start)

	linetether.color = color
	linetether.set_ends(start,end)
	QDEL_IN(linetether, lifespan)

/obj/effect/projectile/tether/debug
	icon_state = "line"
	light_max_bright = 0
//Another comment