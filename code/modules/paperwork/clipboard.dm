/obj/item/clipboard
	name = "clipboard"
	desc = "Useful for holding documents or pretending to look busy."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "clipboard"
	item_state = "clipboard"
	throwforce = 0
	w_class = ITEM_SIZE_SMALL

	throw_range = 10
	var/obj/item/pen/haspen		//The stored pen.
	var/obj/item/toppaper	//The topmost piece of paper.
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_STEEL = 70)

	/// Is the pen integrated?
	var/integrated_pen = FALSE
	/**
	 * Weakref of the topmost piece of paper
	 *
	 * This is used for the paper displayed on the clipboard's icon
	 * and it is the one attacked, when attacking the clipboard.
	 * (As you can't organise contents directly in BYOND)
	 */
	var/datum/weakref/toppaper_ref

/obj/item/clipboard/New()
	update_icon()

/// Take out the topmost paper
/obj/item/clipboard/proc/remove_paper(obj/item/paper/paper, mob/user)
	if(!istype(paper))
		return
	paper.forceMove(user.loc)
	user.put_in_hands(paper)
	to_chat(user, "<span class='notice'>You remove [paper] from [src].</span>")
	var/obj/item/paper/toppaper = toppaper_ref?.resolve()
	if(paper == toppaper)
		toppaper_ref = null
		var/obj/item/paper/newtop = locate(/obj/item/paper) in src
		if(newtop && (newtop != paper))
			toppaper_ref = WEAKREF(newtop)
		else
			toppaper_ref = null
	update_icon()

/obj/item/clipboard/proc/remove_pen(mob/user)
	haspen.forceMove(user.loc)
	user.put_in_hands(haspen)
	to_chat(user, "<span class='notice'>You remove [haspen] from [src].</span>")
	haspen = null
	update_icon()

/obj/item/clipboard/AltClick(mob/user)
	..()
	if(haspen)
		if(integrated_pen)
			to_chat(user, "<span class='warning'>You can't seem to find a way to remove [src]'s [haspen].</span>")
		else
			remove_pen(user)

/obj/item/clipboard/update_icon()
	overlays.Cut()
	if(toppaper)
		overlays += toppaper.icon_state
		overlays += toppaper.overlays
	if(haspen)
		overlays += "clipboard_pen"
	overlays += "clipboard_over"
	return

/obj/item/clipboard/attackby(obj/item/weapon, mob/user, params)
	var/obj/item/paper/toppaper = toppaper_ref?.resolve()
	if(istype(weapon, /obj/item/paper))
		//Add paper into the clipboard
		if(!user.remove_from_mob(weapon, src))
			return
		toppaper_ref = WEAKREF(weapon)
		to_chat(user, "<span class='notice'>You clip [weapon] onto [src].</span>")
	else if(istype(weapon, /obj/item/pen) && !haspen)
		//Add a pen into the clipboard, attack (write) if there is already one
		if(!usr.remove_from_mob(weapon, src))
			return
		haspen = weapon
		to_chat(usr, "<span class='notice'>You slot [weapon] into [src].</span>")
	else if(toppaper)
		toppaper.attackby(user.get_active_hand(), user)

/obj/item/clipboard/attack_self(mob/user as mob)
	add_fingerprint(usr)
	tgui_interact(user)
	return

/obj/item/clipboard/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Clipboard")
		ui.open()

/obj/item/clipboard/ui_data(mob/user)
	// prepare data for TGUI
	var/list/data = list()
	data["pen"] = "[haspen]"
	data["integrated_pen"] = integrated_pen

	var/obj/item/paper/toppaper = toppaper_ref?.resolve()
	data["top_paper"] = "[toppaper]"
	data["top_paper_ref"] = "[REF(toppaper)]"

	data["paper"] = list()
	data["paper_ref"] = list()
	for(var/obj/item/paper/paper in src)
		if(paper == toppaper)
			continue
		data["paper"] += "[paper]"
		data["paper_ref"] += "[REF(paper)]"

	return data

/obj/item/clipboard/ui_act(action, params)
	. = ..()
	if(.)
		return

	if(usr.stat != CONSCIOUS)
		return

	switch(action)
		// Take the pen out
		if("remove_pen")
			if(haspen)
				if(!integrated_pen)
					remove_pen(usr)
				else
					to_chat(usr, "<span class='warning'>You can't seem to find a way to remove [src]'s [haspen].</span>")
				. = TRUE
		// Take paper out
		if("remove_paper")
			var/obj/item/paper/paper = locate(params["ref"]) in src
			if(istype(paper))
				remove_paper(paper, usr)
				. = TRUE
		// Look at (or edit) the paper
		if("edit_paper")
			var/obj/item/paper/paper = locate(params["ref"]) in src
			if(istype(paper))
				paper.ui_interact(usr)
				update_icon()
				. = TRUE
		// Move paper to the top
		if("move_top_paper")
			var/obj/item/paper/paper = locate(params["ref"]) in src
			if(istype(paper))
				toppaper_ref = WEAKREF(paper)
				to_chat(usr, "<span class='notice'>You move [paper] to the top.</span>")
				update_icon()
				. = TRUE
		// Rename the paper (it's a verb)
		if("rename_paper")
			var/obj/item/paper/paper = locate(params["ref"]) in src
			if(istype(paper))
				paper.rename()
				update_icon()
				. = TRUE
