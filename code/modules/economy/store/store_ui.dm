/obj/machinery/store
	var/current_design_id
	var/current_category = "All"

/obj/machinery/store/attack_hand(var/mob/user)
	if(user == occupant)
		tgui_interact(user)
	playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)

	//TODO: Fix transferring to box contents

/obj/machinery/store/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Store", "Store")
		ui.open()

// Make sure that user is on the same tile as Store, if not - close UI
/obj/machinery/store/ui_status(mob/user, datum/ui_state/state)
	if(get_dist(user, src))
		return UI_CLOSE
	else
		. = ..()
		if(busy || isghost(user))
			. = min(., UI_UPDATE)

/obj/machinery/store/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/research_designs)
		)

/obj/machinery/store/ui_data(mob/user)
	var/list/data = list()

	var/datum/money_account/ECA = occupant?.get_account()
	data["credits_account"] = (ECA ? ECA.money : "No ECA found")

	var/credits_rig = (occupant ? occupant.get_rig_balance() : 0)
	data["credits_rig"] = credits_rig

	data["chip"] = FALSE
	data["chip_worth"] = 0
	if (chip)
		data["chip"] = TRUE
		data["chip_worth"] = chip.worth

	data["cash_stored"] = 0
	for(var/obj/item/spacecash/S in deposit_box.contents)
		if(!istype(S, /obj/item/spacecash/minercash))
			data["cash_stored"] += S.worth

	data["credits_total"] = data["chip_worth"] + data["cash_stored"] + credits_rig + (ECA ? ECA.money : 0)

	data["selected_category"] = current_category
	if(current_design_id)
		data["selected_design_id"] = current_design_id
		if(occupant_can_afford())
			data["selected_design_can_afford"] = TRUE

	//This is null if the deposit box is empty
	if (deposit_box.ui_data)
		data["deposit"] = deposit_box.ui_data

	return data

/obj/machinery/store/ui_static_data(mob/user)
	var/list/list/data = list()
	data["designs"] = list()
	data["categories"] = list("All")
	for(var/A in (GLOB.public_store_designs|GLOB.unlimited_store_designs|GLOB.limited_store_designs))
		var/datum/design/D = SSresearch.designs_by_id[A]
		if(!D)
			crash_with("Found one, id: [A]")
			continue
		if(D.PI && !D.PI.can_buy_in_store(occupant))
			continue
		var/list/design_data = D.ui_data.Copy()
		data["designs"] += list(design_data)
		data["categories"] |= D.category
		if(ispath(D.build_path, /obj/item/rig_module) || ispath(D.build_path, /obj/item/rig))
			design_data["transfer_enabled"] = TRUE

	return data

/obj/machinery/store/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..() || IsAdminGhost(usr))
		return

	if (busy || usr != occupant)
		playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
		return

	switch(action)
		if("category")
			current_category = params["category"]
			playsound(src, 'sound/machines/deadspace/menu_positive.ogg', VOLUME_MID, TRUE)
			return TRUE

		if("select_item")
			var/datum/design/D = SSresearch.designs_by_id[params["select_item"]]
			if (istype(D) && (D.build_type & (STORE_SCHEMATICS|STORE_ROUNDSTART)))
				current_design_id = params["select_item"]
			playsound(src, 'sound/machines/deadspace/menu_neutral.ogg', VOLUME_MID, TRUE)
			return TRUE

		if("buy")
			//Nosound because buying plays a vending sound
			switch(text2num(params["buy"]))
				if (1)
					buy_to_occupant()
					return TRUE
				if (2)
					buy_to_deposit()
					return TRUE
				if (3)
					buy_and_transfer()
					return TRUE

		if("withdraw")
			playsound(src, 'sound/machines/deadspace/menu_neutral.ogg', VOLUME_MID, TRUE)
			handle_withdraw(occupant)
			return TRUE

		if("eject")
			playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
			eject_item_by_name(params["item_to_eject"])
			return TRUE

		if("eject_all")
			playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
			eject_all(params["eject"])
			return TRUE

		if("eject_chip")
			if(chip)
				playsound(src, 'sound/machines/deadspace/menu_negative.ogg', VOLUME_MID, TRUE)
				eject_chip()
				return TRUE
