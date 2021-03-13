/*
	Flooring types which use sprites ported from eris
	These floors have edges and corners
*/

/decl/flooring/complex
	name = "advanced floor"
	icon = 'icons/turf/flooring/tiles_white.dmi'
	build_type = /obj/item/stack/tile/floor/steel/gray_perforated //Same type as the normal plating, we'll use can_build_floor to control it
	flags = TURF_CAN_BURN | TURF_CAN_BREAK | TURF_HAS_CORNERS | TURF_HAS_INNER_CORNERS
	can_paint = 1
	has_base_range = 0
	resistance = RESISTANCE_ARMOURED

	color = COLOR_WHITE

	space_smooth = SMOOTH_NONE
	floor_smooth = SMOOTH_ALL
	wall_smooth = SMOOTH_NONE
	smooth_nothing = FALSE
	smooth_movable_atom = SMOOTH_GREYLIST
	movable_atom_blacklist = list(
		list(/obj, list("density" = TRUE, "anchored" = TRUE), 1)
		)
	movable_atom_whitelist = list(
	list(/obj/machinery/door/airlock, list(), 2)
	)

/decl/flooring/complex/perforated_gray
	icon_base = "gray_perforated"
	build_type = /obj/item/stack/tile/floor/steel/gray_perforated


/decl/flooring/complex/perforated_brown
	icon_base = "brown_perforated"
	build_type = /obj/item/stack/tile/floor/steel/gray_perforated

/decl/flooring/complex/mono
	icon_base = "monofloor"
	has_base_range = 15
	icon = 'icons/turf/flooring/tiles_steel.dmi'
	build_type = /obj/item/stack/tile/mono


/decl/flooring/complex/techno
	icon_base = "bar_dance"
	icon = 'icons/turf/flooring/tiles_steel.dmi'
	build_type = /obj/item/stack/tile/mono