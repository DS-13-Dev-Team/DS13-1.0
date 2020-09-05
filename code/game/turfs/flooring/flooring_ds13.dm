/turf/simulated/floor/ds
	name = "grim plating"
	desc = "The naked, ancient hull."
	icon = 'icons/turf/floors_ds13.dmi'
	icon_state = "dank_plating"


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

/decl/flooring/tiling_ds/medical
	name = "medical floor"
	desc = "Scuffed from the passage of countless planet crackers, it reminds you of the asylum..."
	icon_base = "dank_tile_medical"
	build_type = /obj/item/stack/tile/dankmedical

/decl/flooring/tiling_ds/mono
	name = "floor"
	desc = "Scuffed from the passage of countless planet crackers, it looks grimy and smooth."
	icon_base = "dank_tile_mono"
	build_type = /obj/item/stack/tile/dankmono

/decl/flooring/tiling_ds/bathroom
	name = "bathroom tiles"
	desc = "Grim colorings for a grim job to do."
	icon_base = "bathroom"
	build_type = /obj/item/stack/tile/bathroom





/decl/flooring/tiling/mono
	icon_base = "monotile"
	build_type = /obj/item/stack/tile/mono

/decl/flooring/tiling/mono/dark
	color = COLOR_DARK_GRAY
	build_type = /obj/item/stack/tile/mono/dark

/decl/flooring/tiling/mono/white
	icon_base = "monotile_light"
	color = COLOR_OFF_WHITE
	build_type = /obj/item/stack/tile/mono/white

/decl/flooring/tiling/new_tile
	icon_base = "tile_full"
	color = null

/decl/flooring/tiling/new_tile/cargo_one
	icon_base = "cargo_one_full"

/decl/flooring/tiling/new_tile/kafel
	icon_base = "kafel_full"

/decl/flooring/tiling/new_tile/techmaint
	icon_base = "techmaint"
	build_type = /obj/item/stack/tile/techmaint

/decl/flooring/tiling/new_tile/monofloor
	icon_base = "monofloor"
	color = COLOR_GUNMETAL

/decl/flooring/tiling/new_tile/steel_grid
	icon_base = "grid"
	color = COLOR_GUNMETAL
	build_type = /obj/item/stack/tile/grid

/decl/flooring/tiling/new_tile/steel_ridged
	icon_base = "ridged"
	color = COLOR_GUNMETAL
	build_type = /obj/item/stack/tile/ridge
