/mob/living/carbon/human
	hud_type = /datum/hud/human

/datum/hud/human/New(mob/owner)
	..()

	var/mob/living/carbon/human/target = mymob
	var/datum/hud_data/hud_data
	if(!istype(target))
		hud_data = new()
	else
		hud_data = target.species.hud

	if(hud_data.icon)
		ui_style = hud_data.icon

	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	stamina_bar = new
	infodisplay += stamina_bar

	// Draw the various inventory equipment slots.
	var/has_hidden_gear
	for(var/gear_slot in hud_data.gear)

		inv_box = new /obj/screen/inventory()
		inv_box.icon = ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data =  hud_data.gear[gear_slot]
		inv_box.name =        gear_slot
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =     slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]

		if(slot_data["dir"])
			inv_box.set_dir(slot_data["dir"])

		if(slot_data["toggle"])
			toggleable_inventory += inv_box
			has_hidden_gear = 1
		else
			static_inventory += inv_box

	if(has_hidden_gear)
		using = new /obj/screen/toggle_inv()
		using.icon = ui_style
		using.color = ui_color
		using.alpha = ui_alpha
		static_inventory += using

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)

		action_intent = new /obj/screen/intent()
		static_inventory += action_intent

	if(hud_data.has_healthbar)

		hud_healthbar = new /obj/screen/meter/health(owner)
		hud_healthbar.L = owner
		infodisplay += hud_healthbar

		remaining_meter = new /obj/screen/meter_component/current(hud_healthbar)
		remaining_meter.color = hud_healthbar.remaining_color
		remaining_meter.screen_loc = hud_healthbar.screen_loc
		infodisplay += remaining_meter

		delta_meter = new /obj/screen/meter_component/delta(hud_healthbar)
		delta_meter.color = hud_healthbar.delta_color
		delta_meter.screen_loc = hud_healthbar.screen_loc
		infodisplay += delta_meter

		limit_meter = new /obj/screen/meter_component/limit(hud_healthbar)
		limit_meter.screen_loc = hud_healthbar.screen_loc
		infodisplay += limit_meter

		textholder = new /obj/screen/meter_component/text(hud_healthbar)
		textholder.screen_loc = hud_healthbar.screen_loc
		infodisplay += textholder

		hud_healthbar.remaining_meter = remaining_meter
		hud_healthbar.delta_meter = delta_meter
		hud_healthbar.limit_meter = limit_meter
		hud_healthbar.textholder = textholder

		hud_healthbar.update(TRUE)

	if(hud_data.has_resources)
		hud_resource = new /obj/screen/meter/resource/essence(owner)
		infodisplay += hud_resource

		r_m = new /obj/screen/meter_component/current(hud_resource)
		r_m.color = hud_resource.remaining_color
		r_m.screen_loc = hud_resource.screen_loc
		infodisplay += r_m

		d_m = new /obj/screen/meter_component/delta(hud_resource)
		d_m.color = hud_resource.delta_color
		d_m.screen_loc = hud_resource.screen_loc
		infodisplay += d_m

		l_m = new /obj/screen/meter_component/limit(hud_resource)
		l_m.screen_loc = hud_resource.screen_loc
		infodisplay += l_m

		th = new /obj/screen/meter_component/text(hud_resource)
		th.screen_loc = hud_resource.screen_loc
		infodisplay += th

		hud_resource.remaining_meter = r_m
		hud_resource.delta_meter = d_m
		hud_resource.limit_meter = l_m
		hud_resource.textholder = th

		hud_resource.update(TRUE)

	if(hud_data.has_m_intent)
		move_intent = new /obj/screen/movement()
		move_intent.SetName("movement method")
		move_intent.icon = ui_style
		move_intent.icon_state = mymob.move_intent.hud_icon_state
		move_intent.screen_loc = ui_movi
		move_intent.color = ui_color
		move_intent.alpha = ui_alpha
		static_inventory += move_intent

	if(hud_data.has_drop)
		using = new /obj/screen()
		using.SetName("drop")
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = ui_color
		using.alpha = ui_alpha
		hotkeybuttons += using

	if(hud_data.has_hands)

		using = new /obj/screen()
		using.SetName("equip")
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = ui_equip
		using.color = ui_color
		using.alpha = ui_alpha
		static_inventory += using

		inv_box = new /obj/screen/inventory/hand/right()
		inv_box.icon = ui_style
		if(owner && !owner.hand)	//This being 0 or null means the right hand is in use
			inv_box.add_overlay("hand_active")
		inv_box.slot_id = slot_r_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		r_hand_hud_object = inv_box
		static_inventory += inv_box

		inv_box = new /obj/screen/inventory/hand()
		inv_box.setDir(EAST)
		inv_box.icon = ui_style
		if(owner?.hand)	//This being 1 means the left hand is in use
			inv_box.add_overlay("hand_active")
		inv_box.slot_id = slot_l_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		l_hand_hud_object = inv_box
		static_inventory += inv_box

		using = new /obj/screen/swap_hand/human()
		using.icon = ui_style
		using.color = ui_color
		using.alpha = ui_alpha
		static_inventory += using

		using = new /obj/screen/swap_hand/right()
		using.icon = ui_style
		using.color = ui_color
		using.alpha = ui_alpha
		static_inventory += using

	if(hud_data.has_resist)
		using = new /obj/screen()
		using.SetName("resist")
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = ui_pull_resist
		using.color = ui_color
		using.alpha = ui_alpha
		hotkeybuttons += using



	if(hud_data.has_throw)
		throw_icon = new /obj/screen()
		throw_icon.icon = ui_style
		throw_icon.icon_state = "act_throw_off"
		throw_icon.SetName("throw")
		throw_icon.screen_loc = ui_drop_throw
		throw_icon.color = ui_color
		throw_icon.alpha = ui_alpha
		hotkeybuttons += throw_icon

		pullin = new /obj/screen()
		pullin.icon = ui_style
		pullin.icon_state = "pull0"
		pullin.SetName("pull")
		pullin.screen_loc = ui_pull_resist
		hotkeybuttons += pullin

	if(hud_data.has_internals)
		internals = new /obj/screen()
		internals.icon = ui_style
		internals.icon_state = "internal0"
		internals.SetName("internal")
		internals.screen_loc = ui_internal
		infodisplay += internals

	if(hud_data.has_warnings)
		oxygen = new /obj/screen()
		oxygen.icon = ui_style
		oxygen.icon_state = "oxy0"
		oxygen.SetName("oxygen")
		oxygen.screen_loc = ui_oxygen
		infodisplay += oxygen

		toxin = new /obj/screen()
		toxin.icon = ui_style
		toxin.icon_state = "tox0"
		toxin.SetName("toxin")
		toxin.screen_loc = ui_toxin
		infodisplay += toxin

		fire = new /obj/screen()
		fire.icon = ui_style
		fire.icon_state = "fire0"
		fire.SetName("fire")
		fire.screen_loc = ui_fire
		infodisplay += fire

		healths = new /obj/screen/health_doll/human(mymob)
		healths.icon = ui_style
		infodisplay += healths

	if(hud_data.has_pressure)
		pressure = new /obj/screen()
		pressure.icon = ui_style
		pressure.icon_state = "pressure0"
		pressure.SetName("pressure")
		pressure.screen_loc = ui_pressure
		infodisplay += pressure

	if(hud_data.has_bodytemp)
		bodytemp = new /obj/screen()
		bodytemp.icon = ui_style
		bodytemp.icon_state = "temp1"
		bodytemp.SetName("body temperature")
		bodytemp.screen_loc = ui_temp
		infodisplay += bodytemp

	if(target.isSynthetic())
		target.cells = new /obj/screen()
		target.cells.icon = 'icons/hud/screen1_robot.dmi'
		target.cells.icon_state = "charge-empty"
		target.cells.SetName("cell")
		target.cells.screen_loc = ui_nutrition
		infodisplay += target.cells

	else if(hud_data.has_nutrition)
		nutrition_icon = new /obj/screen()
		nutrition_icon.icon = ui_style
		nutrition_icon.icon_state = "nutrition0"
		nutrition_icon.SetName("nutrition")
		nutrition_icon.screen_loc = ui_nutrition
		infodisplay += nutrition_icon

	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.icon = ui_style
	zone_sel.color = ui_color
	zone_sel.alpha = ui_alpha
	zone_sel.overlays.Cut()
	zone_sel.overlays += image('icons/hud/zone_sel.dmi', "[zone_sel.selecting]")
	static_inventory += zone_sel

	//Handle the gun settings buttons
	if(hud_data.has_guns)
		gun_setting_icon = new /obj/screen/gun/mode(null)
		gun_setting_icon.icon = ui_style
		gun_setting_icon.color = ui_color
		gun_setting_icon.alpha = ui_alpha
		static_inventory += gun_setting_icon
		//FAIL POINT 1

	for(var/obj/screen/inventory/inv in (static_inventory + toggleable_inventory))
		if(inv.slot_id)
			inv.hud = src
			inv_slots[TOBITSHIFT(inv.slot_id) + 1] = inv


