/datum/craft_recipe/machinery
	category = "Machinery"
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	time = 120

/datum/craft_recipe/machinery/machine_frame
	name = "machine frame"
	result = /obj/machinery/constructable_frame/machine_frame
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 8),
	)


/datum/craft_recipe/machinery/computer_frame
	name = "computer frame"
	result = /obj/structure/computerframe
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 8),
	)

/datum/craft_recipe/machinery/modularconsole
	name = "modular console frame"
	result = /obj/item/modular_computer/console
	time = 200
	flags = CRAFT_ON_FLOOR|CRAFT_ONE_PER_TURF
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 4),
	)

/datum/craft_recipe/machinery/modularlaptop
	name = "modular laptop frame"
	result = /obj/item/modular_computer/laptop
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 4),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 4),
	)

/datum/craft_recipe/machinery/modulartablet
	name = "modular tablet frame"
	result = /obj/item/modular_computer/tablet
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 5),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 2),
	)

/datum/craft_recipe/machinery/modularpda
	name = "modular pda frame"
	result = /obj/item/modular_computer/pda
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 3),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 1),
	)

/datum/craft_recipe/machinery/modulartelescreen
	name = "modular telescreen frame"
	result = /obj/item/modular_computer/telescreen
	time = 200
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 8),
		list(CRAFT_MATERIAL, MATERIAL_GLASS, 6),
	)


//Airlocks
/datum/craft_recipe/machinery/airlock
	name = "standard airlock assembly"
	result = /obj/structure/door_assembly
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
	)

/datum/craft_recipe/machinery/airlock/external
	name = "external airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_ext

/datum/craft_recipe/machinery/airlock/airtight
	name = "airtight hatch assembly"
	result = /obj/structure/door_assembly/door_assembly_hatch

/datum/craft_recipe/machinery/airlock/high_security
	name = "high security airlock assembly"
	result = /obj/structure/door_assembly/door_assembly_highsecurity

/datum/craft_recipe/machinery/airlock/emergency_shutter
	name = "emergency shutter"
	result = /obj/structure/firedoor_assembly

/datum/craft_recipe/machinery/airlock/multitile
	name = "multi-tile airlock assembly"
	result = /obj/structure/door_assembly/multi_tile
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 20),
	)


//wall or small you know them req only 2 list
/datum/craft_recipe/machinery/wall
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 2),
	)
	flags = null

/datum/craft_recipe/machinery/wall/lightfixture
	name = "light fixture frame"
	result = /obj/item/frame/light

/datum/craft_recipe/machinery/wall/lightfixture/small
	name = "small light fixture frame"
	result = /obj/item/frame/light/small

/datum/craft_recipe/machinery/wall/apc
	name = "apc frame"
	result = /obj/item/frame/apc

/datum/craft_recipe/machinery/wall/air_alarm
	name = "air alarm frame"
	result = /obj/item/frame/air_alarm

/datum/craft_recipe/machinery/wall/fire_alarm
	name = "fire alarm frame"
	result = /obj/item/frame/fire_alarm

/datum/craft_recipe/machinery/AI_core
	name = "AI core"
	result = /obj/structure/AIcore
	steps = list(
		list(CRAFT_MATERIAL, MATERIAL_PLASTEEL, 10),
	)



/datum/craft_recipe/machinery/robot_limb
	time = 120
	flags = CRAFT_ON_WORKBENCH
	icon_state = "electronic"

