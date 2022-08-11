#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/circuitboard/resleever
	name = T_BOARD("neural lace resleever")
	build_path = /obj/machinery/resleever
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	req_components = list(
							/obj/item/stack/cable_coil = 2,
							/obj/item/stock_parts/scanning_module = 1,
							/obj/item/stock_parts/manipulator = 3,
							/obj/item/stock_parts/console_screen = 1)

/obj/item/circuitboard/bioprinter
	name = T_BOARD("bioprinter")
	build_path = /obj/machinery/organ_printer/flesh
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 1, TECH_BIO = 3, TECH_DATA = 3)
	req_components = list(
							/obj/item/healthanalyzer = 1,
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2)

/obj/item/circuitboard/roboprinter
	name = T_BOARD("prosthetic organ fabricator")
	build_path = /obj/machinery/organ_printer/robot
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 3)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 2,
							/obj/item/stock_parts/manipulator = 2)

/obj/item/circuitboard/cryo_cell
	name = T_BOARD("Cryo Cell")
	build_path = /obj/machinery/atmospherics/unary/cryo_cell
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ENGINEERING = 4)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/stock_parts/console_screen = 4)

/obj/item/circuitboard/sleeper
	name = T_BOARD("Sleeper")
	build_path = /obj/machinery/sleeper
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 3, TECH_MATERIALS = 3)
	req_components = list(
							/obj/item/stock_parts/matter_bin = 1,
							/obj/item/stock_parts/manipulator = 1,
							/obj/item/stack/cable_coil = 1,
							/obj/item/stock_parts/console_screen = 2)

/obj/item/circuitboard/body_scanner
	name = T_BOARD("Body Scanner")
	build_path = /obj/machinery/bodyscanner
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_ENGINEERING = 3, TECH_MATERIALS = 3)
	req_components = list(
							/obj/item/stock_parts/scanning_module = 3,
							/obj/item/stack/material/glass/reinforced = 2)
