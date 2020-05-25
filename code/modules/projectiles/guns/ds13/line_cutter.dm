/*
	Force Gun

	Fires a shortrange blast of gravity that repulses things. Light damage, but stuns and knocks down

	Secondary fire is a focused beam with a similar effect and marginally better damage
*/
#define FORCE_FOCUS_WINDUP_TIME	15

/obj/item/weapon/gun/projectile/linecutter
	name = "IM-822 Handheld Ore Cutter Line Gun"
	desc = "A basic energy-based gun."
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "linecutter"
	item_state = "linecutter"

	ammo_type = /obj/item/ammo_casing/linerack
	slot_flags = SLOT_BACK
	mag_insert_sound = 'sound/weapons/guns/interaction/force_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/force_magout.ogg'
	firemodes = list(
		list(mode_name = "line cutter", fire_sound = 'sound/weapons/guns/fire/force_shot.ogg', fire_delay = 1.5 SECONDS))

	icon_state = "linecutter"
	item_state = "linecutter"
	wielded_item_state = ""
	w_class = ITEM_SIZE_HUGE
	handle_casings = CLEAR_CASINGS
	load_method = SPEEDLOADER
	caliber = "linerack"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/linerack
	mag_insert_sound = 'sound/weapons/guns/interaction/pulse_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/pulse_magout.ogg'
	one_hand_penalty = 6	//Don't try to fire this with one hand
	max_shells = 5

	aiming_modes = list(/datum/extension/aim_mode/heavy)

	//The linegun opens when you enter ironsights mode
	require_aiming = TRUE

/obj/item/weapon/gun/projectile/linecutter/empty
	ammo_type = null



/obj/item/weapon/gun/projectile/linecutter/can_fire()
	.=..()
	if (.)
		if (!is_held_twohanded(loc))
			return FALSE

/*
	Firemodes
*/
/*
	Projectile
*/
/obj/item/projectile/wave/linecutter
	damage = 40
	penetrating = TRUE
	icon = 'icons/obj/weapons/ds13_projectiles_large.dmi'
	icon_state = "linecutter_48"
	step_delay = 2
	kill_count = 10	//Short ranged

/obj/item/projectile/wave/linecutter/update_icon()
	if (backstop)
		return

	switch(side)
		if (LEFT)
			icon_state = "linecutter_left"
		if (RIGHT)
			icon_state = "linecutter_right"

/*--------------------------
	Ammo
---------------------------*/

/obj/item/ammo_magazine/lineracks
	name = "line racks"
	desc = "A pack of line racks for use in the IM-822 Handheld Ore Cutter Line Gun"
	icon_state = "line_racks"
	caliber = "linerack"
	ammo_type = /obj/item/ammo_casing/linerack
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 5
	multiple_sprites = 0
	mag_type = SPEEDLOADER
	delete_when_empty = TRUE


/obj/item/ammo_casing/linerack
	name = "line rack"
	desc = "An assemblage of metal and wires with a built in power supply"
	icon_state = "linerack"
	spent_icon = "linerack"
	projectile_type  = /obj/item/projectile/wavespawner/linecutter


/obj/item/projectile/wavespawner/linecutter
	wave_type = /obj/item/projectile/wave/linecutter
	width = 3

/*
	Acquisition
*/
/decl/hierarchy/supply_pack/mining/line_racks
	name = "Line Racks"
	contains = list(/obj/item/ammo_magazine/lineracks = 4)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper line rack crate"


/decl/hierarchy/supply_pack/mining/line_cutter
	name = "Mining Tool - Line Cutter"
	contains = list(/obj/item/ammo_magazine/lineracks = 2,
	/obj/item/weapon/gun/projectile/linecutter/empty = 1)
	cost = 80
	containertype = /obj/structure/closet/crate
	containername = "\improper Line Cutter crate"