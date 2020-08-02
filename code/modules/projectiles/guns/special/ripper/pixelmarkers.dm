/obj/effect/pixelmarker
	icon = 'icons/debug/pixelmarkers.dmi'
	var/lifetime = 0.3
	anchored = TRUE

/obj/effect/pixelmarker/New(var/location, var/_lifetime, var/newcolor = "#FFFFFF")
	if (_lifetime)
		lifetime = _lifetime

	color = newcolor
	.=..()

/obj/effect/pixelmarker/Initialize()
	..()
	spawn(lifetime)
		qdel(src)

//Sets the pixelmarker to be on the target pixel exactly
/obj/effect/pixelmarker/set_global_pixel_loc(var/vector2/coords)
	..(coords + new /vector2(16, 16))




/obj/effect/pixelmarker/tile
	icon_state = "white"


/proc/pixelmark(var/turf/source, var/iconstate, var/vector2/coords)
	var/obj/effect/pixelmarker/P = new /obj/effect/pixelmarker(source, 3 SECOND)
	P.icon_state = iconstate
	if (coords)
		P.set_global_pixel_loc(coords)