// Returns the atom sitting on the turf.
// For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
/proc/get_atom_on_turf(var/atom/movable/M)
	var/atom/mloc = M
	while(mloc && mloc.loc && !istype(mloc.loc, /turf/))
		mloc = mloc.loc
	return mloc

/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || istype(T, /turf/simulated/shuttle/wall))

/proc/isfloor(turf/T)
	return (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))

/proc/turf_clear(turf/T, var/ignore_mobs = FALSE)
	if (!isnull(T.clear))
		return T.clear

	if (T.density)
		T.clear = FALSE
		return FALSE
	for(var/atom/A in T)
		if(A.density)
			T.clear = FALSE
			if (ignore_mobs && ismob(A))
				continue
			return FALSE

	if (isnull(T.clear))
		T.clear = TRUE
	return TRUE


/proc/turf_corrupted(var/atom/A, var/require_support = TRUE, var/min_health = 0)
	var/turf/T = get_turf(A)
	for (var/obj/effect/vine/corruption/C in T)
		if (require_support && !C.is_supported())
			return FALSE

		//Min health is a percentage, corruption patches which have less health than this won't count
		if (min_health && C.healthpercent() < min_health)
			return FALSE

		return TRUE

	return FALSE

//Returns true if this turf is corrupted, OR is near a corrupted tile
/proc/turf_near_corrupted(var/atom/A, var/range = 2, var/require_support = TRUE)
	if (turf_corrupted(A))
		return TRUE

	for (var/obj/effect/vine/corruption/C in dview(range, A))
		if (require_support && !C.is_supported())
			continue
		//TODO here: Check that the corruption is still linked to an undestroyed node. Fail if it is orphaned
		return TRUE

	return FALSE


//Returns true if this turf is near a live necromorph
/proc/turf_near_necromorphs(var/atom/A, var/range = world.view)
	var/turf/T = get_turf(A)
	//If we're not in the visualnet then we can't be
	if (!GLOB.necrovision.checkTurfVis(T))
		return FALSE

	for (var/mob/living/L in dview(range, T))
		if (L.stat != DEAD && L.is_necromorph())
			return TRUE

	return FALSE