/datum/hud/human/show_hud(version = 0,mob/viewmob)
	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	hidden_inventory_update(screenmob)

/datum/hud/human/hidden_inventory_update(mob/viewer)
	if(!mymob)
		return

	var/mob/living/carbon/human/H = mymob
	var/mob/screenmob = viewer || H

	if(H.species && H.species.hud && !H.species.hud.gear.len)
		inventory_shown = FALSE
		return //species without inv slots don't show items.
	if(screenmob.hud_used.inventory_shown && screenmob.hud_used.hud_shown)
		if(H.shoes)
			H.shoes.screen_loc = ui_shoes
			screenmob.client.screen += H.shoes
		if(H.gloves)
			H.gloves.screen_loc = ui_gloves
			screenmob.client.screen += H.gloves
		if(H.l_ear)
			H.l_ear.screen_loc = ui_l_ear
			screenmob.client.screen += H.l_ear
		if(H.r_ear)
			H.r_ear.screen_loc = ui_r_ear
			screenmob.client.screen += H.r_ear
		if(H.glasses)
			H.glasses.screen_loc = ui_glasses
			screenmob.client.screen += H.glasses
		if(H.w_uniform)
			H.w_uniform.screen_loc = ui_iclothing
			screenmob.client.screen += H.w_uniform
		if(H.wear_suit)
			H.wear_suit.screen_loc = ui_oclothing
			screenmob.client.screen += H.wear_suit
		if(H.wear_mask)
			H.wear_mask.screen_loc = ui_mask
			screenmob.client.screen += H.wear_mask
		if(H.head)
			H.head.screen_loc = ui_head
			screenmob.client.screen += H.head
	else
		if(H.shoes)
			screenmob.client.screen -= H.shoes
		if(H.gloves)
			screenmob.client.screen -= H.gloves
		if(H.l_ear)
			screenmob.client.screen -= H.l_ear
		if(H.r_ear)
			screenmob.client.screen -= H.r_ear
		if(H.glasses)
			screenmob.client.screen -= H.glasses
		if(H.w_uniform)
			screenmob.client.screen -= H.w_uniform
		if(H.wear_suit)
			screenmob.client.screen -= H.wear_suit
		if(H.wear_mask)
			screenmob.client.screen -= H.wear_mask
		if(H.head)
			screenmob.client.screen -= H.head

