//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

//All devices that link into the R&D console fall into thise type for easy identification and some shared procs.

/obj/machinery/r_n_d
	name = "R&D Device"
	icon = 'icons/obj/machines/research.dmi'
	density = 1
	anchored = 1
	use_power = 1
	var/busy = 0
	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/datum/wires/rnd/wires = null
	var/obj/machinery/computer/rdconsole/linked_console
	var/working = 0
	var/list/datum/rnd_material/materials = list()

/obj/machinery/r_n_d/proc/eject_sheet()
	return

/obj/machinery/r_n_d/attack_hand(mob/user as mob)
	return

/obj/machinery/r_n_d/dismantle()
	for(var/obj/I in component_parts)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)
	for(var/f in materials)
		eject_sheet(f, INFINITY)
	..()

/obj/machinery/r_n_d/protolathe/dismantle()
	for(var/f in materials)
		eject_sheet(f, INFINITY)
	..()

/obj/machinery/r_n_d/proc/eject(var/material, var/amount)
	if(!(material in materials))
		return
	var/material/mat = get_material_by_name(material)
	var/obj/item/stack/material/sheetType = mat.stack_type
	var/perUnit = initial(sheetType.perunit)
	var/eject = round(materials[material] / perUnit)
	eject = amount == -1 ? eject : min(eject, amount)
	if(eject < 1)
		return
	new sheetType(loc, eject)
	materials[material] -= eject * perUnit

/obj/machinery/r_n_d/proc/TotalMaterials()
	for(var/f in materials)
		. += materials[f]
