//Throwing stuff
/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	src.throw_mode_off()
	if(usr.stat || !target)
		return
	if(target.type == /obj/screen) return

	var/atom/movable/item = src.get_active_hand()

	if(!item) return

	var/throw_range = item.throw_range
	var/itemsize
	if (istype(item, /obj/item/grab))
		var/obj/item/grab/G = item
		item = G.throw_held() //throw the person instead of the grab
		if(ismob(item))
			var/mob/M = item

			//limit throw range by relative mob size
			throw_range = round(M.throw_range * min(src.mob_size/M.mob_size, 1))
			itemsize = round(M.mob_size/4)
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				var/start_T_descriptor = "<font color='#6b5d00'>[start_T] \[[start_T.x],[start_T.y],[start_T.z]\] ([start_T.loc])</font>"
				var/end_T_descriptor = "<font color='#6b4400'>[start_T] \[[end_T.x],[end_T.y],[end_T.z]\] ([end_T.loc])</font>"
				admin_attack_log(usr, M, "Threw the victim from [start_T_descriptor] to [end_T_descriptor].", "Was from [start_T_descriptor] to [end_T_descriptor].", "threw, from [start_T_descriptor] to [end_T_descriptor], ")

	else if (istype(item, /obj/item/))
		var/obj/item/I = item
		itemsize = I.w_class

	if(!unEquip(item))
		return
	if(!item || !isturf(item.loc))
		return

	var/message = "\The [src] has thrown \the [item]."
	var/skill_mod = 0.2
	if(!skill_check(SKILL_HAULING, min(round(itemsize - ITEM_SIZE_HUGE) + 2, SKILL_MAX)))
		if(prob(30))
			Weaken(2)
			message = "\The [src] barely manages to throw \the [item], and is knocked off-balance!"
	else
		skill_mod += 0.2

	skill_mod += 0.8 * (get_skill_value(SKILL_HAULING) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN)
	throw_range *= skill_mod

	//actually throw it!
	src.visible_message("<span class='warning'>[message]</span>", range = min(itemsize*2,world.view))

	if(!src.lastarea)
		src.lastarea = get_area(src.loc)
	if((istype(src.loc, /turf/space)) || (src.lastarea.has_gravity == 0))
		//if(prob((itemsize * itemsize * 10) * MOB_MEDIUM/src.mob_size))
		/*
			This used to be luck based, players are complaining about it.
			While having your direction changed by a tiny object does feel silly, and is a problem worth looking into;
			A luck based solution is not an improvement, it feels unfair and causes rage.
			Future todo: Make inertia speed more granular, and have small items change it by small degrees.
			For now, going back to original behaviour

			Edit by Nanako: 2020-09-23
		*/
		src.inertia_dir = get_dir(target, src)
		step(src, inertia_dir)

	item.throw_at(target, throw_range, item.throw_speed * skill_mod, src)






//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.last_move)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		src.throwing = 0
		var/turf/T = hit_atom
		T.hitby(src,speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/handle_thrown_collision(var/speed)
	if(src.throwing)
		for(var/mob/living/A in get_turf(src))
			if(A == src)
				continue
			if(A:lying)
				continue
			src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range = 7, speed = BASE_THROW_SPEED, thrower = null)
	set waitfor = FALSE
	if(!target || !src)
		return FALSE
	if(target.z != src.z)
		return FALSE

	//If they're attached to anything, remove them from it
	var/datum/extension/mount/mount = src.is_mounted()
	if (mount)
		mount.dismount()

	var/interval = 10 / speed
	var/sleep_debt = 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	src.throwing = speed
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf
	src.pixel_z = 0

	var/dist_travelled = 0
	var/area/a = get_area(src.loc)
	var/target_turf = get_turf(target)

	while(src && target && src.throwing && istype(src.loc, /turf) \
		 && loc != target_turf && dist_travelled < range)
		// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
		var/atom/step
		step = get_step_towards(src, target_turf)
		if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			break
		//src.Move(step)
		var/vector2/pixeltarget = step.get_global_pixel_offset(src)
		pixel_move(pixeltarget, interval)
		release_vector(pixeltarget)
		handle_thrown_collision(speed)
		dist_travelled++
		sleep_debt += interval
		if (sleep_debt > 1)
			sleep(sleep_debt)
			sleep_debt = 0
		/*
		dist_since_sleep++
		if(dist_since_sleep >= speed)
			dist_since_sleep = 0
			sleep(1)*/

		//If we enter an area with no gravity, we're done. Inertia will take over here
		a = get_area(src.loc)
		if (a && a.has_gravity == FALSE)
			break

		// and yet it moves
		if(src.does_spin)
			src.SpinAnimation(speed = 4, loops = 1)

	//done throwing, either because it hit something or it finished moving
	if(isobj(src) && throwing)
		src.throw_impact(get_turf(src),speed)
	src.throwing = 0
	src.thrower = null
	src.throw_source = null
	fall()