/obj/item/weapon/rig/civilian
	name = "CEC Civilian RIG"
	desc = "Resource Integrated Gear. Standard issue for all CEC employees"
	icon_state = "ds_civilian_rig"
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 10, bomb = 10, bio = 10, rad = 10)
	offline_slowdown = 1
	online_slowdown = 0

	chest_type = null
	helm_type =  null
	boot_type =  null
	glove_type = null

	initial_modules = list(
		/obj/item/rig_module/healthbar,
		/obj/item/rig_module/storage/heavy
		)
