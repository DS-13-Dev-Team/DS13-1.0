// Former patreon rig

/obj/item/rig/vintage/sea
	name = "Hazard Diving RIG"
	desc = "The heavy-duty hazard diving RIG is the standard among CEC deep sea mining operations. It's plating has been reinforced to withstand extreme undersea pressures and concussive forces."
	icon_state = "heavy_diving_rig"

	chest_type = /obj/item/clothing/suit/space/rig/sea
	helm_type =  /obj/item/clothing/head/helmet/space/rig/sea
	boot_type =  /obj/item/clothing/shoes/magboots/rig/sea
	glove_type = /obj/item/clothing/gloves/rig/sea

/obj/item/clothing/head/helmet/space/rig/sea
	name = "helmet"

/obj/item/clothing/suit/space/rig/sea
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/sea
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shocks."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/vintage/heavy
	name = "boots"

// Patreon rig

/obj/item/rig/advanced/dad
	name = "Elite Diving RIG"
	desc = "The elite diving RIG is the next generation of diving RIGs used among CEC deep sea mining operations. It's flexible reinforcements allow it to withstand extreme undersea pressures while retaining mobility."
	icon_state = "elite_diving_rig"

	chest_type = /obj/item/clothing/suit/space/rig/sea/dad
	helm_type =  /obj/item/clothing/head/helmet/space/rig/sea/dad
	boot_type =  /obj/item/clothing/shoes/magboots/rig/sea/dad
	glove_type = /obj/item/clothing/gloves/rig/sea/dad

/obj/item/clothing/head/helmet/space/rig/sea/dad
	name = "helmet"

/obj/item/clothing/suit/space/rig/sea/dad
	name = "suit"
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M)
	restricted_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/sea/dad
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shocks."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/sea/dad
	name = "boots"