/obj/item/weapon/gun/projectile/javelin_gun
	name = "T15 Javelin Gun"
	desc = "The Javelin Gun is a telemetric survey tool manufactured by Timson Tools, designed to fire titanium javelins at high speeds with extreme accuracy and piercing power."
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "javelin"
	item_state = "javelin"
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	caliber = "javelin"
	var/icon_loaded = "javelin_loaded"
	screen_shake = 2 //extra kickback
	load_method = MAGAZINE
	handle_casings = CLEAR_CASINGS
	max_shells = 6
	magazine_type = /obj/item/ammo_magazine/javelin
	one_hand_penalty = -30
	accuracy = -10
	scoped_accuracy = 5
	fire_sound = 'sound/weapons/tablehit1.ogg'
	firemodes = list(
		list(mode_name = "launch", burst=1),
		list(mode_name = "shock mode", mode_type = /datum/firemode/automatic/shock, projectile_type = /obj/item/projectile/null_projectile, ammo_cost = 0)
		)
	screen_shake = FALSE
	var/list/obj/item/weapon/gun/projectile/javelin_gun/javelins = list()

/obj/item/weapon/gun/projectile/javelin_gun/patreon
	icon_state = "javelin_p"
	item_state = "javelin_p"
	icon_loaded = "javelin_p_loaded"

/obj/item/weapon/gun/projectile/javelin_gun/can_fire(atom/target, mob/living/user, clickparams, silent)
	. = ..()
	if(.)
		return current_firemode.can_fire(target, user)

/datum/firemode/automatic/shock

/datum/firemode/automatic/shock/on_fire(atom/target, mob/living/user, clickparams, pointblank, reflex, obj/projectile)
	if(istype(gun, /obj/item/weapon/gun/projectile/javelin_gun))
		var/obj/item/weapon/gun/projectile/javelin_gun/J = gun
		J.detone_javelin(user)

/datum/firemode/automatic/shock/can_fire(atom/target, mob/living/user)
	. = ..()
	if(istype(gun, /obj/item/weapon/gun/projectile/javelin_gun))
		var/obj/item/weapon/gun/projectile/javelin_gun/J = gun
		if(!J.javelins.len)
			to_chat(user, SPAN_WARNING("There is no charged javalina nearby."))
			return FALSE

/obj/item/weapon/gun/projectile/javelin_gun/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = icon_loaded
	else
		icon_state = initial(icon_state)

/obj/item/weapon/gun/projectile/javelin_gun/proc/detone_javelin(mob/living/user)
	for(var/obj/item/ammo_casing/javelin/J in javelins)
		if(get_dist(src, J) > 7)
			continue
		J.process_shock()

/obj/effect/overload
	icon = 'icons/effects/96x96.dmi'
	icon_state = "energy_ball"
	anchored = TRUE
	pixel_x = -32
	pixel_y = -32

/obj/effect/overload/Initialize(mapload, life_time = 5)
	. = ..()
	if(life_time != -1)
		QDEL_IN(src, life_time)
