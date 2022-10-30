A/*
	Advanced RIG

	High quality all around. Lightweight, good protection, no real drawbacks. The next generation of awesome
*/

/obj/item/rig/advanced
	name = "advanced RIG"
	desc = "The latest in cutting-edge RIG technology. Lightweight, tough, and packed with utilities"
	icon_state = "ds_advanced_rig"

	//Armor values are slightly higher than security rig in all categories
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 65, bio = 100, rad = 95)
	offline_slowdown = RIG_VERY_HEAVY
	online_slowdown = RIG_LIGHT
	acid_resistance = 3	//Contains a fair bit of plastic

	seal_delay = 45

	chest_type = /obj/item/clothing/suit/space/rig/advanced
	helm_type =  /obj/item/clothing/head/helmet/space/rig/advanced
	boot_type =  /obj/item/clothing/shoes/magboots/rig/advanced
	glove_type = /obj/item/clothing/gloves/rig/advanced


	initial_modules = list(
		/obj/item/rig_module/healthbar/advanced,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/kinesis/advanced,
		/obj/item/rig_module/hotswap,
		/obj/item/rig_module/power_sink
		)

/obj/item/clothing/suit/space/rig/advanced
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/advanced
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shocks."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/advanced
	name = "boots"

/obj/item/clothing/head/helmet/space/rig/advanced
	name = "helmet"
