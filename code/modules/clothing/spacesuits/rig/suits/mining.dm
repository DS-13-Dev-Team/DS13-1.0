/obj/item/rig/mining
	name = "Standard Mining RIG"
	desc = "A standard issued mining suit, issued to class 1 miners; Commonly used during planet cracking operations."
	icon_state = "ds_mining_rig"
	armor = list(melee = 43.5, bullet = 42.5, laser = 42.5, energy = 15, bomb = 70, bio = 100, rad = 50)
	online_slowdown = RIG_MEDIUM
	acid_resistance = 2

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

/obj/item/rig/excavation
	name = "Intermediate Mining RIG"
	desc = "Exclusive only to class 2 miners and is a standard equipment when working in hostile environments or during a hazardous mining operation."
	icon_state = "excavation_rig"
	armor = list(melee = 51.75, bullet = 51.25, laser = 51.25, energy = 22.5, bomb = 67.5, bio = 100, rad = 72.5)
	online_slowdown = RIG_FLEXIBLE
	acid_resistance = 2.5

	chest_type = /obj/item/clothing/suit/space/rig/excavation
	helm_type =  /obj/item/clothing/head/helmet/space/rig/excavation
	boot_type =  /obj/item/clothing/shoes/magboots/rig/excavation
	glove_type = /obj/item/clothing/gloves/rig/excavation

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage,
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

/obj/item/rig/advanced/mining
	name = "Advanced Mining RIG"
	desc = "The latest in cutting-edge RIG technology. Lightweight, tough, and packed with utilities"
	icon_state = "advanced_miner_rig"

	initial_modules = list(
		/obj/item/rig_module/healthbar/advanced,
		/obj/item/rig_module/storage/heavy,
		/obj/item/rig_module/grenade_launcher/light,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/kinesis/advanced,
		/obj/item/rig_module/hotswap,
		/obj/item/rig_module/power_sink
		)