//Slow initialisation system
//This should contain unimportant things which can take as long as they need to, and may very well continue their loading/initialisation work long after roundstart
//Nothing in this system should be blocking
SUBSYSTEM_DEF(slow)
	name = "Slow Initialization"
	init_order = SS_INIT_SLOW
	flags = SS_NO_FIRE

	var/list/doors_needing_areas = list()


//This should always return immediately and not delay the start of the round
/datum/controller/subsystem/slow/Initialize()
	set waitfor = FALSE
	.=..()
	cache_maintenance_turfs()
	calculate_door_areas()


//This makes all the airlocks on the map run update_areas, an extremely expensive proc to find their neighboring areas
/datum/controller/subsystem/slow/proc/calculate_door_areas()
	set waitfor = FALSE

	for (var/obj/machinery/door/D in doors_needing_areas)
		D.update_areas()
		CHECK_TICK

	doors_needing_areas = list()


/datum/controller/subsystem/slow/proc/cache_maintenance_turfs()
	for(var/Y in GLOB.ship_areas)
		var/area/A = Y
		if (A.is_maintenance)
			for (var/turf/T in A)
				if (isOnShipLevel(T) && turf_clear(T))
					GLOB.maintenance_turfs += T
		CHECK_TICK
