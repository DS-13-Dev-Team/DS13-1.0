
/datum/extension/asteroidcannon
	var/obj/structure/asteroidcannon/gun = null
	var/mob/living/carbon/human/gunner = null
	var/mob/observer/eye/turret/eyeobj = null
	var/datum/click_handler/gun/tracked/TCH


/datum/extension/asteroidcannon/Process()
	if(gunner)
		if(gun.is_firing()) //We've got a gunner, don't fire.
			handle_manual_fire()
			return
	else if (gun?.operational)
		if(!LAZYLEN(GLOB.asteroids))
			return
		handle_auto_fire()




/datum/extension/asteroidcannon/proc/handle_manual_fire()
	gun.fire_at(gun.target)


/datum/extension/asteroidcannon/proc/handle_auto_fire()
	//Meteor targeting!
	if (!is_valid_meteor(gun.target))

		var/obj/effect/meteor/M = get_valid_meteor()
		if (!M)
			return
		gun.set_target(M)

	gun.fire_at(gun.target)

/datum/extension/asteroidcannon/proc/get_valid_meteor()
	var/list/things = GLOB.asteroids.Copy()
	while (LAZYLEN(things))
		var/obj/effect/meteor/M = pick_n_take(things)
		if (is_valid_meteor(M))
			return M

	return null

/datum/extension/asteroidcannon/proc/is_valid_meteor(var/obj/effect/meteor/M)
	if (!istype(M))
		return FALSE
	if (QDELETED(M))
		return FALSE
	if (!isturf(M.loc))
		return FALSE
	if (abs(gun.rotator.get_total_rotation_to_target(M)) > gun.firing_arc)
		return FALSE	//Out of our firing arc

	return TRUE

/datum/extension/asteroidcannon/proc/target_click(var/mob/user, var/atom/target, var/params)
	gun.fire_at(get_turf(target))


/**
	Sets up the cannon for manual aiming, removes the autofire ability.
*/
/datum/extension/asteroidcannon/proc/set_gunner(mob/living/carbon/human/gunner)
	if(src.gunner)
		remove_gunner()
	src.gunner = gunner
	gunner.verbs |= /mob/living/carbon/human/proc/stop_gunning
	gunner.verbs |= /mob/living/carbon/human/proc/recenter_gunning
	gunner.forceMove(gun)
	gunner.pixel_x = (-gun.pixel_x)+4
	gunner.pixel_y = (-gun.pixel_y)+12
	gunner.set_dir(EAST)
	TCH = gunner.PushClickHandler(/datum/click_handler/gun/tracked/asteroidcannon)
	TCH.reciever = gun

	//This is vital to make drawing work right
	gun.cached_plane = gunner.plane
	gunner.plane = gun.plane

	//The gunner must be an overlay, not in vis contents, in order to smoothly rotate with the gun
	gun.overlays += gunner
	//gunner.vis_flags |= VIS_INHERIT_ID
	//gun.vis_contents += gunner
	gun.lead_distance = 1 //Gunners don't get hitscan...
	eyeobj = new /mob/observer/eye/turret(get_turf(gun))
	eyeobj.acceleration = FALSE
	eyeobj.possess(gunner, gun)	//Pass in the gun with possess

/datum/extension/asteroidcannon/proc/recenter()
	eyeobj?.setLoc(get_turf(gun))

/datum/extension/asteroidcannon/proc/remove_gunner()
	qdel(eyeobj)
	qdel(TCH)
	gun.lead_distance = initial(gun.lead_distance) //Gunners don't get hitscan...
	gunner.verbs -= /mob/living/carbon/human/proc/stop_gunning
	gunner.verbs -= /mob/living/carbon/human/proc/recenter_gunning
	//gunner.vis_flags |= VIS_INHERIT_ID
	gunner.eyeobj = null
	gun.overlays.Cut()
	gunner.plane = gun.cached_plane
	gunner.forceMove(get_turf(gun))
	gunner.animate_to_default()
	//gun.vis_contents -= gunner
	gunner = null

/datum/extension/asteroidcannon/New(datum/holder)
	if(!istype(holder, /obj/structure/asteroidcannon))
		return FALSE
	gun = holder
	START_PROCESSING(SSfastprocess, src)








/*
	Eye: Used for offset view on fixed angle turrets
*/
/mob/observer/eye/turret
	var/atom/gun = null
	var/offset = 6
	view_range = 12
	var/turf/offset_turf
	var/vector2/direction_vector	//This uses a non-copied global vector fetched from direction.
	//Do not edit or release it

/mob/observer/eye/turret/possess(var/mob/user, var/atom/newgun)
	gun = newgun
	update_direction()
	.=..()

/mob/observer/eye/turret/proc/update_direction()
	//We do NOT release the old vector here, it is a global value
	direction_vector = Vector2.FromDir(gun.dir)

	//This is temporary, we'll release it in a sec
	var/vector2/offset_vector = direction_vector * offset
	offset_turf = locate(gun.x + offset_vector.x, gun.y + offset_vector.y, gun.z)


	release_vector(offset_vector)


/mob/observer/eye/turret/EyeMove(direct)
	//Lets see if our target turf is valid
	var/turf/target_turf = get_step(src, direct)

	//To do that, we simply get the delta vector between our offset and the target, then
	var/vector2/difference = Vector2.DirMagBetween(offset_turf, target_turf)

	//Cross product with the turret direction
	var/vector2/cross = difference * direction_vector


	var/fail = FALSE
	//Now we check the cross. Any values which are negative, have gone past where they should, and that makes this movement invalid
	if (cross.x < 0 || cross.y < 0)
		fail = TRUE

	//Call parent to allow move to proceed
	if (!fail)
		. = ..()

	//Simply do not call parent to terminate movement
	//Either way we gotta cleanup vectors
	release_vector(cross)
	release_vector(difference)


/mob/observer/eye/turret/Destroy()
	gun = null
	. = ..()