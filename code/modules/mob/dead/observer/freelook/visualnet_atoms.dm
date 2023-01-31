/*
When this atom is used as a source for a visualnet, what's the farthest possible distance it could see?
This is used to optimise visualnet processing, and it must represent an absolute biggest-case.
It does not actually determine which tiles can be seen at any given moment
*/
/datum/var/visualnet_range = 7


//Returns the max range we can see. This could be overridden for an edge case where a single source is used for multiple visualnets and has different radius for each
/atom/proc/get_visualnet_range(var/datum/visualnet/network)
	return visualnet_range

//Overrideable proc for any datum to return what turfs it can "see" for visualnets
/atom/proc/get_visualnet_tiles()
	var/list/things = list()
	FOR_DVIEW(var/turf/T, world.view, get_turf(src), 0)
		things += T
	END_FOR_DVIEW
	return things

/mob/get_visualnet_tiles()
	var/origin
	if (!view_offset)
		origin = get_turf(src)
	else
		origin = get_view_centre()

	var/list/things = list()
	FOR_DVIEW(var/turf/T, view_range, origin, 0)
		things += T
	END_FOR_DVIEW
	return things
