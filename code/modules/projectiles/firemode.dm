/*
	Defines a firing mode for a gun.

	A firemode is created from a list of fire mode settings. Each setting modifies the value of the gun var with the same name.
	If the fire mode value for a setting is null, it will be replaced with the initial value of that gun's variable when the firemode is created.
	Obviously not compatible with variables that take a null value. If a setting is not present, then the corresponding var will not be modified.
*/
/datum/firemode
	var/name = "default"
	var/list/settings = list()
	var/obj/item/gun/gun = null
	var/override_fire = FALSE	//If true, this firemode has its own firing proc which replaces that of the gun
	var/list/original_vars = list()

	var/click_handler_type
	var/datum/click_handler/gun/CH

	var/mob/user
	var/atom/target
	var/req_ammo = TRUE

/datum/firemode/New(obj/item/gun/_gun, list/properties = null)
	..()
	if(!properties) return

	gun = _gun //Cache the weapon

	for(var/propname in properties)
		var/propvalue = properties[propname]

		if(propname == "mode_name")
			name = propvalue
		else if(isnull(propvalue))
			settings[propname] = gun.vars[propname] //better than initial() as it handles list vars like burst_accuracy
		else
			settings[propname] = propvalue

/datum/firemode/Destroy()
	gun = null
	original_vars = list()
	stop_firing()
	.=..()

/datum/firemode/proc/apply_to(obj/item/gun/_gun)
	gun = _gun
	gun.current_firemode = src
	for(var/propname in settings)
		if (propname in gun.vars)
			original_vars[propname] = gun.vars[propname]
			gun.vars[propname] = settings[propname]


/datum/firemode/proc/unapply_to(obj/item/gun/_gun)
	gun = _gun
	if (gun.current_firemode == src)
		gun.current_firemode = null
	for(var/propname in settings)
		if (propname in gun.vars)
			gun.vars[propname] = original_vars[propname]


//Called from clickhandlers to send a fire command to the gun.
/datum/firemode/proc/do_fire()
	gun.afterattack(target, user, FALSE, CH.last_clickparams, CH.last_click_location)


//Only called when override_fire == TRUE. Called INSTEAD of the parent gun firing. on_fire will not be called in this case
/datum/firemode/proc/fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	return

//Called every time just after the parent gun fires
/datum/firemode/proc/on_fire(var/atom/target, var/mob/living/user, var/clickparams, var/pointblank=0, var/reflex=0, var/obj/projectile)
	return

//Called whenever the firemode is switched to, or the gun is picked up while its active
/datum/firemode/proc/update(var/force_state = null)

	user = get_user()

	var/enable = FALSE
	//Force state is used for forcing it to be disabled in circumstances where it'd normally be valid
	if (!isnull(force_state))
		enable = force_state
	else
		enable = should_have_click_handler()

	//Ok now lets set the desired state
	if (!enable)
		stop_firing()
		remove_click_handler()
	else
		create_click_handler()


/datum/firemode/proc/should_have_click_handler()
	. = FALSE

	if (!user || !user.client)
		return FALSE

	if (!gun || !gun.is_held())
		return FALSE
	//First of all, lets determine whether we're enabling or disabling the click handler

	//We enable it if the gun is held in the user's active hand and the safety is off
	if (!(user.get_active_hand() == gun))
		//Lets also make sure it can fire
		return FALSE


	//Projectile weapons need to have enough ammo to fire
	if (!gun.can_ever_fire())
		return FALSE

	return TRUE



/datum/firemode/proc/create_click_handler()
	if (CH || !click_handler_type)
		return //The click handler exists, we dont need to do anything


	if (user)
		//Create and assign the click handler
		//A click handler intercepts mouseup/drag/down events which allow fullauto firing
		CH = user.PushClickHandler(click_handler_type)
		CH.reciever = src //Reciever is the thing which recieves firing events
		CH.user = user //And tell it where it is


/datum/firemode/proc/remove_click_handler()
	if (CH)
		//Todo: make client click handlers into a list
		if (CH.user) //Remove our handler from the client
			CH.user.RemoveClickHandler(CH)
		CH = null

//If we can't find our user, remove the click handler
/datum/firemode/proc/get_user()
	if (gun && gun.is_held())
		return gun.loc
	else
		remove_click_handler()

/datum/firemode/proc/can_stop_firing()
	return TRUE

/*
	This only handles additional checks that the gun itself may not handle
*/
/datum/firemode/proc/can_fire(mob/living/user)
	return TRUE

//Override in subtypes
/datum/firemode/proc/start_firing()



//Called from update. Ceases any ongoing operations
/datum/firemode/proc/stop_firing()
	if (is_firing())
		gun?.stop_firing()
	target = null

/datum/firemode/proc/is_firing()
	return gun?.is_firing()




/datum/firemode/proc/set_target(var/atom/newtarget)
	target = newtarget
	if (user)
		user.face_atom(target)


