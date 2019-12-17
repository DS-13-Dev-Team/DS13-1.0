/obj/structure
	icon = 'icons/obj/structures.dmi'
	w_class = ITEM_SIZE_NO_CONTAINER

	var/breakable
	var/parts

	var/list/connections = list("0", "0", "0", "0")
	var/list/other_connections = list("0", "0", "0", "0")
	var/list/blend_objects = newlist() // Objects which to blend with
	var/list/noblend_objects = newlist() //Objects to avoid blending with (such as children of listed blend objects.

	var/list/footstep_sounds	//footstep sounds when stepped on
	var/step_priority = 1	//Priority of the sound attached to this
	var/obj_integrity = 100
	var/max_integrity = 100

/obj/structure/proc/take_damage(amount)
	obj_integrity -= amount
	update_icon()
	if(obj_integrity <= 0 && breakable)
		qdel(src)

/obj/structure/proc/repair_damage(amount)
	if(obj_integrity + amount > max_integrity)
		obj_integrity = max_integrity
		return
	obj_integrity += obj_integrity

/obj/structure/proc/get_footstep_sound()
	if(LAZYLEN(footstep_sounds)) return pick(footstep_sounds)

/obj/structure/New()
	.=..()
	if(LAZYLEN(footstep_sounds) && istype(loc, /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		T.step_structures |= src

/obj/structure/Destroy()
	if(LAZYLEN(footstep_sounds) && istype(loc, /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		T.step_structures -= src
	if(parts)
		new parts(loc)
	. = ..()

/obj/structure/attack_hand(mob/user)
	..()
	if(breakable)
		if(HULK in user.mutations)
			user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!" ))
			attack_generic(user,1,"smashes")
		else if(istype(user,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = user
			if(H.species.can_shred(user))
				attack_generic(user,1,"slices")
	return ..()

/obj/structure/attack_tk()
	return

/obj/structure/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if(prob(50))
				qdel(src)
				return
		if(3.0)
			return

/obj/structure/attack_generic(var/mob/user, var/damage, var/attack_verb, var/wallbreaker)
	if(!breakable || !damage || !wallbreaker)
		return 0
	visible_message("<span class='danger'>[user] [attack_verb] the [src] apart!</span>")
	attack_animation(user)
	spawn(1) qdel(src)
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
				AM.loc = loc
				AM.ex_act(severity++, epicentre)

			qdel(src)
			return
		if(2.0)
			if(prob(50))
				for(var/atom/movable/AM in contents)
					AM.loc = loc
					AM.ex_act(severity++, epicentre)

				qdel(src)
				return
		if(3.0)
			return
