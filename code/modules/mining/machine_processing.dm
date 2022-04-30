#define ORE_PROCESSING_NOTHING 0
#define ORE_PROCESSING_SMELTING 1
#define ORE_PROCESSING_COMPRESSING 2
#define ORE_PROCESSING_ALLOYING 3

/**********************Mineral processing unit console**************************/
/obj/machinery/mineral/processing_unit_console
	name = "processing unit console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 1
	anchored = 1
	can_block_movement = FALSE
	var/obj/machinery/mineral/processing_unit/machine = null

/obj/machinery/mineral/processing_unit_console/Initialize()
	.=..()
	. = INITIALIZE_HINT_LATELOAD

/obj/machinery/mineral/processing_unit_console/LateInitialize()
	if(!machine)
		qdel(src)

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	if(machine)
		tgui_interact(user)
	else
		to_chat(user, SPAN_NOTICE("Couldn't find linked Ore Processor!"))

/obj/machinery/mineral/processing_unit_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "OreProcessor", name)
		ui.open()

/obj/machinery/mineral/processing_unit_console/ui_status(mob/user, datum/ui_state/state)
	if(!machine)
		return UI_CLOSE
	else
		. = ..()

/obj/machinery/mineral/processing_unit_console/ui_data(mob/user)
	var/list/data = list()

	for(var/ore in machine.ores_stored)
		var/ore/O = GLOB.ores_by_type[ore]
		var/ore_data = list("name" = capitalize(O.name), "type" = ore, "amount" = machine.ores_stored[ore], "processing" = machine.ores_processing[ore])

		data["ores"] += list(ore_data)

	data["active"] = machine.active

	data["panel_status"] = machine.panel_open

	return data

/obj/machinery/mineral/processing_unit_console/ui_act(action, list/params)
	if(..())
		return TRUE

	switch(action)
		if("activate")
			if(!machine.panel_open)
				machine.active = !machine.active
				machine.wake_up()
				machine.update_icon()

		if("toggle_smelting")
			var/choice = params["tog_smelt"]
			var/ore_type = text2path(params["ore_type"])
			machine.ores_processing[ore_type] = choice

	SStgui.update_uis(src)
	machine.wake_up()

/**********************Mineral processing unit**************************/
/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron...
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	density = 1
	anchored = 1
	light_outer_range = 3
	circuit = /obj/item/weapon/circuitboard/ore_processing
	var/obj/machinery/input/input
	var/obj/machinery/mineral/output
	var/obj/machinery/mineral/processing_unit_console/console
	var/sheets_per_tick
	var/ores_per_tick
	var/list/ores_processing = list()
	var/list/ores_stored = list()
	var/static/list/alloy_data
	var/active = FALSE
	var/currently_working = FALSE	//Set true if we made anything last tick

/obj/machinery/mineral/processing_unit/Initialize()
	.=..()
	// initialize static alloy_data list
	if(!alloy_data)
		alloy_data = list()
		for(var/alloytype in subtypesof(/datum/alloy))
			alloy_data += new alloytype()

	ensure_ore_data_initialised()
	for(var/ore in GLOB.ores_by_type)
		ores_processing[ore] = ORE_PROCESSING_NOTHING
		ores_stored[ore] = 0

	for(var/obj/machinery/mineral/processing_unit_console/PC in orange(2, src))
		console = PC
		console.machine = src
		break

	for(var/obj/machinery/input/I in orange(1, src))
		input = I
		input.master = src
		break

	for(var/obj/machinery/mineral/output/O in orange(1, src))
		output = O
		break

	update_icon()

/obj/machinery/mineral/processing_unit/Destroy()
	if (input)
		if (input.master == src)
			input.master = null
		input = null

	if (output)
		output = null

	if (console)
		if (console.machine == src)
			console.machine = null
			SStgui.close_uis(console)
		console = null

	. = ..()

/obj/machinery/mineral/processing_unit/dismantle()
	for(var/ore in ores_stored)
		if(ores_stored[ore])
			for(var/i = 1 to ores_stored[ore])
				new ore(get_turf(src))
	. = ..()

/obj/machinery/mineral/processing_unit/RefreshParts()
	sheets_per_tick = 0
	ores_per_tick = 0
	for(var/obj/item/weapon/stock_parts/manipulator/MP in component_parts)
		sheets_per_tick += MP.rating * 0.5

	var/eff = 0
	for(var/obj/item/weapon/stock_parts/micro_laser/ML in component_parts)
		eff += ML.rating * 0.5
	// Up to 9 per tick
	sheets_per_tick *= eff

	for(var/obj/item/weapon/stock_parts/scanning_module/SM in component_parts)
		ores_per_tick += round(SM.rating * 1.5)
	// Up to 6 ores per tick

	// In case someone decides to upgrade only one component
	sheets_per_tick = round(sheets_per_tick)

