/**
Divet pistol typedef & logic
*/

/obj/item/weapon/gun/projectile/divet
	name = "divet pistol"
	desc = "A Winchester Arms NK-series pistol capable of fully automatic fire."
	icon_state = "divet"
	magazine_type = /obj/item/ammo_magazine/divet
	allowed_magazines = /obj/item/ammo_magazine/divet
	caliber = "slug"
	accuracy = 10
	fire_delay = 5.5
	burst_delay = 1
	w_class = ITEM_SIZE_SMALL
	handle_casings = CLEAR_CASINGS
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	load_method = MAGAZINE

	mag_insert_sound = 'sound/weapons/guns/interaction/divet_magin.ogg'
	mag_remove_sound = 'sound/weapons/guns/interaction/divet_magout.ogg'


	firemodes = list(
		FULL_AUTO_300,
		list(mode_name="3-round bursts", burst=3, fire_delay=3, move_delay=4, one_hand_penalty=0, burst_accuracy=list(0,-2,-4),       dispersion=list(0.0, 0.6, 1.0)),

		)

/obj/item/weapon/gun/projectile/divet/empty
	magazine_type = null

/obj/item/weapon/gun/projectile/divet/silenced
	icon_state = "divet_spec"
	name = "special ops divet pistol"
	silenced = TRUE

/obj/item/weapon/gun/projectile/divet/update_icon()
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "divet"
	else
		icon_state = "divet_e"


/**
Magazine type definitions
*/

/obj/item/ammo_magazine/divet
	name = "magazine (pistol slug)"
	icon_state = "45ds"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/ls_slug
	matter = list(MATERIAL_STEEL = 525) //metal costs are very roughly based around 1 .45 casing = 75 metal
	caliber = "slug"
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/divet/hollow_point
	name = "divet magazine (hollow point)"
	icon_state = "hpds"
	ammo_type = /obj/item/ammo_casing/ls_slug/hollow_point

/obj/item/ammo_magazine/divet/ap
	name = "divet magazine (AP)"
	icon_state = "apds"
	ammo_type = /obj/item/ammo_casing/ls_slug/ap

/obj/item/ammo_magazine/divet/incendiary
	name = "divet magazine (dragon's breath)"
	icon_state = "icds"
	ammo_type = /obj/item/ammo_casing/ls_slug/incendiary


/**
Ammo casings for the mags
*/

/obj/item/ammo_casing/ls_slug
	desc = "A .45 bullet casing."
	caliber = "slug"
	projectile_type = /obj/item/projectile/bullet/ls_slug

/obj/item/ammo_casing/ls_slug/hollow_point
	projectile_type = /obj/item/projectile/bullet/ls_slug/hollow_point

/obj/item/ammo_casing/ls_slug/ap
	projectile_type = /obj/item/projectile/bullet/ls_slug/ap

/obj/item/ammo_casing/ls_slug/incendiary
	projectile_type = /obj/item/projectile/bullet/ls_slug/incendiary

/**
Projectile logic
*/

/obj/item/projectile/bullet/ls_slug
	damage = 17.5
	expiry_method = EXPIRY_FADEOUT
	muzzle_type = /obj/effect/projectile/pulse/muzzle/light
	fire_sound='sound/weapons/guns/fire/divet_fire.ogg'
	armor_penetration = 5
	structure_damage_factor = 1.5
	penetration_modifier = 1.1
	icon_state = "divet"

/obj/item/projectile/bullet/ls_slug/hollow_point
	structure_damage_factor = 0.5
	penetration_modifier = 0
	embed = TRUE
	armor_penetration = -50
	icon_state = "divet_hp"

/obj/item/projectile/bullet/ls_slug/ap
	structure_damage_factor = 1.75
	penetration_modifier = 1.5
	armor_penetration = 15
	icon_state = "divet_ap"

/obj/item/projectile/bullet/ls_slug/incendiary
	icon_state = "divet_incend"
	fire_sound = list('sound/weapons/guns/fire/torch_altfire_1.ogg',
	'sound/weapons/guns/fire/torch_altfire_2.ogg',
	'sound/weapons/guns/fire/torch_altfire_3.ogg')


/obj/item/projectile/bullet/ls_slug/incendiary/on_hit(atom/target, blocked)
	//Yoinked from hydrazine torch. Spreads the flames on the turf because this bullet is about to be GC'd
	var/turf/T = get_turf(target)
	T.spray_ability(subtype = /datum/extension/spray/flame/radial,  target = target, angle = 360, length = 3, duration = 3 SECONDS, extra_data = list("temperature" = (T0C + 2600)))
	. = ..()