/*
	Advanced RIG

	High quality all around. Extremely lightweight, comes with effective modules, exclusive to the EDF Marine Lieutenant
*/

/obj/item/rig/advanced
	name = "advanced RIG"
	desc = "The latest in cutting-edge RIG technology, manufactured by Earthgov laboraties for use in special forces applications. A self-resealing bodysuit mitigates the would-be weight of any armor."
	icon_state = "ds_advanced_rig"
	armor = list(melee = 75, bullet = 75, laser = 75, energy = 40, bomb = 75, bio = 100, rad = 75)
	cell_type =  /obj/item/cell/hyper
	offline_slowdown = RIG_VERY_HEAVY
	online_slowdown = RIG_VERY_LIGHT //flexible bodysuit, incredibly easy to move around in so long as it's powered
	acid_resistance = 3	//Contains a fair bit of plastic

	seal_delay = 45

	chest_type = /obj/item/clothing/suit/space/rig/advanced
	helm_type =  /obj/item/clothing/head/helmet/space/rig/advanced
	boot_type =  /obj/item/clothing/shoes/magboots/rig/advanced
	glove_type = /obj/item/clothing/gloves/rig/advanced


	initial_modules = list(
		/obj/item/rig_module/healthbar/advanced,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/grenade_launcher/military,
		/obj/item/rig_module/chem_dispenser/combat, //how do you think isaac got outta the sprawl in one piece? drugs.
		/obj/item/rig_module/extension/speedboost/advanced,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/multi,
		/obj/item/rig_module/kinesis/advanced,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/hotswap,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/self_destruct,
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