/datum/craft_recipe/machinery/robot_limb/l_arm
	name = "robotic left arm"
	result = /obj/item/robot_parts/l_arm
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 5),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10), //Rough frame
		list(CRAFT_TOOL, QUALITY_SAWING, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 30),
		list(CRAFT_MATERIAL, MATERIAL_PLASTEEL, 10),//Base frame to build on
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/matter_bin),//Extra materials "awaiting construction"
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator, 30),//Motors for the joints (shoulder, elbow)
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator/nano, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator/nano, 30),//Fine, more advanced manipulators, for the fingers and wrist
		list(CRAFT_OBJECT, /obj/item/stock_parts/scanning_module/adv, 30),//Sensor for feeling with hand, and movement
		list(CRAFT_OBJECT, /obj/item/computer_hardware/hard_drive, 30),
		list(CRAFT_OBJECT, /obj/item/computer_hardware/processor_unit, 30),//Console parts, controls and processes rest of parts.
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 20),//Wiring parts together
		list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10),
		list(CRAFT_STACK, /obj/item/stack/power_node, 1),//Powers the arm
		list(CRAFT_TOOL, QUALITY_PULSING, 10),//Uploading program from bench, linking parts
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_MATERIAL, MATERIAL_PLASTIC, 10),//Final covers
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10),
	)

/datum/craft_recipe/machinery/robot_limb/r_arm
	name = "robotic right arm"
	result = /obj/item/robot_parts/r_arm
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 5),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_TOOL, QUALITY_SAWING, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 30),
		list(CRAFT_MATERIAL, MATERIAL_PLASTEEL, 10),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/matter_bin),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator/nano, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator/nano, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/scanning_module/adv, 30),
		list(CRAFT_OBJECT, /obj/item/computer_hardware/hard_drive, 30),
		list(CRAFT_OBJECT, /obj/item/computer_hardware/processor_unit, 30),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 20),
		list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10),
		list(CRAFT_STACK, /obj/item/stack/power_node, 1),
		list(CRAFT_TOOL, QUALITY_PULSING, 10),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_MATERIAL, MATERIAL_PLASTIC, 10),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10),
	)


/datum/craft_recipe/machinery/robot_limb/l_leg
	name = "robotic left leg"
	result = /obj/item/robot_parts/l_leg
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 5),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_TOOL, QUALITY_SAWING, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 30),
		list(CRAFT_MATERIAL, MATERIAL_PLASTEEL, 10),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/matter_bin),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator/nano, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator/nano, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/scanning_module/adv, 30),
		list(CRAFT_OBJECT, /obj/item/computer_hardware/hard_drive, 30),
		list(CRAFT_OBJECT, /obj/item/computer_hardware/processor_unit, 30),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 20),
		list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10),
		list(CRAFT_STACK, /obj/item/stack/power_node, 1),
		list(CRAFT_TOOL, QUALITY_PULSING, 10),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_MATERIAL, MATERIAL_PLASTIC, 10),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10),
	)

/datum/craft_recipe/machinery/robot_limb/r_leg
	name = "robotic right leg"
	result = /obj/item/robot_parts/r_leg
	steps = list(
		list(CRAFT_STACK, /obj/item/stack/rods, 5),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_TOOL, QUALITY_SAWING, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 30),
		list(CRAFT_MATERIAL, MATERIAL_PLASTEEL, 10),
		list(CRAFT_TOOL, QUALITY_BOLT_TURNING, 10),
		list(CRAFT_TOOL, QUALITY_WELDING, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/matter_bin),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator/nano, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/manipulator/nano, 30),
		list(CRAFT_OBJECT, /obj/item/stock_parts/scanning_module/adv, 30),
		list(CRAFT_OBJECT, /obj/item/computer_hardware/hard_drive, 30),
		list(CRAFT_OBJECT, /obj/item/computer_hardware/processor_unit, 30),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10),
		list(CRAFT_STACK, /obj/item/stack/cable_coil, 20),
		list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10),
		list(CRAFT_STACK, /obj/item/stack/power_node, 1),
		list(CRAFT_TOOL, QUALITY_PULSING, 10),
		list(CRAFT_MATERIAL, MATERIAL_STEEL, 10),
		list(CRAFT_MATERIAL, MATERIAL_PLASTIC, 10),
		list(CRAFT_TOOL, QUALITY_SCREW_DRIVING, 10),
	)