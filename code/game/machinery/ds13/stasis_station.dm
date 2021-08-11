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
	. = ..()

/obj/machinery/stasis_station/attack_hand(var/mob/user)
	if(busy)
		to_chat(user, SPAN_NOTICE("Someone is already using [src]"))
	else if(recharging)
		to_chat(user, SPAN_NOTICE("[src] is recharging!"))
	else
		if(istype(user.back, /obj/item/weapon/rig))
			var/obj/item/weapon/rig/R = user.back
			if(R.stasis)
				var/obj/item/weapon/gun/energy/E = R.stasis.gun
				if(E.power_supply.percent() != 100)
					busy = TRUE
					update_icon()
					if(user.do_skilled(10, SKILL_DEVICES, src))
						E.power_supply.insta_recharge()
						to_chat(user, SPAN_NOTICE("Stasis Module was recharged"))
						busy = FALSE
						recharging = TRUE
						update_icon()
						spawn(150)
							recharging = FALSE
							update_icon()
					else
						busy = FALSE
						update_icon()
				else
					to_chat(user, SPAN_NOTICE("Stasis Module is already fully charged"))
			else
				to_chat(user, SPAN_NOTICE("You don't have stasis module installed."))

/obj/machinery/stasis_station/attackby(var/obj/item/I, var/mob/user)
	return attack_hand(user)
