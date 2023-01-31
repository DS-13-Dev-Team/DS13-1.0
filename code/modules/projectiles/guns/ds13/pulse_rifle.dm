/*-----------------------
	Gun
------------------------*/
/obj/item/gun/projectile/automatic/pulse_rifle
	name = "SWS Motorized Pulse Rifle"
	desc = "The SWS Motorized Pulse Rifle is a military-grade, triple-barreled assault rifle, manufactured by Winchester Arms, is capable of a rapid rate of fire. \
The Pulse Rifle is the standard-issue service rifle of the Earth Defense Force and is also common among corporate security officers. "
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "pulserifle"
	item_state = "pulserifle"
	wielded_item_state = "pulserifle-wielded"
	w_class = ITEM_SIZE_HUGE
	handle_casings = CLEAR_CASINGS
	magazine_type = /obj/item/ammo_magazine/pulse
	allowed_magazines = list(/obj/item/ammo_magazine/pulse, /obj/item/ammo_magazine/pulse/hv)
	load_method = MAGAZINE
	caliber = "pulse"
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/pulse
	mag_insert_sound = 'sound/weapons/guns/interaction/pulse_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/pulse_magout.ogg'
	one_hand_penalty = 6	//Don't try to fire this with one hand
	accuracy = 5	//Slight accuracy increase
	tier_1_bonus = 1



	aiming_modes = list(/datum/extension/aim_mode/rifle)

	screen_shake = 0	//It is good with recoil

	firemodes = list(
		list(mode_name="full auto",  mode_type = /datum/firemode/automatic/pulserifle, fire_delay=1),
		list(mode_name="grenade launcher",  ammo_cost = 25, windup_time = 0.5 SECONDS, windup_sound = 'sound/weapons/guns/fire/pulse_grenade_windup.ogg', projectile_type = /obj/item/projectile/bullet/impact_grenade, fire_delay=20)
		)


/obj/item/gun/projectile/automatic/pulse_rifle/empty
	magazine_type = null

/obj/item/gun/projectile/automatic/pulse_rifle/egov
	name = "SWS Earthgov Motorized Pulse Rifle"
	desc = "The SWS Motorized Pulse Rifle is a military-grade, triple-barreled assault rifle, manufactured by Winchester Arms, is capable of a rapid rate of fire. \
This variant is the earthgov standard, featuring the highest grade parts. "
	icon_state = "pulserifle_egov"
	item_state = "pulserifle_egov"
	wielded_item_state = "pulserifle_egov-wielded"
	damage_factor = 1.10
	tier_1_bonus = 0

/obj/item/gun/projectile/automatic/pulse_rifle/egov/empty
	magazine_type = null

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
	desc = "A low caliber round designed for the SWS Motorized Pulse Rifle."
	caliber = "pulse"
	icon_state = "empshell"
	spent_icon = "empshell-spent"
	projectile_type  = /obj/item/projectile/bullet/pulse
	embed_mult = 0	//No embedding


/obj/item/projectile/bullet/pulse
	icon_state = "pulse"
	damage = 8.1
	embed = 0
	structure_damage_factor = 0.5
	penetration_modifier = 0
	penetrating = FALSE
	step_delay = 1.3
	expiry_method = EXPIRY_FADEOUT
	muzzle_type = /obj/effect/projectile/pulse/muzzle/light
	impact_type = /obj/effect/projectile/pulse/impact
	fire_sound='sound/weapons/guns/fire/pulse_shot.ogg'

/obj/item/ammo_magazine/pulse
	name = "magazine (pulse rounds)"
	desc = "With a distinctive \"bell and stock\" design, pulse magazines can be inserted and removed from the Pulse Rifle with minimal effort and risk."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "pulse_rounds_empty"
	caliber = "pulse"
	ammo_type = /obj/item/ammo_casing/pulse
	matter = list(MATERIAL_STEEL = 1260)
	max_ammo = 65
	multiple_sprites = FALSE
	mag_type = MAGAZINE


/obj/item/ammo_magazine/pulse/update_icon()
	if (stored_ammo.len)
		icon_state = "pulse_rounds"
	else
		icon_state = "pulse_rounds_empty"





