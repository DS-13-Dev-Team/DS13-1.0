/*
	Necrovision is used by both the marker, and signal ghosts
*/

/datum/visualnet/necrovision
	valid_source_types = list(/mob/living/, /obj/machinery/marker)
	chunk_type = /datum/chunk/necrovision

/datum/chunk/necrovision/acquire_visible_turfs(var/list/visible)
	for(var/source in sources)
		var/viewrange = world.view
		if(istype(source, /mob/living))
			var/mob/living/L = source
			if(L.stat == DEAD)
				remove_source(source, FALSE)	//Dead necros can't be revived, remove them from the list. just inert meat now
				continue

			for(var/t in L.turfs_in_view())
				visible[t] = t
		else if (istype(source, /obj/machinery/marker))
			for(var/t in range(10, source)) //The marker has decent vision around itself
				visible[t] = t
		else
			for(var/t in seen_turfs_in_range(source, viewrange))
				visible[t] = t

