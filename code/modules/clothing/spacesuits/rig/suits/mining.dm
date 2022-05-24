/obj/item/weapon/rig/mining
	name = "hazard mining RIG"
	desc = "A cheaper version of the engineering suit. Commonly used during planet cracking operations."
	icon_state = "ds_mining_rig"
	armor = list(melee = 27.60, bullet = 36.12, laser = 36.12, energy = 12.75, bomb = 59.5, bio = 85, rad = 42.5)
	online_slowdown = RIG_HEAVY

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

/obj/item/weapon/rig/mining/store
	name = "hazard mining RIG"
	desc = "A cheaper version of the engineering suit. Commonly used during planet cracking operations. This one looks brand new, as if from a store."
	icon_state = "ds_mining_rig"
	armor = list(melee = 29.25, bullet = 38.25, laser = 38.25, energy = 13.5, bomb = 63, bio = 90, rad = 45)
	online_slowdown = RIG_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/mining
	helm_type =  /obj/item/clothing/head/helmet/space/rig/mining
	boot_type =  /obj/item/clothing/shoes/magboots/rig/mining
	glove_type = /obj/item/clothing/gloves/rig/mining

	initial_modules = list(
		/obj/item/rig_module/healthbar/advanced,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		)