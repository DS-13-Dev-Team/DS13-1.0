
/****************************
	Full auto gunfire
*****************************/
/datum/click_handler/fullauto
	var/atom/target = null
	var/firing = FALSE
	var/obj/item/weapon/gun/reciever //The thing we send firing signals to.
	//Todo: Make this work with callbacks
	var/minimum_shots = 0
	var/shots_fired = 0

	var/user_trying_to_fire = FALSE




/datum/click_handler/fullauto/proc/start_firing()
	if (!firing)
		firing = TRUE
		shots_fired = 0
		reciever.started_firing()
		while (firing && target)
			if (can_stop_firing())
				break
			do_fire()
			sleep(reciever.fire_delay) //Keep spamming events every frame as long as the button is held
		stop_firing()

//Next loop will notice these vars and stop shooting
/datum/click_handler/fullauto/proc/stop_firing()
	firing = FALSE
	target = null

/datum/click_handler/fullauto/proc/do_fire()
	if (reciever.afterattack(target, user, FALSE))
		shots_fired++

/datum/click_handler/fullauto/MouseDown(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["left"])
		object = resolve_world_target(object, params)
		if (object)
			target = object
			user.face_atom(target)
			user_trying_to_fire = TRUE
			spawn()
				start_firing()
			return FALSE
	return TRUE

//In the case of drag events we should always return true, incase there are multiple drag handlers in the sta
/datum/click_handler/fullauto/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	over_object = resolve_world_target(over_object, params)
	if (over_object && firing)
		target = over_object
		user.face_atom(target)
	return TRUE

/datum/click_handler/fullauto/MouseUp(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["left"])
		user_trying_to_fire = FALSE	//When we release the button, stop attempting to fire. it may still go if there's minimum shots remaining
	return TRUE

/datum/click_handler/fullauto/Destroy()
	stop_firing()//Without this it keeps firing in an infinite loop when deleted
	.=..()


/datum/click_handler/fullauto/proc/can_stop_firing()
	if (!reciever || !reciever.can_ever_fire())	//If the gun loses the ability to fire, we stop immediately
		return TRUE

	//If the user is still holding down the button, keep going
	if (user_trying_to_fire)
		return FALSE

	//If we haven't fired the minimum yet, we may be forced to continue. But only if the gun is in condition to do so
	if (minimum_shots && (shots_fired < minimum_shots))
		return FALSE

	return TRUE




//Automatic firing
//Todo: Way more checks and safety here
/datum/firemode/automatic
	settings = list(burst = 1, suppress_delay_warning = TRUE, dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
	//The full auto clickhandler we have
	var/minimum_shots = 0
	var/datum/click_handler/fullauto/CH = null

/datum/firemode/automatic/update(var/force_state = null)
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
		stop_firing()


	else
		//We're trying to turn things on
		if (CH)
			return //The click handler exists, we dont need to do anything


		//Create and assign the click handler
		//A click handler intercepts mouseup/drag/down events which allow fullauto firing
		CH = L.PushClickHandler(/datum/click_handler/fullauto)
		CH.reciever = gun //Reciever is the gun that gets the fire events
		CH.user = L //And tell it where it is
		CH.minimum_shots = minimum_shots


/datum/firemode/automatic/proc/can_fire()
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
			if(istype(gun, /obj/item/weapon/gun/projectile))
				var/obj/item/weapon/gun/projectile/P = gun
				if (!P.can_ever_fire())
					. =  FALSE


/datum/firemode/automatic/stop_firing()
	if (CH)
		//Todo: make client click handlers into a list
		if (CH.user) //Remove our handler from the client
			CH.user.RemoveClickHandler(CH)
		CH = null