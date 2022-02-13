/obj/effect/vent_spawner
	var/floor_type
	var/wall_type
	var/roof_type


/obj/effect/vent_spawner/pump	
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "hout"

	wall_type = /obj/machinery/atmospherics/unary/vent/pump/wall
	floor_type = /obj/machinery/atmospherics/unary/vent/pump/on

/obj/effect/vent_spawner/Initialize(mapload)
	. = ..()
	var/obj/machinery/atmospherics/unary/vent/V = activate()
	if (istype(V))
		V.bootstrap()
	return INITIALIZE_HINT_QDEL


/obj/effect/vent_spawner/proc/activate()
	var/turf/ourturf = get_turf(src)
	/*
		Alright, first up, wall vents get priority
	*/
	if (wall_type)
		var/turfs = get_cardinal_turfs()
		for (var/turf/T as anything in turfs)
			if (!T.is_wall)
				continue	//gotta be a wall



			//Lets get the direction from it to us
			var/direction = get_dir(T, src)

			//Get the axis perpendicular to our direction
			var/list/axis = direction_to_axis(turn(direction, 90))

			
			//Gotta be connected to one other wall
			if (!T.is_connected_vertical_surface(axis))
				continue

			//If we have reached here, then we've successfully found a valid wall to attach to
			return new wall_type(ourturf, direction)//pass in the direction, it will automatically handle that stuff


	//TODO Future: Ceiling Vents
	if (roof_type)
		return

	//Floor is the fallback, no special conditions needed
	if (floor_type)
		return new floor_type(ourturf)
	
