/obj/item/weapon/rig/mining
	name = "intermediate hazard suit"
	desc = "A cheaper version of the engineering suit. Commonly used during planet cracking operations."
	icon_state = "ds_mining_rig"
	armor = list(melee = 32.5, bullet = 42.5, laser = 42.5, energy = 15, bomb = 70, bio = 100, rad = 50)
	offline_slowdown = 3.5
	online_slowdown = 2
	acid_resistance = 1.75	//Contains a fair bit of plastic

	chest_type = /obj/item/clothing/suit/space/rig/mining
	helm_type =  /obj/item/clothing/head/helmet/space/rig/mining
	boot_type =  /obj/item/clothing/shoes/magboots/rig/mining
	glove_type = /obj/item/clothing/gloves/rig/mining

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage/light,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		)

/obj/item/clothing/suit/space/rig/mining
	name = "suit"

/obj/item/clothing/gloves/rig/mining
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/mining
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/mining
	name = "hood"
