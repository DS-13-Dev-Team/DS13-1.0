/*///////////////Circuit Imprinter (By Darem)////////////////////////
	Used to print new circuit boards (for computers and similar systems) and AI modules. Each circuit board pattern are stored in
a /datum/desgin on the linked R&D console. You can then print them out in a fasion similar to a regular lathe. However, instead of
using metal and glass, it uses glass and reagents (usually sulfuric acid).
*/
/obj/machinery/r_n_d/circuit_imprinter
	name = "Circuit Imprinter"
	icon_state = "circuit_imprinter"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	var/max_material_storage = 75000
	var/efficiency_coeff
	var/list/queue = list()
	circuit = /obj/item/circuitboard/circuit_imprinter

/obj/machinery/r_n_d/circuit_imprinter/Initialize()
	. = ..()
	materials[MATERIAL_GLASS]	= list("name" = "Glass", "amount" = 0, "sheet_type" = /obj/item/stack/material/glass)
	materials[MATERIAL_GOLD]	= list("name" = "Gold", "amount" = 0, "sheet_type" = /obj/item/stack/material/gold)
	materials[MATERIAL_DIAMOND]	= list("name" = "Diamond", "amount" = 0, "sheet_type" = /obj/item/stack/material/diamond)

	for(var/A in materials)
		var/obj/item/stack/material/M = materials[A]["sheet_type"]
		materials[A]	+= list("sheet_size" = initial(M.perunit))


/obj/machinery/r_n_d/circuit_imprinter/Destroy()
	. = ..()
	if(linked_console)
		linked_console.linked_imprinter = null
		if(linked_console.cats[4] == IMPRINTER)
			linked_console.cats[4] = 1
			SStgui.update_uis(linked_console, TRUE)
		else
			SStgui.update_uis(linked_console)
		linked_console = null

/obj/machinery/r_n_d/circuit_imprinter/RefreshParts()
	var/T = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	T = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		T += M.rating
	max_material_storage = T * 75000
	T = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T += M.rating
	efficiency_coeff = 2 ** (T - 1)

/obj/machinery/r_n_d/circuit_imprinter/update_icon()
	if(panel_open)
		icon_state = "circuit_imprinter_t"
	else if(busy)
		icon_state = "circuit_imprinter_ani"
	else
		icon_state = "circuit_imprinter"

/obj/machinery/r_n_d/circuit_imprinter/proc/check_mat(datum/design/being_built, M)
	var/A = 0
	if(materials[M])
		A = materials[M]["amount"]
		A /= max(1 , (being_built.materials[M]/efficiency_coeff))
		return A
	else
		A = reagents.get_reagent_amount(M)
		A /= max(1, (being_built.chemicals[M]/efficiency_coeff))
		return A

/obj/machinery/r_n_d/circuit_imprinter/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		update_icon()
		if(linked_console)
			linked_console.linked_imprinter = null
			if(linked_console.cats[4] == IMPRINTER)
				linked_console.cats[4] = 1
				SStgui.update_uis(linked_console, TRUE)
			else
				SStgui.update_uis(linked_console)
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return TRUE
	if(!linked_console)
		to_chat(user, "\The [src] must be linked to an R&D console first.")
		return TRUE
	if(O.is_open_container())
		spawn(0)
			SStgui.update_uis(linked_console, TRUE)
		return FALSE
	if(is_robot_module(O))
		return FALSE
	if(!istype(O, /obj/item/stack/material))
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return FALSE
	if(stat)
		return
	var/obj/item/stack/material/stack = O
	if(istype(O, /obj/item/stack/material))
		if(!materials[stack.default_type])
			to_chat(user, "<span class='notice'>You cannot insert this material into the [src]!</span>")
			return
	if(busy)
		to_chat(user, "The [src] is busy. Please wait for completion of previous operation.")
		return
	if((TotalMaterials() + stack.perunit) > max_material_storage)
		to_chat(user, "The [src] is full. Please remove some materials from the protolathe in order to insert more.")
		return

	var/amount = min(stack.get_amount(), round((max_material_storage - TotalMaterials()) / SHEET_MATERIAL_AMOUNT))

	busy = 1
	update_icon()
	use_power(max(1000, (SHEET_MATERIAL_AMOUNT * amount / 10)))

	var/t = stack.material.name
	if(t)
		if(do_after(usr, 16, src))
			for(var/M in materials)
				if(stack.stacktype == materials[M]["sheet_type"])
					if(stack.use(amount))
						materials[M]["amount"] += amount * stack.perunit
						break
	busy = 0
	update_icon()
	if(linked_console)
		SStgui.update_uis(linked_console, TRUE)

/obj/machinery/r_n_d/circuit_imprinter/proc/queue_design(datum/design/D, amount)
	var/list/RNDD = list()
	RNDD["name"] = D.name
	if(amount > 1)
		RNDD["name"] = "[RNDD["name"]] x[amount]"

	RNDD["design"] = D.id
	RNDD["amount"] = amount
	// We need unique name in the list
	queue["[RNDD["name"]]_[D.id]_[world.time]"] = RNDD
	if(!busy)
		produce_design("[RNDD["name"]]_[D.id]_[world.time]")

/obj/machinery/r_n_d/circuit_imprinter/proc/clear_queue()
	queue = list()

/obj/machinery/r_n_d/circuit_imprinter/proc/restart_queue()
	if(queue.len && !busy)
		produce_design(queue[1])

/obj/machinery/r_n_d/circuit_imprinter/proc/produce_design(P)
	var/RNDD = queue[P]
	var/datum/design/D = SSresearch.designs_by_id[RNDD["design"]]
	var/amount = RNDD["amount"]
	var/power = 2000
	amount = max(1, min(10, amount))
	for(var/M in D.materials)
		power += round(D.materials[M] * amount / 5)
	power = max(2000, power)
	if (busy)
		to_chat(usr, SPAN_WARNING("The [name] is busy right now"))
		return
	if (!(D.build_type & IMPRINTER))
		log_and_message_admins("Circuit imprinter exploit attempted! Tried to print non-imprinter design!", usr, usr.loc)
		return

	busy = TRUE
	update_icon()
	use_power(power)

	for(var/M in D.materials)
		if(check_mat(D, M) < amount)
			to_chat(usr, SPAN_WARNING("Not enough materials to complete design."))
			busy = FALSE
			update_icon()
			return

	for(var/M in D.materials)
		materials[M]["amount"] = max(0, (materials[M]["amount"] - (D.materials[M]*amount / efficiency_coeff)))
	for(var/C in D.chemicals)
		reagents.remove_reagent(C, D.chemicals[C]/efficiency_coeff)

	addtimer(CALLBACK(src, .proc/create_design, P), D.time)

/obj/machinery/r_n_d/circuit_imprinter/proc/create_design(P)
	var/RNDD = queue[P]
	var/datum/design/D = SSresearch.designs_by_id[RNDD["design"]]
	var/amount = RNDD["amount"]
	for(var/i = 1 to amount)
		new D.build_path(loc)
	busy = FALSE
	update_icon()
	queue -= P

	if(queue.len)
		produce_design(queue[1])

	if(linked_console)
		SStgui.update_uis(linked_console, TRUE)