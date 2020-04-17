/turf/simulated/floor/ds
	name = "grim plating"
	icon = 'icons/turf/floors_ds13.dmi'
	icon_state = "dank_plating"

	base_name = "grim plating"
	base_desc = "The naked, ancient hull."
	icon = 'icons/turf/floors_ds13.dmi'
	base_icon_state = "dank_plating"
	base_icon = 'icons/turf/floors_ds13.dmi'

/decl/flooring/tiling_ds
	name = "floor"
	desc = "Scuffed from the passage of countless planet crackers, it looks ancient."
	icon = 'icons/turf/floors_ds13.dmi'
	icon_base = "dank_tile"
	has_damage_range = 4
	damage_temperature = T0C+1400
	flags = TURF_REMOVE_CROWBAR | TURF_CAN_BREAK | TURF_CAN_BURN
	build_type = /obj/item/stack/tile/dank
	can_paint = 1

/decl/flooring/tiling_ds/roller
	name = "roller"
	desc = "Scuffed from the passage of countless greyshirts."
	icon_base = "dank_roller"
	build_type = /obj/item/stack/tile/dankroller

/decl/flooring/tiling_ds/heavy
	name = "heavy floor"
	desc = "Scuffed from the passage of countless planet crackers, it looks ancient and sturdy."
	icon_base = "dank_tile_heavy"
	build_type = /obj/item/stack/tile/dankheavy