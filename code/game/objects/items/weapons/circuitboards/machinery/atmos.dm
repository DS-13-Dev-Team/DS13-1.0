#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/spaceheater
	name = T_BOARD("space heater")
	build_path = /obj/machinery/space_heater
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 1)
	req_components = list(
		/obj/item/weapon/stock_parts/micro_laser = 1,
		/obj/item/weapon/stock_parts/capacitor = 1,
		/obj/item/stack/cable_coil = 3)