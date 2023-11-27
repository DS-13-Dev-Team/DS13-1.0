/obj/item/rig/cseco
	name = "P-Sec Commander RIG"
	desc = "A lightweight and flexible armoured rig suit used by CEC shipboard security during crackdowns and for use in hazardous environments. This instance was designed specially for CSECO."
	icon_state = "pcsi_riot_rig"
	armor = list(melee = 70, bullet = 67, laser = 60, energy = 30, bomb = 75, bio = 100, rad = 60)
	online_slowdown = RIG_MEDIUM
	acid_resistance = 2	//Contains a fair bit of plastic
	allowed = list(/obj/item/shield/riot)

	chest_type = /obj/item/clothing/suit/space/rig/cseco
	helm_type =  /obj/item/clothing/head/helmet/space/rig/cseco
	boot_type =  /obj/item/clothing/shoes/magboots/rig/cseco
	glove_type = /obj/item/clothing/gloves/rig/cseco

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/device/paperdispenser,	//For warrants and paperwork
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/nvgsec
		)

/obj/item/rig/cseco/Initialize()
	. = ..()
	if(istype(GLOB.using_map, /datum/map/ishimura))
		name = "P.C.S.I Commander RIG"

/obj/item/clothing/suit/space/rig/cseco
	name = "armor"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/cseco
	name = "gauntlets"

/obj/item/clothing/shoes/magboots/rig/cseco
	name = "boots"

/obj/item/clothing/head/helmet/space/rig/cseco
	name = "helmet"
