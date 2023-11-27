/obj/machinery/vending/mining
	name = "Mine-o-vend"
	desc = "For all of your mining needs. Excahnges merits for useful things."
	product_slogans = "Can't stop the industrial revolution!"
	product_ads = "Almost free!"
	icon_state = "discomat"
	custom_not_enough_message = "Please insert merits to pay for the item."
	products = list(
		/obj/item/stack/power_node = 10,
		/obj/item/rig/mining = 10,
		/obj/item/cell/high = 20,
		/obj/item/cell/super = 20,
		/obj/item/cell/hyper = 20,
		/obj/item/healthanalyzer = 15,
		/obj/item/adv_health_analyzer = 5,
		/obj/item/stack/nanopaste = 15,
		/obj/item/storage/firstaid/trauma = 10,
		/obj/item/storage/firstaid/fire = 10,
		/obj/item/storage/firstaid/o2 = 10,
		/obj/item/storage/firstaid/stab = 10,
		/obj/item/storage/firstaid/combat = 5,
		/obj/item/clothing/glasses/meson = 10,
		/obj/item/clothing/glasses/material = 10,
		/obj/item/clothing/glasses/tacgoggles = 10,
		/obj/item/tool/pickaxe/laser = 10,
		/obj/item/rig_module/vision/meson = 10,
		/obj/item/rig_module/vision/nvg = 10,
		/obj/item/rig_module/device/drill = 10,
		/obj/item/rig_module/device/orescanner = 10,
		/obj/item/rig_module/kinesis = 10,
		/obj/item/rig_module/kinesis/advanced = 7,
		/obj/item/gun/energy/contact = 7,
		/obj/item/cell/contact = 21,
		/obj/item/gun/energy/cutter = 15,
		/obj/item/gun/energy/cutter/plasma = 5,
		/obj/item/stack/special_node/cutter = 5,
		/obj/item/cell/plasmacutter = 50,
		/obj/item/gun/projectile/ripper = 10,
		/obj/item/ammo_magazine/sawblades = 15,
		/obj/item/ammo_magazine/sawblades/diamond = 5,
		/obj/item/gun/projectile/linecutter = 5,
		/obj/item/ammo_magazine/lineracks = 20,
		/obj/item/gun/projectile/javelin_gun = 5,
		/obj/item/ammo_magazine/javelin = 20,
		/obj/item/gun/energy/forcegun = 10,
		/obj/item/cell/force = 20,
		/obj/item/gun/spray/hydrazine_torch = 10,
		/obj/item/reagent_containers/glass/fuel_tank/fuel = 25,
		/obj/item/reagent_containers/glass/fuel_tank/hydrazine = 10,
	)
	prices = list(
		/obj/item/stack/power_node = 5000,
		/obj/item/rig/mining = 2000,
		/obj/item/cell/high = 500,
		/obj/item/cell/super = 750,
		/obj/item/cell/hyper = 1000,
		/obj/item/healthanalyzer = 250,
		/obj/item/adv_health_analyzer = 1500,
		/obj/item/stack/nanopaste = 400,
		/obj/item/storage/firstaid/trauma = 700,
		/obj/item/storage/firstaid/fire = 700,
		/obj/item/storage/firstaid/o2 = 700,
		/obj/item/storage/firstaid/stab = 1000,
		/obj/item/storage/firstaid/combat = 3000,
		/obj/item/clothing/glasses/meson = 500,
		/obj/item/clothing/glasses/material = 400,
		/obj/item/clothing/glasses/tacgoggles = 700,
		/obj/item/tool/pickaxe/laser = 1000,
		/obj/item/rig_module/vision/meson = 700,
		/obj/item/rig_module/vision/nvg = 800,
		/obj/item/rig_module/device/drill = 1200,
		/obj/item/rig_module/device/orescanner = 300,
		/obj/item/rig_module/kinesis = 500,
		/obj/item/rig_module/kinesis/advanced = 1000,
		/obj/item/gun/energy/contact = 4500,
		/obj/item/cell/contact = 2000,
		/obj/item/gun/energy/cutter = 1000,
		/obj/item/gun/energy/cutter/plasma = 3500,
		/obj/item/stack/special_node/cutter = 4500,
		/obj/item/cell/plasmacutter = 500,
		/obj/item/gun/projectile/ripper = 4000,
		/obj/item/ammo_magazine/sawblades = 1000,
		/obj/item/ammo_magazine/sawblades/diamond = 2000,
		/obj/item/gun/projectile/linecutter = 4500,
		/obj/item/ammo_magazine/lineracks = 1500,
		/obj/item/gun/projectile/javelin_gun = 4250,
		/obj/item/ammo_magazine/javelin = 1350,
		/obj/item/gun/energy/forcegun = 3000,
		/obj/item/cell/force = 1000,
		/obj/item/gun/spray/hydrazine_torch = 8000,
		/obj/item/reagent_containers/glass/fuel_tank/fuel = 2000,
		/obj/item/reagent_containers/glass/fuel_tank/hydrazine = 4000,
		/obj/item/rig/eng_int = 10000,
		/obj/item/rig/advanced/mining = 20000,
	)

