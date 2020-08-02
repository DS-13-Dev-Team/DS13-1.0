/obj/item/weapon/rig/engineering
	name = "engineering rig"
	desc = "A lightweight and flexible armoured rig suit, designed for mining and shipboard engineering."
	icon_state = "ds_engineering_rig"
	armor = list(melee = 45, bullet = 60, laser = 60, energy = 25, bomb = 60, bio = 100, rad = 60)
	offline_slowdown = 4
	online_slowdown = 2
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/engineering
	helm_type =  /obj/item/clothing/head/helmet/space/rig/engineering
	boot_type =  /obj/item/clothing/shoes/magboots/rig/engineering
	glove_type = /obj/item/clothing/gloves/rig/engineering

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/kinesis
		)

/obj/item/clothing/suit/space/rig/engineering
	name = "suit"

/obj/item/clothing/gloves/rig/engineering
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/engineering
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/engineering
	name = "hood"




/decl/hierarchy/supply_pack/engineering/rig
	name = "Armor - Engineering rig"
	contains = list(/obj/item/weapon/rig/engineering)
	cost = 120
	containername = "\improper Engineering rig crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_engineering