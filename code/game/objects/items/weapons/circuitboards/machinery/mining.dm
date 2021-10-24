#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/miningdrill
	name = T_BOARD("mining drill head")
	build_path = /obj/machinery/mining/drill
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/cell = 1,
							/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/scanning_module = 1)

/obj/item/weapon/circuitboard/miningdrillbrace
	name = T_BOARD("mining drill brace")
	build_path = /obj/machinery/mining/brace
	board_type = "machine"
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	req_components = list()

/obj/item/weapon/circuitboard/ore_processing
	name = T_BOARD("material processor")
	build_path = /obj/machinery/mineral/processing_unit
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/matter_bin = 3,
							/obj/item/weapon/stock_parts/micro_laser = 2,
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/scanning_module = 1)

/obj/item/weapon/circuitboard/unloading_machine
	name = T_BOARD("unloading machine")
	build_path = /obj/machinery/mineral/unloading_machine
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator = 2,
							/obj/item/weapon/stock_parts/scanning_module = 2)
