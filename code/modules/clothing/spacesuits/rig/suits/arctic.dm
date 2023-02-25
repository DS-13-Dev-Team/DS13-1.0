/obj/item/rig/arctic
	name = "Arctic Survival RIG"
	desc = "A standard-issue Sovereign Colonies RIG used for exploring and generally weathering harsh environments otherwise hostile to human life, from space to an icy alien tundra."
	icon_state = "arctic_survival_rig"
	armor = list(melee = 60, bullet = 60, laser = 60, energy = 30, bomb = 65, bio = 100, rad = 95) //cut and paste from advanced suit, no change
	offline_slowdown = RIG_VERY_HEAVY //this thing's a winter coat and armor at the same time!
	online_slowdown = RIG_LIGHT //but it's also purpose-built for staying mobile
	acid_resistance = 3
	seal_delay = 45

	chest_type = /obj/item/clothing/suit/space/rig/arctic
	helm_type =  /obj/item/clothing/head/helmet/space/rig/arctic
	boot_type =  /obj/item/clothing/shoes/magboots/rig/arctic
	glove_type = /obj/item/clothing/gloves/rig/arctic

	initial_modules = list(
		/obj/item/rig_module/healthbar/advanced,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/grenade_launcher/light,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/kinesis/advanced,
		/obj/item/rig_module/hotswap,
		/obj/item/rig_module/power_sink
		)

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

/obj/item/rig/arctic/witness //donor variant - basically the same as the advanced suit, but looks dope
	name = "witness RIG"
	desc = "A Sovereign Colonies all-purpose survival RIG painted in a mesmerizing fashion as a tribute to the Church of Unitology and the general faith they hold."
	icon_state = "witness_rig"
  
