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
		list(mode_name = "launch", fire_delay = 0.2 SECONDS),
		list(mode_name = "shock mode", mode_type = /datum/firemode/automatic/shock, projectile_type = /obj/item/projectile/null_projectile, fire_delay = 3 SECONDS)
		)
	screen_shake = FALSE
	var/list/javelins = list()

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
		J.detonate_javelin(user)

/datum/firemode/automatic/shock/can_fire(atom/target, mob/living/user)
	. = ..()
	if(. && istype(gun, /obj/item/weapon/gun/projectile/javelin_gun))
		var/obj/item/weapon/gun/projectile/javelin_gun/J = gun
		if(!J.javelins.len)
			to_chat(user, SPAN_WARNING("There is no charged javelin nearby."))
			return FALSE

/obj/item/weapon/gun/projectile/javelin_gun/stop_firing()
	. = ..()
	if(!.)
		return
	for(var/obj/item/weapon/material/shard/shrapnel/javeling/J in javelins)
		if(J.shock_count)
			J.remove_from_launcher_list()

/obj/item/weapon/gun/projectile/javelin_gun/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = icon_loaded
	else
		icon_state = initial(icon_state)

/obj/item/weapon/gun/projectile/javelin_gun/proc/detonate_javelin(mob/living/user)
	for(var/obj/item/weapon/material/shard/shrapnel/javeling/J in javelins)
		if(get_dist(src, J) > 7)
			continue
		J.process_shock()

/obj/item/weapon/gun/projectile/javelin_gun/register_shrapnel(obj/item/weapon/material/shard/shrapnel/SP)
	javelins |= SP

/obj/item/weapon/gun/projectile/javelin_gun/unregister_shrapnel(obj/item/weapon/material/shard/shrapnel/SP)
	javelins -= SP

/obj/effect/overload
	icon = 'icons/effects/96x96.dmi'
	icon_state = "energy_ball"
	anchored = TRUE
	pixel_x = -32
	pixel_y = -32
	var/life_time = 5
	var/shock_damage = 35

/obj/effect/overload/Initialize(mapload, n_life_time = 5)
	. = ..()
	life_time = n_life_time
	START_PROCESSING(SSfastprocess, src)

/obj/effect/overload/Process()
	for(var/turf/T in trange(2, get_turf(src)))
		for(var/mob/living/L in T)
			L.electrocute_act(shock_damage, src)
	if(--life_time <= 0)
		qdel(src)

/obj/effect/overload/Crossed(atom/A)
	. = ..()
	if(isliving(A))
		var/mob/living/L = A
		L.electrocute_act(shock_damage, src)

/obj/effect/overload/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()
