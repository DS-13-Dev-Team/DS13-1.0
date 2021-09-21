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

	adding = list()
	other = list()
	src.hotkeybuttons = list() //These can be disabled for hotkey usersx

	var/list/hud_elements = list()
	var/obj/screen/using
	var/obj/screen/inventory/inv_box

	stamina_bar = new
	adding += stamina_bar

	// Draw the various inventory equipment slots.
	var/has_hidden_gear
	for(var/gear_slot in hud_data.gear)

		inv_box = new /obj/screen/inventory()
		inv_box.icon = ui_style
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		var/list/slot_data =  hud_data.gear[gear_slot]
		inv_box.SetName(gear_slot)
		inv_box.screen_loc =  slot_data["loc"]
		inv_box.slot_id =     slot_data["slot"]
		inv_box.icon_state =  slot_data["state"]

		if(slot_data["dir"])
			inv_box.set_dir(slot_data["dir"])

		if(slot_data["toggle"])
			src.other += inv_box
			has_hidden_gear = 1
		else
			src.adding += inv_box

	if(has_hidden_gear)
		using = new /obj/screen()
		using.SetName("toggle")
		using.icon = ui_style
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

	// Draw the attack intent dialogue.
	if(hud_data.has_a_intent)

		using = new /obj/screen/intent()
		src.adding += using
		action_intent = using

		hud_elements |= using

	if(hud_data.has_healthbar)

		hud_healthbar = new /obj/screen/meter/health(target.client)
		src.adding += hud_healthbar
		hud_elements |= hud_healthbar

	if(hud_data.has_m_intent)
		using = new /obj/screen/movement()
		using.SetName("movement method")
		using.icon = ui_style
		using.icon_state = mymob.move_intent.hud_icon_state
		using.screen_loc = ui_movi
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using
		move_intent = using

	if(hud_data.has_drop)
		using = new /obj/screen()
		using.SetName("drop")
		using.icon = ui_style
		using.icon_state = "act_drop"
		using.screen_loc = ui_drop_throw
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using

	if(hud_data.has_hands)

		using = new /obj/screen()
		using.SetName("equip")
		using.icon = ui_style
		using.icon_state = "act_equip"
		using.screen_loc = ui_equip
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

		inv_box = new /obj/screen/inventory()
		inv_box.SetName("r_hand")
		inv_box.icon = ui_style
		inv_box.icon_state = "r_hand_inactive"
		if(mymob && !mymob.hand)	//This being 0 or null means the right hand is in use
			inv_box.icon_state = "r_hand_active"
		inv_box.screen_loc = ui_rhand
		inv_box.slot_id = slot_r_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha

		src.r_hand_hud_object = inv_box
		src.adding += inv_box

		inv_box = new /obj/screen/inventory()
		inv_box.SetName("l_hand")
		inv_box.icon = ui_style
		inv_box.icon_state = "l_hand_inactive"
		if(mymob && mymob.hand)	//This being 1 means the left hand is in use
			inv_box.icon_state = "l_hand_active"
		inv_box.screen_loc = ui_lhand
		inv_box.slot_id = slot_l_hand
		inv_box.color = ui_color
		inv_box.alpha = ui_alpha
		src.l_hand_hud_object = inv_box
		src.adding += inv_box

		using = new /obj/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "hand1"
		using.screen_loc = ui_swaphand1
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

		using = new /obj/screen/inventory()
		using.SetName("hand")
		using.icon = ui_style
		using.icon_state = "hand2"
		using.screen_loc = ui_swaphand2
		using.color = ui_color
		using.alpha = ui_alpha
		src.adding += using

	if(hud_data.has_resist)
		using = new /obj/screen()
		using.SetName("resist")
		using.icon = ui_style
		using.icon_state = "act_resist"
		using.screen_loc = ui_pull_resist
		using.color = ui_color
		using.alpha = ui_alpha
		src.hotkeybuttons += using



	if(hud_data.has_throw)
		throw_icon = new /obj/screen()
		throw_icon.icon = ui_style
		throw_icon.icon_state = "act_throw_off"
		throw_icon.SetName("throw")
		throw_icon.screen_loc = ui_drop_throw
		throw_icon.color = ui_color
		throw_icon.alpha = ui_alpha
		src.hotkeybuttons += throw_icon
		hud_elements |= throw_icon

		pullin = new /obj/screen()
		pullin.icon = ui_style
		pullin.icon_state = "pull0"
		pullin.SetName("pull")
		pullin.screen_loc = ui_pull_resist
		src.hotkeybuttons += pullin
		hud_elements |= pullin

	if(hud_data.has_internals)
		internals = new /obj/screen()
		internals.icon = ui_style
		internals.icon_state = "internal0"
		internals.SetName("internal")
		internals.screen_loc = ui_internal
		hud_elements |= internals

	if(hud_data.has_warnings)
		oxygen = new /obj/screen()
		oxygen.icon = ui_style
		oxygen.icon_state = "oxy0"
		oxygen.SetName("oxygen")
		oxygen.screen_loc = ui_oxygen
		hud_elements |= oxygen

		toxin = new /obj/screen()
		toxin.icon = ui_style
		toxin.icon_state = "tox0"
		toxin.SetName("toxin")
		toxin.screen_loc = ui_toxin
		hud_elements |= toxin

		fire = new /obj/screen()
		fire.icon = ui_style
		fire.icon_state = "fire0"
		fire.SetName("fire")
		fire.screen_loc = ui_fire
		hud_elements |= fire

		healths = new /obj/screen/health_doll/human(mymob)
		healths.icon = ui_style
		hud_elements |= healths

	if(hud_data.has_pressure)
		pressure = new /obj/screen()
		pressure.icon = ui_style
		pressure.icon_state = "pressure0"
		pressure.SetName("pressure")
		pressure.screen_loc = ui_pressure
		hud_elements |= pressure

	if(hud_data.has_bodytemp)
		bodytemp = new /obj/screen()
		bodytemp.icon = ui_style
		bodytemp.icon_state = "temp1"
		bodytemp.SetName("body temperature")
		bodytemp.screen_loc = ui_temp
		hud_elements |= bodytemp

	if(target.isSynthetic())
		target.cells = new /obj/screen()
		target.cells.icon = 'icons/mob/screen1_robot.dmi'
		target.cells.icon_state = "charge-empty"
		target.cells.SetName("cell")
		target.cells.screen_loc = ui_nutrition
		hud_elements |= target.cells

	else if(hud_data.has_nutrition)
		nutrition_icon = new /obj/screen()
		nutrition_icon.icon = ui_style
		nutrition_icon.icon_state = "nutrition0"
		nutrition_icon.SetName("nutrition")
		nutrition_icon.screen_loc = ui_nutrition
		hud_elements |= nutrition_icon

	pain = mymob.overlay_fullscreen("pain", /obj/screen/fullscreen/pain, INFINITY)//new /obj/screen/fullscreen/pain( null )
	//pain.set_size(mymob.client)
	if (istype(pain))
		hud_elements |= pain


	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.icon = ui_style
	zone_sel.color = ui_color
	zone_sel.alpha = ui_alpha
	zone_sel.overlays.Cut()
	zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[zone_sel.selecting]")
	hud_elements |= zone_sel

	//Handle the gun settings buttons
	if(hud_data.has_guns)
		gun_setting_icon = new /obj/screen/gun/mode(null)
		gun_setting_icon.icon = ui_style
		gun_setting_icon.color = ui_color
		gun_setting_icon.alpha = ui_alpha
		hud_elements |= gun_setting_icon
		//FAIL POINT 1

		item_use_icon = new /obj/screen/gun/item(null)
		item_use_icon.icon = ui_style
		item_use_icon.color = ui_color
		item_use_icon.alpha = ui_alpha

		gun_move_icon = new /obj/screen/gun/move(null)
		gun_move_icon.icon = ui_style
		gun_move_icon.color = ui_color
		gun_move_icon.alpha = ui_alpha

		radio_use_icon = new /obj/screen/gun/radio(null)
		radio_use_icon.icon = ui_style
		radio_use_icon.color = ui_color
		radio_use_icon.alpha = ui_alpha

	mymob.client.screen = list()

	mymob.client.add_to_screen(hud_elements)

	mymob.client.add_to_screen(src.adding)

	mymob.client.add_to_screen(src.hotkeybuttons)
	inventory_shown = 0

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