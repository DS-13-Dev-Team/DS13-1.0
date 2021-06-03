#define JAVELIN_MAX_SHOCK_TIME	(3 SECONDS)
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
	fire_sound = null
	firemodes = list(
		list(mode_name = "launch", fire_delay = 1.5 SECONDS, fire_sound = 'sound/weapons/guns/fire/jav_fire.ogg'),
		list(mode_name = "shock mode", mode_type = /datum/firemode/automatic/shock, projectile_type = /obj/item/projectile/null_projectile, fire_delay = 3 SECONDS)
		)
	screen_shake = FALSE
	var/list/javelins = list()

/obj/item/weapon/gun/projectile/javelin_gun/empty
	magazine_type = null

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
	for(var/obj/item/weapon/material/shard/shrapnel/javelin/J in javelins)
		if(J.shock_count)
			J.remove_from_launcher_list()

/obj/item/weapon/gun/projectile/javelin_gun/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = icon_loaded
	else
		icon_state = initial(icon_state)

/obj/item/weapon/gun/projectile/javelin_gun/proc/detonate_javelin(mob/living/user)
	for(var/obj/item/weapon/material/shard/shrapnel/javelin/J in javelins)
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
	var/life_time = JAVELIN_MAX_SHOCK_TIME
	var/shock_damage = 25

	var/datum/sound_token/shock_sound_token



/obj/effect/overload/Initialize(mapload, n_life_time = JAVELIN_MAX_SHOCK_TIME)
	. = ..()
	if (n_life_time)
		life_time = n_life_time
	shock_sound_token = GLOB.sound_player.PlayStoppableSound(source = src, sound = 'sound/weapons/guns/fire/jav_electric.ogg', sound_id = "contact_charge", volume = VOLUME_HIGH, duration = life_time, range = 12)
	START_PROCESSING(SSfastprocess, src)

/obj/effect/overload/Process()
	for(var/turf/T in trange(2, get_turf(src)))
		for(var/mob/living/L in T)
			L.electrocute_act(shock_damage * (FAST_PROCESS_INTERVAL * 0.1), src, 1, def_zone = BP_OVERALL)

	life_time -= FAST_PROCESS_INTERVAL
	if(life_time <= 0)
		qdel(src)

/obj/effect/overload/Crossed(atom/A)
	. = ..()
	if(isliving(A))
		var/mob/living/L = A
		L.electrocute_act(shock_damage, src)

/obj/effect/overload/Destroy()
	QDEL_NULL(shock_sound_token)
	STOP_PROCESSING(SSfastprocess, src)
	return ..()







/obj/item/projectile/bullet/javelin
	name = "javelin spears"
	icon_state = "javelin_flight"
	damage = 30
	embed = TRUE
	sharp = TRUE
	accuracy = 200
	armor_penetration = 15
	penetration_modifier = 50
	embed_mult = 1000
	muzzle_type = null
	shrapnel_type = /obj/item/weapon/material/shard/shrapnel/javelin
	var/push_force = 600
	var/turf/last_turf
	fire_sound = 'sound/weapons/guns/fire/jav_fire.ogg'

/obj/item/projectile/bullet/javelin/attack_mob(var/mob/living/target_mob, var/distance, var/miss_modifier=0)
	last_turf = (isturf(last_loc) ? last_loc : get_turf(src))
	.=..()


/obj/item/projectile/bullet/javelin/on_organ_embed(obj/item/organ/external/target, mob/M)
	var/obj/item/SP = new src.shrapnel_type(target, src)
	target.embed(SP)
	playsound(src, "fleshtear", VOLUME_MID, TRUE)
	if(!M.buckled)
		GLOB.bump_event.register(M, SP, /obj/item/weapon/material/shard/shrapnel/javelin/proc/on_target_collision)

		M.apply_push_impulse_from(last_turf, push_force)

		addtimer(CALLBACK(SP, /obj/item/weapon/material/shard/shrapnel/javelin/proc/unregister_collision, M), 1.5 SECONDS)