/datum/hud/human/persistent_inventory_update(mob/viewer)
	if(!mymob)
		return

	. = ..()

	var/mob/living/carbon/human/H = mymob
	var/mob/screenmob = viewer || H

	if(screenmob.hud_used)
		if(screenmob.hud_used.hud_shown)
			if(H.s_store)
				H.s_store.screen_loc = ui_sstore1
				screenmob.client.screen += H.s_store
			if(H.wear_id)
				H.wear_id.screen_loc = ui_id
				screenmob.client.screen += H.wear_id
			if(H.belt)
				H.belt.screen_loc = ui_belt
				screenmob.client.screen += H.belt
			if(H.back)
				H.back.screen_loc = ui_back
				screenmob.client.screen += H.back
			if(H.l_store)
				H.l_store.screen_loc = ui_storage1
				screenmob.client.screen += H.l_store
			if(H.r_store)
				H.r_store.screen_loc = ui_storage2
				screenmob.client.screen += H.r_store
		else
			if(H.s_store)
				screenmob.client.screen -= H.s_store
			if(H.wear_id)
				screenmob.client.screen -= H.wear_id
			if(H.belt)
				screenmob.client.screen -= H.belt
			if(H.back)
				screenmob.client.screen -= H.back
			if(H.l_store)
				screenmob.client.screen -= H.l_store
			if(H.r_store)
				screenmob.client.screen -= H.r_store

	if(hud_version != HUD_STYLE_NOHUD)
		if(H.r_hand)
			H.r_hand.screen_loc = ui_rhand
			screenmob.client.screen += H.r_hand
		if(H.l_hand)
			H.l_hand.screen_loc = ui_lhand
			screenmob.client.screen += H.l_hand
	else
		if(H.r_hand)
			screenmob.client.screen -= H.r_hand
		if(H.l_hand)
			screenmob.client.screen -= H.l_hand

/mob/living/carbon/human/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1

/obj/screen/movement/Click(var/location, var/control, var/params)
	if(istype(usr))
		usr.set_next_usable_move_intent()