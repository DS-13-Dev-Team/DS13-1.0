/**********************Mineral processing unit console**************************/

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "console"
	density = 1
	anchored = 1

	var/obj/machinery/mineral/processing_unit/machine = null
	var/machinedir = EAST
	var/show_all_ores = 0




/obj/machinery/mineral/processing_unit_console/New(var/atom/location, var/direction, var/nocircuit = FALSE)
	..()
	spawn(7)
		src.machine = locate(/obj/machinery/mineral/processing_unit, get_step(src, machinedir))
		if (machine)
			machine.console = src
		else
			qdel(src)

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/mineral/processing_unit_console/interact(mob/user)

	if(..())
		return

	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	user.set_machine(src)

	var/dat = "<h1>Ore processor console</h1>"

	dat += "<hr><table>"

	for(var/ore in machine.ores_processing)

		if(!machine.ores_stored[ore] && !show_all_ores) continue
		var/ore/O = ore_data[ore]
		if(!O) continue
		dat += "<tr><td width = 40><b>[capitalize(O.display_name)]</b></td><td width = 30>[machine.ores_stored[ore]]</td><td width = 100>"
		if(machine.ores_processing[ore])
			switch(machine.ores_processing[ore])
				if(0)
					dat += "<font color='red'>not processing</font>"
				if(1)
					dat += "<font color='orange'>smelting</font>"
				if(2)
					dat += "<font color='blue'>compressing</font>"
				if(3)
					dat += "<font color='gray'>alloying</font>"
		else
			dat += "<font color='red'>not processing</font>"
		dat += ".</td><td width = 30><a href='?src=\ref[src];toggle_smelting=[ore]'>\[change\]</a></td></tr>"

	dat += "</table><hr>"
	dat += "Currently displaying [show_all_ores ? "all ore types" : "only available ore types"]. <A href='?src=\ref[src];toggle_ores=1'>\[[show_all_ores ? "show less" : "show more"]\]</a></br>"
	dat += "The ore processor is currently <A href='?src=\ref[src];toggle_power=1'>[(machine.active ? "<font color='green'>processing</font>" : "<font color='red'>disabled</font>")]</a>."
	user << browse(dat, "window=processor_console;size=400x500")
	onclose(user, "processor_console")
	return

/obj/machinery/mineral/processing_unit_console/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	src.add_fingerprint(usr)

	if(href_list["toggle_smelting"])

		var/choice = input("What setting do you wish to use for processing [href_list["toggle_smelting"]]?") as null|anything in list("Smelting","Compressing","Alloying","Nothing")
		if(!choice) return

		switch(choice)
			if("Nothing") choice = 0
			if("Smelting") choice = 1
			if("Compressing") choice = 2
			if("Alloying") choice = 3

		machine.ores_processing[href_list["toggle_smelting"]] = choice

	if(href_list["toggle_power"])

		machine.active = !machine.active
		machine.update_icon()

	if(href_list["toggle_ores"])

		show_all_ores = !show_all_ores

	if (machine)
		machine.wake_up()

	src.updateUsrDialog()
	return

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron...
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	density = 1
	anchored = 1
	light_outer_range = 3
	var/obj/machinery/input/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/mineral/processing_unit_console/console = null
	var/sheets_per_tick = 1
	var/list/ores_processing[0]
	var/list/ores_stored[0]
	var/static/list/alloy_data
	var/active = 0
	var/currently_working = FALSE	//Set true if we made anything last tick



/obj/machinery/mineral/processing_unit/Initialize()
	update_icon()
	.=..()


/obj/machinery/mineral/processing_unit/update_icon()
	if (active)
		icon_state = "furnace"
	else
		icon_state = "furnace_off"

/obj/machinery/mineral/processing_unit/proc/wake_up()
	START_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)

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
		console = null
	. = ..()


