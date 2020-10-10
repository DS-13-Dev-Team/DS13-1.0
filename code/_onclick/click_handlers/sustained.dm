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



/****************************
	Sustained Firemode
*****************************/

//Automatic firing
//Todo: Way more checks and safety here
/datum/firemode/sustained
	settings = list(burst = 1, suppress_delay_warning = TRUE, dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
	//The full auto clickhandler we have
	var/minimum_shots = 0
	var/datum/click_handler/fullauto/CH = null
	override_fire = TRUE

/datum/firemode/sustained/update(var/force_state = null)
	var/mob/living/L
	if (gun && gun.is_held())
		L = gun.loc

	var/enable = FALSE
	//Force state is used for forcing it to be disabled in circumstances where it'd normally be valid
	if (!isnull(force_state))
		enable = force_state
	else if (can_fire())
		enable = TRUE
	else
		enable = FALSE

	//Ok now lets set the desired state
	if (!enable)
		if (!CH)
			//If we're turning it off, but the click handler doesn't exist, then we have nothing to do
			return

		//Todo: make client click handlers into a list
		if (CH.user) //Remove our handler from the client
			CH.user.RemoveClickHandler(CH)
			CH = null
		return

	else
		//We're trying to turn things on
		if (CH)
			return //The click handler exists, we dont need to do anything


		//Create and assign the click handler
		//A click handler intercepts mouseup/drag/down events which allow fullauto firing
		CH = L.PushClickHandler(/datum/click_handler/sustained)
		CH.reciever = gun //Reciever is the gun that gets the fire events
		CH.user = L //And tell it where it is


/datum/firemode/sustained/proc/can_fire()
	. = FALSE
	var/mob/living/L
	if (gun && gun.is_held())
		L = gun.loc
	if (L && L.client)
		//First of all, lets determine whether we're enabling or disabling the click handler

		//We enable it if the gun is held in the user's active hand and the safety is off
		if (L.get_active_hand() == gun)
			//Lets also make sure it can fire
			. = TRUE


			//Projectile weapons need to have enough ammo to fire
			if(istype(gun, /obj/item/weapon/gun))
				var/obj/item/weapon/gun/P = gun
				if (!P.can_ever_fire())
					. =  FALSE




/*
	A firemode which does a spray ability from the gun
*/
/datum/firemode/sustained/spray
	var/spray_type
	var/angle
	var/range