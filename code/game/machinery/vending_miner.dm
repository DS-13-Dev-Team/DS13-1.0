/obj/machinery/vending/mining
	name = "Mine-o-vend"
	desc = "For all of your mining needs."
	product_slogans = "Can't stop the industrial revolution!"
	product_ads = "Almost free!"
	icon_state = "discomat"
	products = list(
		/obj/item/stack/power_node = 3,
	)
	prices = list(
		/obj/item/stack/power_node = 5000,
	)

/obj/machinery/vending/mining/attackby(obj/item/weapon/W, mob/user)
	if(currently_vending && istype(W, /obj/item/weapon/spacecash/minercash))
		var/obj/item/weapon/spacecash/minercash/C = W
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


/obj/machinery/vending/mining/attempt_to_stock()
	return
