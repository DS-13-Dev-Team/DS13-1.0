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

//We deliberately pass in a null user so the spray doesn't make a click handler. We will create our own
/datum/firemode/sustained/spray/fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	if (!gun.is_firing())
		spray_extension = gun.spray_ability(subtype = spray_type,  target = target, angle = src.angle, length = range, stun = FALSE, duration  = FALSE, cooldown = FALSE, windup = FALSE, override_user = null, extra_data = src.extra_data)
		if (istype(spray_extension))
			gun.started_firing()
			world << "Got spray extension [spray_extension]"
		else
			world << "Failed to get extension [spray_extension]"

	//If the gun is already firing, then this fire call is to re-orient the spray
	else if (target)
		spray_extension.set_target_loc(target.get_global_pixel_loc(), target)


/datum/firemode/sustained/spray/stop_firing()
	world << "Spray firemode stopping firing 1"
	.=..()
	if (spray_extension)
		world << "Spray firemode stopping firing 2"
		spray_extension.stop()
		spray_extension = null

/datum/firemode/sustained/spray/update(var/force_state = null)
	var/obj/item/weapon/gun/spray/sprayer = gun
	spray_type = sprayer.spray_type
	world << "Spray updated"
	.=..()