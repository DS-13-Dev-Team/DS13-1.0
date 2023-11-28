/obj/item/rig/engineering
	name = "Standard Engineering RIG"
	desc = "the most basic form of Resource Integration Gear available for engineers throughout the course of their employment."
	icon_state = "ds_engineering_rig"
	armor = list(melee = 45, bullet = 45, laser = 45, energy = 25, bomb = 60, bio = 100, rad = 75)
	offline_slowdown = 4
	online_slowdown = RIG_MEDIUM
	acid_resistance = 2	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/engineering
	helm_type =  /obj/item/clothing/head/helmet/space/rig/engineering
	boot_type =  /obj/item/clothing/shoes/magboots/rig/engineering
	glove_type = /obj/item/clothing/gloves/rig/engineering

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/kinesis,
		/obj/item/rig_module/hotswap,
		/obj/item/rig_module/power_sink
		)

/obj/item/clothing/suit/space/rig/engineering
	name = "suit"

/obj/item/clothing/gloves/rig/engineering
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shocks."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/engineering
	name = "boots"

/obj/item/clothing/head/helmet/space/rig/engineering
	name = "helmet"

/obj/item/rig/engineering/forged
	name = "Standard Forged Engineering RIG"
	icon_state = "forged_rig"

/obj/item/rig/engineering/wasp
	name = "Wasp RIG"
	desc = "A lightweight and flexible armoured rig suit, offers good protection against light impacts. Use kit on an Engineering RIG."
	icon_state = "wasp_rig"

/obj/item/rig/engineering/forged_new
	name = "Standard Forged Engineering RIG"
	icon_state = "engineer_standard_forged_rig"


/// int



/obj/item/rig/intermediate
	name = "Intermediate Engineering RIG"
	desc = "A intermediate engineering suit, issued to class 2 engineers; designed for shipboard engineering."
	icon_state = "engineer_intermediate_rig"
	armor = list(melee = 53.25, bullet = 53.75, laser = 53.75, energy = 27.5, bomb = 67.5, bio = 100, rad = 85)
	online_slowdown = RIG_FLEXIBLE
	acid_resistance = 2.5

	chest_type = /obj/item/clothing/suit/space/rig/intermediate
	helm_type =  /obj/item/clothing/head/helmet/space/rig/intermediate
	boot_type =  /obj/item/clothing/shoes/magboots/rig/intermediate
	glove_type = /obj/item/clothing/gloves/rig/intermediate

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/kinesis,
		/obj/item/rig_module/hotswap,
		/obj/item/rig_module/power_sink
		)

/obj/item/clothing/suit/space/rig/intermediate
	name = "suit"

/obj/item/clothing/gloves/rig/intermediate
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shocks."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/intermediate
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/intermediate
	name = "helmet"

/obj/item/rig/intermediate/forged
	name = "Intermediate Forged Engineering RIG"
	icon_state = "engineer_intermediate_forged_rig"

/obj/item/rig/intermediate/survivor
	name = "Intermediate Survivor Engineering RIG"
	icon_state = "intermediate_engineer_survivor_rig"

// adv


/obj/item/rig/advanced/engineering
	name = "Advanced Engineering RIG"
	desc = "Exclusive only to upper class engineers who have passed rigorous training and performed multiple repairs in hostile environments."
	icon_state = "advanced_engineer_rig"

/obj/item/rig/advanced/forged
	name = "Forged Advanced Engineering RIG"
	desc = "Exclusive only to upper class engineers who have passed rigorous training and performed multiple repairs in hostile environments."
	icon_state = "engineer_advanced_forged_rig"
