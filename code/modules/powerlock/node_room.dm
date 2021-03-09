/*
	A node room is a special room which is sealed with a power lock, and cannot be entered except by opening that lock.

	Node rooms contain goodies, lots of random loot
	Node rooms are always pristine and in good condition. They have been sealed and are less worn than other places on the ship

*/
GLOBAL_LIST_EMPTY(powernode_rooms)

/datum/node_room
	//The landmark we're using
	var/obj/effect/landmark/node_room/source

	var/turf/origin



	//Powerlock
	var/obj/power_lock/lock



	//How many powernodes are needed to open this?
	var/difficulty = 1

	//Increases the quantity of loot, calculated based on difficulty
	var/multiplier = 1

	//Has the room been opened?
	var/opened = FALSE


	//Chance that a piece of loot will spawn on the floor, even when placements are available
	var/floor_spawn_chance = 20

	/*
		Cache Lists
	*/
	//This contains ALL of the nonturf atoms in the room
	var/list/stuff

	//All turfs in the room
	var/list/turfs = list()

	//Clear floor tiles, upon which we might place large items, or maybe just normal ones
	var/list/floors = list()

	//When a node room is in maintenance with a plating floor, we pick one of these floors to use instead
	var/list/possible_flooring_types = list(/decl/flooring/carpet/red,
	/decl/flooring/complex/perforated_gray,
	/decl/flooring/complex/perforated_brown,
	/decl/flooring/complex/mono,
	/decl/flooring/complex/techno)

	//The flooring we've picked
	var/decl/flooring/selected_flooring

	//A list of atoms which we've added the indestructible flag to. So we can remove it later
	var/list/indestructible_atoms = list()

	//List of doors bound by the power lock
	var/list/doors = list()

	//A list of atoms (tables, lockers, crates, racks, etc) that are suitable to spawn loot on or within
	var/list/placements = list()


	//A list of light fixtures
	var/list/lights	 = list()
	var/light_dim_factor = 0.5

	/*
		Loot spawns
	*/
	var/ammo = 5
	var/toolmods = 5
	var/uncommon_loot	= 10
	var/rare_loot	= 5
	//var/epic_loot	//Currently unused

/datum/node_room/New(var/obj/effect/landmark/node_room/source)
	GLOB.powernode_rooms += src
	src.source = source
	origin = get_turf(source)
	measure_room()
	prepare_room()
	set_difficulty()
	spawn_loot()
	create_lock()
	dim_lights()

	world << "Powerlocked room created at [jumplink(origin)]"


/datum/node_room/proc/measure_room()
	turfs = get_room(origin, TRUE)	//This gets the turfs in the room, including walls
	stuff = get_contents_list(turfs)	//Gets all the stuff in those turfs
	if (origin.is_plating())
		selected_flooring = pickweight(possible_flooring_types)

/datum/node_room/proc/prepare_room()

	//Turfs become unbreakable
	for (var/turf/A as anything in turfs)
		make_indestructible(A)
		A.clean()//Clean it up. This room has been sealed so it should look pristine
		var/turf/T2 = GetAbove(A)

		//Also apply to the turf above them so people can't dig a hole in the floor above
		if (T2)
			make_indestructible(T2)


		if (selected_flooring && isfloor(A))
			var/turf/simulated/floor/F = A
			F.set_flooring(get_flooring_data(selected_flooring))
		if (turf_clear(A))
			floors |= A


	for (var/atom/A as anything in stuff)
		if (isturf(A))
			turfs |= A
		else if (istype(A, /obj/structure/window))
			make_indestructible(A)
		else if (istype(A, /obj/machinery/door/airlock))
			make_indestructible(A)
			lock_door(A)
			doors += A
		else if (iscloset(A) || istable(A))
			placements += A
		else if (islight(A))
			lights += A
		//Light constructs get turned into real lights with free bulbs
		else if (istype(A, /obj/machinery/light_construct))
			var/obj/machinery/light_construct/LC = A
			var/atom/B = LC.finish_construction(TRUE)
			lights += B

	stuff = list()	//Dont need this data anymore

//The room has been opened with powernodes!
/datum/node_room/proc/open()
	opened = TRUE
	//Open the doors
	for (var/obj/machinery/door/airlock/A in doors)
		unlock_door(A)

	//The walls and floors are no longer protected
	for (var/atom/A in indestructible_atoms)
		remove_indestructible(A)


	illuminate_lights()

/datum/node_room/proc/set_difficulty()
	difficulty = rand_between(1, source.max_difficulty)
	multiplier = 1 + ((difficulty - 1)* 0.5)

/datum/node_room/proc/make_indestructible(var/atom/A)



	//If it is already, we do nothing
	if (A.atom_flags & ATOM_FLAG_INDESTRUCTIBLE)
		return


	A.atom_flags |= ATOM_FLAG_INDESTRUCTIBLE
	indestructible_atoms |= A

/datum/node_room/proc/remove_indestructible(var/atom/A)
	A.atom_flags -= ATOM_FLAG_INDESTRUCTIBLE
	indestructible_atoms -= A


/datum/node_room/proc/lock_door(var/obj/machinery/door/airlock/A)

	doors |= A
	A.req_access |= access_powerlock
	A.locked = TRUE
	A.update_icon()

/datum/node_room/proc/unlock_door(var/obj/machinery/door/airlock/A)

	doors -= A
	A.req_access -= access_powerlock
	A.locked = FALSE
	spawn(10)
		A.open()
	A.update_icon()



/datum/node_room/proc/spawn_loot()
	spawn_loot_type(/obj/random/ammo, ammo)
	spawn_loot_type(/obj/random/tool_upgrade, toolmods)
	spawn_loot_type(/obj/random/uncommon_loot, uncommon_loot)
	spawn_loot_type(/obj/random/rare_loot/nodeless, rare_loot)

/datum/node_room/proc/spawn_loot_type(var/item_path, var/quantity)
	quantity *= multiplier
	for (var/index in 1 to quantity)
		var/atom/target_loc = get_spawn_location()
		target_loc.spawn_at(item_path)

/datum/node_room/proc/get_spawn_location()
	if (!length(placements) || prob(floor_spawn_chance))
		return pick(floors)

	return pick(placements)


/datum/node_room/proc/create_lock()

	if (!doors.len)
		message_admins("ERROR: Powerlocked room with no doors created at [jumplink(origin)]")
		return

	/*
		Lets pick which door we're going to put the lock next to
	*/
	var/obj/machinery/door/airlock/A = doors[1]
	if (doors.len > 1)
		A = pick(doors)	//Todo: try to pick one that stands alone with a nearby wall to use

	lock = new (get_turf(A))
	lock.NR = src
	for (var/turf/simulated/wall/W in lock.get_cardinal())
		lock.offset_to(W, 24)
		break

/datum/node_room/proc/dim_lights()
	for (var/obj/machinery/light/L in lights)
		if (L.lightbulb)
			L.lightbulb.b_max_bright *= light_dim_factor
			L.lightbulb.b_inner_range *= light_dim_factor
			L.lightbulb.b_outer_range *= light_dim_factor
			L.update_icon()

/datum/node_room/proc/illuminate_lights()
	for (var/obj/machinery/light/L in lights)
		spawn(rand_between(2 SECONDS, 10 SECONDS))
			if (L.lightbulb)
				L.lightbulb.b_max_bright /= light_dim_factor
				L.lightbulb.b_inner_range /= light_dim_factor
				L.lightbulb.b_outer_range /= light_dim_factor
				L.seton(TRUE)
				L.update_icon()