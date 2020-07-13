/obj/item/weapon/rig/security
	name = "security rig"
	desc = "A lightweight and flexible armoured rig suit, designed for riot control and shipboard disciplinary enforcement."
	icon_state = "ds_security_rig"
	armor = list(melee = 50, bullet = 55, laser = 55, energy = 25, bomb = 60, bio = 100, rad = 60)
	offline_slowdown = 4
	online_slowdown = 2
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/security
	helm_type =  /obj/item/clothing/head/helmet/space/rig/security
	boot_type =  /obj/item/clothing/shoes/magboots/rig/security
	glove_type = /obj/item/clothing/gloves/rig/security

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/grenade_launcher/light,	//These grenades are harmless illumination
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/mounted/taser,
		/obj/item/rig_module/device/paperdispenser,	//For warrants and paperwork
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/vision/nvgsec
		)

/obj/item/clothing/suit/space/rig/security
	name = "suit"

/obj/item/clothing/gloves/rig/security
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/security
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/security
	name = "hood"




/decl/hierarchy/supply_pack/security/rig
	name = "Armor - Security rig"
	contains = list(/obj/item/weapon/rig/security)
	cost = 120
	containername = "\improper Security rig crate"
	containertype = /obj/structure/closet/crate/secure/large
	access = access_security