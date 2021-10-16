/**********************Input and output plates**************************/

/obj/machinery/input
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x2"
	name = "Input area"
	density = 0
	anchored = 1.0
	var/obj/machinery/master
	New()
		icon_state = "blank"

/obj/machinery/input/Crossed(O)
	. = ..()
	if (master)
		master.input_available(O)

/obj/machinery/input/Destroy()
	master = null
	.=..()

//Called when something enters our relevant input tile
/obj/machinery/proc/input_available(var/atom/movable/O)

/obj/machinery/mineral/output
	icon = 'icons/hud/screen1.dmi'
	icon_state = "x"
	name = "Output area"
	density = 0
	anchored = 1.0
	New()
		icon_state = "blank"