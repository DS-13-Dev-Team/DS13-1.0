/****************************
	Sustained Firemode
*****************************/

//Automatic firing
//Todo: Way more checks and safety here
/datum/firemode/sustained
	settings = list(burst = 1, suppress_delay_warning = TRUE, dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
	//The full auto clickhandler we have
	var/minimum_shots = 0
	var/datum/click_handler/sustained/CH = null
	var/firing = FALSE
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
		stop_firing()
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


/datum/firemode/sustained/stop_firing()
	if (CH && !can_fire())
		//Todo: make client click handlers into a list
		if (CH.user) //Remove our handler from the client
			CH.user.RemoveClickHandler(CH)
		CH = null