/*-----------------------
	High Velocity Ammo
------------------------*/
/obj/item/ammo_casing/pulse/hv
	name = "high velocity pulse round"
	desc = "A low caliber hypersonic round designed for the SWS Motorized Pulse Rifle."
	caliber = "pulse"
	projectile_type  = /obj/item/projectile/bullet/pulse/hv


/obj/item/ammo_magazine/pulse/hv
	name = "magazine (high velocity rounds)"
	desc = "With a distinctive \"bell and stock\" design, pulse magazines can be inserted and removed from the Pulse Rifle with minimal effort and risk. This one contains hypersonic rounds, unsafe for naval usage."
	caliber = "pulse"
	ammo_type = /obj/item/ammo_casing/pulse/hv
	max_ammo = 80

/obj/item/ammo_magazine/pulse/hv/update_icon()
	if (stored_ammo.len)
		icon_state = "pulse_rounds_hv"
	else
		icon_state = "pulse_rounds_empty"

/obj/item/projectile/bullet/pulse/hv
	icon_state = "pulse_hv"
	damage = 9.5
	embed = 0
	structure_damage_factor = 1.2
	penetration_modifier = 1
	penetrating = FALSE
	step_delay = 1
	expiry_method = EXPIRY_FADEOUT
	muzzle_type = /obj/effect/projectile/pulse/muzzle/hv
	fire_sound='sound/weapons/guns/fire/pulse_shot.ogg'

/*-----------------------
	Deflection Ammo
------------------------*/

/obj/item/ammo_casing/pulse/df
	name = "deflection pulse round"
	desc = "A low caliber deflection round designed for the SWS Motorized Pulse Rifle."
	caliber = "pulse"
	projectile_type  = /obj/item/projectile/bullet/pulse/df


/obj/item/ammo_magazine/pulse/df
	name = "magazine (deflection rounds)"
	desc = "With a distinctive \"bell and stock\" design, pulse magazines can be inserted and removed from the Pulse Rifle with minimal effort and risk. This one contains EXPERIMENTAL deflection rounds. Extremely dangerous, these rounds are with a deflective tip, letting them bounce of surfaces."
	caliber = "pulse"
	ammo_type = /obj/item/ammo_casing/pulse/df
	max_ammo = 130 //Slightly more total damage than a regular pulse mag

/obj/item/ammo_magazine/pulse/df/update_icon()
	if (stored_ammo.len)
		icon_state = "pulse_rounds_df"
	else
		icon_state = "pulse_rounds_empty"

/obj/item/projectile/bullet/pulse/df
	icon_state = "pulse_df"
	damage = 5
	agony = 2
	embed = 0
	structure_damage_factor = 0.1
	penetration_modifier = 0
	embed_mult = 0
	ricochet_chance = 120 //Bounces once, 20% chance to bounce twice. BE WARY.
	penetrating = FALSE
	step_delay = 1.15
	expiry_time = 0.25 SECONDS //25% longer life-time
	expiry_method = EXPIRY_FADEOUT
	muzzle_type = /obj/effect/projectile/pulse/muzzle/df
	fire_sound='sound/weapons/guns/fire/pulse_shot.ogg'

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
	fire_sound='sound/weapons/guns/fire/pulse_grenade.ogg'
	grippable = TRUE
	embed = FALSE
	ricochet_chance = 0

/obj/item/projectile/bullet/impact_grenade/proc/detonate()
	if (!exploded)
		exploded = TRUE
		explosion(2, 2)

/obj/item/projectile/bullet/impact_grenade/on_hit(var/atom/target, var/blocked = 0)
	detonate()
	return 1

/obj/item/projectile/bullet/impact_grenade/on_impact(var/atom/target, var/blocked = 0)
	detonate()
	return 1


//----------------------------
// Pulse muzzle effect only
//----------------------------
/obj/effect/projectile/pulse/muzzle/light
	icon_state = "muzzle_pulse_light"
	light_power = 0.6
	light_color = COLOR_DEEP_SKY_BLUE


/obj/effect/projectile/pulse/muzzle/hv
	icon_state = "muzzle_pulse_hv"
	light_power = 0.6
	light_color = COLOR_MARKER_RED

/obj/effect/projectile/pulse/muzzle/df
	icon_state = "muzzle_pulse_light"
	light_power = 0.6
	light_color = COLOR_YELLOW
