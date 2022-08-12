#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/hydro_tray
	name = T_BOARD("Hydroponic Tray")
	build_path = /obj/machinery/portable_atmospherics/hydroponics
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(/obj/item/stock_parts/matter_bin = 2,
						  /obj/item/stock_parts/manipulator = 1,
						 /obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/seed_extractor
	name = T_BOARD("Seed Extractor")
	build_path = /obj/machinery/seed_extractor
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/smartfridge
	name = T_BOARD("Smartfridge")
	build_path = /obj/machinery/smartfridge
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/matter_bin = 1)

/obj/item/circuitboard/deepfryer
	name = T_BOARD("Deep Fryer")
	build_path = /obj/machinery/cooker/fryer
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
						  /obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/microwave
	name = T_BOARD("Microwave")
	build_path = /obj/machinery/microwave
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
						  /obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/oven
	name = T_BOARD("Oven")
	build_path = /obj/machinery/cooker/oven
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
						  /obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/grill
	name = T_BOARD("Grill")
	build_path = /obj/machinery/cooker/grill
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
						  /obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/candymaker
	name = T_BOARD("Candy Machine")
	build_path = /obj/machinery/cooker/candy
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
						  /obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/cereal
	name = T_BOARD("Cereal")
	build_path = /obj/machinery/cooker/cereal
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/micro_laser = 1,
						  /obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/gibber
	name = T_BOARD("Gibber")
	build_path = /obj/machinery/gibber
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1)
	req_components = list(/obj/item/stock_parts/matter_bin = 2,
						  /obj/item/stock_parts/manipulator = 1)

/obj/item/circuitboard/extractor
	name = T_BOARD("lysis-isolation centrifuge")
	build_path = /obj/machinery/botany/extractor
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(/obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/manipulator = 1,
						  /obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/editor
	name = T_BOARD("bioballistic delivery system")
	build_path = /obj/machinery/botany/editor
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 2)
	req_components = list(/obj/item/stock_parts/matter_bin = 1,
						  /obj/item/stock_parts/manipulator = 1,
						  /obj/item/stock_parts/console_screen = 1)
