/datum/map/proc/setup_powernode_rooms()
	//Called from /datum/map/proc/setup_map() in maps/~mapsystem/maps.dm
	for (var/index in 1 to powernode_rooms)
		if (!length(GLOB.possible_node_rooms))
			message_admins("WARNING: Not enough potential powernode room landmarks on the map, could not spawn the desired number of rooms. \n\
			We only spawned [index-1]/[powernode_rooms]")
			break

		var/obj/effect/landmark/node_room/NRL = pickweight_n_take(GLOB.possible_node_rooms)

		//Alright we're gonna place a room at this landmark
		new /datum/node_room(NRL) //It will do all the work itself


/*
	This proc returns all the tiles in a "room", defined as a contigious atmospheric zone.
	Not recommended for use after roundstart, as gameplay may result in walls being removed and rooms changing

	The perimeter var grabs a 1 tile buffer around the room as well. important if you want walls, windows, doors, etc
	Same level only var confines room selection to the same zlevel
*/
/proc/get_room(var/turf/simulated/origin, var/perimeter = TRUE, var/same_level_only = FALSE)
	. = list()

	if (istype(origin) && origin.zone)
		. += origin.zone.contents



	//else
		//Possible future todo: Account for vacuum and flood fill the room manually?


	if (same_level_only)
		for (var/turf/T in .)
			if (T.z != origin.z)
				.-=T

	if (perimeter)
		for (var/turf/T in .)
			for (var/turf/T2 in RANGE_TURFS(T, 1))
				//Dont check if its already in the list
				if ((T2 in .))
					continue

				//This little check covers a possible edge case where there's turfs on the other side of a thin-pane window.
				//Unless those turfs are walls or otherwise block air, they won't be counted as part of the perimeter
				if(T2.c_airblock(T2) & AIR_BLOCKED)
					. += T2




/*
	This proc tells an atom to spawn the specified type path "at" itself.
	The item is allowed to interpret exactly what this means.

	In most cases, the new thing is simply spawned on the same turf.
	In the case of containers, it spawns inside them and is added to their contents
*/
/atom/proc/spawn_at(var/path)
	return new path(get_turf(src))

/obj/structure/closet/spawn_at(var/path)
	.=..()
	store_contents()	//Spawn on turf and then succ in
