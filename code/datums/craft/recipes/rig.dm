/datum/craft_recipe/rig
	category = "RIG"
	time = 150
	icon_state = "gun"

/datum/craft_recipe/rig/kinesis_upgrade
	name = "Advanced Kinesis Module (Upgrade)"
	desc = "Upgrade a standard kinesis module to improve its power and range"
	result = /obj/item/rig_module/kinesis/advanced
	flags = CRAFT_ON_WORKBENCH
	steps = list(
	list(CRAFT_OBJECT, /obj/item/rig_module/kinesis),
	list(CRAFT_STACK, /obj/item/stack/power_node, 1),
	list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10, WORKTIME_NORMAL, FAILCHANCE_NORMAL, SKILL_ELECTRICAL)
	)

/datum/craft_recipe/rig/intermediate
	name = "Intermediate Engineering RIG"
	desc = "Upgrade a Standard Engineering RIG into a Intermediate Engineering RIG"
	time = 50
	result = /obj/item/rig/intermediate
	steps = list(
	list(CRAFT_OBJECT, /obj/item/rig/engineering),
	list(CRAFT_STACK, /obj/item/stack/power_node, 3),
	list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10, WORKTIME_NORMAL, FAILCHANCE_NORMAL, SKILL_ELECTRICAL)
	)

/datum/craft_recipe/rig/excavation
	name = "Intermediate Mining RIG"
	desc = "Upgrade a Standard Mining RIG into a Intermediate Mining RIG"
	time = 50
	result = /obj/item/rig/excavation
	steps = list(
	list(CRAFT_OBJECT, /obj/item/rig/mining),
	list(CRAFT_STACK, /obj/item/stack/power_node, 3),
	list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10, WORKTIME_NORMAL, FAILCHANCE_NORMAL, SKILL_ELECTRICAL)
	)









/datum/craft_recipe/rig/flesh
	name = "Odd RIG"
	desc = "Upgrade a zealot rig into a odd rig"
	time = 50
	result = /obj/item/rig/zealot/flesh
	steps = list(
	list(CRAFT_OBJECT, /obj/item/rig/zealot),
	list(CRAFT_STACK, /obj/item/stack/special_node/evil, 1),
	list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10, WORKTIME_NORMAL, FAILCHANCE_NORMAL, SKILL_ELECTRICAL)
	)