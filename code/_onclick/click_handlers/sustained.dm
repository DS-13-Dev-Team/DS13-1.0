/****************************
	Sustained Fire
*****************************/
/datum/click_handler/sustained
//Useful for ripper and kinesis. Intended for things
//Works similar to full auto, but:
	//Constant firing events are not generated
	//Firing events are generated on every mousedrag
	//Firing events are generated on every mousemove
	var/atom/target = null
	var/firing = FALSE
	var/atom/reciever //The thing we send firing signals to.
	var/last_params

	var/fire_proc = /obj/item/weapon/gun/afterattack
	//var/start_proc = /obj/item/weapon/gun/proc/start_firing
	var/stop_proc = /obj/item/weapon/gun/proc/stop_firing
	var/get_firing_proc = /obj/item/weapon/gun/proc/is_firing

	has_mousemove = TRUE

/datum/click_handler/sustained/proc/start_firing()

	if (reciever && istype(reciever.loc, /mob))
		GLOB.moved_event.register(reciever.loc, reciever, /obj/item/weapon/gun/proc/user_moved)
	do_fire()
	firing = call(reciever, get_firing_proc)()

//Next loop will notice these vars and stop shooting
/datum/click_handler/sustained/proc/stop_firing()
	if (firing)
		if (reciever && istype(reciever.loc, /mob))
			GLOB.moved_event.unregister(reciever.loc, reciever, /obj/item/weapon/gun/proc/user_moved)
		firing = FALSE
		target = null
		if (call(reciever, get_firing_proc)())
			call(reciever, stop_proc)()

/datum/click_handler/sustained/proc/do_fire()
	call(reciever,fire_proc)(target, user, FALSE, last_params, get_global_pixel_click_location(last_params, user ? user.client : null))

/datum/click_handler/sustained/MouseDown(object,location,control,params)
	last_params = params
	object = resolve_world_target(object, params)
	if (object)
		target = object
		user.face_atom(target)
		start_firing()
		return FALSE
	return TRUE

/datum/click_handler/sustained/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	last_params = params
	over_object = resolve_world_target(over_object, params)
	if (over_object && firing)
		target = over_object //This var contains the thing the user is hovering over, oddly
		user.face_atom(target)
		do_fire()
		return FALSE
	return TRUE

/datum/click_handler/sustained/MouseMove(object,location,control,params)
	last_params = params
	object = resolve_world_target(object, params)
	if (object && firing)
		target = location //This var contains the thing the user is hovering over, oddly
		user.face_atom(target)
		do_fire()
		return FALSE
	return TRUE


/datum/click_handler/sustained/MouseUp(object,location,control,params)
	stop_firing()
	return TRUE

/datum/click_handler/sustained/Destroy()
	stop_firing()//Without this it keeps firing in an infinite loop when deleted
	.=..()
