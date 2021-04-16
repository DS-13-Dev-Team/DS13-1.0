/*
	Special areas mark places necromorphs can spawn for events
*/
/area/necrospawn
	var/active = FALSE	//Has this already been opened for spawning?
	var/obj/structure/corruption_node/nest/event_spawn/spawner

/area/necrospawn/proc/open_spawner()
	if (spawner)
		return

	var/turf/T = get_clear_turf()
	spawner = new (T)
	active = TRUE