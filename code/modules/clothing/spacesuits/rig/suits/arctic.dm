/obj/item/rig/advanced/arctic
	name = "Arctic Survival RIG"
	desc = "A standard-issue Sovereign Colonies RIG used for exploring and generally weathering harsh environments otherwise hostile to human life, from space to an icy alien tundra."
	icon_state = "arctic_survival_rig"

	chest_type = /obj/item/clothing/suit/space/rig/arctic
	helm_type =  /obj/item/clothing/head/helmet/space/rig/arctic
	boot_type =  /obj/item/clothing/shoes/magboots/rig/arctic
	glove_type = /obj/item/clothing/gloves/rig/arctic

/obj/item/clothing/head/helmet/space/rig/arctic
	light_overlay = "arctic_light"

/obj/item/clothing/suit/space/rig/arctic
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA, ACCESSORY_SLOT_MEDAL, ACCESSORY_SLOT_ARMOR_S, ACCESSORY_SLOT_ARMOR_M) //this can fit insignia, medals, and rank boards - why take your suit off to show accolades on tau volantis?
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMOR_S)

/obj/item/clothing/gloves/rig/arctic
	name = "padded gloves"
	desc = "These gloves will protect the wearer from electric shocks and horrendous temperatures."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/arctic
	name = "boots"

/obj/item/rig/advanced/arctic/witness //donor variant - basically the same as the advanced suit, but looks dope
	name = "witness RIG"
	desc = "A Sovereign Colonies all-purpose survival RIG painted in a mesmerizing fashion as a tribute to the Church of Unitology and the general faith they hold."
	icon_state = "witness_rig"