// Picks a turf without a mob from the given list of turfs, if one exists.
// If no such turf exists, picks any random turf from the given list of turfs.
/proc/pick_mobless_turf_if_exists(var/list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

/proc/get_random_turf_in_range(var/atom/origin, var/outer_range, var/inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	for(var/turf/T in orange(origin, outer_range))
		if(!(T.z in GLOB.using_map.sealed_levels)) // Picking a turf outside the map edge isn't recommended
			if(T.x >= world.maxx-TRANSITIONEDGE || T.x <= TRANSITIONEDGE)	continue
			if(T.y >= world.maxy-TRANSITIONEDGE || T.y <= TRANSITIONEDGE)	continue
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T
	if(turfs.len)
		return pick(turfs)

/proc/screen_loc2turf(text, turf/origin)
	if(!origin)
		return null
	var/tZ = splittext(text, ",")
	var/tX = splittext(tZ[1], "-")
	var/tY = text2num(tX[2])
	tX = splittext(tZ[2], "-")
	tX = text2num(tX[2])
	tZ = origin.z
	tX = max(1, min(origin.x + 7 - tX, world.maxx))
	tY = max(1, min(origin.y + 7 - tY, world.maxy))
	return locate(tX, tY, tZ)

/*
	Predicate helpers
*/

/proc/is_holy_turf(var/turf/T)
	return T && T.holy

/proc/is_not_holy_turf(var/turf/T)
	return !is_holy_turf(T)

/proc/turf_contains_dense_objects(var/turf/T)
	return T.contains_dense_objects()

/proc/not_turf_contains_dense_objects(var/turf/T)
	return !turf_contains_dense_objects(T)

/proc/is_station_turf(var/turf/T)
	return T && isStationLevel(T.z)

/proc/has_air(var/turf/T)
	return !!T.return_air()

/proc/IsTurfAtmosUnsafe(var/turf/T)
	if(istype(T, /turf/space)) // Space tiles
		return "Spawn location is open to space."
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return "Spawn location lacks atmosphere."
	return get_atmosphere_issues(air, 1)

/proc/IsTurfAtmosSafe(var/turf/T)
	return !IsTurfAtmosUnsafe(T)

/proc/is_below_sound_pressure(var/turf/T)
	var/datum/gas_mixture/environment = T ? T.return_air() : null
	var/pressure =  environment ? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE

/*
	Turf manipulation
*/

//Returns an assoc list that describes how turfs would be changed if the
//turfs in turfs_src were translated by shifting the src_origin to the dst_origin
/proc/get_turf_translation(turf/src_origin, turf/dst_origin, list/turfs_src)
	var/list/turf_map = list()
	for(var/turf/source in turfs_src)
		var/x_pos = (source.x - src_origin.x)
		var/y_pos = (source.y - src_origin.y)
		var/z_pos = (source.z - src_origin.z)

		var/turf/target = locate(dst_origin.x + x_pos, dst_origin.y + y_pos, dst_origin.z + z_pos)
		if(!target)
			log_debug("Null turf in translation @ ([dst_origin.x + x_pos], [dst_origin.y + y_pos], [dst_origin.z + z_pos])")
		turf_map[source] = target //if target is null, preserve that information in the turf map

	return turf_map


/proc/translate_turfs(list/translation, area/base_area = null, turf/base_turf)
	for(var/turf/source in translation)

		var/turf/target = translation[source]

		if(target)
			//update area first so that area/Entered() will be called with the correct area when atoms are moved
			if(base_area)
				ChangeArea(target, get_area(source))
				ChangeArea(source, base_area)
			transport_turf_contents(source, target)

	//change the old turfs
	for(var/turf/source in translation)
		source.ChangeTurf(base_turf ? base_turf : get_base_turf_by_area(source), 1, 1)

//Transports a turf from a source turf to a target turf, moving all of the turf's contents and making the target a copy of the source.
/proc/transport_turf_contents(turf/source, turf/target)

	var/turf/new_turf = target.ChangeTurf(source.type, 1, 1)
	new_turf.transport_properties_from(source)

	for(var/obj/O in source)
		if(O.simulated)
			O.forceMove(new_turf)

	for(var/mob/M in source)
		if(isEye(M)) continue // If we need to check for more mobs, I'll add a variable
		M.forceMove(new_turf)

	return new_turf

//Takes a list of turfs, randomly picks from it til we find one that passes turf_clear
/proc/clear_turf_in_list(var/list/turfs, var/ignore_mobs = FALSE)
	if (!turfs || !turfs.len)
		return null

	while (turfs.len)
		var/turf/T = pick(turfs)
		if (turf_clear(T, ignore_mobs))
			return T
		else
			turfs -= T


/*
	Very specific use case. This proc returns true if the turf is currently visible to any conscious, living, human crewmember
	It does not return true if seen by:
		Animals
		Necromorphs
		Ghosts/signals

	Optionally (enabled by default), tiles in sight of the marker, or a marker shard, are designated safe zone, crew visibility is ignored there
*/
/turf/proc/is_seen_by_crew(var/marker_safe_zone = TRUE)
	.=FALSE
	if (marker_safe_zone && is_in_sight_of_marker())
		return FALSE
	for (var/mob/living/carbon/human/H as anything in get_viewers(20, /mob/living/carbon/human))
		if (H.is_necromorph())
			//Necromorphs don't count
			continue
		if (H.stat == UNCONSCIOUS)
			//Sleeping people can see one tile around them
			if (get_dist(src, H) >= 2)
				continue

		return H


/*
	Very specific use case. This proc returns true if the turf is currently visible to any conscious, living, human crewmember
	It does not return true if seen by:
		Animals
		Necromorphs
		Ghosts/signals

	Optionally (enabled by default), tiles in sight of the marker, or a marker shard, are designated safe zone, crew visibility is ignored there
*/
/turf/proc/crew_nearby(var/distance = 7)
	for (var/mob/living/carbon/human/H in range(distance, src))
		if (H.is_necromorph())
			//Necromorphs don't count
			continue
		if (H.stat == UNCONSCIOUS)
			continue

		return H

	return FALSE



/turf/proc/is_in_sight_of_marker()
	var/list/safe_types = list(/obj/item/marker_shard, /obj/machinery/marker)
	for (var/obj/O in dview(7, src))
		if (is_type_in_list(O, safe_types))
			return TRUE

	return FALSE



/atom/proc/get_cardinal_corruption()
	var/list/turfs = get_cardinal()
	for (var/turf/T in turfs)
		if (!turf_corrupted(T))
			turfs -= T

	return turfs




//Returns true if this tile is an upper hull tile of the ship. IE, a roof
/proc/turf_is_upper_hull(var/turf/T)
	var/turf/B = GetBelow(T)
	if (!B)
		//Gotta be something below us if we're a roof
		return FALSE

	if (!turf_is_external(T))
		//We must be outdoors. if there's something above us we're not the roof
		return FALSE

	if (turf_is_external(B))
		//Got to be containing something underneath us
		return FALSE

	return TRUE


//Returns true if this is a lower hull of the ship. IE,a floor that has space underneath
/proc/turf_is_lower_hull(var/turf/T)
	if (turf_is_external(T))
		//We must be indoors
		return FALSE

	var/turf/B = GetBelow(T)
	if (!B)
		//If we're on the lowest zlevel, return true
		return TRUE

	if (turf_is_external(B))
		//We must be outdoors. if there's something above us we're not the roof
		return TRUE



	return FALSE


/proc/isOnShipLevel(var/atom/A)
	if (A && istype(A))
		if (A.z in GLOB.using_map.station_levels)
			return TRUE
	return FALSE


/*
//This is used when you want to check a turf which is a Z transition. For example, an openspace or stairs
//If this turf conencts to another in that manner, it will return the destination. If not, it will return the input
/proc/get_connecting_turf(var/turf/T, var/turf/from = null)
	if (T.is_hole)
		var/turf/U = GetBelow(T)
		if (U)
			return U

	var/obj/effect/portal/P = (locate(/obj/effect/portal) in T)
	if (P && P.target)
		return P.get_destination(from)

	var/obj/structure/multiz/stairs/active/SA = (locate(/obj/structure/multiz/stairs/active) in T)
	if (SA && SA.target)
		return get_turf(SA.target)
	return T
*/

/turf/proc/has_gravity()
	var/area/A = loc
	if (A)
		return A.has_gravity()

	return FALSE

/proc/is_turf_atmos_unsafe(var/turf/T)
	if(istype(T, /turf/space)) // Space tiles
		return "Spawn location is open to space."
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return "Spawn location lacks atmosphere."
	return get_atmosphere_issues(air, 1)


//Used for border objects. This returns true if this atom is on the border between the two specified turfs
//This assumes that the atom is located inside the target turf
/atom/proc/is_between_turfs(var/turf/origin, var/turf/target)
	if (atom_flags & ATOM_FLAG_CHECKS_BORDER)
		var/testdir = get_dir(target, origin)
		return (dir & testdir)
	return TRUE


//This fuzzy proc attempts to determine whether or not this tile is outside the ship
/proc/turf_is_external(var/turf/T)
	if (istype(T, /turf/space))
		return TRUE

	var/area/A = get_area(T)
	if (A.area_flags & AREA_FLAG_EXTERNAL)
		return TRUE

	if (isnull(T.initial_gas))
		return TRUE

	return FALSE