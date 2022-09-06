/turf
	icon = 'icons/turf/floors.dmi'
	level = 1
	vis_flags = VIS_INHERIT_ID | VIS_INHERIT_PLANE// Important for interaction with and visualization of openspace.
	var/turf_flags

	var/holy = 0
	var/is_hole = FALSE			// If true, turf is open to vertical transitions through it.
	var/is_wall = FALSE			// If true, this turf is, or contains, a solid wall.

	var/hitsound = 'sound/weapons/Genhit.ogg'

	var/health
	var/max_health = 100
	var/resistance

	//Set this false when the turf is dense, or contains any dense atom
	//A null value is maybe, it means we should check to find out. Set it null whenever any change happens to contents
	var/clear = null

	// Initial air contents (in moles)
	var/list/initial_gas

	//Properties for airtight tiles (/wall)
	var/thermal_conductivity = 0.05
	var/heat_capacity = 1

	//Properties for both
	var/temperature = T20C      // Initial turf temperature.
	var/blocks_air = 0          // Does this turf contain air/let air through?

	// General properties.
	var/icon_old = null
	var/pathweight = 1          // How much does it cost to pathfind over this turf?
	var/blessed = 0             // Has the turf been blessed?

	var/list/decals

	var/movement_delay

	var/tmp/changing_turf

	///Lumcount added by sources other than lighting datum objects, such as the overlay lighting component.
	var/dynamic_lumcount = 0

	///Bool, whether this turf will always be illuminated no matter what area it is in
	var/always_lit = FALSE

	var/tmp/lighting_corners_initialised = FALSE

	///Our lighting object.
	var/tmp/datum/lighting_object/lighting_object
	///Lighting Corner datums.
	var/tmp/datum/lighting_corner/lighting_corner_NE
	var/tmp/datum/lighting_corner/lighting_corner_SE
	var/tmp/datum/lighting_corner/lighting_corner_SW
	var/tmp/datum/lighting_corner/lighting_corner_NW


	///Which directions does this turf block the vision of, taking into account both the turf's opacity and the movable opacity_sources.
	var/directional_opacity = NONE
	///Lazylist of movable atoms providing opacity sources.
	var/list/atom/movable/opacity_sources

	var/footstep
	var/barefootstep
	var/clawfootstep
	var/heavyfootstep

/turf/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE)
	if(atom_flags & ATOM_FLAG_INITIALIZED)
		crash_with("Warning: [src]([type]) initialized multiple times!")
	atom_flags |= ATOM_FLAG_INITIALIZED

	// by default, vis_contents is inherited from the turf that was here before
	vis_contents.Cut()

	levelupdate()

	for(var/atom/movable/content as anything in src)
		Entered(content, null)

	var/area/our_area = loc
	if(our_area.area_has_base_lighting && always_lit) //Only provide your own lighting if the area doesn't for you
		add_overlay(GLOB.fullbright_overlay)

	if (light_power && light_range)
		update_light()

	var/turf/T = GetAbove(src)
	if(T)
		T.multiz_turf_new(src, DOWN)
	T = GetBelow(src)
	if(T)
		T.multiz_turf_new(src, UP)

	if (opacity)
		directional_opacity = ALL_CARDINALS

	return INITIALIZE_HINT_NORMAL

/turf/proc/has_wall()
	if (is_wall)
		return TRUE
	for (var/atom/A in src)
		if (iswindow(A))
			var/obj/structure/window/W = A
			if (W.is_full_window())
				return TRUE

	return FALSE

/turf/Destroy(force)
	if (!changing_turf)
		crash_with("Improper turf qdel. Do not qdel turfs directly.")

	changing_turf = FALSE

	remove_cleanables()

	var/turf/T = GetAbove(src)
	if(T)
		T.multiz_turf_del(src, DOWN)
	T = GetBelow(src)
	if(T)
		T.multiz_turf_del(src, UP)

	..()
	return QDEL_HINT_IWILLGC

/turf/proc/multiz_turf_del(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_DEL, T, dir)

/turf/proc/multiz_turf_new(turf/T, dir)
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_NEW, T, dir)

/turf/ex_act(severity)
	return FALSE

/turf/proc/is_solid_structure()
	return TRUE

/turf/AllowDrop()
	return TRUE

/turf/attack_robot(var/mob/user)
	if(Adjacent(user))
		attack_hand(user)

/turf/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/storage))
		var/obj/item/storage/S = W
		if(S.use_to_pickup && S.collection_mode)
			S.gather_all(src, user)
	return ..()


