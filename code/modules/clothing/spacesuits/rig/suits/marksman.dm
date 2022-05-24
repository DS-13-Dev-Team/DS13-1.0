/obj/item/weapon/rig/marksman
	name = "marksman RIG"
	desc = "A RIG designed for usage by a vessel's forensics specialist."
	icon_state = "marksman_rig"
	armor = list(melee = 57.5, bullet = 60, laser = 60, energy = 25, bomb = 60, bio = 100, rad = 60)
	online_slowdown = RIG_MEDIUM

	chest_type = /obj/item/clothing/suit/space/rig/marksman
	helm_type =  /obj/item/clothing/head/helmet/space/rig/marksman
	boot_type =  /obj/item/clothing/shoes/magboots/rig/marksman
	glove_type = /obj/item/clothing/gloves/rig/marksman

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/kinesis,
		/obj/item/rig_module/device/paperdispenser,	//For warrants and paperwork
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/vision/nvgsec,
		/obj/item/rig_module/hotswap
		)

/obj/item/clothing/suit/space/rig/marksman
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/marksman
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shocks."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/marksman
	name = "boots"

/obj/item/clothing/head/helmet/space/rig/marksman
	name = "helmet"
	light_overlay = "wasp_light"

/obj/item/weapon/rig/marksman/store
	name = "marksman RIG"
	desc = "A RIG designed for usage by a vessel's forensics specialist."
	icon_state = "marksman_rig"
	armor = list(melee = 57.5, bullet = 60, laser = 60, energy = 25, bomb = 60, bio = 100, rad = 60)
	online_slowdown = RIG_MEDIUM

	chest_type = /obj/item/clothing/suit/space/rig/marksman
	helm_type =  /obj/item/clothing/head/helmet/space/rig/marksman
	boot_type =  /obj/item/clothing/shoes/magboots/rig/marksman
	glove_type = /obj/item/clothing/gloves/rig/marksman

	initial_modules = list(
		/obj/item/rig_module/healthbar/advanced,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/kinesis/advanced,
		/obj/item/rig_module/device/paperdispenser,	//For warrants and paperwork
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/vision/nvgsec,
		/obj/item/rig_module/hotswap
		)