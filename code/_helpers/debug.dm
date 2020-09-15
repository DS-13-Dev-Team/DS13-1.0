//Test
/proc/debug_mark_turf(var/turf/T, var/time = 10, var/color = "#00FF00")
	new /obj/effect/pixelmarker/tile (T, time, color)

//Draws a line representing a vector
/proc/debug_mark_vector(var/atom/origin, var/vector2/line, var/length = WORLD_ICON_SIZE*3, var/lifespan = 1 SECOND, var/color = "#00FF00")
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