/*
	The hud datum
	Used to show and hide huds for all the different mob types,
	including inventories and item quick actions.
*/

/mob
	var/hud_type = /datum/hud
	var/datum/hud/hud_used = null

/datum/hud
	var/mob/mymob

	var/hud_version = HUD_STYLE_STANDARD	//the hud version used (standard, reduced, none)
	var/hud_shown = TRUE			//Used for the HUD toggle (F12)
	var/inventory_shown = TRUE		//the inventory
	var/show_intent_icons = FALSE
	var/hotkey_ui_hidden = FALSE	//This is to hide the buttons that can be used via hotkeys. (hotkeybuttons list of buttons)

	var/obj/screen/lingchemdisplay
	var/obj/screen/r_hand_hud_object
	var/obj/screen/l_hand_hud_object
	var/obj/screen/action_intent
	var/obj/screen/move_intent
	var/obj/screen/stamina/stamina_bar
	var/obj/screen/meter/health/hud_healthbar
	var/obj/screen/hands
	var/obj/screen/pullin
	var/obj/screen/purged
	var/obj/screen/internals
	var/obj/screen/oxygen
	var/obj/screen/i_select
	var/obj/screen/m_select
	var/obj/screen/toxin
	var/obj/screen/fire
	var/obj/screen/bodytemp
	var/obj/screen/healths
	var/obj/screen/throw_icon
	var/obj/screen/nutrition_icon
	var/obj/screen/pressure
	var/obj/screen/fullscreen/pain
	var/obj/screen/gun/item/item_use_icon
	var/obj/screen/gun/radio/radio_use_icon
	var/obj/screen/gun/move/gun_move_icon
	var/obj/screen/gun/run/gun_run_icon
	var/obj/screen/gun/mode/gun_setting_icon

	var/obj/screen/movable/ability_master/ability_master

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/obj/screen/zone_sel/zone_sel

	var/list/static_inventory = list() //the screen objects which are static
	var/list/toggleable_inventory = list() //the screen objects which can be hidden
	var/list/obj/screen/hotkeybuttons = list() //the buttons that can be used via hotkeys
	var/list/infodisplay = list() //the screen objects that display mob info (health, alien plasma, etc...)

	var/obj/screen/movable/action_button/hide_toggle/hide_actions_toggle
	var/action_buttons_hidden = 0

	// subtypes can override this to force a specific UI style
	var/ui_style
	var/ui_color
	var/ui_alpha

/datum/hud/New(mob/owner)
	mymob = owner

	if (!ui_style)
		// will fall back to the default if any of these are null
		ui_style = ui_style2icon(mymob.client?.prefs?.UI_style)
	if (!ui_color)
		ui_color = mymob.client?.prefs?.UI_style_color
	if (!ui_alpha)
		ui_alpha = mymob.client?.prefs?.UI_style_alpha

	ability_master = new /obj/screen/movable/ability_master(null,mymob)

/datum/hud/Destroy()
	if(mymob.hud_used == src)
		mymob.hud_used = null

	QDEL_NULL(hide_actions_toggle)

	hands = null
	pullin = null
	purged = null
	internals = null
	oxygen = null
	i_select = null
	m_select = null
	toxin = null
	fire = null
	bodytemp = null
	healths = null
	throw_icon = null
	nutrition_icon = null
	pressure = null
	pain = null
	item_use_icon = null
	gun_move_icon = null
	gun_setting_icon = null
	ability_master = null
	zone_sel = null
	hud_healthbar = null
	zone_sel = null
	radio_use_icon = null
	stamina_bar = null
	lingchemdisplay = null
	r_hand_hud_object = null
	l_hand_hud_object = null
	action_intent = null
	move_intent = null

	QDEL_LIST(static_inventory)
	QDEL_LIST(infodisplay)
	QDEL_LIST(hotkeybuttons)

	mymob = null

	return ..()

/mob/proc/create_mob_hud()
	if(!client || hud_used)
		return
	hud_used = new hud_type(src)

/datum/hud/proc/update_stamina()
	if(mymob && stamina_bar)
		stamina_bar.invisibility = INVISIBILITY_MAXIMUM
		var/stamina = mymob.get_stamina()
		if(stamina < 100)
			stamina_bar.invisibility = 0
			stamina_bar.icon_state = "prog_bar_[Floor(stamina/5)*5]"

/datum/hud/proc/hidden_inventory_update()
	if(!mymob) return
	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		for(var/gear_slot in H.species.hud.gear)
			var/list/hud_data = H.species.hud.gear[gear_slot]
			if(inventory_shown && hud_shown)
				switch(hud_data["slot"])
					if(slot_head)
						if(H.head)      H.head.screen_loc =      hud_data["loc"]
					if(slot_shoes)
						if(H.shoes)     H.shoes.screen_loc =     hud_data["loc"]
					if(slot_l_ear)
						if(H.l_ear)     H.l_ear.screen_loc =     hud_data["loc"]
					if(slot_r_ear)
						if(H.r_ear)     H.r_ear.screen_loc =     hud_data["loc"]
					if(slot_gloves)
						if(H.gloves)    H.gloves.screen_loc =    hud_data["loc"]
					if(slot_glasses)
						if(H.glasses)   H.glasses.screen_loc =   hud_data["loc"]
					if(slot_w_uniform)
						if(H.w_uniform) H.w_uniform.screen_loc = hud_data["loc"]
					if(slot_wear_suit)
						if(H.wear_suit) H.wear_suit.screen_loc = hud_data["loc"]
					if(slot_wear_mask)
						if(H.wear_mask) H.wear_mask.screen_loc = hud_data["loc"]
			else
				switch(hud_data["slot"])
					if(slot_head)
						if(H.head)      H.head.screen_loc =      null
					if(slot_shoes)
						if(H.shoes)     H.shoes.screen_loc =     null
					if(slot_l_ear)
						if(H.l_ear)     H.l_ear.screen_loc =     null
					if(slot_r_ear)
						if(H.r_ear)     H.r_ear.screen_loc =     null
					if(slot_gloves)
						if(H.gloves)    H.gloves.screen_loc =    null
					if(slot_glasses)
						if(H.glasses)   H.glasses.screen_loc =   null
					if(slot_w_uniform)
						if(H.w_uniform) H.w_uniform.screen_loc = null
					if(slot_wear_suit)
						if(H.wear_suit) H.wear_suit.screen_loc = null
					if(slot_wear_mask)
						if(H.wear_mask) H.wear_mask.screen_loc = null


