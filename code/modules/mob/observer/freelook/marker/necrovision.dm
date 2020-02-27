/*
	Necrovision is used by both the marker, and signal ghosts
*/

/datum/visualnet/necrovision
	valid_source_types = list(/mob/living/, /obj/machinery/marker, /obj/effect/vine/corruption, /obj/structure/corruption_node)
	chunk_type = /datum/chunk/necrovision

/datum/chunk/necrovision/acquire_visible_turfs(var/list/visible)
	for(var/datum/source as anything in sources)
		for(var/t in source.get_visualnet_tiles(visualnet)) //The marker has decent vision around itself
			visible[t] = t


