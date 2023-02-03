/atom/movable

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

	/// Either FALSE, [EMISSIVE_BLOCK_GENERIC], or [EMISSIVE_BLOCK_UNIQUE]
	var/blocks_emissive = FALSE
	///Internal holder for emissive blocker object, do not use directly use blocks_emissive
	var/atom/movable/emissive_blocker/em_block

	///Lazylist to keep track on the sources of illumination.
	var/list/affected_dynamic_lights
	///Highest-intensity light affecting us, which determines our visibility.
	var/affecting_dynamic_lumi = 0
	//Mass is measured in kilograms. It should never be zero
	var/mass = 1

	//Biomass is also measured in kilograms, its the organic mass in the atom. Is often zero
	var/biomass = 0


/atom/movable/Initialize(var/mapload)
	.=..()
	switch(blocks_emissive)
		if(EMISSIVE_BLOCK_GENERIC)
			var/mutable_appearance/gen_emissive_blocker = mutable_appearance(icon, icon_state, plane = EMISSIVE_PLANE, alpha = src.alpha)
			gen_emissive_blocker.color = GLOB.em_block_color
			gen_emissive_blocker.dir = dir
			gen_emissive_blocker.appearance_flags |= appearance_flags
			add_overlay(list(gen_emissive_blocker))
		if(EMISSIVE_BLOCK_UNIQUE)
			render_target = ref(src)
			em_block = new(src, render_target)
			add_overlay(list(em_block))
	if(opacity)
		AddElement(/datum/element/light_blocking)

///Keeps track of the sources of dynamic luminosity and updates our visibility with the highest.
/atom/movable/proc/update_dynamic_luminosity()
	var/highest = 0
	for(var/i in affected_dynamic_lights)
		if(affected_dynamic_lights[i] <= highest)
			continue
		highest = affected_dynamic_lights[i]
	if(highest == affecting_dynamic_lumi)
		return
	luminosity -= affecting_dynamic_lumi
	affecting_dynamic_lumi = highest
	luminosity += affecting_dynamic_lumi

/atom/movable/Destroy()
	QDEL_NULL(em_block)
	if(opacity)
		RemoveElement(/datum/element/light_blocking)

	if(virtual_mob && !ispath(virtual_mob))
		qdel(virtual_mob)
		virtual_mob = null

	. = ..()


	for(var/atom/movable/AM in src)
		qdel(AM)

	forceMove(null, hardforce = TRUE)
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

	if(LAZYLEN(movement_handlers) && !ispath(movement_handlers[1]))
		QDEL_NULL_LIST(movement_handlers)

	vis_locs = null //clears this atom out of all viscontents
	vis_contents.Cut()

/atom/movable/proc/update_emissive_block()
	if(!blocks_emissive)
		return
	else if (blocks_emissive == EMISSIVE_BLOCK_GENERIC)
		var/mutable_appearance/gen_emissive_blocker = emissive_blocker(icon, icon_state, alpha = src.alpha, appearance_flags = src.appearance_flags)
		gen_emissive_blocker.dir = dir
		return gen_emissive_blocker
	else if(blocks_emissive == EMISSIVE_BLOCK_UNIQUE)
		if(!em_block && !QDELETED(src))
			render_target = ref(src)
			em_block = new(src, render_target)
		return em_block

/atom/movable/Bump(var/atom/A, yes)

	if(src.throwing)
		src.throw_impact(A, src.throwing)
		src.throwing = FALSE
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, A)

	spawn(0)
		if (A && yes)
			A.last_bumped = world.time
			A.Bumped(src)
		return
	..()
	return

/atom/movable/proc/forceMove(atom/destination, hardforce, glide_size_override=0)
	if(loc == destination)
		return FALSE

	if (glide_size_override)
		set_glide_size(glide_size_override)

	SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, loc, destination)
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

	if(opacity)
		updateVisibility(src)

	Moved(origin, NONE)
	return TRUE

//This proc should never be overridden elsewhere at /atom/movable to keep directions sane.
/atom/movable/Move(NewLoc, direct = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	var/OldLoc = loc
	var/list/old_locs = locs
	SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_MOVE, loc, NewLoc)
	if (glide_size_override > 0)
		set_glide_size(glide_size_override)

	if (direct & (direct - 1))
		src.mid_diag_move = TRUE

		var/vert_dir = SOUTH
		if (direct & 1)
			vert_dir = NORTH

		var/hor_dir = WEST
		if (direct & 4)
			hor_dir = EAST

		if(Move(get_step(src, vert_dir), vert_dir))
			src.mid_diag_move = FALSE
			Move(get_step(src, hor_dir), hor_dir)
		else if(Move(get_step(src, hor_dir), hor_dir))
			src.mid_diag_move = FALSE
			Move(get_step(src, vert_dir), vert_dir)

		src.mid_diag_move = FALSE // In case diagonal movement does not actually happen
	else
		var/atom/A = src.loc

		set_dir(direct)
		. = ..()

		//This is an actual speed in metres per second
		var/last_move_delta = world.time - src.l_move_time
		if (last_move_delta)
			src.move_speed = 10 / last_move_delta
		else
			move_speed = 0

		src.l_move_time = world.time
		src.m_flag = 1
		if ((A != src.loc && A && A.z == src.z))
			src.last_move = get_dir(A, src.loc)

	if(.)
		if(opacity)
			updateVisibility(src)
		Moved(OldLoc, dir, old_locs)

/atom/movable/proc/Moved(atom/OldLoc, Dir, old_locs)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, OldLoc, Dir, old_locs)

/atom/movable/proc/set_glide_size(glide_size_override = 0, min = 0.1, max = world.icon_size)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_MOVABLE_UPDATE_GLIDE_SIZE, glide_size_override)
	if (!glide_size_override || glide_size_override > max)
		glide_size = 0
	else
		glide_size = max(min, glide_size_override)

/obj/set_glide_size(glide_size_override, min, max)
	..()
	buckled_mob?.set_glide_size(glide_size, min, max)

/proc/step_glide(atom/movable/AM, dir, glide_size)
	return AM.Move(get_step(AM, dir), dir, glide_size_override = glide_size)

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