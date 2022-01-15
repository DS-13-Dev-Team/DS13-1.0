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

	var/atom/movable/screen/lingchemdisplay
	var/atom/movable/screen/r_hand_hud_object
	var/atom/movable/screen/l_hand_hud_object
	var/atom/movable/screen/intent/action_intent
	var/atom/movable/screen/move_intent
	var/atom/movable/screen/stamina/stamina_bar
	var/atom/movable/screen/meter/health/hud_healthbar
	var/list/atom/movable/screen/meter/resource/hud_resource = list()
	var/atom/movable/screen/hands
	var/atom/movable/screen/pullin
	var/atom/movable/screen/purged
	var/atom/movable/screen/internals
	var/atom/movable/screen/oxygen
	var/atom/movable/screen/i_select
	var/atom/movable/screen/m_select
	var/atom/movable/screen/toxin
	var/atom/movable/screen/fire
	var/atom/movable/screen/bodytemp
	var/atom/movable/screen/healths
	var/atom/movable/screen/throw_icon
	var/atom/movable/screen/nutrition_icon
	var/atom/movable/screen/pressure
	var/atom/movable/screen/gun/mode/gun_setting_icon

	var/atom/movable/screen/movable/ability_master/ability_master

	var/list/atom/movable/screen/plane_master/plane_masters = list() // see "appearance_flags" in the ref, assoc list of "[plane]" = object
	///Assoc list of controller groups, associated with key string group name with value of the plane master controller ref
	var/list/atom/movable/plane_master_controller/plane_master_controllers = list()

	/*A bunch of this stuff really needs to go under their own defines instead of being globally attached to mob.
	A variable should only be globally attached to turfs/objects/whatever, when it is in fact needed as such.
	The current method unnecessarily clusters up the variable list, especially for humans (although rearranging won't really clean it up a lot but the difference will be noticable for other mobs).
	I'll make some notes on where certain variable defines should probably go.
	Changing this around would probably require a good look-over the pre-existing code.
	*/
	var/atom/movable/screen/zone_sel/zone_sel

	var/list/static_inventory = list() //the screen objects which are static
	var/list/toggleable_inventory = list() //the screen objects which can be hidden
	var/list/atom/movable/screen/hotkeybuttons = list() //the buttons that can be used via hotkeys
	var/list/infodisplay = list() //the screen objects that display mob info (health, alien plasma, etc...)
	var/list/inv_slots[SLOTS_AMT] // /atom/movable/screen/inventory objects, ordered by their slot ID.

	var/atom/movable/screen/movable/action_button/hide_toggle/hide_actions_toggle
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

	ability_master = new /atom/movable/screen/movable/ability_master(null,mymob)

	for(var/mytype in subtypesof(/atom/movable/screen/plane_master))
		var/atom/movable/screen/plane_master/instance = new mytype()
		plane_masters["[instance.plane]"] = instance
		instance.backdrop(mymob)

	for(var/mytype in subtypesof(/atom/movable/plane_master_controller))
		var/atom/movable/plane_master_controller/controller_instance = new mytype(null,src)
		plane_master_controllers[controller_instance.name] = controller_instance

	for (var/typepath as anything in mymob.extensions)
		var/datum/extension/E = mymob.extensions[typepath]
		E.handle_hud(src)

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
	gun_setting_icon = null
	ability_master = null
	zone_sel = null
	hud_healthbar = null
	hud_resource = null
	zone_sel = null
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

/datum/hud/proc/hidden_inventory_update(mob/viewer)
	return

/datum/hud/proc/persistent_inventory_update(mob/viewer)
	return

//Triggered when F12 is pressed (Unless someone changed something in the DMF)
/mob/verb/button_pressed_F12()
	set name = "F12"
	set hidden = TRUE

	if(hud_used && client)
		hud_used.show_hud() //Shows the next hud preset
		to_chat(usr, "<span class='info'>Switched HUD mode. Press F12 to toggle.</span>")
	else
		to_chat(usr, SPAN_WARNING("This mob type does not use a HUD."))

//Version denotes which style should be displayed. blank or 0 means "next version"
//-1 means "Use the same version as last time" assuming any has previously been set, essentially a refresh function
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
	else if (display_hud_version == -1 && hud_version)
		display_hud_version = hud_version
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

	screenmob.refresh_lighting_overlays()
	screenmob.set_darksight_range(screenmob.client.view_range)
	hud_version = display_hud_version
	persistent_inventory_update(screenmob)
	screenmob.update_action_buttons()
	screenmob.reload_fullscreens()

	return TRUE

/datum/hud/proc/update_locked_slots()
	return

/*
	Target can be any of..
		/datum/hud
		/mob
		/client

	This proc attempts to return all three of those things related to the target
*/
/proc/get_hud_data_for_target(var/target)
	var/list/data = list()
	if (ismob(target))
		var/mob/M = target
		data["mob"] = target
		data["client"] = M.client
		data["hud"] = M.hud_used
	else if (istype(target, /client))
		var/client/C = target
		data["mob"] = C.mob
		data["client"] = C
		data["hud"] = C.mob?.hud_used
	else if (istype(target, /datum/hud))
		var/datum/hud/M = target
		
		data["mob"] = M.mymob
		data["client"] = M.mymob?.client
		data["hud"] = M

	return data