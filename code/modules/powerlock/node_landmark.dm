/*
	Node landmarks are mapped in at authortime. One in the centre of a room.

	These landmarks designate a room as being a potential candidate to become a node room.
	They should only be placed within rooms that do not otherwise serve a significant purpose.
	Deadend maintenance areas, lesser-used storage rooms, etc.
*/
GLOBAL_LIST_EMPTY(possible_node_rooms)

/obj/effect/landmark/node_room
	var/weight = 1	//Likelihood of being chosen, make subtypes with varying weights
	var/max_difficulty = 3	//How many powernodes could this door possibly require?
	delete_me = FALSE

/obj/effect/landmark/node_room/New()
	GLOB.possible_node_rooms[src] = weight
	.=..()


/obj/effect/landmark/node_room/maintenance
	weight = 2
