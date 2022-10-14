/obj/item/rig/excavation
	name = "excavation RIG"
	desc = "A modified, lightweight version of the engineering suit. Perfect for quick operations."
	icon_state = "excavation_rig"
	armor = list(melee = 44, bullet = 44, laser = 40, energy = 15, bomb = 60, bio = 100, rad = 50)
	online_slowdown = RIG_FLEXIBLE

	chest_type = /obj/item/clothing/suit/space/rig/excavation
	helm_type =  /obj/item/clothing/head/helmet/space/rig/excavation
	boot_type =  /obj/item/clothing/shoes/magboots/rig/excavation
	glove_type = /obj/item/clothing/gloves/rig/excavation

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage/light,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		)

/obj/item/clothing/suit/space/rig/excavation
	name = "suit"

/obj/item/clothing/gloves/rig/excavation
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/excavation
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/excavation
	name = "hood"
