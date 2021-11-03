/obj/machinery/store
	var/datum/design/current_design
	var/current_category

	//This list contains data for listings that are specific to one occupant
	var/list/occupant_ui_data

	var/list/combined_store_data

/obj/machinery/store/attack_hand(var/mob/user)
	if (user == occupant)
		ui_interact(user)
	playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)

	//TODO: Fix transferring to box contents

/obj/machinery/store/ui_data()
	var/list/data = list()

	var/datum/money_account/ECA = occupant?.get_account()
	data["credits_account"] = (ECA ? ECA.money : "No ECA found")

	var/credits_rig = (occupant ? occupant.get_rig_balance() : 0)
	data["credits_rig"] = credits_rig


	var/credits_chip = (chip ? chip.worth : null)
	if (credits_chip != null)
		data["credits_chip"] = "[credits_chip]"
	data["credits_total"] = (isnum(credits_chip) ? credits_chip : 0) + credits_rig

	data["designs"] = combined_store_data

	if (current_category)
		data["selected_category"] = current_category

	if (current_design)
		data["current"] = current_design.ui_data
		data["selected_id"] = current_design.id
		if (occupant_can_afford())
			data["buy_enabled"] = TRUE

		if (current_design.store_transfer)
			data["transfer_enabled"] = TRUE

	if (chip)
		data["chip_ejectable"] = TRUE

	//This is null if the deposit box is empty
	if (deposit_box.ui_data)
		data["deposit"] = deposit_box.ui_data

	return data

/*
	Called whenever a new occupant enters
*/
/obj/machinery/store/proc/update_occupant_data()
	combined_store_data = list()
	for(var/A in GLOB.public_store_designs)
		var/datum/design/D = SSresearch.designs_by_id[A]
		combined_store_data[D.category] += list(D.ui_data)


	for(var/A in GLOB.limited_store_designs)
		var/datum/design/D = SSresearch.designs_by_id[A]
		if (D.PI?.can_buy_in_store(occupant))
			combined_store_data[D.category] += list(D.ui_data)


/obj/machinery/store/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null)
	var/list/data = ui_data(user, ui_key)
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		var/datum/asset/assets = get_asset_datum(/datum/asset/simple/research_designs)
		assets.send(user)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "store.tmpl", "Store", 900, 600)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()


/obj/machinery/store/OnTopic(var/mob/user, var/href_list, var/datum/topic_state/state)
	.= TOPIC_REFRESH


	if (busy)
		playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
		return


	if (user != occupant)
		playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
		return


	if(href_list["category"])
		current_category = href_list["category"]
		playsound(src, 'sound/machines/deadspace/menu_positive.ogg', VOLUME_MID, TRUE)
		return TOPIC_REFRESH


	if(href_list["select_item"])
		var/datum/design/D = SSresearch.designs_by_id[href_list["select_item"]]
		//TODO: Check that D is in our valid designs
		if (istype(D))
			current_design = D
		playsound(src, 'sound/machines/deadspace/menu_neutral.ogg', VOLUME_MID, TRUE)
		return TOPIC_REFRESH


	if(href_list["buy"])
		//Nosound because buying plays a vending sound
		switch(text2num(href_list["buy"]))
			if (1)
				buy_to_occupant()
			if (2)
				buy_to_deposit()
			if (3)
				buy_and_transfer()
		return TOPIC_REFRESH


	if(href_list["withdraw"])
		playsound(src, 'sound/machines/deadspace/menu_neutral.ogg', VOLUME_MID, TRUE)
		handle_withdraw(occupant)
		return TOPIC_REFRESH


	if(href_list["eject"])
		playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
		eject_item_by_name(href_list["eject"])
		return TOPIC_REFRESH


	if(href_list["eject_all"])
		playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
		eject_all(href_list["eject"])
		return TOPIC_REFRESH


	if(href_list["eject_chip"] && chip)
		playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
		eject_chip()
		return TOPIC_REFRESH