/obj/machinery/mineral/processing_unit/New(var/atom/location, var/direction, var/nocircuit = FALSE)
	..()

	// initialize static alloy_data list
	if(!alloy_data)
		alloy_data = list()
		for(var/alloytype in typesof(/datum/alloy)-/datum/alloy)
			alloy_data += new alloytype()

	ensure_ore_data_initialised()
	for(var/ore in ore_data)
		ores_processing[ore] = 0
		ores_stored[ore] = 0

	//Locate our output and input machinery.
	spawn(5)
		for (var/dir in GLOB.cardinal)
			src.input = locate(/obj/machinery/input, get_step(src, dir))
			if(src.input)
				input.master = src
				break
		for (var/dir in GLOB.cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		return
	return


/obj/machinery/mineral/processing_unit/input_available(var/obj/item/weapon/ore/O)
	if (istype(O))
		wake_up()

/obj/machinery/mineral/processing_unit/Process()


	//This will be set back to true if we intake or process any ores this tick
	currently_working = FALSE

	if (!src.output || !src.input)
		if (can_stop_processing())
			return PROCESS_KILL
		return

	var/list/tick_alloys = list()

	//Grab some more ore to process this tick.
	for(var/i = 0,i<3,i++)
		var/obj/item/weapon/ore/O = locate() in input.loc

		if(!O)
			break
		var/OS = ores_stored[O.ore.name]
		if(O.ore)
			if (isnull(OS))
				OS = 0
			OS++
			currently_working = TRUE
			ores_stored[O.ore.name] = OS
			qdel(O)
		else
			world.log << "[src] encountered ore [O] with oretag [O.ore ? O.ore : "(no ore)"] which this machine did not have an entry for!"



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
		if(OS > 0 && ores_processing[metal] != 0)

			var/ore/O = ore_data[metal]

			if(!O) continue


			//Alloying.
			//--------------
			if(ores_processing[metal] == 3 && O.alloy)

				for(var/datum/alloy/A in alloy_data)

					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires[metal]) && OS >= A.requires[metal]) //We have enough of our first metal, we're off to a good start.

						enough_metal = 1

						for(var/needs_metal in A.requires)
							//Check if we're alloying the needed metal and have it stored.
							if(ores_processing[needs_metal] != 3 || ores_stored[needs_metal] < A.requires[needs_metal])
								enough_metal = 0
								break
					if(!enough_metal)
						continue
					else

						var/total
						for(var/needs_metal in A.requires)
							OS -= A.requires[needs_metal]
							LAZYAPLUS(ores_processed, needs_metal, A.requires[needs_metal])
							total += A.requires[needs_metal]
							total = max(1,round(total*A.product_mod)) //Always get at least one sheet.
							sheets += total-1

						for(var/i=0,i<total,i++)
							currently_working = TRUE	//We have enough ore to make something
							new A.product(output.loc)

			else if(ores_processing[metal] == 2 && O.compresses_to) //Compressing.

				var/can_make = Clamp(OS,0,(sheets_per_tick-sheets)*2)
				if(can_make%2>0) can_make--

				var/material/M = get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || OS < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					OS -=2
					LAZYAPLUS(ores_processed, metal, 2)
					sheets+=2
					currently_working = TRUE	//We have enough ore to make something
					new M.stack_type(output.loc)

			else if(ores_processing[metal] == 1 && O.smelts_to) //Smelting.

				var/can_make = Clamp(OS,0,sheets_per_tick-sheets)

				var/material/M = get_material_by_name(O.smelts_to)
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
				new /obj/item/weapon/ore/slag(output.loc)
			ores_stored[metal] = OS
		else
			continue

	if (length(ores_processed))
		SStrade.ores_processed(ores_processed)

	console.updateUsrDialog()

	if (can_stop_processing())
		//STOP_PROCESSING_MACHINE(src, MACHINERY_PROCESS_SELF)
		return PROCESS_KILL

/obj/machinery/mineral/processing_unit/can_stop_processing()
	if (currently_working)
		return FALSE

	return TRUE
/*
	var/total = 0
	for (var/thing in ores_stored)
		total += ores_stored[thing]

	if (total <= 0)
		return TRUE
*/