/obj/machinery/vending/mining/attackby(obj/item/W, mob/user)
	if(currently_vending && istype(W, /obj/item/spacecash/minercash))
		var/obj/item/spacecash/minercash/C = W
		if(currently_vending.price < C.worth)
			visible_message(SPAN_NOTICE("\The [user] inserts some cash into \the [src]."))
			C.worth -= currently_vending.price
			C.worth ? C.update_icon() : qdel(C)
			credit_purchase("(cash)")
			vend(currently_vending, user)
			SSnano.update_uis(src)
		else
			to_chat(user, "\icon[C] [SPAN_WARNING("That is not enough money.")]")

	if(isScrewdriver(W))
		panel_open = !panel_open
		to_chat(user, "You [panel_open ? "open" : "close"] the maintenance panel.")
		update_icon()
		SSnano.update_uis(src)  // Speaker switch is on the main UI, not wires UI

	else if(panel_open && (isMultitool(W) || isWirecutter(W)))
		attack_hand(user)

	else if(isWrench(W))
		wrench_floor_bolts(user)
		power_change()

/obj/machinery/vending/mining/Topic(href, href_list)
	if(stat & (BROKEN|NOPOWER))
		return
	if(..())
		return

	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))))
		if ((href_list["vend"]) && (src.vend_ready) && (!currently_vending))
			if((!allowed(usr)) && !emagged && scan_id)	//For SECURE VENDING MACHINES YEAH
				to_chat(usr, "<span class='warning'>Access denied.</span>")//Unless emagged of course
				playsound(loc, 'sound/machines/vending_denied.ogg', VOLUME_LOW)
				flick(icon_deny,src)
				return

			var/key = text2num(href_list["vend"])
			var/datum/stored_items/vending_products/R = product_records[key]

			// This should not happen unless the request from NanoUI was bad
			if(!(R.category & src.categories))
				return

			if(R.price <= 0)
				src.vend(R, usr)
			else if(istype(usr,/mob/living/silicon)) //If the item is not free, provide feedback if a synth is trying to buy something.
				to_chat(usr, "<span class='danger'>Artificial unit recognized.  Artificial units cannot complete this transaction.  Purchase canceled.</span>")
				playsound(loc, 'sound/machines/vending_denied.ogg', VOLUME_LOW)
				return
			else
				src.currently_vending = R
				if(!vendor_account || vendor_account.suspended)
					src.status_message = "This machine is currently unable to process payments due to problems with the associated account."
					src.status_error = 1
					playsound(loc, 'sound/machines/vending_denied.ogg', VOLUME_LOW)
				else
					src.status_message = "Please swipe a card or insert cash to pay for the item."
					src.status_error = 0


/obj/machinery/vending/mining/attempt_to_stock()
	return
