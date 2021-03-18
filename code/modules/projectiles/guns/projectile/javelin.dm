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
	scoped_accuracy = 5 //increased accuracy over the LWAP because only one shot
	fire_sound = 'sound/weapons/tablehit1.ogg'
	firemodes = list(
		list(mode_name="launch", burst=1),
		list(mode_name="fire both barrels at once", burst=2),
		)
	var/detone_javelin = FALSE
	var/shock_damage = 20
	var/list/obj/item/weapon/material/shard/shrapnel/javelin/javelins = list()

/obj/item/weapon/gun/projectile/javelin_gun/patreon
	icon_state = "javelin_p"
	item_state = "javelin_p"
	icon_loaded = "javelin_p_loaded"

/obj/item/weapon/gun/projectile/javelin_gun/update_icon()
	. = ..()
	if(ammo_magazine)
		icon_state = icon_loaded
	else
		icon_state = initial(icon_state)

/obj/item/weapon/gun/projectile/javelin_gun/can_fire(atom/target, mob/living/user, clickparams, var/silent = FALSE)
	. = ..()
	if(!. && detone_javelin)
		return TRUE

/obj/item/weapon/gun/projectile/javelin_gun/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	..()
	unload_shell()

/obj/item/weapon/gun/projectile/javelin_gun/proc/unload_shell()
	if(chambered)
		playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, 1)
		chambered.dropInto(src.loc)
		loaded -= chambered
		chambered = null

/obj/item/weapon/gun/projectile/javelin_gun/attack_self(mob/user)
	detone_javelin = !detone_javelin
	to_chat(user, SPAN_NOTICE("You active the [detone_javelin ? "detonation" : "shooting"] mode"))

//Safety checks are done by the time fire is called
/obj/item/weapon/gun/projectile/javelin_gun/Fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if(detone_javelin)
		detone_javelin(user)
	else
		return ..()

/obj/item/weapon/gun/projectile/javelin_gun/proc/detone_javelin(mob/living/user)
	detone_javelin = FALSE
	if(!javelins.len)
		to_chat(user, SPAN_NOTICE("There is no javelin to detonate."))
		return

	for(var/obj/item/weapon/material/shard/shrapnel/javelin/A in javelins)
		if(get_dist(src, A) > 7)
			continue

		var/datum/effect/effect/system/spark_spread/S = new
		S.set_up(5, 1, get_turf(A))
		S.start()

		var/mob/living/L

		if(ismob(A.loc))
			L = A.loc

		else if(istype(A.loc, /obj/item/organ))
			var/obj/item/organ/O = A.loc
			if(O.owner && O.loc == O.owner)
				L = O.owner

		if(L)
			L.electrocute_act(shock_damage, A)

	javelins = list()
