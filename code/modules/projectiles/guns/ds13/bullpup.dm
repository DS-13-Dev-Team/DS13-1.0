/*-----------------------
	Gun
------------------------*/
/obj/item/gun/projectile/automatic/bullpup
	name = "SCAF Bullpup Rifle"
	desc = "The standard issued rifle of the Sovereign Colonies Armed Forces, capable of firing in a variety of different modes and suitable for nearly any combat environment. Generally considered outdated when compared against the compact Pulse Rifle."
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "bullpuprifle"
	item_state = "bullpuprifle"
	wielded_item_state = "bullpuprifle-wielded"
	w_class = ITEM_SIZE_HUGE
	handle_casings = CLEAR_CASINGS
	magazine_type = /obj/item/ammo_magazine/bullpup
	allowed_magazines = /obj/item/ammo_magazine/bullpup
	load_method = MAGAZINE
	caliber = "bullpup"
	screen_shake = 0
	accuracy = 20 //this is a low-ammo precision rifle
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/pulse
	mag_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'
	one_hand_penalty = 6	//Don't try to fire this with one hand
	dispersion = list()

	aiming_modes = list(/datum/extension/aim_mode/rifle, /datum/extension/aim_mode/rifle/bullpup_long)

	firemodes = list(
		FULL_AUTO_300, 
		list(mode_name="3-round bursts", burst=3, fire_delay=2.5, burst_delay=1.5),
		list(mode_name="semi-automatic", burst=1, fire_delay=2)
		)



/*-----------------------
	Ammo
------------------------*/

/obj/item/ammo_casing/bullpup
	name = "bullpup round"
	desc = "A rifle-caliber round designed for the SCAF Bullpup Rifle."
	caliber = "bullpup"
	icon_state = "rifle_casing"
	spent_icon = "rifle_casing-spent"
	projectile_type  = /obj/item/projectile/bullet/bullpup

/obj/item/projectile/bullet/bullpup
	damage = 17.5 //same damage as the divet
	structure_damage_factor = 2
	step_delay = 1
	expiry_method = EXPIRY_FADEOUT

/obj/item/ammo_magazine/bullpup
	name = "bullpup magazine"
	desc = "A thirty round box magazine made to fit the SCAF bullpup rifle."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "bullpup-20" //deep state conspiracy
	caliber = "bullpup"
	ammo_type = /obj/item/ammo_casing/bullpup
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 30
	multiple_sprites = TRUE
	mag_type = MAGAZINE

/*-----------------------
	Zoom
------------------------*/

/datum/extension/aim_mode/rifle/bullpup_long
	name = "2x Zoom"
	damage_mod = 0.2 //more damage when scoped!!
	view_offset = 8*WORLD_ICON_SIZE //long range
	statmods = list(STATMOD_MOVESPEED_ADDITIVE = -0.65,
	STATMOD_RANGED_ACCURACY = 25)
