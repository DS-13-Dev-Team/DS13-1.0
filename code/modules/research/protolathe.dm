/datum/rnd_material
	var/name
	var/amount
	var/sheet_size
	var/sheet_type

/datum/rnd_material/New(Name, obj/item/stack/material/Sheet_type)
	name = Name
	amount = 0
	sheet_type = Sheet_type
	sheet_size = initial(Sheet_type.perunit)

/datum/rnd_queue_design
	var/name
	var/datum/design/design
	var/amount

/datum/rnd_queue_design/New(datum/design/D, Amount)
	name = D.name
	if(Amount > 1)
		name = "[name] x[Amount]"

	design = D
	amount = Amount

/obj/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon_state = "protolathe"

	var/max_material_storage = 100000
	var/efficiency_coeff
	var/list/queue = list()

/obj/machinery/r_n_d/protolathe/Initialize()
	materials = default_material_composition.Copy()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/protolathe(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	RefreshParts()

	materials[MATERIAL_STEEL]    = new /datum/rnd_material("Steel",    /obj/item/stack/material/steel)
	materials[MATERIAL_GLASS]    = new /datum/rnd_material("Glass",    /obj/item/stack/material/glass)
	materials[MATERIAL_SILVER]   = new /datum/rnd_material("Silver",   /obj/item/stack/material/silver)
	materials[MATERIAL_GOLD]     = new /datum/rnd_material("Gold",     /obj/item/stack/material/gold)
	materials[MATERIAL_DIAMOND]  = new /datum/rnd_material("Diamond",  /obj/item/stack/material/diamond)
	materials[MATERIAL_URANIUM]  = new /datum/rnd_material("Uranium",  /obj/item/stack/material/uranium)
	materials[MATERIAL_PHORON]   = new /datum/rnd_material("Phoron",   /obj/item/stack/material/phoron)

/obj/machinery/r_n_d/protolathe/TotalMaterials() //returns the total of all the stored materials. Makes code neater.
	var/am = 0
	for(var/M in materials)
		am += materials[M].amount
	return am

/obj/machinery/r_n_d/protolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		T += M.rating
	max_material_storage = T * 75000
	T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += (M.rating/3)
	efficiency_coeff = max(T, 1)

/obj/machinery/r_n_d/protolathe/proc/check_mat(datum/design/being_built, M)
	var/A = 0
	if(materials[M])
		A = materials[M].amount
	A = A / max(1 , (being_built.materials[M]/efficiency_coeff))
	return A


/obj/machinery/r_n_d/protolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return TRUE
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_lathe = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(O.is_open_container())
		return TRUE
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return TRUE
	if(!linked_console)
		to_chat(user, "<span class='notice'>\The [src] must be linked to an R&D console first!</span>")
		return TRUE
	if(is_robot_module(O))
		return FALSE
	if(!istype(O, /obj/item/stack/material))
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return FALSE
	if(stat)
		return TRUE

	if(TotalMaterials() + SHEET_MATERIAL_AMOUNT > max_material_storage)
		to_chat(user, "<span class='notice'>\The [src]'s material bin is full. Please remove material before adding more.</span>")
		return TRUE

	var/obj/item/stack/material/stack = O
	var/amount = round(input("How many sheets do you want to add?") as num)//No decimals
	if(!O)
		return
	if(amount < 0)//No negative numbers
		amount = 0
	if(amount == 0)
		return
	if(amount > stack.get_amount())
		amount = stack.get_amount()
	if(max_material_storage - TotalMaterials() < (amount*stack.perunit))//Can't overfill
		amount = min(stack.get_amount(), round((max_material_storage-TotalMaterials())/stack.perunit))

	busy = TRUE

	to_chat(user, "<span class='notice'>You add [amount] sheets to the [name].</span>")

	overlays += "protolathe_[stack.name]"
	sleep(10)
	overlays -= "protolathe_[stack.name]"

	use_power(max(1000, (3750 * amount / 10)))

	if(stack.get_amount() >= amount)
		for(var/M in materials)
			if(stack.stacktype == materials[M].sheet_type)
				if(stack.use(amount))
					materials[M].amount += amount * stack.perunit
					break

	busy = FALSE
	if(linked_console)
		linked_console.update_open_uis()

/obj/machinery/r_n_d/protolathe/proc/queue_design(datum/design/D, amount)
	var/datum/rnd_queue_design/RNDD = new /datum/rnd_queue_design(D, amount)

	if(queue.len) // Something is already being created, put us into queue
		queue += RNDD
	else if(!busy)
		queue += RNDD
		produce_design(RNDD)

/obj/machinery/r_n_d/protolathe/proc/clear_queue()
	queue = list()

/obj/machinery/r_n_d/protolathe/proc/restart_queue()
	if(queue.len && !busy)
		produce_design(queue[1])

/obj/machinery/r_n_d/protolathe/proc/produce_design(datum/rnd_queue_design/RNDD)
	var/datum/design/D = RNDD.design
	var/amount = RNDD.amount
	var/power = 2000
	amount = max(1, min(10, amount))
	for(var/M in D.materials)
		power += round(D.materials[M] * amount / 5)
	power = max(2000, power)
	if(busy)
		to_chat(usr, "<span class='warning'>The [name] is busy right now</span>")
		return
	if (!(D.build_type & PROTOLATHE))
		message_admins("Protolathe exploit attempted by [key_name(usr, usr.client)]!")
		return

	busy = TRUE
	flick("protolathe_n",src)
	use_power(power)

	for(var/M in D.materials)
		if(check_mat(D, M) < amount)
			visible_message("<span class='warning'>The [name] beeps, \"Not enough materials to complete prototype.\"</span>")
			busy = FALSE
			return
	for(var/M in D.materials)
		materials[M].amount = max(0, (materials[M].amount - (D.materials[M] / efficiency_coeff * amount)))

	addtimer(CALLBACK(src, .proc/create_design, RNDD), 32 * amount / efficiency_coeff)

/obj/machinery/r_n_d/protolathe/proc/create_design(datum/rnd_queue_design/RNDD)
	var/datum/design/D = RNDD.design
	var/amount = RNDD.amount
	for(var/i = 1 to amount)
		new D.build_path(loc)
	busy = FALSE
	queue -= RNDD

	if(queue.len)
		produce_design(queue[1])

	if(linked_console)
		linked_console.update_open_uis()

/obj/machinery/r_n_d/protolathe/proc/eject_sheet(sheet_type, amount)
	if(materials[sheet_type])
		var/available_num_sheets = Floor(materials[sheet_type].amount / materials[sheet_type].sheet_size)
		if(available_num_sheets > 0)
			var/S = materials[sheet_type].sheet_type
			var/obj/item/stack/material/M = new S(loc)
			var/sheet_ammount = min(available_num_sheets, amount)
			M.set_amount(sheet_ammount)
			materials[sheet_type].amount = max(0, materials[sheet_type].amount - sheet_ammount * materials[sheet_type].sheet_size)
