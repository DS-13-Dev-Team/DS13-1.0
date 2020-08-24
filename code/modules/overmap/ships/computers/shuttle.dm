//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"
	ui_template = "shuttle_control_console_exploration.tmpl"

/obj/machinery/computer/shuttle_control/explore/get_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		var/fuel_pressure = 0
		var/fuel_max_pressure = 0
		for(var/obj/structure/fuel_port/FP in shuttle.fuel_ports) //loop through fuel ports
			var/obj/item/weapon/tank/fuel_tank = locate() in FP
			if(fuel_tank)
				fuel_pressure += fuel_tank.air_contents.return_pressure()
				fuel_max_pressure += 1013

		if(fuel_max_pressure == 0) fuel_max_pressure = 1

		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
			"fuel_port_present" = shuttle.fuel_consumption? 1 : 0,
			"fuel_pressure" = fuel_pressure,
			"fuel_max_pressure" = fuel_max_pressure,
			"fuel_pressure_status" = (fuel_pressure/fuel_max_pressure > 0.2)? "good" : "bad"
		)

	if((. = ..()) != null)
		return