/datum/hud/proc/persistant_inventory_update()
	if(!mymob)
		return

	if(ishuman(mymob))
		var/mob/living/carbon/human/H = mymob
		for(var/gear_slot in H.species.hud.gear)
			var/list/hud_data = H.species.hud.gear[gear_slot]
			if(hud_shown)
				switch(hud_data["slot"])
					if(slot_s_store)
						if(H.s_store) H.s_store.screen_loc = hud_data["loc"]
					if(slot_wear_id)
						if(H.wear_id) H.wear_id.screen_loc = hud_data["loc"]
					if(slot_belt)
						if(H.belt)    H.belt.screen_loc =    hud_data["loc"]
					if(slot_back)
						if(H.back)    H.back.screen_loc =    hud_data["loc"]
					if(slot_l_store)
						if(H.l_store) H.l_store.screen_loc = hud_data["loc"]
					if(slot_r_store)
						if(H.r_store) H.r_store.screen_loc = hud_data["loc"]
			else
				switch(hud_data["slot"])
					if(slot_s_store)
						if(H.s_store) H.s_store.screen_loc = null
					if(slot_wear_id)
						if(H.wear_id) H.wear_id.screen_loc = null
					if(slot_belt)
						if(H.belt)    H.belt.screen_loc =    null
					if(slot_back)
						if(H.back)    H.back.screen_loc =    null
					if(slot_l_store)
						if(H.l_store) H.l_store.screen_loc = null
					if(slot_r_store)
						if(H.r_store) H.r_store.screen_loc = null


//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12()
	set name = "F12"
	set hidden = TRUE

	if(hud_used && client)
		hud_used.show_hud() //Shows the next hud preset
		to_chat(usr, "<span class='info'>Switched HUD mode. Press F12 to toggle.</span>")
	else
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))

/obj/screen/stamina
	name = "stamina"
	icon = 'icons/effects/progessbar.dmi'
	icon_state = "prog_bar_100"
	invisibility = INVISIBILITY_MAXIMUM
	screen_loc = ui_stamina

//Version denotes which style should be displayed. blank or 0 means "next version"
/datum/hud/proc/show_hud(version = 0, mob/viewmob)
	if(!ismob(mymob))
		return FALSE

	var/mob/screenmob = viewmob || mymob
	if(!screenmob.client)
		return FALSE

	screenmob.client.screen = list()
	screenmob.client.apply_clickcatcher()

	var/display_hud_version = version
	if(!display_hud_version)	//If 0 or blank, display the next hud version
		display_hud_version = hud_version + 1
	if(display_hud_version > HUD_VERSIONS)	//If the requested version number is greater than the available versions, reset back to the first version
		display_hud_version = 1

	switch(display_hud_version)
		if(HUD_STYLE_STANDARD)	//Default HUD
			hud_shown = 1	//Governs behavior of other procs
			if(static_inventory.len)
				screenmob.client.screen += static_inventory
			if(toggleable_inventory.len && inventory_shown)
				screenmob.client.screen += toggleable_inventory
			if(hotkeybuttons.len && !hotkey_ui_hidden)
				screenmob.client.screen += hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen += infodisplay
			if(action_intent)
				action_intent.screen_loc = initial(action_intent.screen_loc) //Restore intent selection to the original position

		if(HUD_STYLE_REDUCED)	//Reduced HUD
			hud_shown = 0	//Governs behavior of other procs
			if(static_inventory.len)
				screenmob.client.screen -= static_inventory
			if(toggleable_inventory.len)
				screenmob.client.screen -= toggleable_inventory
			if(hotkeybuttons.len)
				screenmob.client.screen -= hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen += infodisplay

			//These ones are a part of 'static_inventory', 'toggleable_inventory' or 'hotkeybuttons' but we want them to stay
			if(l_hand_hud_object)
				screenmob.client.screen += l_hand_hud_object	//we want the hands to be visible
			if(r_hand_hud_object)
				screenmob.client.screen += r_hand_hud_object	//we want the hands to be visible
			if(action_intent)
				screenmob.client.screen += action_intent		//we want the intent switcher visible
				action_intent.screen_loc = ui_acti_alt	//move this to the alternative position, where zone_select usually is.

		if(HUD_STYLE_NOHUD)	//No HUD
			hud_shown = 0	//Governs behavior of other procs
			if(static_inventory.len)
				screenmob.client.screen -= static_inventory
			if(toggleable_inventory.len)
				screenmob.client.screen -= toggleable_inventory
			if(hotkeybuttons.len)
				screenmob.client.screen -= hotkeybuttons
			if(infodisplay.len)
				screenmob.client.screen -= infodisplay

	hud_version = display_hud_version
	persistant_inventory_update(screenmob)
	mymob.update_action_buttons()
	mymob.reload_fullscreens()

	return TRUE

/datum/hud/human/show_hud(version = 0,mob/viewmob)
	. = ..()
	if(!.)
		return
	var/mob/screenmob = viewmob || mymob
	hidden_inventory_update(screenmob)
