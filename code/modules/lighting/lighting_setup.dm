/proc/create_all_lighting_objects()
	for(var/area/A in world)
		for(var/turf/T in A)
			if(T.always_lit)
				continue
			new/datum/lighting_object(T)
			CHECK_TICK
		CHECK_TICK
