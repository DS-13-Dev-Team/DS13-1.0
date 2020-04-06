/datum/signal_ability/flicker
	name = "Flicker"
	id = "flicker"
	desc = "Causes a targeted light to flicker"
	energy_cost = 20

	target_types = list(/obj/machinery/light)

	targeting_method	=	TARGET_CLICK

/datum/signal_ability/flicker/on_cast(var/atom/target, var/mob/user, var/list/data)
	var/obj/machinery/light/L = target
	L.flicker()
	world << "Flickering [jumplink(L)]"