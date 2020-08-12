/atom/movable
	plane = OBJ_PLANE

	appearance_flags = TILE_BOUND
	glide_size = 8

	var/movable_flags

	var/last_move = null
	var/anchored = 0
	// var/elevation = 2    - not used anywhere
	var/move_speed = 1
	var/l_move_time = 1
	var/m_flag = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = BASE_THROW_SPEED
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby = null
	var/item_state = null // Used to specify the item state for the on-mob overlays.
	var/does_spin = TRUE // Does the atom spin when thrown (of course it does :P)
	var/mid_diag_move = FALSE // Whether the atom is in the first step of diagonal movement


	//Mass is measured in kilograms. It should never be zero
	var/mass = 1


/atom/movable/Initialize(var/mapload)
	if (can_block_movement && isturf(loc))
		var/turf/T = loc
		T.movement_blocking_atoms |= src


	.=..()

/atom/movable/Destroy()
	if (can_block_movement)
		var/turf/T = get_turf(src)
		if (T)
			T.movement_blocking_atoms -= src

	. = ..()


	for(var/atom/movable/AM in src)
		qdel(AM)

	forceMove(null)
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

/atom/movable/Bump(var/atom/A, yes)
	if(src.throwing)
		src.throw_impact(A, src.throwing)
		src.throwing = FALSE
	GLOB.bump_event.raise_event(src, A)

	spawn(0)
		if (A && yes)
			A.last_bumped = world.time
			A.Bumped(src)
		return
	..()
	return

/atom/movable/proc/forceMove(atom/destination)
	if(loc == destination)
		return FALSE
	var/is_origin_turf = isturf(loc)
	var/is_destination_turf = isturf(destination)
	// It is a new area if:
	//  Both the origin and destination are turfs with different areas.
	//  When either origin or destination is a turf and the other is not.
	var/is_new_area = (is_origin_turf ^ is_destination_turf) || (is_origin_turf && is_destination_turf && loc.loc != destination.loc)

	var/atom/origin = loc
	loc = destination

	if(origin)
		origin.Exited(src, destination)
		if(is_origin_turf)
			for(var/atom/movable/AM in origin)
				AM.Uncrossed(src)
			if(is_new_area && is_origin_turf)
				origin.loc.Exited(src, destination)

	if(destination)
		destination.Entered(src, origin)
		if(is_destination_turf) // If we're entering a turf, cross all movable atoms
			for(var/atom/movable/AM in loc)
				if(AM != src)
					AM.Crossed(src)
			if(is_new_area && is_destination_turf)
				destination.loc.Entered(src, origin)
	return TRUE

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

/atom/movable/proc/throw_at(atom/target, range, speed, thrower)
	set waitfor = FALSE
	if(!target || !src)
		return FALSE
	if(target.z != src.z)
		return FALSE

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
		 && loc != target_turf && dist_travelled < range \
		  	   || (a && a.has_gravity == 0))
		// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
		var/atom/step
		step = get_step_towards(src, target_turf)
		if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			break
		//src.Move(step)
		pixel_move(step.get_global_pixel_offset(src), interval)
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
		a = get_area(src.loc)
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

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	src.verbs.Cut()
	..()

/atom/movable/overlay/Destroy()
	master = null
	. = ..()

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/touch_map_edge()
	if(!simulated)
		return

	if(!z || (z in GLOB.using_map.sealed_levels))
		return

	if(!GLOB.universe.OnTouchMapEdge(src))
		return

	if(GLOB.using_map.use_overmap)
		overmap_spacetravel(get_turf(src), src)
		return

	var/new_x
	var/new_y
	var/new_z = GLOB.using_map.get_transit_zlevel(z)
	if(new_z)
		if(x <= TRANSITIONEDGE)
			new_x = world.maxx - TRANSITIONEDGE - 2
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (x >= (world.maxx - TRANSITIONEDGE + 1))
			new_x = TRANSITIONEDGE + 1
			new_y = rand(TRANSITIONEDGE + 2, world.maxy - TRANSITIONEDGE - 2)

		else if (y <= TRANSITIONEDGE)
			new_y = world.maxy - TRANSITIONEDGE -2
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		else if (y >= (world.maxy - TRANSITIONEDGE + 1))
			new_y = TRANSITIONEDGE + 1
			new_x = rand(TRANSITIONEDGE + 2, world.maxx - TRANSITIONEDGE - 2)

		var/turf/T = locate(new_x, new_y, new_z)
		if(T)
			forceMove(T)

/atom/movable/proc/get_mass()
	return mass


/atom/movable/proc/reset_move_animation()
	animate_movement = SLIDE_STEPS


// if this returns true, interaction to turf will be redirected to src instead
/atom/movable/proc/preventsTurfInteractions()
	return (density && anchored && !(atom_flags & ATOM_FLAG_CHECKS_BORDER))