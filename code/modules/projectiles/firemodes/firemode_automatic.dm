//Automatic firing
//Todo: Way more checks and safety here
/datum/firemode/automatic
	settings = list(burst = 1, suppress_delay_warning = TRUE, dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
	//The full auto clickhandler we have
	var/shots_fired
	var/minimum_shots = 0
	click_handler_type = /datum/click_handler/gun/sustained





/datum/firemode/automatic/start_firing()
	set waitfor = FALSE

	if (!is_firing())
		shots_fired = 0
		gun.started_firing()
		while (is_firing() && target)
			do_fire()
			sleep(gun.fire_delay) //Keep spamming events every frame as long as the button is held
		stop_firing()



/datum/firemode/automatic/on_fire(var/atom/target, var/mob/living/user, var/clickparams, var/pointblank=0, var/reflex=0, var/obj/projectile)
	shots_fired++

//This only handles reasons specific to this mode. the gun itself will handle things like running out of ammo or being dropped
/datum/firemode/automatic/can_stop_firing()
	//If the user is still holding down the button, keep going
	if (CH.left_mousedown)
		return FALSE

	//If we haven't fired the minimum yet, we may be forced to continue. But only if the gun is in condition to do so
	if (minimum_shots && (shots_fired < minimum_shots))
		return FALSE


	.=..()