/obj/machinery/mineral/processing_unit/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		active = FALSE
		update_icon()
		SStgui.update_uis(console)
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	.=..()

/obj/machinery/mineral/processing_unit/update_icon()
	if (active)
		icon_state = "furnace"
	else
		icon_state = "furnace_off"

/obj/machinery/mineral/processing_unit/proc/wake_up()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

/obj/machinery/mineral/processing_unit/input_available()
	wake_up()

/obj/machinery/mineral/processing_unit/Process()
	//This will be set back to true if we intake or process any ores this tick
	currently_working = FALSE

	if (!src.output || !src.input)
		if (can_stop_processing())
			return PROCESS_KILL
		return

	var/list/tick_alloys = list()

	if(panel_open)
		if (can_stop_processing())
			return PROCESS_KILL
		return

	//Grab some more ore to process this tick.
	for(var/i = 1 to ores_per_tick)
		var/obj/item/stack/ore/O = locate() in input.loc

		if(!O)
			break

		if(O.ore)
			currently_working = TRUE
			ores_stored[O.ore.type] += O.amount
			qdel(O)
			SStgui.update_uis(console)
		else
			crash_with("[src] encountered ore [O] [O.type] with oretag [O.ore ? O.ore : "(no ore)"] which this machine did not have an entry for!")

	if(!active)
		if (can_stop_processing())
			return PROCESS_KILL
		return

	//Process our stored ores and spit out sheets.
	var/sheets = 0

	//This list holds all the ores we've consumed this tick. These will be sent to the trade subsystem to do mining bonuses
	var/list/ores_processed = list()

	for(var/metal in ores_stored)

		if(sheets >= sheets_per_tick) break

		var/OS = ores_stored[metal]
		if(OS > 0 && ores_processing[metal] != ORE_PROCESSING_NOTHING)

			var/ore/O = metal

			if(!O) continue


			//Alloying.
			if(ores_processing[metal] == ORE_PROCESSING_ALLOYING && initial(O.alloy))

				for(var/datum/alloy/A in alloy_data)

					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires[metal]) && OS >= A.requires[metal]) //We have enough of our first metal, we're off to a good start.

						enough_metal = 1

						for(var/needs_metal in A.requires)
							//Check if we're alloying the needed metal and have it stored.
							if(ores_processing[needs_metal] != ORE_PROCESSING_ALLOYING || ores_stored[needs_metal] < A.requires[needs_metal])
								enough_metal = 0
								break
					if(!enough_metal)
						continue
					else

						var/total
						for(var/needs_metal in A.requires)
							if(needs_metal == metal)
								OS -= A.requires[needs_metal]
							else
								ores_stored[needs_metal] -= A.requires[needs_metal]
							LAZYAPLUS(ores_processed, needs_metal, A.requires[needs_metal])
							total += A.requires[needs_metal]
							total = max(1,round(total*A.product_mod)) //Always get at least one sheet.
							sheets += total-1

						for(var/i=0,i<total,i++)
							currently_working = TRUE	//We have enough ore to make something
							new A.product(output.loc)

			//Compressing
			else if(ores_processing[metal] == ORE_PROCESSING_COMPRESSING && initial(O.compresses_to))

				var/can_make = Clamp(OS,0,(sheets_per_tick-sheets)*2)
				if(can_make%2>0) can_make--

				var/material/M = get_material_by_name(initial(O.compresses_to))

				if(!istype(M) || !can_make || OS < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					OS -=2
					LAZYAPLUS(ores_processed, metal, 2)
					sheets+=2
					currently_working = TRUE	//We have enough ore to make something
					new M.stack_type(output.loc)

			//Smelting
			else if(ores_processing[metal] == ORE_PROCESSING_SMELTING && initial(O.smelts_to))

				var/can_make = Clamp(OS,0,sheets_per_tick-sheets)

				var/material/M = get_material_by_name(initial(O.smelts_to))
				if(!istype(M) || !can_make || OS < 1)
					continue

				for(var/i=0,i<can_make,i++)
					OS--
					LAZYAPLUS(ores_processed, metal, 1)
					sheets++
					currently_working = TRUE	//We have enough ore to make something
					new M.stack_type(output.loc)
			else
				OS--
				sheets++
				currently_working = TRUE	//We have enough ore to make something
				new /obj/item/stack/ore/slag(output.loc)
			ores_stored[metal] = OS
		else
			continue

	if (length(ores_processed))
		SStrade.ores_processed(ores_processed)

	console.updateUsrDialog()

	if (can_stop_processing())
		return PROCESS_KILL

/obj/machinery/mineral/processing_unit/can_stop_processing()
	if (currently_working)
		return FALSE

	return TRUE

#undef ORE_PROCESSING_NOTHING
#undef ORE_PROCESSING_SMELTING
#undef ORE_PROCESSING_COMPRESSING
#undef ORE_PROCESSING_ALLOYING
