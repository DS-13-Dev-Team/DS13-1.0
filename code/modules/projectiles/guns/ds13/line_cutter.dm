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

	charge_cost = 1000 //Five shots per battery
	ammo_type = /obj/item/ammo_casing/linerack
	slot_flags = SLOT_BACK
	charge_meter = FALSE	//if set, the icon state will be chosen based on the current charge
	mag_insert_sound = 'sound/weapons/guns/interaction/force_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/force_magout.ogg'
	removeable_cell = TRUE
	firemodes = list(
		list(mode_name = "blast", mode_type = /datum/firemode/linecutter/blast, fire_sound = 'sound/weapons/guns/fire/force_shot.ogg', fire_delay = 1.5 SECONDS),
		list(mode_name = "focus", mode_type = /datum/firemode/linecutter/focus, windup_time = 1.5 SECONDS, windup_sound = 'sound/weapons/guns/fire/force_windup.ogg', fire_sound = 'sound/weapons/guns/fire/force_focus.ogg',fire_delay = 1.5 SECONDS)
		)

	icon_state = "linecutter"
	item_state = "linecutter"
	wielded_item_state = ""
	w_class = ITEM_SIZE_HUGE
	handle_casings = CLEAR_CASINGS
	load_method = SPEEDLOADER
	caliber = "linerack"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/pulse
	mag_insert_sound = 'sound/weapons/guns/interaction/pulse_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/pulse_magout.ogg'
	one_hand_penalty = 6	//Don't try to fire this with one hand
	max_shells = 5

	aiming_modes = list(/datum/extension/aim_mode/heavy)

	//The linegun opens when you enter ironsights mode
	require_aim = TRUE

/obj/item/weapon/gun/projectile/linecutter/empty
	ammo_type = null



/obj/item/weapon/gun/projectile/linecutter/can_fire()
	.=..()
	if (.)
		if (!is_held_twohanded(loc))

/*
	Firemodes
*/
/*
	Blast is a close range shotgun attack.
*/
/datum/firemode/linecut




/datum/firemode/linecut/on_fire(var/atom/target, var/mob/living/user, var/clickparams, var/pointblank=0, var/reflex=0, var/obj/projectile)








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