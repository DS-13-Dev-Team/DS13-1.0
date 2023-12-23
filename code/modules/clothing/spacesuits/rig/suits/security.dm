//Ishimura Sec RIGs
//PCSI RIG
/obj/item/rig/pcsi
	name = "PCSI RIG"
	desc = "A lightweight and flexible armoured rig suit used by CEC shipboard security during crackdowns and for use in hazardous environments."
	icon_state = "pcsi_rig"
	armor = list(melee = 60, bullet = 64, laser = 60, energy = 0, bomb = 60, bio = 100, rad = 60)
	online_slowdown = RIG_MEDIUM
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/pcsi
	helm_type =  /obj/item/clothing/head/helmet/space/rig/pcsi
	boot_type =  /obj/item/clothing/shoes/magboots/rig/pcsi
	glove_type = /obj/item/clothing/gloves/rig/pcsi

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/device/paperdispenser,	//For warrants and paperwork
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/nvgsec
		)

/obj/item/clothing/head/helmet/space/rig/pcsi

/obj/item/clothing/suit/space/rig/pcsi
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/shoes/magboots/rig/pcsi

/obj/item/clothing/gloves/rig/pcsi

//Titan Security RIG
/obj/item/rig/pcsi/security
	name = "Security RIG"
	desc = "A lightweight and flexible armoured rig suit, designed for riot control and shipboard disciplinary enforcement."
	icon_state = "ds_security_rig"

//PCSI Patreon RIGs
/obj/item/rig/pcsi/ruined
	name = "PCSI Survivor RIG"
	desc = "The RIG remains battered and beaten, dented and missing pieces. The blood remains permanently rusted to the frame. The will of the survivor remains unbroken."
	icon_state = "pcsi_rig_ruined"

/obj/item/rig/pcsi/carver
	name = "Spec Ops RIG"
	desc = "A heavily armoured rig suit, designed for military use. Especially effective against bullets."
	icon_state = "carver_rig"

	helm_type =  /obj/item/clothing/head/helmet/space/rig/carver

/obj/item/clothing/head/helmet/space/rig/carver
	name = "helmet"
	light_overlay = "carver_light"

//PCSI Riot RIG
/obj/item/rig/riot
	name = "Riot RIG"
	desc = "A lightweight and flexible armoured rig suit used by CEC shipboard security during crackdowns and for use in hazardous environments."
	icon_state = "ds_riot_rig"
	armor = list(melee = 65, bullet = 60, laser = 55, energy = 30, bomb = 65, bio = 100, rad = 60)
	online_slowdown = RIG_MEDIUM
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/riot
	helm_type =  /obj/item/clothing/head/helmet/space/rig/riot
	boot_type =  /obj/item/clothing/shoes/magboots/rig/riot
	glove_type = /obj/item/clothing/gloves/rig/riot

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/device/paperdispenser,	//For warrants and paperwork
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/nvgsec
		)

/obj/item/clothing/suit/space/rig/riot
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/riot
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/riot
	name = "boots"

/obj/item/clothing/head/helmet/space/rig/riot
	name = "helmet"

//PCSI Patrol RIG
/obj/item/rig/riot/patrol
	name = "Patrol RIG"
	desc = "A very lightweight yet reasonably armoured suit, designed for long journeys on foot."
	icon_state = "patrol"
	armor = list(melee = 60, bullet = 65, laser = 55, energy = 30, bomb = 65, bio = 100, rad = 60)
