/*-----------------------
	Gun
------------------------*/
/obj/item/weapon/gun/projectile/automatic/pulse_rifle
	name = "SWS Motorized Pulse Rifle"
	desc = "The SWS Motorized Pulse Rifle is a military-grade, triple-barreled assault rifle with a rapid rate of fire and large magazine ammunition capacity.\
The Pulse Rifle is the standard-issue service rifle of the Earth Defense Force, and is also common among EarthGov security forces, corporate security officers, and civilians. "
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "pulserifle"
	item_state = "pulserifle"
	wielded_item_state = "pulserifle-wielded"
	w_class = ITEM_SIZE_HUGE
	handle_casings = CLEAR_CASINGS
	magazine_type = /obj/item/ammo_magazine/pulse
	allowed_magazines = /obj/item/ammo_magazine/pulse
	load_method = MAGAZINE
	caliber = "pulse"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/pulse
	mag_insert_sound = 'sound/weapons/guns/interaction/smg_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/smg_magout.ogg'
	one_hand_penalty = 6	//Don't try to fire this with one hand
	dispersion = list()

	screen_shake = 0	//It is good with recoil

	firemodes = list(
		list(mode_name="full auto",  mode_type = /datum/firemode/automatic/pulserifle, fire_delay=1),
		list(mode_name="grenade launcher",  ammo_cost = 25, projectile_type = /obj/item/projectile/bullet/impact_grenade, fire_delay=20)
		)

/*-----------------------
	Firemode
------------------------*/
//The pulse rifle has a 2 shot minimum on each trigger pull. However it is NOT a burstfire weapon
/datum/firemode/automatic/pulserifle
	minimum_shots = 2


/*-----------------------
	Ammo
------------------------*/

/obj/item/ammo_casing/pulse
	name = "pulse round"
	desc = "A low caliber round designed for the SWS motorized pulse rifle"
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type  = /obj/item/projectile/bullet/pulse


/obj/item/projectile/bullet/pulse
	icon_state = "pulse"
	damage = 7.5
	embed = 0
	structure_damage_factor = 0.5
	penetration_modifier = 0
	penetrating = FALSE
	step_delay = 1.5
	expiry_method = EXPIRY_FADEOUT
	muzzle_type = /obj/effect/projectile/pulse/muzzle/light

/obj/item/ammo_magazine/pulse
	name = "Pulse Rounds"
	desc = "With a distinctive \"Bell and stock\" design, pulse magazines can be inserted and removed from the Pulse Rifle with minimal effort and risk. "
	icon = 'icons/obj/ammo.dmi'
	icon_state = "pulse_rounds_empty"
	caliber = "pulse"
	ammo_type = /obj/item/ammo_casing/pulse
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 50
	multiple_sprites = FALSE
	mag_type = MAGAZINE

/obj/item/ammo_magazine/pulse/update_icon()
	if (stored_ammo.len)
		icon_state = "pulse_rounds"
	else
		icon_state = "pulse_rounds_empty"

/*-----------------------
	Ammo
------------------------*/

/obj/item/projectile/bullet/impact_grenade
	name ="impact grenade"
	icon_state= "bolter"
	damage = 5
	check_armour = "bomb"
	var/exploded = FALSE
	step_delay = 2.5


/obj/item/projectile/bullet/impact_grenade/on_hit(var/atom/target, var/blocked = 0)
	if (!exploded)
		exploded = TRUE
		explosion(target, -1, 1, 2)
	return 1

/obj/item/projectile/bullet/impact_grenade/on_impact(var/atom/target, var/blocked = 0)
	if (!exploded)
		exploded = TRUE
		explosion(target, -1, 1, 2)
	return 1


//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/effect/projectile/pulse/muzzle/light
	icon_state = "muzzle_pulse_light"
	light_max_bright = 2
	light_color = COLOR_DEEP_SKY_BLUE