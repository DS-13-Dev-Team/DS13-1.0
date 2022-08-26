/obj/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon_state = "protolathe"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	circuit = /obj/item/circuitboard/protolathe

	var/max_material_storage = 100000
	var/efficiency_coeff
	var/list/queue = list()

/obj/machinery/r_n_d/protolathe/Initialize()
	. = ..()
	materials[MATERIAL_STEEL]	= list("name" = "Steel", "amount" = 0, "sheet_type" = /obj/item/stack/material/steel)
	materials[MATERIAL_GLASS]	= list("name" = "Glass", "amount" = 0, "sheet_type" = /obj/item/stack/material/glass)
	materials[MATERIAL_PLASTIC]	= list("name" = "Plastic", "amount" = 0, "sheet_type" = /obj/item/stack/material/plastic)
	materials[MATERIAL_PLASTEEL]= list("name" = "Plasteel", "amount" = 0, "sheet_type" = /obj/item/stack/material/plasteel)
	materials[MATERIAL_SILVER]	= list("name" = "Silver", "amount" = 0, "sheet_type" = /obj/item/stack/material/silver)
	materials[MATERIAL_GOLD]	= list("name" = "Gold", "amount" = 0, "sheet_type" = /obj/item/stack/material/gold)
	materials[MATERIAL_URANIUM]	= list("name" = "Uranium", "amount" = 0, "sheet_type" = /obj/item/stack/material/uranium)
	materials[MATERIAL_DIAMOND]	= list("name" = "Diamond", "amount" = 0, "sheet_type" = /obj/item/stack/material/diamond)
	materials[MATERIAL_PHORON]	= list("name" = "Phoron", "amount" = 0, "sheet_type" = /obj/item/stack/material/phoron)

	for(var/A in materials)
		var/obj/item/stack/material/M = materials[A]["sheet_type"]
		materials[A] += list("sheet_size" = initial(M.perunit))

/obj/machinery/r_n_d/protolathe/Destroy()
	. = ..()
	if(linked_console)
		linked_console.linked_lathe = null
		if(linked_console.cats[4] == PROTOLATHE)
			linked_console.cats[4] = 1
			SStgui.update_uis(linked_console, TRUE)
		else
			SStgui.update_uis(linked_console)
		linked_console = null

/obj/machinery/r_n_d/protolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	T = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		T += M.rating
	max_material_storage = T * 100000
	T = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T += (M.rating/3)
	efficiency_coeff = max(T, 1)

/obj/machinery/r_n_d/protolathe/update_icon()
	if(panel_open)
		icon_state = "protolathe_t"
	else if(busy)
		icon_state = "protolathe_n"
	else
		icon_state = "protolathe"

/obj/machinery/r_n_d/protolathe/proc/check_mat(datum/design/being_built, M)
	var/A = 0
	if(materials[M])
		A = materials[M]["amount"]
		A /= max(1 , (being_built.materials[M]/efficiency_coeff))
		return A
	else
		A = reagents.get_reagent_amount(M)
		A /= max(1, (being_built.chemicals[M]/efficiency_coeff))
		return A

/obj/machinery/r_n_d/protolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return TRUE
	if(default_deconstruction_screwdriver(user, O))
		update_icon()
		if(linked_console)
			linked_console.linked_lathe = null
			if(linked_console.cats[4] == PROTOLATHE)
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
	if(O.is_open_container())
		spawn(0)
			SStgui.update_uis(linked_console, TRUE)
		return FALSE
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return TRUE
	if(!linked_console)
		to_chat(user, "<span class='notice'>\The [src] must be linked to an R&D console first!</span>")
		return TRUE
	if(is_robot_module(O))
		return FALSE
	if(stat)
		return TRUE
	if(!istype(O, /obj/item/stack/material))
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return FALSE
	var/obj/item/stack/material/stack = O
	if(istype(O, /obj/item/stack/material))
		if(!materials[stack.default_type])
			to_chat(user, "<span class='notice'>You cannot insert this material into the [src]!</span>")
			return

	if(TotalMaterials() + SHEET_MATERIAL_AMOUNT > max_material_storage)
		to_chat(user, "<span class='notice'>\The [src]'s material bin is full. Please remove material before adding more.</span>")
		return TRUE

	var/amount = min(stack.get_amount(), round((max_material_storage - TotalMaterials()) / SHEET_MATERIAL_AMOUNT))

	var/t = stack.material.name
	overlays += "protolathe_[t]"

	busy = TRUE
	update_icon()
	use_power(max(1000, (SHEET_MATERIAL_AMOUNT * amount / 10)))
	if(t)
		if(do_after(user, 18, src))
			for(var/M in materials)
				if(stack.stacktype == materials[M]["sheet_type"])
					if(stack.use(amount))
						materials[M]["amount"] += amount * stack.perunit
						break
	overlays -= "protolathe_[t]"
	busy = FALSE
	update_icon()
	if(linked_console)
		SStgui.update_uis(linked_console, TRUE)

/obj/machinery/r_n_d/protolathe/proc/queue_design(datum/design/D, amount)
	var/list/RNDD = list()
	RNDD["name"] = D.name
	if(amount > 1)
		RNDD["name"] = "[RNDD["name"]] x[amount]"

	RNDD["design"] = D.id
	RNDD["amount"] = amount
	// We need unique name in the list
	var/list_name = "[D.id]_x[RNDD["amount"]]_[world.time]"
	queue[list_name] = RNDD
	if(!busy)
		produce_design(list_name)

/obj/machinery/r_n_d/protolathe/proc/clear_queue()
	queue = list()

/obj/machinery/r_n_d/protolathe/proc/restart_queue()
	if(queue.len && !busy)
		produce_design(queue[1])

/obj/machinery/r_n_d/protolathe/proc/produce_design(P)
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
	if (!(D.build_type & PROTOLATHE))
		log_and_message_admins("Protolathe exploit attempted! Tried to print non-protolathe design!", usr, usr.loc)
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
	addtimer(CALLBACK(src, .proc/create_design, P, amount), (D.time / efficiency_coeff) * amount)

/obj/machinery/r_n_d/protolathe/proc/create_design(P, amount)
	var/RNDD = queue[P]
	var/datum/design/D = SSresearch.designs_by_id[RNDD["design"]]
	for(var/i = 1 to amount)
		new D.build_path(loc)
	busy = FALSE
	update_icon()
	queue -= P

	if(queue.len)
		produce_design(queue[1])

	if(linked_console)
		SStgui.update_uis(linked_console, TRUE)
