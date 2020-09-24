/datum/craft_recipe/rig
	category = "RIG"
	time = 150
	icon_state = "gun"

/datum/craft_recipe/rig/kinesis_upgrade
	name = "Advanced Kinesis Module (Upgrade)"
	desc = "Upgrade a standard kinesis module to improve its power and range"
	result = /obj/item/rig_module/kinesis/advanced
	flags = CRAFT_ON_SURFACE
	passive_steps = list(
	list(CRAFT_PASSIVE, QUALITY_WORKBENCH, 1, 0)
	)
	steps = list(
	list(CRAFT_OBJECT, /obj/item/rig_module/kinesis),
	list(CRAFT_STACK, /obj/item/stack/power_node, 1),
	list(CRAFT_TOOL, QUALITY_WIRE_CUTTING, 10, WORKTIME_NORMAL, FAILCHANCE_NORMAL, SKILL_ELECTRICAL)
	)