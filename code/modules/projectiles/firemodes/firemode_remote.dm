//Sustained remote control
/datum/firemode/remote
	settings = list(burst = 1, suppress_delay_warning = TRUE, dispersion=list(0.0))

	click_handler_type = /datum/click_handler/gun/sustained/move
	override_fire = TRUE
	var/list/projectiles = list()
	var/tether_type
	var/max_range	=	128

/datum/firemode/remote/fire(atom/target, mob/living/user, clickparams, pointblank=0, reflex=0)
	var/obj/item/projectile/remote/projectile = gun.consume_next_projectile(user)
	if(!projectile)
		gun.handle_click_empty(user)
		return

	var/turf/T = get_step(user, user.dir)

	projectile.forceMove(T)

	register_projectile(projectile)
	projectile.control_launched(src)

	if (!gun.is_firing())
		gun.started_firing()





/datum/firemode/remote/Process()
	var/vector2/target_loc = get_clamped_target()
	for (var/obj/item/projectile/remote/R as anything in projectiles)
		R.track_target(target_loc)
		R.damage_turf()
	release_vector(target_loc)


/datum/firemode/remote/proc/user_moved()
	update_tethers()


/datum/firemode/remote/proc/get_clamped_target()
	var/vector2/target_loc = CH.last_click_location.Copy()
	if (max_range)
		target_loc.SelfClampMagFrom(user, 1, max_range)

	return target_loc

/datum/firemode/remote/proc/update_tethers()
	if (!tether_type)
		return

	var/vector2/target_loc = get_clamped_target()
	for (var/obj/item/projectile/remote/R as anything in projectiles)
		if (R.tether)
			R.tether.set_target_coords(target_loc) //The tether points to the cursor, the blade catches up with it

	release_vector(target_loc)


/datum/firemode/remote/proc/register_projectile(var/obj/item/projectile/remote/R)
	projectiles |= R
	if (tether_type)
		R.tether = new tether_type(get_turf(R))
		R.tether.set_origin(gun)

		update_tethers()

	START_PROCESSING(SSfastprocess, src)

/datum/firemode/remote/proc/unregister_projectile(var/obj/item/projectile/remote/R)
	if ((R in projectiles))
		projectiles -= R
		if (!projectiles.len)
			stop_firing()

/datum/firemode/remote/start_firing()
	do_fire()


/datum/firemode/remote/stop_firing()
	.=..()
	for (var/obj/item/projectile/remote/R as anything in projectiles)
		R.drop()

	STOP_PROCESSING(SSfastprocess, src)


/datum/firemode/remote/can_stop_firing()
	if (CH.left_mousedown)
		return FALSE

	.=..()


/datum/firemode/remote/set_target(var/atom/newtarget)
	target = newtarget
	if (user)
		user.face_atom(target)

	update_tethers()