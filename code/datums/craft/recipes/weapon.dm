/datum/craft_recipe/weapon
	category = "Weapon"
	time = 60

	icon_state = "gun"

/datum/craft_recipe/weapon/baseballbat
	name = "baseball bat"
	result = /obj/item/material/twohanded/baseballbat
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 6)
	)

/datum/craft_recipe/weapon/grenade_casing
	name = "grenade casing"
	result = /obj/item/grenade/chem_grenade
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2)
	)

/datum/craft_recipe/weapon/fork
	name = "fork"
	result = /obj/item/material/kitchen/utensil/fork
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2)
	)

/datum/craft_recipe/weapon/knife
	name = "steel knife"
	result = /obj/item/material/knife
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 1)
	)

/datum/craft_recipe/weapon/spoon
	name = "spoon"
	result = /obj/item/material/kitchen/utensil/spoon
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 1)
	)


/datum/craft_recipe/weapon/knife_blade
	name = "knife blade"
	result = /obj/item/material/butterflyblade
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 6)
	)

/datum/craft_recipe/weapon/knife_grip
	name = "knife grip"
	result = /obj/item/material/butterflyhandle
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_PLASTEEL, 4)
	)

/datum/craft_recipe/weapon/crossbow_frame
	name = "crossbow frame"
	result = /obj/item/crossbowframe
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 5)
	)


/datum/craft_recipe/weapon/zipgun
	name = "zip gun frame"
	result = /obj/item/zipgunframe
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 12),
		list(CRAFT_TOOL, QUALITY_SAWING, 10, 90)
	)

/datum/craft_recipe/weapon/doublebarrel
	name = "double-barreled shotgun"
	result = /obj/item/gun/projectile/shotgun/doublebarrel
	steps = list(
		list(CRAFT_OBJECT, /obj/item/pipe, 20),
		list(CRAFT_TOOL, QUALITY_SAWING, 10, 60),
		list(CRAFT_TOOL, QUALITY_WELDING, 20, 90),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 8),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 8, "time" = 120),
		list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10, WORKTIME_NORMAL, FAILCHANCE_NORMAL, SKILL_ELECTRICAL),
		list(CRAFT_TOOL, QUALITY_WELDING, 20, 100),
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 12),
		list(CRAFT_TOOL, QUALITY_SAWING, 10, 60)
	)

/datum/craft_recipe/weapon/cane
	name = "cane"
	result = /obj/item/cane
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 2),
		list(CRAFT_TOOL, QUALITY_SAWING, 10, 120),
	)

/datum/craft_recipe/weapon/caneknife
	name = "concealed cane sword"
	result = /obj/item/cane/concealed
	steps = list(
		list(CRAFT_OBJECT, /obj/item/cane, 30),
		list(CRAFT_OBJECT, /obj/item/material/butterfly, 30),
		list(CRAFT_TOOL, QUALITY_SAWING, 10, 120),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 60)
	)

/datum/craft_recipe/weapon/star
	name = "shuriken"
	result = /obj/item/material/star
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 1),
		list(CRAFT_TOOL, QUALITY_SAWING, 10, 50)
	)

/datum/craft_recipe/weapon/bola
	name = "bola"
	result = /obj/item/projectile/bullet/shotgun/bola
	steps = list(
		list(CRAFT_OBJECT, /obj/item/handcuffs/cable, 60),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 6),
	)


/datum/craft_recipe/weapon/handmade_shield
	name = "handmade shield"
	result = /obj/item/shield/buckler
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 12),
		list(CRAFT_STACK, /obj/item/stack/rods, 4),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2)
	)

/datum/craft_recipe/weapon/tray_shield
	name = "handmade tray shield"
	result = /obj/item/shield/tray
	steps = list(
		list(CRAFT_OBJECT, /obj/item/tray),
		list(CRAFT_OBJECT, /obj/item/storage/belt),
		list(CRAFT_OBJECT, /obj/item/storage/belt)
	)


/datum/craft_recipe/weapon/flamethrower
	name = "PFM-100 Industrial Torch"
	result = /obj/item/gun/spray/hydrazine_torch
	steps = list(
		list(CRAFT_OBJECT, /obj/item/tool/weldingtool, "time" = 60),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 70),
		list(CRAFT_OBJECT, /obj/item/assembly/igniter,),
		list(CRAFT_STACK, /obj/item/stack/power_node, 1)
	)

/datum/craft_recipe/weapon/torch_tank
	name = "liquid fuel tank"
	result = /obj/item/reagent_containers/glass/fuel_tank
	steps = list(
		list(CRAFT_OBJECT, /obj/item/tank, "time" = 60),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 70),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2),
		list(CRAFT_TOOL, QUALITY_WELDING, 20, 70)
	)




/datum/craft_recipe/weapon/ripper
	name = "RC-DS Remote Control Disc Ripper"
	result = /obj/item/gun/projectile/ripper
	flags = CRAFT_ON_WORKBENCH
	time = 100
	steps = list(
	list(CRAFT_OBJECT, /obj/item/tool/wrench),
	list(CRAFT_OBJECT, /obj/item/stock_parts/matter_bin),
	list(CRAFT_STACK, /obj/item/stack/cable_coil, 5),
	list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10, WORKTIME_NORMAL, FAILCHANCE_NORMAL, SKILL_ELECTRICAL),
	list(CRAFT_STACK, /obj/item/stack/power_node, 1)
	)


/datum/craft_recipe/weapon/plasmacutter
	name = "Plasma Cutter"
	result = /obj/item/gun/energy/cutter/plasma
	flags = CRAFT_ON_WORKBENCH
	time = 200
	steps = list(
	list(CRAFT_OBJECT, /obj/item/gun/energy/cutter, WORKTIME_NORMAL, FALSE, /obj/item/gun/energy/cutter/plasma),
	list(CRAFT_STACK, /obj/item/stack/power_node, 1)
	)