/obj/item/projectile/bullet/javelin/attack_atom(var/atom/A,  var/distance, var/miss_modifier=0)
	.=..()
	if (. == PROJECTILE_HIT)
		new src.shrapnel_type(get_turf(A), src)


/obj/item/weapon/material/shard/shrapnel/javelin
	name = "javelin"
	icon_state = "javelin"
	icon = 'icons/obj/projectiles.dmi'
	var/charged_icon = "javelin"
	var/obj/item/weapon/gun/projectile/javelin_gun/javelin_gun
	var/obj/effect/overload/tesla
	var/shock_count
	var/extension_type = /datum/extension/mount/self_delete


/obj/item/weapon/material/shard/shrapnel/javelin/New(loc, obj/item/projectile/P)
	..()
	javelin_gun = launcher
	update_icon()

/obj/item/weapon/material/shard/shrapnel/javelin/Destroy()
	if(launcher)
		remove_from_launcher_list()
	return ..()

/obj/item/weapon/material/shard/shrapnel/javelin/update_icon()
	if(launcher && !shock_count)
		icon_state = charged_icon
	else
		icon_state = initial(icon_state)

/obj/item/weapon/material/shard/shrapnel/javelin/examine(mob/user, distance)
	. = ..()
	if(launcher)
		if(shock_count)
			to_chat(user, SPAN_NOTICE("Its fully discharged."))
		else
			to_chat(user, SPAN_WARNING("Its charged with electricity."))

/obj/item/weapon/material/shard/shrapnel/javelin/proc/remove_from_launcher_list()
	launcher.unregister_shrapnel(src)
	QDEL_NULL(tesla)
	update_icon()

/obj/item/weapon/material/shard/shrapnel/javelin/proc/process_shock()
	if(!shock_count)
		var/datum/effect/effect/system/spark_spread/S = new
		S.set_up(3, 1, get_turf(src))
		S.start()
		tesla = new /obj/effect/overload(get_turf(src), JAVELIN_MAX_SHOCK_TIME)
		addtimer(CALLBACK(src, .proc/remove_from_launcher_list), 4 SECONDS)
	shock_count++

/obj/item/weapon/material/shard/shrapnel/javelin/proc/on_target_collision(mob/user, atom/obstacle)
	var/list/implants = user.get_visible_implants(0, TRUE)
	if(src in implants)
		var/mount_target = get_mount_target_at_direction(user, get_dir(obstacle, user))
		if(mount_target)
			var/obj/item/javelin/javelin = new /obj/item/javelin(get_turf(user))
			javelin.javelin = src
			src.forceMove(javelin)
			mount_to_atom(javelin, mount_target, extension_type)
			javelin.anchored = TRUE
			javelin.buckle_mob(user)
			playsound(src, "fleshtear", VOLUME_MID, TRUE)

	unregister_collision(user)

/obj/item/weapon/material/shard/shrapnel/javelin/proc/unregister_collision(mob/M)
	GLOB.bump_event.unregister(M, src, /obj/item/weapon/material/shard/shrapnel/javelin/proc/on_target_collision)

/obj/item/javelin
	name = "javelin"
	icon_state = "javelin"
	icon = 'icons/obj/projectiles.dmi'
	var/obj/item/weapon/material/shard/shrapnel/javelin/javelin

/obj/item/javelin/update_icon()
	javelin.update_icon()
	icon_state = javelin.icon_state

/obj/item/javelin/attack_hand(mob/user)
	if(is_mounted())

		//Freeing yourself is harder than freeing another
		var/free_time = 3 SECONDS
		if (buckled_mob == user)
			free_time *= 2
		if (!do_after(user, free_time, src))
			return

		//Maybe someone else freed the victim in the meantime
		if(!is_mounted())
			return

		playsound(src, "fleshtear", VOLUME_MID, TRUE)
		anchored = FALSE
		unbuckle_mob()
	return ..()





/obj/item/ammo_magazine/javelin
	name = "javelin rack"
	desc = "A set of javelins for the launcher"
	icon_state = "javelin"
	caliber = "javelin"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/javelin
	matter = list(MATERIAL_STEEL = 600)
	max_ammo = 6
	multiple_sprites = 1
