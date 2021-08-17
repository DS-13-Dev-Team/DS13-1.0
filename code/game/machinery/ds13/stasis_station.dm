/obj/machinery/stasis_station
	name = "stasis recharge station"
	desc = "This station is used to recharge stasis module."
	icon = 'icons/obj/machines/ds13/stasis.dmi'
	icon_state = "stasis_station"
	anchored = 1
	use_power = 0

	var/busy = FALSE
	var/recharging = FALSE

/obj/machinery/stasis_station/Initialize()
	. = ..()
	update_icon()

/obj/machinery/stasis_station/update_icon()
	if(busy)
		icon_state = "stasis_station_discharging"
	else if(recharging)
		icon_state = "stasis_recharging"
	else
		icon_state = "stasis_station"

/obj/machinery/stasis_station/attack_hand(var/mob/living/carbon/human/user)
	if(busy)
		to_chat(user, SPAN_NOTICE("Someone is already using [src]"))
	else if(recharging)
		to_chat(user, SPAN_NOTICE("[src] is recharging!"))
		playsound(loc, 'sound/machines/buzz-two.ogg', VOLUME_MID, 0)
	else
		if(user.wearing_rig)
			if(user.wearing_rig.stasis)
				var/obj/item/weapon/gun/energy/E = user.wearing_rig.stasis.gun
				if(E.power_supply.percent() < 100)
					busy = TRUE
					update_icon()
					if(do_after(user, 27, src))
						E.power_supply.full_recharge()
						E.update_stas_charge()
						to_chat(user, SPAN_NOTICE("Stasis Module was recharged"))
						busy = FALSE
						recharging = TRUE
						update_icon()
						addtimer(CALLBACK(src, /obj/machinery/stasis_station/proc/stop_recharging), 162)
						return
					else
						busy = FALSE
						update_icon()
						return
				else
					to_chat(user, SPAN_NOTICE("Stasis Module is already fully charged"))
					playsound(loc, 'sound/machines/buzz-two.ogg', VOLUME_MID, 0)
					return
		to_chat(user, SPAN_NOTICE("You don't have stasis modules installed."))
		playsound(loc, 'sound/machines/buzz-two.ogg', VOLUME_MID, 0)

/obj/machinery/stasis_station/proc/stop_recharging()
	recharging = FALSE
	update_icon()

/obj/machinery/stasis_station/attackby(var/obj/item/I, var/mob/user)
	return attack_hand(user)
