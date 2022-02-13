/obj/machinery/atmospherics/unary/vent

	var/area/initial_loc

	var/welded = 0


/obj/machinery/atmospherics/unary/vent/return_network(obj/machinery/atmospherics/reference)
	.=..()
	if (!.)
		return network 

/*
	Call this when doing runtime spawning
*/
/obj/machinery/atmospherics/unary/vent/proc/bootstrap()
	node = null
	set_dir(dir)
	var/turf/T = loc
	level = !T.is_plating() ? 2 : 1
	atmos_init()
	build_network()
	if (node)
		node.atmos_init()
		node.build_network()