/turf/proc/can_enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return FALSE

	var/turf/origin = mover.loc

	//First, check objects to block exit . border or not
	for(var/obj/obstacle in origin.contents)
		if((mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				return obstacle


	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src.contents)
		if(border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				return border_obstacle

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		return src

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src.contents)
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				return obstacle
	return FALSE //Nothing found to block so return success!


/turf/Enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)

	..()

	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return TRUE

	var/turf/origin = mover.loc

	//First, check objects to block exit . border or not
	for(var/obj/obstacle in origin.contents)
		if((mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return FALSE

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src.contents)
		if(border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return FALSE

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return FALSE

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src.contents)
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return FALSE

	return TRUE //Nothing found to block so return success!

var/const/enterloopsanity = 100
/turf/Entered(atom/atom as mob|obj)

	..()

	if(!istype(atom, /atom/movable))
		return

	var/atom/movable/A = atom

	if(ismob(A))
		var/mob/M = A
		if(!M.check_solid_ground())
			inertial_drift(M)
			//we'll end up checking solid ground again but we still need to check the other things.
			//Ususally most people aren't in space anyways so hopefully this is acceptable.
			M.update_floating()
		else
			M.inertia_dir = 0
			M.make_floating(0) //we know we're not on solid ground so skip the checks to save a bit of processing

	var/objects = 0
	if(A && (A.movable_flags & MOVABLE_FLAG_PROXMOVE))
		for(var/atom/movable/thing in range(1))
			if(objects > enterloopsanity) break
			objects++
			spawn(0)
				if(A)
					A.HasProximity(thing, 1)
					if ((thing && A) && (thing.movable_flags & MOVABLE_FLAG_PROXMOVE))
						thing.HasProximity(A, 1)

	if(A.density)
		if(clear)	//If clear was previously true, null it
			clear = null

		//If this turf was not already dense, maybe it is now. notify everyone of that possibility
		if(!density && A.density)
			content_density_set(A.density)

/turf/Exited(atom/atom as mob|obj)
	.=..()

	if(atom.density)
		if(!clear)	//If clear was previously true, null it
			clear = null

		//If this turf was not naturally dense, maybe this object was the only thing blocking it, lets fire off an event
		if(!density && atom.density)
			content_density_set(atom.density)


/turf/proc/adjacent_fire_act(turf/simulated/floor/source, temperature, volume)
	return

/turf/proc/is_plating()
	return FALSE

/turf/proc/protects_atom(var/atom/A)
	return FALSE

/turf/proc/inertial_drift(atom/movable/A)
	if(!(A.last_move))	return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Allow_Spacemove(1)) //if this mob can control their own movement in space then they shouldn't be drifting
			M.inertia_dir  = 0
			return
		spawn(5)
			if(M && !(M.anchored) && !(M.pulledby) && (M.loc == src))
				if(!M.inertia_dir)
					M.inertia_dir = M.last_move
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		O.hide(O.hides_under_flooring() && !is_plating())

/turf/proc/AdjacentTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/turf/t as anything in (RANGE_TURFS(src, 1) - src))
		if(check_blockage)
			if(!t.density)
				if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
					. += t
		else
			. += t

/turf/proc/CardinalTurfs(var/check_blockage = TRUE)
	. = list()
	for(var/ad in AdjacentTurfs(check_blockage))
		var/turf/T = ad
		if(T.x == src.x || T.y == src.y)
			. += T

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		cost *= (pathweight+t.pathweight)/2
		return cost
	else
		return get_dist(src,t)

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/contains_dense_objects()
	if(density)
		return TRUE
	for(var/atom/A in src)
		if(A.density && !(A.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			return TRUE
	return FALSE

//expects an atom containing the reagents used to clean the turf
/turf/proc/clean(atom/source, mob/user = null)
	if(!source || source.reagents.has_reagent(/datum/reagent/water, 1) || source.reagents.has_reagent(/datum/reagent/space_cleaner, 1))
		clean_blood()
		remove_cleanables()
	else if (user)
		to_chat(user, "<span class='warning'>\The [source] is too dry to wash that.</span>")
	if (source)
		source.reagents.trans_to_turf(src, 1, 10)	//10 is the multiplier for the reaction effect. probably needed to wet the floor properly.

/turf/proc/remove_cleanables()
	for(var/obj/effect/O in src)
		if(istype(O,/obj/effect/rune) || istype(O,/obj/effect/decal/cleanable) || istype(O,/obj/effect/overlay))
			qdel(O)

/turf/proc/update_blood_overlays()
	return

/turf/proc/remove_decals()
	if(decals && decals.len)
		decals.Cut()
		decals = null


/turf/proc/is_floor()
	return FALSE

//Telling a turf to store an item just puts it ontop of us
/turf/store_item(var/obj/item/input, var/mob/user)
	input.forceMove(src)