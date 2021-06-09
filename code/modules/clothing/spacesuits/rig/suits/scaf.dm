//"Refurbished" SCAF RIGs
// - These are not intended to go anywhere but the store. Do not add them to random lists. - Snype

//SCAF Elite RIG
/obj/item/weapon/rig/scaf
	name = "refurbished SCAF rig"
	desc = "A lightweight and flexible armoured rig suit, designed for riot control and shipboard disciplinary enforcement."
	icon_state = "scaf_elite_rig"
	armor = list(melee = 72.5, bullet = 75, laser = 75, energy = 40, bomb = 75, bio = 100, rad = 75)
	online_slowdown = RIG_MEDIUM
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/scaf
	helm_type =  /obj/item/clothing/head/helmet/space/rig/scaf
	boot_type =  /obj/item/clothing/shoes/magboots/rig/scaf
	glove_type = /obj/item/clothing/gloves/rig/scaf

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/light	//These grenades are harmless illumination
		)

/obj/item/clothing/suit/space/rig/scaf
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/scaf
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/scaf
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/scaf
	name = "helmet"


//SCAF Legionnaire RIG
/obj/item/weapon/rig/scaf/legionnaire
	name = "refurbished SCAF expeditionary rig"
	desc = "A lightweight and flexible armoured rig suit, designed for riot control and shipboard disciplinary enforcement."
	icon_state = "scaf_legionnaire_rig"
	armor = list(melee = 72.5, bullet = 75, laser = 75, energy = 40, bomb = 75, bio = 100, rad = 75)
	online_slowdown = RIG_MEDIUM
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/scaf/legionnaire
	helm_type =  /obj/item/clothing/head/helmet/space/rig/scaf/legionnaire
	boot_type =  /obj/item/clothing/shoes/magboots/rig/scaf/legionnaire
	glove_type = /obj/item/clothing/gloves/rig/scaf/legionnaire

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/light	//These grenades are harmless illumination
		)

/obj/item/clothing/suit/space/rig/scaf/legionnaire
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/scaf/legionnaire
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/scaf/legionnaire
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/scaf/legionnaire
	name = "helmet"


//SCAF Sharpshooter RIG
/obj/item/weapon/rig/scaf/sharpshooter
	name = "refurbished SCAF sharpshooter rig"
	desc = "A lightweight and flexible armoured rig suit, designed for riot control and shipboard disciplinary enforcement."
	icon_state = "scaf_sharpshooter_rig"
	armor = list(melee = 72.5, bullet = 75, laser = 75, energy = 40, bomb = 75, bio = 100, rad = 75)
	online_slowdown = RIG_MEDIUM
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/scaf/sharpshooter
	helm_type =  /obj/item/clothing/head/helmet/space/rig/scaf/sharpshooter
	boot_type =  /obj/item/clothing/shoes/magboots/rig/scaf/sharpshooter
	glove_type = /obj/item/clothing/gloves/rig/scaf/sharpshooter

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/vision/nvgsec				//Unique advantage of the Sharpshooter rig vs its counterparts.
		)

/obj/item/clothing/suit/space/rig/scaf/sharpshooter
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/scaf/sharpshooter
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/scaf/sharpshooter
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/scaf/sharpshooter
	name = "helmet"
