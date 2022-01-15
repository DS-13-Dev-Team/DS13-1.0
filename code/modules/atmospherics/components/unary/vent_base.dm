/obj/machinery/atmospherics/unary/vent

	var/area/initial_loc

	var/welded = 0


/obj/machinery/atmospherics/unary/vent/return_network(obj/machinery/atmospherics/reference)
	.=..()
	if (!.)
		return network 