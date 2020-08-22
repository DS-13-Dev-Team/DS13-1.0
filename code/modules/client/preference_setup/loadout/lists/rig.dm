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

/*	There's no space to display this, need to reformat the loadout menu in future
/datum/gear/RIG/frame/get_description(var/metadata)
	.=..()
	. += "\n\n"
	. += "Included Modules:\n"
	var/obj/item/weapon/rig/R = path
	for (var/typepath in initial(R.initial_modules))
		var/obj/item/rig_module/RM = typepath
		. += "	-[initial(RM.name)]\n"

*/

/datum/gear/RIG/frame/civilian
	display_name = "civilian RIG"
	path = /obj/item/weapon/rig/civilian

	cost = 0


/*
/datum/gear/RIG/frame/hacker
	display_name = "digital infiltration RIG"
	path = /obj/item/weapon/rig/light/hacker

	cost = 4
	patron_only = TRUE

*/









/*
	Modules:
	The things that go inside rigs
*/

/datum/gear/RIG/module

	category = /datum/gear/RIG/module
	priority = 2 //These should come after a frame is equipped

	//They go into a rig frame, so you need to pick one first
	required_tags = list(LOADOUT_TAG_RIG)

	slot = GEAR_EQUIP_SPECIAL


//Rig modules attempt to install into any worn rig
/datum/gear/RIG/module/spawn_special(var/mob/living/carbon/human/H,  var/metadata)
	var/obj/item/rig_module/RM = ..()
	if (H.wearing_rig)
		if (H.wearing_rig.attempt_install(RM, user = null, force = TRUE, instant = TRUE, delete_replaced = TRUE))
			return

	//If we get here, the user is not wearing a rig, or installation failed somehow#
	//Spawn in storage as a fallback option
	spawn_in_storage_or_drop(H, metadata)



/*
	Standard storage compartment.
	Intended as an upgrade for rigs that come with the light version by default
*/
/datum/gear/RIG/module/storage
	display_name = "standard storage compartment"
	path = /obj/item/rig_module/storage

	cost = 2

	//Can't take it if you already have standard or better
	exclusion_tags = list(LOADOUT_TAG_RIG_STORAGE_2, LOADOUT_TAG_RIG_STORAGE_3, LOADOUT_TAG_RIG_STORAGE_ANY)
	tags = list(LOADOUT_TAG_RIG_STORAGE_2, LOADOUT_TAG_RIG_STORAGE_ANY)

/datum/gear/RIG/module/bigstorage
	display_name = "expanded storage compartment"
	path = /obj/item/rig_module/storage/heavy

	cost = 3

	//Can't take it if you already have it
	exclusion_tags = list(LOADOUT_TAG_RIG_STORAGE_3, LOADOUT_TAG_RIG_STORAGE_ANY)
	tags = list(LOADOUT_TAG_RIG_STORAGE_3, LOADOUT_TAG_RIG_STORAGE_ANY)




/datum/gear/RIG/module/hotswap
	display_name = "hotswap module"
	path = /obj/item/rig_module/hotswap

	cost = 1

	//Can't take it if you already have it
	exclusion_tags = list(LOADOUT_TAG_RIG_HOTSWAP)
	tags = list(LOADOUT_TAG_RIG_HOTSWAP)



/datum/gear/RIG/module/maneuvering_jets
	display_name = "RIG maneuvering jets"

	cost = 1

	path = /obj/item/rig_module/maneuvering_jets
	tags = list(LOADOUT_TAG_RIG_JETPACK)
	exclusion_tags = list(LOADOUT_TAG_RIG_JETPACK)




/datum/gear/RIG/module/kinesis
	display_name = "G.R.I.P kinesis module"

	cost = 3

	path = /obj/item/rig_module/kinesis
	tags = list(LOADOUT_TAG_RIG_KINESIS)
	exclusion_tags = list(LOADOUT_TAG_RIG_KINESIS)


/datum/gear/RIG/module/siphon
	display_name = "Power Siphon"

	cost = 2

	path = /obj/item/rig_module/power_sink
	tags = list(LOADOUT_TAG_RIG_POWERSIPHON)
	exclusion_tags = list(LOADOUT_TAG_RIG_POWERSIPHON)