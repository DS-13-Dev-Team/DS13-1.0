/obj/effect/decal
	plane = ABOVE_TURF_PLANE
	layer = DECAL_LAYER
	biomass = 0	//Used for blood and other organic smears

/obj/effect/decal/fall_damage()
	return 0

/obj/effect/decal/is_burnable()
	return TRUE

/obj/effect/decal/lava_act()
	. = !throwing ? ..() : FALSE
