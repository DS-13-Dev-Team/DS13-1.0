/obj/item/rig/civilian
	name = "CEC civilian RIG"
	desc = "Resource Integrated Gear. Standard issue for all CEC employees."
	icon_state = "ds_civilian_rig"
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 10, rad = 10)
	offline_slowdown = 1
	online_slowdown = RIG_VERY_LIGHT

	max_health = 1500

	chest_type = null
	helm_type =  null
	boot_type =  null
	glove_type = null

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage/light
		)

/obj/item/rig/civilian/slim
	name = "CEC slim civilian RIG"
	desc = "Slim variant of the Resource Integrated Gear. Standard issue for all CEC employees."
	icon_state = "ds_civilian_slim_rig"
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 10, rad = 10)
	offline_slowdown = 1
	online_slowdown = RIG_VERY_LIGHT

	max_health = 1500

	chest_type = null
	helm_type =  null
	boot_type =  null
	glove_type = null





/obj/item/rig/emergency
	name = "emergency RIG"
	desc = "A light, emergency rig for use by non-qualified personnel in the case of emergency decompression."
	icon_state = "eva_suit"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 50)
	online_slowdown = 1
	offline_slowdown = 3

	chest_type = /obj/item/clothing/suit/space/rig/emergency
	helm_type = /obj/item/clothing/head/helmet/space/rig/emergency
	boot_type = /obj/item/clothing/shoes/magboots/rig/emergency
	glove_type = /obj/item/clothing/gloves/rig/emergency

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/maneuvering_jets
		)

/obj/item/clothing/suit/space/rig/emergency
	name = "suit"

/obj/item/clothing/gloves/rig/emergency
	name = "gloves"

/obj/item/clothing/shoes/magboots/rig/emergency
	name = "boots"

/obj/item/clothing/head/helmet/space/rig/emergency
	name = "helmet"

/obj/item/rig/clown
	name = "clown RIG"
	desc = "Honk honk."
	icon_state = "clown_rig"
	armor = list(melee = 25, bullet = 25, laser = 25, energy = 25, bomb = 25, bio = 25, rad = 25)
	offline_slowdown = 1
	online_slowdown = RIG_VERY_LIGHT

	chest_type = /obj/item/clothing/suit/space/rig/clown
	helm_type =  /obj/item/clothing/head/helmet/space/rig/clown
	boot_type =  /obj/item/clothing/shoes/magboots/rig/clown
	glove_type = /obj/item/clothing/gloves/rig/clown

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage/light
		)

/obj/item/clothing/suit/space/rig/clown
	name = "clown suit"

/obj/item/clothing/gloves/rig/clown
	name = "clown gloves"

/obj/item/clothing/shoes/magboots/rig/clown
	name = "clown shoes"

/obj/item/clothing/head/helmet/space/rig/clown
	name = "clown wig"