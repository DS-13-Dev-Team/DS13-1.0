/obj/item/weapon/gun/projectile/javeling_gun
	name = "T15 Javelin Gun"
	desc = "The Javelin Gun is a telemetric survey tool manufactured by Timson Tools, designed to fire titanium javelins at high speeds with extreme accuracy and piercing power."
	icon_state = "heavysniper" //sort of placeholder
	item_state = "heavysniper" //sort of placeholder
	w_class = ITEM_SIZE_HUGE
	force = 10
	slot_flags = SLOT_BACK
	caliber = "javeling"
	screen_shake = 2 //extra kickback
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/javeling
	one_hand_penalty = -30
	accuracy = -10
	scoped_accuracy = 5 //increased accuracy over the LWAP because only one shot
	wielded_item_state = "heavysniper-wielded" //sort of placeholder
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	var/detone_javeling = FALSE
	var/shock_damage = 20
	var/list/obj/item/weapon/material/shard/shrapnel/javeling/javelings = list()

/obj/item/weapon/gun/projectile/javeling_gun/can_fire(atom/target, mob/living/user, clickparams, var/silent = FALSE)
	. = ..()
	if(!. && detone_javeling)
		return TRUE

/obj/item/weapon/gun/projectile/javeling_gun/handle_post_fire(mob/user, atom/target, var/pointblank=0, var/reflex=0)
	..()
	unload_shell()

/obj/item/weapon/gun/projectile/javeling_gun/proc/unload_shell()
	if(chambered)
		playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, 1)
		chambered.dropInto(src.loc)
		loaded -= chambered
		chambered = null

/obj/item/weapon/gun/projectile/javeling_gun/attack_self(mob/user)
	detone_javeling = !detone_javeling
	to_chat(user, SPAN_NOTICE("You active the [detone_javeling ? "detonation" : "shooting"] mode"))

//Safety checks are done by the time fire is called
/obj/item/weapon/gun/projectile/javeling_gun/Fire(var/atom/target, var/mob/living/user, var/clickparams, var/pointblank=0, var/reflex=0)
	if(detone_javeling)
		detone_javeling(user)
	else
		return ..()

/obj/item/weapon/gun/projectile/javeling_gun/proc/detone_javeling(mob/living/user)
	detone_javeling = FALSE
	if(!javelings.len)
		to_chat(user, SPAN_NOTICE("There is no javelin to detonate."))
		return

	for(var/obj/item/weapon/material/shard/shrapnel/javeling/A in javelings)

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

	javelings = list()
