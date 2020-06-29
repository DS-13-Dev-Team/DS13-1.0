/obj/item/weapon/rig/vintage
	name = "antique CEC suit"
	desc = "An extremely bulky, durable vintage suit that has mostly been replaced by sleeker modern designs. Some collectors still value the good old days though."
	icon_state = "vintage_rig"
	armor = list(melee = 70, bullet = 70, laser = 70, energy = 25, bomb = 90, bio = 100, rad = 70)
	offline_slowdown = 5
	online_slowdown = 3.5

	chest_type = /obj/item/clothing/suit/space/rig/vintage
	helm_type =  /obj/item/clothing/head/helmet/space/rig/vintage
	boot_type =  /obj/item/clothing/shoes/magboots/rig/vintage
	glove_type = /obj/item/clothing/gloves/rig/vintage

	initial_modules = list(
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/healthbar
		)

/obj/item/clothing/suit/space/rig/vintage
	name = "suit"

/obj/item/clothing/gloves/rig/vintage
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/vintage
	name = "shoes"

/obj/item/clothing/head/helmet/space/rig/vintage
	name = "hood"
