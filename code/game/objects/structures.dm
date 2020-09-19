/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER

	var/breakable = TRUE
	resistance = 5
	health = 20
	max_health = 20
	var/parts
	var/hitsound = 'sound/weapons/smash.ogg'

	var/list/connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/list/blend_objects = newlist() // Objects which to blend with
	var/list/noblend_objects = newlist() //Objects to avoid blending with (such as children of listed blend objects.

	var/list/footstep_sounds	//footstep sounds when stepped on
	var/step_priority = 1	//Priority of the sound attached to this
	mass = 10

/obj/structure/proc/repair_damage(amount)
	if(health + amount > max_health)
		health = max_health
		return
	health += amount

/obj/structure/proc/get_footstep_sound()
	if(LAZYLEN(footstep_sounds)) return pick(footstep_sounds)

/obj/structure/New()
	.=..()
	if (max_health) //Not everything sets both of these. either will do
		health = max_health
	else if (health)
		max_health = health

	if(LAZYLEN(footstep_sounds) && istype(loc, /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		T.step_structures |= src

/obj/structure/Destroy()
	if(LAZYLEN(footstep_sounds) && istype(loc, /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		T.step_structures -= src
	if(parts)
		new parts(loc)
	.=..()

/obj/structure/attack_hand(mob/user)
	if(breakable && user.a_intent == I_HURT)
		user.strike_structure(src)
		return 1
	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	if(!breakable || !damage)
		return 0
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	attack_animation(user)
	take_damage(damage, BRUTE, user, user)
	return 1

/obj/structure/proc/can_visually_connect()
	return anchored

/obj/structure/proc/can_visually_connect_to(var/obj/structure/S)
	return istype(S, src)

/obj/structure/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	var/list/other_dirs = list()

	if(!anchored)
		return

	for(var/obj/structure/S in orange(src, 1))
		if(can_visually_connect_to(S))
			if(S.can_visually_connect())
				if(propagate)
					S.update_connections()
					S.update_icon()
				dirs += get_dir(src, S)

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		var/success = 0
		for(var/b_type in blend_objects)
			if(istype(T, b_type))
				success = 1
				if(propagate)
					var/turf/simulated/wall/W = T
					if(istype(W))
						W.update_connections(1)
						W.update_icon()
				if(success)
					break
			if(success)
				break
		if(!success)
			for(var/obj/O in T)
				for(var/b_type in blend_objects)
					if(istype(O, b_type))
						success = 1
						for(var/obj/structure/S in T)
							if(istype(S, src))
								success = 0
						for(var/nb_type in noblend_objects)
							if(istype(O, nb_type))
								success = 0

					if(success)
						break
				if(success)
					break

		if(success)
			dirs += get_dir(src, T)
			other_dirs += get_dir(src, T)

	connections = dirs_to_corner_states(dirs)
	other_connections = dirs_to_corner_states(other_dirs)


// When destroyed by explosions, properly handle contents.
/obj/structure/ex_act(severity, var/atom/epicentre)
	switch(severity)
		if(1.0)
			for(var/atom/movable/AM in contents)
				AM.ex_act(severity++, epicentre)

			take_damage(rand(150,300), BRUTE, null, epicentre)
		if(2.0)
			if(prob(50))
				for(var/atom/movable/AM in contents)
					AM.ex_act(severity++, epicentre)

			take_damage(rand(60,150), BRUTE, null, epicentre)

		if(3.0)
			take_damage(rand(25,60), BRUTE, null, epicentre)

/obj/structure/bullet_act(var/obj/item/projectile/P)
	take_damage(P.get_structure_damage(), user = P.firer, used_weapon = P)
	if (health > 0)
		return FALSE
	return TRUE


/obj/structure/attackby(var/obj/item/C, var/mob/user)
	if (breakable && user.a_intent == I_HURT)
		playsound(src, hitsound, VOLUME_MID, 1)
		user.do_attack_animation(src)
		take_damage(C.force, C.damtype, user, C)
		user.set_click_cooldown(DEFAULT_ATTACK_COOLDOWN)
		return
	.=..()

/obj/structure/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return
	var/obj/O = AM
	var/tforce = O.throwforce * (speed/THROWFORCE_SPEED_DIVISOR)

	take_damage(tforce, BRUTE, O.thrower, O)

//Called when a structure takes damage
/obj/structure/proc/take_damage(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist = FALSE)
	if (!bypass_resist)
		amount -= resistance

	if (amount <= 0)
		return 0

	health -= amount

	if (health <= 0)
		health = 0
		return zero_health(amount, damtype, user, used_weapon, bypass_resist)//Some zero health overrides do things with a return value
	else
		update_icon()
		return amount

/obj/structure/proc/updatehealth()
	if (health <= 0)
		health = 0
		return zero_health()

//Called when health drops to zero. Parameters are the params of the final hit that broke us, if this was called from take_damage
/obj/structure/proc/zero_health(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist)
	if (breakable)
		qdel(src)
	return TRUE

/obj/structure/repair(var/repair_power, var/datum/repair_source, var/mob/user)
	health = clamp(health+repair_power, 0, max_health)
	updatehealth()
	update_icon()