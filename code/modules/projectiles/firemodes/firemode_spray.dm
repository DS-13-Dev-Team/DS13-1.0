/*
	A firemode which does a spray ability from the gun
*/
/datum/firemode/sustained/spray
	var/spray_type
	var/angle
	var/range

	var/datum/extension/spray/spray_extension

	var/obj/item/weapon/gun/spray/sprayer
	override_fire = TRUE
	var/list/extra_data
	click_handler_type = /datum/click_handler/gun/sustained	//We use a null handler type so that one isn't created


/datum/firemode/sustained/spray/start_firing()
	set waitfor = FALSE

	if (!is_firing())
		do_fire()
		if (is_firing())
			gun.started_firing()


//We deliberately pass in a null user so the spray doesn't make a click handler. We will create our own
/datum/firemode/sustained/spray/fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if (!gun.is_firing())
		//Get rid of any existing spray extension
		stop_spray()

		//We pass in a null user
		spray_extension = gun.spray_ability(subtype = spray_type,  target = target, angle = src.angle, length = range, stun = FALSE, duration  = FALSE, cooldown = FALSE, windup = FALSE, override_user = -1, extra_data = src.extra_data)
		if (istype(spray_extension))
			gun.started_firing()

	//If the gun is already firing, then this fire call is to re-orient the spray
	else if (target)
		spray_extension.set_target_loc(target.get_global_pixel_loc(), target)


/datum/firemode/sustained/spray/stop_firing()
	.=..()
	stop_spray()


/datum/firemode/sustained/spray/proc/stop_spray()

	if (spray_extension)
		spray_extension.stop()
		spray_extension = null

/datum/firemode/sustained/spray/update(var/force_state = null)
	var/obj/item/weapon/gun/spray/sprayer = gun
	spray_type = sprayer.spray_type
	.=..()

/*
	When target changes, reorient the spray extension
*/
/datum/firemode/sustained/spray/set_target(var/atom/newtarget)
	.=..()
	if (spray_extension && CH)
		spray_extension.set_target_loc(CH.last_click_location, newtarget)