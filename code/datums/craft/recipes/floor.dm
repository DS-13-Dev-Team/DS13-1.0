// Re-organized 07-AUG-2020. This is now organized based on the tile obj list.

// MASTER

/datum/craft_recipe/floor
	category = "Tiles"
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 1, "time" = 1),
	)
	time = 1 //Crafting individual tiles is fast

// DANK

/datum/craft_recipe/floor/dank
	name = "grim floor tile"
	result = /obj/item/stack/tile/dank
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 1, "time" = 1),
	)

/datum/craft_recipe/floor/dank/heavy
	name = "grim heavy floor tile"
	result = /obj/item/stack/tile/dankheavy

/datum/craft_recipe/floor/dank/medical
	name = "grim medical floor tile"
	result = /obj/item/stack/tile/dankmedical

/datum/craft_recipe/floor/dank/mono
	name = "grim mono floor tile"
	result = /obj/item/stack/tile/dankmono

// FLOOR

/datum/craft_recipe/floor/steel
	name = "regular steel floor tile"
	result = /obj/item/stack/tile/floor

// MONO

/datum/craft_recipe/floor/monofloor
	name = "steel monofloor tile"
	result = /obj/item/stack/tile/mono

/datum/craft_recipe/floor/monofloor/white
	name = "white monofloor tile"
	result = /obj/item/stack/tile/mono/white

/datum/craft_recipe/floor/monofloor/dark
	name = "dark monofloor tile"
	result = /obj/item/stack/tile/mono/dark

// FLOOR DARK

/datum/craft_recipe/floor/dark
	name = "dark tile"
	result = /obj/item/stack/tile/floor_dark

// FLOOR FREEZER

/datum/craft_recipe/floor/freezer
	name = "freezer floor tile"
	result = /obj/item/stack/tile/floor_freezer

// FLOOR WHITE

/datum/craft_recipe/floor/white
	name = "white tile"
	result = /obj/item/stack/tile/floor_white

// GRID

/datum/craft_recipe/floor/grid
	name = "grey grid tile"
	result = /obj/item/stack/tile/grid

// LINOLEUM

/datum/craft_recipe/floor/linoleum
	name = "linoleum floor tile"
	result = /obj/item/stack/tile/linoleum
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_PLASTIC, 1),
	)
	time = 1 //Crafting individual tiles is fast

// RIDGE

/datum/craft_recipe/floor/ridge
	name = "ridge floor tile"
	result = /obj/item/stack/tile/ridge

// TECH

/datum/craft_recipe/floor/tech
	name = "tech grey floor tile"
	result = /obj/item/stack/tile/techgrey

/datum/craft_recipe/floor/tech/grid
	name = "tech grid floor tile"
	result = /obj/item/stack/tile/techgrid

/datum/craft_recipe/floor/tech/maint
	name = "panels maint floor tile"
	result = /obj/item/stack/tile/techmaint

// WOOD

/datum/craft_recipe/floor/wood
	name = "wood floor tile"
	result = /obj/item/stack/tile/wood
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 1, "time" = 2) // Flex that wood.
	)

// SPECIAL / UNRELATED

/datum/craft_recipe/floor/grille
	name = "regular grille"
	result = /obj/structure/grille
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(/obj/item/stack/rods, 2, "time" = 10)
	)


