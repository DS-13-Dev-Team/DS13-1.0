/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulfuric acid).
*/
/obj/machinery/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	icon_state = "circuit_imprinter"
	obj_flags = ATOM_FLAG_OPEN_CONTAINER

	var/max_material_storage = 75000
	var/efficiency_coeff
	var/list/queue = list()

/obj/machinery/r_n_d/circuit_imprinter/Initialize()
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/circuit_imprinter(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	RefreshParts()

	materials[MATERIAL_GLASS]    = new /datum/rnd_material("Glass",    /obj/item/stack/material/glass)
	materials[MATERIAL_GOLD]     = new /datum/rnd_material("Gold",     /obj/item/stack/material/gold)
	materials[MATERIAL_DIAMOND]  = new /datum/rnd_material("Diamond",  /obj/item/stack/material/diamond)

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		T += M.rating
	max_material_storage = T * 75000
	T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	efficiency_coeff = 2 ** (T - 1)

/obj/machinery/r_n_d/circuit_imprinter/proc/check_mat(datum/design/being_built, M)
	if(materials[M])
		return (materials[M].amount - (being_built.materials[M]/efficiency_coeff) >= 0) ? 1 : 0
	else
		return (reagents.has_reagent(M, (being_built.materials[M]/efficiency_coeff)) != 0) ? 1 : 0

/obj/machinery/r_n_d/circuit_imprinter/TotalMaterials()
	var/am = 0
	for(var/M in materials)
		am += materials[M].amount
	return am

/obj/machinery/r_n_d/circuit_imprinter/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_imprinter = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return 1
	if(!linked_console)
		to_chat(user, "\The [src] must be linked to an R&D console first.")
		return 1
	if(O.is_open_container())
		return 0
	if(is_robot_module(O))
		return 0
	if(!istype(O, /obj/item/stack/material))
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return 0
	if(istype(O, /obj/item/stack/material))
		if(!istype(O, /obj/item/stack/material/glass) && !istype(O, /obj/item/stack/material/gold) && !istype(O, /obj/item/stack/material/diamond))
			to_chat(user, "<span class='notice'>You cannot insert this material into the [src]!</span>")
			return
	if(stat)
		return
	if(busy)
		to_chat(user, "The [src] is busy. Please wait for completion of previous operation.")
		return
	var/obj/item/stack/material/stack  = O
	if((TotalMaterials() + stack.perunit) > max_material_storage)
		to_chat(user, "The [src] is full. Please remove some materials from the protolathe in order to insert more.")
		return

	var/amount = round(input("How many sheets do you want to add?") as num)
	if(amount <= 0)
		return

	if(amount > stack.get_amount())
		amount = min(stack.get_amount(), round((max_material_storage-TotalMaterials())/stack.perunit))

	busy = 1
	use_power(max(1000, (3750*amount/10)))
	if(stack.get_amount() >= amount)
		if(do_after(usr, 16, src))
			to_chat(user, "You add [amount] sheets to the [src].")
			for(var/M in materials)
				if(stack.stacktype == materials[M].sheet_type)
					if(stack.use(amount))
						materials[M].amount += amount * stack.perunit
						break
	busy = 0
	if(linked_console)
		linked_console.update_open_uis()

/obj/machinery/r_n_d/circuit_imprinter/proc/queue_design(datum/design/D)
	var/datum/rnd_queue_design/RNDD = new /datum/rnd_queue_design(D, 1)

	if(queue.len) // Something is already being created, put us into queue
		queue += RNDD
	else if(!busy)
		queue += RNDD
		produce_design(RNDD)

/obj/machinery/r_n_d/circuit_imprinter/proc/clear_queue()
	queue = list()

/obj/machinery/r_n_d/circuit_imprinter/proc/restart_queue()
	if(queue.len && !busy)
		produce_design(queue[1])

/obj/machinery/r_n_d/circuit_imprinter/proc/produce_design(datum/rnd_queue_design/RNDD)
	var/datum/design/D = RNDD.design
	var/power = 2000
	for(var/M in D.materials)
		power += round(D.materials[M] / 5)
	power = max(2000, power)
	if (busy)
		to_chat(usr, "<span class='warning'>The [name] is busy right now</span>")
		return
	if (!(D.build_type & IMPRINTER))
		message_admins("Circuit imprinter exploit attempted by [key_name(usr, usr.client)]!")
		return

	busy = TRUE
	flick("circuit_imprinter_ani", src)
	use_power(power)

	for(var/M in D.materials)
		if(!check_mat(D, M))
			visible_message("<span class='warning'>The [name] beeps, \"Not enough materials to complete prototype.\"</span>")
			busy = FALSE
			return
	for(var/M in D.materials)
		if(materials[M])
			materials[M].amount = max(0, (materials[M].amount - (D.materials[M] / efficiency_coeff)))
		else
			reagents.remove_reagent(M, D.materials[M]/efficiency_coeff)

	addtimer(CALLBACK(src, .proc/create_design, RNDD), 16)

/obj/machinery/r_n_d/circuit_imprinter/proc/create_design(datum/rnd_queue_design/RNDD)
	var/datum/design/D = RNDD.design
	new D.build_path(loc)
	busy = FALSE
	queue -= RNDD

	if(queue.len)
		produce_design(queue[1])

	if(linked_console)
		linked_console.update_open_uis()

/obj/machinery/r_n_d/circuit_imprinter/proc/eject_sheet(sheet_type, amount)
	if(materials[sheet_type])
		var/available_num_sheets = Floor(materials[sheet_type].amount / materials[sheet_type].sheet_size)
		if(available_num_sheets > 0)
			var/S = materials[sheet_type].sheet_type
			var/obj/item/stack/material/sheet = new S(loc)
			var/sheet_ammount = min(available_num_sheets, amount)
			sheet.set_amount(sheet_ammount)
			materials[sheet_type].amount = max(0, materials[sheet_type].amount - sheet_ammount * materials[sheet_type].sheet_size)
