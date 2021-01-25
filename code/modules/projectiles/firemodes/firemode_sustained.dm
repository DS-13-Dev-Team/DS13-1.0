/****************************
	Sustained Firemode
*****************************/


//sustained firing
//Todo: Way more checks and safety here
/datum/firemode/sustained
	settings = list(burst = 1, suppress_delay_warning = TRUE, dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2))
	click_handler_type = /datum/click_handler/gun/sustained


/datum/firemode/sustained/start_firing()
	set waitfor = FALSE

	if (!is_firing())
		gun.started_firing()



//This only handles reasons specific to this mode. the gun itself will handle things like running out of ammo or being dropped
/datum/firemode/sustained/can_stop_firing()
	if (CH.left_mousedown)
		return FALSE

	.=..()




