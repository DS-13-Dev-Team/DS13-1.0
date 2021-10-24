/obj/machinery/computer/crew
	name = "RIG sensors monitoring computer"
	desc = "Used to monitor active health sensors built into most of the crew's RIGs."
	icon_keyboard = "med_key"
	icon_screen = "crew"
	light_color = "#315ab4"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/weapon/circuitboard/crew
	var/datum/tgui_module/crew_monitor/crew_monitor

/obj/machinery/computer/crew/New(var/atom/location, var/direction, var/nocircuit = FALSE)
	crew_monitor = new(src)
	.=..()

/obj/machinery/computer/crew/Destroy()
	QDEL_NULL(crew_monitor)
	.=..()

/obj/machinery/computer/crew/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/crew/attack_hand(mob/user)
	..()
	if(stat & (BROKEN|NOPOWER))
		return
	tgui_interact(user)

/obj/machinery/computer/crew/tgui_interact(mob/user, datum/tgui/ui = null)
	crew_monitor.tgui_interact(user, ui)
