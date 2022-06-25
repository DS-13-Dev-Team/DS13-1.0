
//Executive

/obj/machinery/computer/shuttle_control/escape1
	shuttle_tag = "Escape Shuttle 1"

/obj/machinery/computer/shuttle_control/escape2
	shuttle_tag = "Escape Shuttle 2"

/obj/machinery/computer/shuttle_control/escape3
	shuttle_tag = "Escape Shuttle 3"

/obj/machinery/computer/shuttle_control/repairable
	name = "Broken Shuttle Console"
	desc = "It looks like some parts of this shuttle console are missing."
	shuttle_tag = "Repaired Shuttle"
	// Amount of parts you need to gather to fix it
	var/remaining_parts = 5

/obj/machinery/computer/shuttle_control/repairable/ui_interact(mob/user, ui_key, datum/nanoui/ui, force_open)
	if(remaining_parts > 0)
		to_chat(user, SPAN_WARNING("The shuttle console is broken! You can't interact with it."))
	else
		.=..()

/obj/machinery/computer/shuttle_control/repairable/examine(mob/user)
	.=..()
	if(remaining_parts > 0)
		to_chat(user, SPAN_NOTICE("You need to gather [remaining_parts] more to fix it."))

/obj/machinery/computer/shuttle_control/repairable/get_ui_data(datum/shuttle/autodock/shuttle)
	. = ..()
	.["can_launch"] = (.["can_launch"] && (remaining_parts <= 0))

/obj/machinery/computer/shuttle_control/repairable/attackby(obj/item/shuttle_part/I, mob/user)
	if(istype(I, /obj/item/shuttle_part) && (remaining_parts > 0) && do_after(user, 3 SECONDS, src, TRUE))
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		to_chat(user, SPAN_NOTICE("You replace broken part of the console."))
		remaining_parts--
		qdel(I)
		if(remaining_parts <= 0)
			name = "Shuttle Piloting Console"
			desc = "Looks like someone recently fixed this console and it's ready to use."
	else
		.=..()
