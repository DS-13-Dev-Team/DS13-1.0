/**********************Unloading unit**************************/
/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "unloader"
	density = 1
	anchored = 1.0
	circuit = /obj/item/circuitboard/unloading_machine
	var/obj/machinery/input/input = null
	var/obj/machinery/mineral/output = null
	var/max_unloads_per_tick = 0

/obj/machinery/mineral/unloading_machine/Initialize()
	.=..()
	for(var/obj/machinery/input/I in orange(1, src))
		if(!I.master)
			input = I
			input.master = src
			break

	for(var/obj/machinery/mineral/output/O in orange(1, src))
		output = O
		break

/obj/machinery/mineral/unloading_machine/attackby(obj/item/O, mob/user)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	.=..()

/obj/machinery/mineral/unloading_machine/RefreshParts()
	max_unloads_per_tick = 0
	for(var/obj/item/stock_parts/scanning_module/SM in component_parts)
		max_unloads_per_tick += SM.rating * 0.5

	var/eff = 0
	for(var/obj/item/stock_parts/manipulator/MP in component_parts)
		eff += MP.rating * 0.5
	// Up to 9 per tick
	max_unloads_per_tick *= eff

	// In case someone decides to upgrade only one component
	max_unloads_per_tick = round(max_unloads_per_tick)

/obj/machinery/mineral/unloading_machine/Process()
	if(!panel_open)
		if (src.output && src.input)
			if (locate(/obj/structure/ore_box, input.loc))
				var/obj/structure/ore_box/BOX = locate(/obj/structure/ore_box, input.loc)
				var/i = max_unloads_per_tick
				for(var/obj/item/stack/ore/O in BOX.contents)
					var/obj/item/stack/ore/splitted = O.split(i)
					splitted.forceMove(output.loc)
					i -= splitted.amount
					if(i <= 0)
						break
			if (locate(/obj/item, input.loc))
				var/obj/item/O
				for(var/i=0 to 9)
					O = locate(/obj/item, input.loc)
					if(!O)
						break
					O.forceMove(output.loc)
	return