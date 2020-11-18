/datum/craft_recipe/fortification
	category = "Fortifications"
	time = 80

	icon_state = "gun"


/datum/craft_recipe/fortification/pulse_turret
	name = "pulse turret"
	result = /obj/machinery/turret/covered/pulse/active
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 15),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10, 80),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 10, 150),
		list(CRAFT_STACK, /obj/item/stack/power_node, 1),
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

/datum/craft_recipe/fortification/wood_barricade
	name = "wooden barricade"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	desc = "A sturdy obstacle made of wood, which will block passage and serve as cover that can be fired over. This is cheap and quick to construct. <br>\
	Barricades can be upgraded with the addition of metal rods, adding spikes which will harm attackers and turn it into a hazard."
	result = /obj/structure/barricade/wood
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_WOOD, 3),
		list(CRAFT_TOOL, QUALITY_SAWING, 10, 60))


/datum/craft_recipe/fortification/metal_barricade
	name = "metal barricade"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	result = /obj/structure/barricade/steel
	desc = "A sturdy barricade made of welded steel. Tougher than wood, but requires more time, resources, tools and effort to construct. <br>\
	Barricades can be upgraded with the addition of metal rods, adding spikes which will harm attackers and turn it into a hazard."
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10, 50),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 3),
		list(CRAFT_TOOL, QUALITY_WELDING, 10, 50),
	)