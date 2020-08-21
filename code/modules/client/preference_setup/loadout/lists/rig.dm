/datum/gear/RIG
	sort_category = "RIG"
	category = /datum/gear/RIG

/*
	Frames
	AKA Suits, Cores, Rigs.
	Often incorrectly called modules
	They are the thing you wear on your back
*/
/datum/gear/RIG/frame
	gear_tweaks = list(/datum/gear_tweak/RIG/active)
	slot = slot_back
	category = /datum/gear/RIG/frame

	//Only one rig can be equipped
	tags = list(LOADOUT_TAG_RIG)
	exclusion_tags = list(LOADOUT_TAG_RIG)

	equip_adjustments = OUTFIT_ADJUSTMENT_SKIP_BACKPACK

/datum/gear/RIG/frame/civilian
	display_name = "civilian RIG"
	path = /obj/item/weapon/rig/civilian

	cost = 1


/datum/gear/RIG/frame/engineering
	display_name = "engineering RIG"
	path = /obj/item/weapon/rig/engineering

	cost = 6


/*
	Modules:
	The things that go inside rigs
*/

/datum/gear/RIG/module

	category = /datum/gear/RIG/module
	priority = 2 //These should come after a frame is equipped

	//They go into a rig frame, so you need to pick one first
	required_tags = list(LOADOUT_TAG_RIG)