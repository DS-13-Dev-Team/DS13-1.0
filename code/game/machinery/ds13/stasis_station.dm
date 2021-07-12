/obj/machinery/stasis_station
	name = "stasis recharge"
	desc = "This station is used to recharge stasis module."
	icon = 'icons/obj/machines/ds13/stasis.dmi'
	icon_state = "stasis_station"
	anchored = 1
	use_power = 0

/obj/machinery/stasis_station/attack_hand(var/mob/user)
	for(var/obj/item/weapon/rig/R in user.contents)
		for(var/obj/item/rig_module/mounted/stasis/S in R.installed_modules)
			for(var/obj/item/weapon/gun/energy/stasis/G in S.contents)
				for(var/obj/item/weapon/cell/C in G.contents)
					if(C.percent() != 100)
						C.insta_recharge()
						to_chat(user, "Stasis Module was recharged")
						return
					else
						to_chat(user, "Stasis Module is already fully charged")
						return

	to_chat(user, "You don't have stasis module installed.")
	return

/obj/machinery/stasis_station/attackby(var/obj/item/I, var/mob/user)
	for(var/obj/item/weapon/rig/R in user.contents)
		for(var/obj/item/rig_module/mounted/stasis/S in R.installed_modules)
			for(var/obj/item/weapon/gun/energy/stasis/G in S.contents)
				for(var/obj/item/weapon/cell/C in G.contents)
					if(C.percent() != 100)
						C.insta_recharge()
						to_chat(user, "Stasis Module was recharged")
						return
					else
						to_chat(user, "Stasis Module is already fully charged")
						return

	to_chat(user, "You don't have stasis module installed.")
	return
