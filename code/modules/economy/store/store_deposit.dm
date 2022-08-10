//Deposit box in store kiosks
/obj/item/storage/internal/deposit
	max_w_class = ITEM_SIZE_GARGANTUAN
	//Stores a total number of items
	storage_slots = 30
	var/list/ui_data = list()


/obj/item/storage/internal/deposit/proc/update_ui_data()
	ui_data = list()
	for (var/obj/item/I in contents)
		ui_data += list(list("name" = copytext(I.name, 1, 21), "value" = 0))


	///If the list is empty, null it out
	if (!length(ui_data))
		ui_data = null





/obj/item/storage/internal/deposit/prepare_ui()
	.=..()
	update_ui_data()



/obj/machinery/store/proc/eject_item_by_name(var/item_name)
	//Ejects a specific item by name
	for (var/obj/item/I in deposit_box.contents)
		if (item_name == copytext(I.name, 1, 21))
			eject_item_from_deposit(I)

/obj/machinery/store/proc/eject_all()
	for (var/obj/item/I in deposit_box.contents)
		eject_item_from_deposit(I, TRUE)

/obj/machinery/store/proc/eject_item_from_deposit(var/obj/item/I, var/silent = FALSE)
	deposit_box.remove_from_storage(I, loc)
	if (occupant)
		var/atom/destination = occupant.equip_to_storage_or_hands(I)
		if(!destination)
			destination = store_or_drop(I)

		if (!silent && istype(destination, /atom))
			to_chat(occupant, "[I] ejected to [destination]")