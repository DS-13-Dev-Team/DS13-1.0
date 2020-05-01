/datum/craft_recipe/fortification
	category = "Fortifications"
	time = 80

	icon_state = "gun"


/datum/craft_recipe/fortification/pulse_turret
	name = "pulse turret"
	result = /obj/machinery/turret/covered/pulse
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 15),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10, 80),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 10, 150),
		list(CRAFT_STACK, /obj/item/stack/power_node, 2),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 80)
	)


/datum/craft_recipe/fortification/mechanical_trap
	name = "makeshift mechanical trap"
	result = /obj/item/weapon/beartrap/makeshift
	steps = list(
		list(CRAFT_OBJECT, /obj/item/weapon/tool/saw, "time" = 120),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10, 70),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 20),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10, 70),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 2, "time" = 10)
	)