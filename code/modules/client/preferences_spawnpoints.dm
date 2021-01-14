GLOBAL_VAR(spawntypes)

/proc/spawntypes()
	if(!GLOB.spawntypes)
		GLOB.spawntypes = list()
		for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
			var/datum/spawnpoint/S = type
			var/display_name = initial(S.display_name)
			if((display_name in GLOB.using_map.allowed_spawns) || initial(S.always_visible))
				GLOB.spawntypes[display_name] = new S
	return GLOB.spawntypes

/datum/spawnpoint
	var/msg		  //Message to display on the arrivals computer.
	var/list/turfs   //List of turfs to spawn on.
	var/display_name //Name used in preference setup. These names are defines from _defines/mobs.dm
	var/always_visible = FALSE	// Whether this spawn point is always visible in selection, ignoring map-specific settings.
	var/selectable = TRUE	//If false, this spawnpoint will not appear in the setup menu, but you could still be spawned there as a fallback if other points fail
	var/list/restrict_job = null
	var/list/disallow_job = null
	var/max_attempts = SPAWNPOINT_MAX_SAFETY_ATTEMPTS

/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return 0

	if(disallow_job && (job in disallow_job))
		return 0

	return 1

/datum/spawnpoint/proc/is_safe(var/mob/living/spawner)
	var/list/remaining_turfs = turfs.Copy()
	var/remaining_checks = max_attempts
	while (remaining_checks && length(remaining_turfs))
		var/turf/T = pick_n_take(remaining_turfs)

		//If we find even one safe turf, someone can spawn here, we're done
		if (turf_is_safe(spawner, T))
			return TRUE

		remaining_checks--

	return FALSE

/datum/spawnpoint/proc/turf_is_safe(var/mob/living/spawner, var/turf/spawn_turf)
	var/radlevel = SSradiation.get_rads_at_turf(spawn_turf)
	var/airstatus = IsTurfAtmosUnsafe(spawn_turf)
	if(airstatus || radlevel > 0)
		return FALSE

	if (area_corrupted(spawn_turf))
		return FALSE

	if (area_contains_necromorphs(spawn_turf))
		return FALSE

	return TRUE

//Loop through all the turfs in this spawnpoint randomly
/datum/spawnpoint/proc/get_safe_turf(var/mob/spawner, var/guaranteed = TRUE)
	var/list/checkturfs = turfs.Copy()
	checkturfs = shuffle(checkturfs)
	for (var/t in checkturfs)
		if (turf_is_safe(spawner, t))
			return t

	return null


/datum/spawnpoint/proc/post_spawn(var/mob/spawner, var/turf/location)
	return TRUE

#ifdef UNIT_TEST
/datum/spawnpoint/Del()
	crash_with("Spawn deleted: [log_info_line(src)]")
	..()

/datum/spawnpoint/Destroy()
	crash_with("Spawn destroyed: [log_info_line(src)]")
	. = ..()
#endif

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	msg = "has arrived on the station"

/datum/spawnpoint/arrivals/New()
	..()
	turfs = GLOB.latejoin

/datum/spawnpoint/gateway
	display_name = "Gateway"
	msg = "has completed translation from offsite gateway"

/datum/spawnpoint/gateway/New()
	..()
	turfs = GLOB.latejoin_gateway

/datum/spawnpoint/cryo
	display_name = SPAWNPOINT_CRYO
	msg = "has completed cryogenic revival"
	disallow_job = list("Robot")

/datum/spawnpoint/cryo/turf_is_safe(var/mob/living/spawner, var/turf/spawn_turf)
	var/obj/machinery/cryopod/C = locate(/obj/machinery/cryopod) in spawn_turf
	if (!C || C.occupant)
		return FALSE
	.=..()

/datum/spawnpoint/cryo/New()
	..()
	turfs = GLOB.latejoin_cryo


/datum/spawnpoint/cryo/post_spawn(var/mob/living/spawner, var/turf/location)
	var/obj/machinery/cryopod/C = locate(/obj/machinery/cryopod) in location
	if (istype(C))
		C.set_occupant(spawner, FALSE)

		//When spawning in cryo, you start off asleep for a few moments and wake up
		spawner.Paralyse(2)

		//You can get yourself out of the cryopod, or it will auto-eject after one minute
		spawn(600)
			if (C && C.occupant == spawner)
				C.go_out()
		return TRUE
	return FALSE


/datum/spawnpoint/dorm
	display_name = SPAWNPOINT_DORM
	msg = "has awoken in the crew quarters"
	disallow_job = list("Robot")

/datum/spawnpoint/dorm/New()
	..()
	turfs = GLOB.latejoin_dorm


/datum/spawnpoint/dorm/turf_is_safe(var/mob/living/spawner, var/turf/spawn_turf)
	var/obj/structure/bed/C = locate(/obj/structure/bed) in spawn_turf
	if (!C || C.buckled_mob)
		return FALSE
	.=..()

/datum/spawnpoint/dorm/post_spawn(var/mob/living/spawner, var/turf/location)
	var/obj/structure/bed/C = locate(/obj/structure/bed) in location
	if (istype(C))
		C.buckle_mob(spawner)

		//When spawning in bed, you start off asleep for a moment
		spawner.Paralyse(2)


		return TRUE
	return FALSE

/datum/spawnpoint/cyborg
	display_name = "Cyborg Storage"
	msg = "has been activated from storage"
	restrict_job = list("Robot")

/datum/spawnpoint/cyborg/New()
	..()
	turfs = GLOB.latejoin_cyborg

/datum/spawnpoint/default
	display_name = DEFAULT_SPAWNPOINT_ID
	msg = "has arrived on the station"
	always_visible = TRUE




//Maintenance is the last-ditch fallback. It can't be selected and is used only if all other spawnpoints are unsafe
//You awaken bleary eyed in maintenance, late to the party and probably surrounded by chaos.
//You must have gotten drunk and passed out, never made it back to your bunk
/datum/spawnpoint/maint
	display_name = SPAWNPOINT_MAINT
	msg = "belatedly reports for duty"
	disallow_job = list("Robot")
	max_attempts = 200	//There are a LOT more maintenance tiles, we'll try harder to find a safe one


/datum/spawnpoint/maint/New()
	..()
	turfs = GLOB.maintenance_turfs

//Custom safety checks, more localised
/datum/spawnpoint/maint/turf_is_safe(var/mob/living/spawner, var/turf/spawn_turf)
	var/radlevel = SSradiation.get_rads_at_turf(spawn_turf)
	var/airstatus = IsTurfAtmosUnsafe(spawn_turf)
	if(airstatus || radlevel > 0)
		return FALSE

	//No visible corruption
	if (turf_near_corrupted(spawn_turf, world.view))
		return FALSE

	//No live necros
	if (turf_near_necromorphs(spawn_turf))
		return FALSE

	return TRUE


/datum/spawnpoint/maint/post_spawn(var/mob/living/spawner, var/turf/location)
	.=..()
	new /obj/item/device/flashlight/flare/active(location)
	spawner.Paralyse(2)
	spawn (20)
		to_chat(spawner, SPAN_NOTICE("You don't remember making it back to your bunk last shift. Where are you...?"))