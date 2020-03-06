/datum/click_handler/rmb_aim
	var/obj/item/weapon/gun/gun	//What gun are they aiming

	var/min_interval = 0.6 SECONDS	//Minimum time between changing states (zoom in/zoom out) to make things feel less janky
	var/interval_timer_handle
	var/last_change = 0

/datum/click_handler/rmb_aim/New(var/mob/user)
	.=..()
	user.client.show_popup_menus = FALSE

/datum/click_handler/rmb_aim/Destroy()
	if (user)
		user.client.show_popup_menus = TRUE
	if (gun)
		gun.disable_aiming_mode()
	.=..()

/datum/click_handler/rmb_aim/MouseDown(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		object = user.client.resolve_drag(object, params)
		deltimer(interval_timer_handle)
		var/delta = world.time - last_change
		if (delta < min_interval)
			interval_timer_handle = addtimer(CALLBACK(src, .proc/start_aiming), min_interval - delta, TIMER_STOPPABLE)
		else
			start_aiming()
		return FALSE
	return TRUE

/datum/click_handler/rmb_aim/MouseUp(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		object = user.client.resolve_drag(object, params)
		deltimer(interval_timer_handle)
		var/delta = world.time - last_change
		if (delta < min_interval)
			interval_timer_handle = addtimer(CALLBACK(src, .proc/stop_aiming), min_interval - delta, TIMER_STOPPABLE)
		else
			stop_aiming()
		return FALSE
	return TRUE


/datum/click_handler/rmb_aim/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		over_object = resolve_world_target(over_object, params)
	return TRUE



/datum/click_handler/rmb_aim/proc/start_aiming()
	if (gun.enable_aiming_mode())
		last_change = world.time

/datum/click_handler/rmb_aim/proc/stop_aiming()
	if (gun.disable_aiming_mode())
		last_change = world.time