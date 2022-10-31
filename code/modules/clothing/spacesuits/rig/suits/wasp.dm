/obj/item/rig/wasp
	name = "wasp RIG"
	desc = "A lightweight and flexible armoured rig suit, offers good protection against light impacts. Use kit on an Engineering RIG."
	icon_state = "wasp_rig"
	armor = list(melee = 47.5, bullet = 53, laser = 55, energy = 30, bomb = 65, bio = 100, rad = 80)
	offline_slowdown = 4
	online_slowdown = RIG_MEDIUM
	acid_resistance = 2	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/wasp
	helm_type =  /obj/item/clothing/head/helmet/space/rig/wasp
	boot_type =  /obj/item/clothing/shoes/magboots/rig/wasp
	glove_type = /obj/item/clothing/gloves/rig/wasp

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/kinesis,
		/obj/item/rig_module/hotswap,
		/obj/item/rig_module/power_sink
		)

/obj/item/clothing/suit/space/rig/wasp
	name = "suit"

/obj/item/clothing/gloves/rig/wasp
	name = "insulated gloves"
	desc = "These gloves will protect the wearer from electric shocks."
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/wasp
	name = "boots"

/obj/item/clothing/head/helmet/space/rig/wasp
	name = "helmet"
	light_overlay = "wasp_light"