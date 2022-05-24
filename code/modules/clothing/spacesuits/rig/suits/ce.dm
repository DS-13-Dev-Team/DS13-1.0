/obj/item/weapon/rig/ce
	name = "chief engineer's RIG"
	desc = "A lightweight and flexible armoured rig suit, designed for mining and shipboard engineering. This one has a pretentious tag reading 'CE' slapped onto it. It also seems slightly more reinforced."
	icon_state = "ds_engineering_rig"
	armor = list(melee = 44, bullet = 55, laser = 55, energy = 27.5, bomb = 66, bio = 100, rad = 100)
	offline_slowdown = 4.7
	online_slowdown = RIG_HEAVY
	acid_resistance = 2.3	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/engineering
	helm_type =  /obj/item/clothing/head/helmet/space/rig/engineering
	boot_type =  /obj/item/clothing/shoes/magboots/rig/engineering
	glove_type = /obj/item/clothing/gloves/rig/engineering

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/kinesis,
		/obj/item/rig_module/hotswap,
		/obj/item/rig_module/power_sink
		)
