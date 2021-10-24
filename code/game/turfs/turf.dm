/turf
	icon = 'icons/turf/floors.dmi'
	level = 1

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

	//List of everything that could possibly block movement
	var/list/movement_blocking_atoms = list()

	var/list/decals

	var/movement_delay

	var/tmp/changing_turf


/turf/proc/has_wall()
	if (is_wall)
		return TRUE
	for (var/atom/A in src)
		if (iswindow(A))
			var/obj/structure/window/W = A
			if (W.is_full_window())
				return TRUE

	return FALSE
/turf/Initialize(mapload, ...)
	. = ..()
	if(dynamic_lighting)
		luminosity = 0
	else
		luminosity = 1

	if (mapload && permit_ao)
		queue_ao()

	if (z_flags & ZM_MIMIC_BELOW)
		setup_zmimic(mapload)

	return INITIALIZE_HINT_NORMAL

/turf/Destroy()
	if (!changing_turf)
		crash_with("Improper turf qdel. Do not qdel turfs directly.")

	changing_turf = FALSE

	remove_cleanables()

	if (ao_queued)
		SSao.queue -= src
		ao_queued = 0

	if (z_flags & ZM_MIMIC_BELOW)
		cleanup_zmimic()

	if (bound_overlay)
		QDEL_NULL(bound_overlay)

	..()
	return QDEL_HINT_IWILLGC

/turf/ex_act(severity)
	return FALSE

/turf/proc/is_solid_structure()
	return TRUE



/turf/attack_robot(var/mob/user)
	if(Adjacent(user))
		attack_hand(user)

turf/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		if(S.use_to_pickup && S.collection_mode)
			S.gather_all(src, user)
	return ..()


/turf/proc/can_enter(atom/movable/mover as mob|obj, atom/forget as mob|obj|turf|area)
	if (!mover || !isturf(mover.loc) || isobserver(mover))
		return FALSE

	var/turf/origin = mover.loc

	//First, check objects to block exit . border or not
	for(var/obj/obstacle in origin.movement_blocking_atoms)
		if((mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				return obstacle


	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src.movement_blocking_atoms)
		if(border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				return border_obstacle

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		return src

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src.movement_blocking_atoms)
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
	for(var/obj/obstacle in origin.movement_blocking_atoms)
		if((mover != obstacle) && (forget != obstacle))
			if(!obstacle.CheckExit(mover, src))
				mover.Bump(obstacle, 1)
				return FALSE

	//Next, check objects to block entry that are on the border
	for(var/obj/border_obstacle in src.movement_blocking_atoms)
		if(border_obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER)
			if(!border_obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != border_obstacle))
				mover.Bump(border_obstacle, 1)
				return FALSE

	//Then, check the turf itself
	if (!src.CanPass(mover, src))
		mover.Bump(src, 1)
		return FALSE

	//Finally, check objects/mobs to block entry that are not on the border
	for(var/atom/movable/obstacle in src.movement_blocking_atoms)
		if (QDELETED(obstacle))
			movement_blocking_atoms -= obstacle
			continue
		if(!(obstacle.atom_flags & ATOM_FLAG_CHECKS_BORDER))
			if(!obstacle.CanPass(mover, mover.loc, 1, 0) && (forget != obstacle))
				mover.Bump(obstacle, 1)
				return FALSE

	return TRUE //Nothing found to block so return success!

var/const/enterloopsanity = 100
/turf/Entered(atom/atom as mob|obj)

	..()

	if (atom.can_block_movement)
		LAZYDISTINCTADD(movement_blocking_atoms,atom)

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
	return

/turf/Exited(atom/atom as mob|obj)
	if (atom.can_block_movement)

		LAZYREMOVE(movement_blocking_atoms,atom)

	.=..()


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
	for(var/turf/t in (trange(1,src) - src))
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