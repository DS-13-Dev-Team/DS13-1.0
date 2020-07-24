/*
	The kinesis module is technologically powered telekinesis.
	A man-made superpower that wouldn't seem out of plce in comics

	Being technology, it is grounded in reality to some extent, it has costs, and limitations.

	The kinesis module can be used as a weapon by throwing objects
*/

/obj/item/rig_module/kinesis
	name = "G.R.I.P kinesis module module"
	desc = "An engineering tool that uses microgravity fields to manipulate objects at distances of several metres."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "module"
	//matter = list(MATERIAL_STEEL = 20000, "plastic" = 30000, MATERIAL_GLASS = 5000)

	module_cooldown = 0
	active = FALSE

	active_power_cost = 300           // Power used while manipulating an object


	//The kinesis module tries to grab certain items in an order of priority
	var/list/target_priority = list(/obj/item/projectile,
	/obj/item/weapon/grenade,
	/obj/item/weapon,
	/obj/item/organ,
	/mob,
	/atom/movable)



//Registry
	//What are we currently moving, or trying to rip free?
	var/atom/movable/subject	=	null

	//Click handler
	var/datum/click_handler/sustained/kinesis/CHK

	var/hotkeys_set = FALSE


//Data:
	//If we are currently trying to rip an object free, this is how much health its moorings have.
	//The time taken to rip it out is (this / max force) seconds
	var/rip_health = 0

	//The current direction*speed of the object, in metres per second
	var/vector2/velocity

	//If true, the object has reached the user's cursor and doesnt need to go anywhere else
	var/at_rest = FALSE

	//A target location in global pixels. This is where the user's cursor is, and thus where we're aiming at
	var/vector2/target

	//How far away is the object from the user, in pixels? This is just cached to save a tiny shred of cpu time
	var/distance_pixels

	//In what manner are we releasing the thing we're holding? See defines/movement.dm
	var/release_type = RELEASE_DROP

//Config
	//How far away can we grip objects?
	//Measured in metres. Also note tiles are 1x1 metre
	var/range = 4

	//Held items that get this far away are dropped on the floor
	//Measured in metres
	var/drop_range = 5

	//If we are less than this distance from the target point, we will slow down as we approach it so we don't overshoot it
	//In Metres
	var/control_range = 2

	//If we are less than this range from the target, we will come to a complete stop and then enter at_rest
	var/stop_range = 0.25

	//How much force does this impart upon objects. This determines:
		//How fast things move towards the cursor
		//The maximum mass we can lift and move
		//How fast things are thrown when we release them
	//In newtons
	var/max_force	=	10

	//When we launch the object, this much impulse is applied in a burst
	var/launch_force	=	30


	//When an object is fully accelerated, how fast can it possibly move while we're gripping it?
	//This is a hard cap and it will be reached fairly easily with half a second or so of accelerating
	//In metres per second
	var/max_speed = 4

	//When we launch the object, it can reach this much total speed
	var/max_launch_speed = 8


	//How fast can the object's speed increase? Measured in metres per second per second
	//That was not a typo.
	//This needs to be limited to prevent small/light objects just going nuts
	var/max_acceleration = 4

	//Multiply velocity by this each tick, before acceleration
	var/velocity_decay = 0.95

	//When our held subject collides with an obstacle, it will only generate impact events if its speed is at least this high
	//In metres per second
	var/min_impact_speed = 0.3


	process_with_rig = FALSE

/*
	Activation and Engaging
*/

//Engage is called when the user presses F, the assigned hotkey
//This calls parent for safety checks first, then it does one of three things
	//If the user is currently gripping a subject, the subject is launched at the cursor
	//If the module is not active, activates it, adding the click handler
	//If the module is active (but not gripping anything) deactivates it, and removes click handler
/obj/item/rig_module/kinesis/proc/toggle()
	if (subject)
		launch()
		return
	else if (!active)
		activate()
		return

	//This goes here because we dont need to pass the safety checks to turn off
	if (active)
		deactivate()


//When the kinesis module is activated, it gets its click handler and
/obj/item/rig_module/kinesis/activate()
	.=..()
	if (.)
		var/mob/living/carbon/human/user = holder.wearer
		CHK = user.PushUniqueClickHandler(/datum/click_handler/sustained/kinesis)
		CHK.reciever = src

/obj/item/rig_module/kinesis/deactivate()
	.=..()
	if (.)
		var/mob/living/carbon/human/user = holder.wearer
		user.RemoveClickHandler(CHK)
		CHK = null

/*
	Grip: Starting off
*/
/obj/item/rig_module/kinesis/proc/attempt_grip(var/atom/movable/AM)
	//We can only hold one object. If we have something already, tough luck, drop it first
	if (subject)
		return FALSE



	//Can we pick it up? (assuming its unanchored)
	if (!AM.can_telegrip(src))
		return FALSE

	//If its anchored, do we have what it takes to rip it from its moorings?
	if (AM.anchored)
		var/riptest = AM.can_rip_free(src)

		//Can't be ripped free?
		if (isnull(riptest) || !isnum(riptest))
			return FALSE

		//Alright we are able to pull it free
		rip_health = riptest
		//Spawn off this process, it will take time
		//TODO: Implement this when there's a use for it
		//spawn()
			//rip_free()

	//We are ready to grip it.
	//Even if its anchored, we can start the grip, the object won't move until we pull it loose
	grip(AM)
	return TRUE

/obj/item/rig_module/kinesis/proc/grip(var/atom/movable/AM)

	velocity = new /vector2(0,0)

	subject = AM
	subject.telegripped(src)	//Tell the object it was picked up
	subject.throwing = TRUE

	set_extension(subject, /datum/extension/kinesis_gripped)

	if (!target)
		target = subject.get_global_pixel_loc()
	release_type = RELEASE_DROP

	//We need to register some listeners
	GLOB.destroyed_event.register(subject, src, /obj/item/rig_module/kinesis/proc/release_grip)
	GLOB.bump_event.register(subject, src, /obj/item/rig_module/kinesis/proc/subject_collision)

	start_processing()


//Can this module grip live mobs? False in most circumstances
//Future todo: Allow live mob gripping when standing in a Stasis Amplification Field
/obj/item/rig_module/kinesis/proc/can_grip_live()
	return FALSE


/obj/item/rig_module/kinesis/proc/can_grip(var/atom/movable/A)
	if (!istype(A))
		return FALSE

	var/distance  = holder.wearer.get_global_pixel_distance(A)
	//Too far from user
	if (distance > drop_range * WORLD_ICON_SIZE)
		return FALSE

//Check if we can grab it
	if (!A.can_telegrip(src))
		return FALSE

	//If its anchored and we can't rip it out, continue
	if (A.anchored && A.can_rip_free() == null)
		return FALSE

	return TRUE



/*
	Grip: Release
*/
//Main release proc, drops the item but does nothing with it
/obj/item/rig_module/kinesis/proc/release()
	.=subject
	if (!QDELETED(subject))
		GLOB.destroyed_event.unregister(subject, src, /obj/item/rig_module/kinesis/proc/release_grip)
		GLOB.bump_event.unregister(subject, src, /obj/item/rig_module/kinesis/proc/subject_collision)
		remove_extension(subject, /datum/extension/kinesis_gripped)
		subject.telegrip_released(src)
		subject.throwing = FALSE
		subject = null
	target = null
	stop_processing()


//The default entrypoint, a wrapper for release
//If the item is not in control range, it will be thrown based upon its velocity
/obj/item/rig_module/kinesis/proc/release_grip()

	var/speed = velocity.Magnitude()
	if (speed > 1 && release_type == RELEASE_DROP)
		release_type = RELEASE_THROW

	var/atom/movable/thing = release()	//Release it first, it will be returned here

	//If it deleted itself in the process of being released, we're done
	if (QDELETED(thing))
		return

	//When released the object will fly through the air for one second, if possible.
	//Requires a speed of > 1m/s, so this won't happen if it was brought to a controlled stop before being released

	if (release_type != RELEASE_DROP)
		var/turf/throw_target = thing.get_turf_at_pixel_offset(velocity * WORLD_ICON_SIZE)
		thing.throw_at(throw_target, speed, speed, null)




//Called when user presses the toggle key while holding an item
//The object is thrown based on its velocity, plus an additional burst of speed
//We just set the release type and velocity, then call release grip as normal
/obj/item/rig_module/kinesis/proc/launch()
	release_type = RELEASE_LAUNCH
	var/acceleration = launch_force / subject.get_mass()
	var/vector2/target_direction = target - subject.get_global_pixel_loc()
	target_direction = target_direction.Normalized()
	velocity += target_direction * acceleration

	var/speed = velocity.Magnitude()
	if (speed > max_launch_speed)
		velocity = velocity.ToMagnitude(max_launch_speed)

	//Todo here: Sound and visual effect for launching

	release_grip()

/*
	Process handling

	The kinesis module uses fastprocess, ticking 5 times per second
*/
/obj/item/rig_module/kinesis/proc/start_processing()

	if (is_processing)
		return FALSE

	START_PROCESSING(SSfastprocess, src)


/obj/item/rig_module/kinesis/proc/stop_processing()
	STOP_PROCESSING(SSfastprocess, src)


/obj/item/rig_module/kinesis/Process(var/wait)

	wait *= 0.1	//Convert this to seconds

	//Don't need to do anything if we're at the goal
	if(at_rest)
		return

	if (!safety_checks())
		release_grip()
		return

	accelerate(wait)
	if(at_rest)
		return

	move_subject(wait)



/obj/item/rig_module/kinesis/proc/safety_checks()
	//It ceased existing?
	if (QDELETED(subject))
		return FALSE

	//Cache this for use later in the stack
	if (!holder || !holder.wearer)
		return FALSE
	distance_pixels = holder.wearer.get_global_pixel_distance(subject)

	//Too far from user
	if (distance_pixels > drop_range * WORLD_ICON_SIZE)
		return FALSE

	return TRUE





/*
	Motion and Physics
*/

/*
	This handles all the acceleration calculations, and returns the force we used, which is useful to calculate power costs
*/
/obj/item/rig_module/kinesis/proc/accelerate(var/delta)

	//Velocity wears off gradually
	velocity *= velocity_decay

	//First of all, lets get the distance from subject to target point
	var/vector2/offset = target - subject.get_global_pixel_loc()
	var/distance = offset.Magnitude()


	var/subject_mass = subject.get_mass()



	//Are we close enough to use Control mode?
	var/control_percentage = distance / (control_range * WORLD_ICON_SIZE)	//
	control_percentage = Interpolate(0.2, 1, control_percentage)
	if (control_percentage  < 1)
		var/vector2/velocity_direction = velocity.SafeNormalized()
		//How much force we have available to make the changes, shared across both steps
		var/remaining_force = max_force

		var/current_speed = velocity.Magnitude()

		if (distance < (stop_range * WORLD_ICON_SIZE))
			//We're close enough to come to a complete stop, lets attempt to do so
			var/required_force = current_speed * subject_mass

			//We'll slow it as much as required, or as much as we can
			var/slowing_force = min(required_force, remaining_force)
			remaining_force -= slowing_force

			//Acceleration calculations
			var/deceleration = slowing_force / subject_mass

			velocity -= velocity_direction * deceleration

			//If we're successfully hit zero velocity, we are done
			if (!velocity.NonZero())
				at_rest = TRUE
				return max_force - remaining_force

		//Yes we are! alright, control mode aims to hold us to a speed limit towards the target
		//It has a limit on the total force it can apply for this task
		var/speed_limit = max_speed * control_percentage

		var/vector2/direction = offset.SafeNormalized()



		//We do this in three steps:
			//1. Slow down our velocity away from target
			//1. Slow down our general velocity if its over the speed limit
			//2. Speed up our velocity towards target,if its under the speed limit

		//Step 1
		var/vector2/velocity_away_from_target = velocity.SafeRejection(direction)
		var/speed_away_from_target = velocity_away_from_target.Magnitude()
		if (speed_away_from_target > 0)
			//We're not moving towards the target as fast as we're allowed to, we can accelerate
			var/required_force = speed_away_from_target * subject_mass

			var/accelerating_force = min(required_force, remaining_force)
			remaining_force -= accelerating_force
			//Acceleration calculations
			var/acceleration = accelerating_force / subject_mass
			acceleration = min(acceleration, max_acceleration)

			//And finally, modify the velocity
			velocity -= (velocity_away_from_target.Normalized() * acceleration)

			velocity_away_from_target = velocity.SafeRejection(direction)


		//If we used up all our force, we're done
		if (remaining_force <= 0)
			return max_force

		if (current_speed > speed_limit)
			//We're going too fast, lets slow down
			//The force we need to make the change is
			var/required_force = (current_speed - speed_limit) * subject_mass

			//We'll slow it as much as required, or as much as we can
			var/slowing_force = min(required_force, remaining_force)
			remaining_force -= slowing_force

			//Acceleration calculations
			var/deceleration = slowing_force / subject_mass

			//And finally, modify the velocity
			velocity -= velocity_direction * deceleration //We subtract rather than add, since we're slowing it down


		//If we used up all our force, we're done
		if (remaining_force <= 0)
			return max_force

		//Alright step 2, we find out how much of our velocity is towards the target, and accelerate towards it if needed
		var/vector2/velocity_towards_target = velocity.SafeProjection(direction)
		var/speed_towards_target = velocity_towards_target.Magnitude()
		if (speed_towards_target < speed_limit)
			//We're not moving towards the target as fast as we're allowed to, we can accelerate
			var/required_force = (speed_limit - speed_towards_target) * subject_mass

			var/accelerating_force = min(required_force, remaining_force)
			remaining_force -= accelerating_force
			//Acceleration calculations
			var/acceleration = accelerating_force / subject_mass
			acceleration = min(acceleration, max_acceleration)

			//And finally, modify the velocity
			velocity += direction * acceleration


		return max_force - remaining_force

	else
		//Alright, how much will we change the speed per second?
		var/acceleration = max_force / subject_mass
		acceleration = min(acceleration, max_acceleration)	//This is hardcapped

		//Now how much acceleration are we actually adding this tick ? Just multiply by the time delta, which will usually be 0.2
		acceleration *= delta


		//Okay now that we have the magnitude of the acceleration, lets create a velocity delta.
		if (acceleration > 0 && distance > 0)

			offset.ToMagnitude(acceleration)


			//Now we adjust the velocity
			velocity += offset

			//And we clamp its magnitude to our max speed
			velocity = velocity.ClampMag(0, max_speed)

		//We're done with velocity calculations, but we haven't moved yet

	return max_force

//This proc actually adjusts the subject's position, based on the calculated velocity
/obj/item/rig_module/kinesis/proc/move_subject(var/time_delta)
	var/vector2/position_delta = new /vector2(velocity)	//Copy the velocity first, we don't want to modify it here

	//Velocity is in metres, we work in pixels, so lets convert it
	position_delta *= WORLD_ICON_SIZE

	//The velocity is per second, but we're working on a sub-second frame interval, so multiply by our time delta
	position_delta *= time_delta

	//We now have the actual pixels we're going to add to our position
	subject.pixel_move(position_delta, time_delta*10)//We convert the time delta to deciseconds


//We collide with a thing
/obj/item/rig_module/kinesis/proc/subject_collision(var/atom/movable/mover, var/atom/obstacle)
	var/turf/old_loc = get_turf(obstacle)
	var/curspeed = velocity.Magnitude()
	if (curspeed >= min_impact_speed)
		subject.throw_impact(obstacle, curspeed)

	//If the object didn't break or move and still won't let us through, then we lose our velocity towards the object
	if (!QDELETED(obstacle))
		if (get_turf(obstacle) == old_loc)
			if (!obstacle.CanPass(subject, obstacle.loc))
				var/vector2/offset = obstacle.get_global_pixel_loc() - subject.get_global_pixel_loc()
				var/vector2/direction = offset.SafeNormalized()
				var/vector2/velocity_towards_target = velocity.SafeProjection(direction)
				velocity -= velocity_towards_target
/*
	Click Handler Stuff
*/

/*
	The click handler itself
*/
/datum/click_handler/sustained/kinesis

	fire_proc = /obj/item/rig_module/kinesis/proc/update
	//var/start_proc = /obj/item/weapon/gun/proc/start_firing
	stop_proc = /obj/item/rig_module/kinesis/proc/release_grip
	get_firing_proc = /obj/item/rig_module/kinesis/proc/is_gripping



/*
	Click handler recieving procs
*/
/*
	This proc is called for two scenarios/purposes

	1. If we're already holding something, this tells us that the user has moved their mouse,
	giving us a new place to move the held item towards. We will update our clickpoint, unset at_rest, etc.

	2. When we're not holding anything, this is called when the user attempts to grab something
	In this case, we will look around the original clickpoint to determine what they might have been trying to click on.
	Once we find the most likely candidate, we will attempt to grab it
*/
/*Arguments:
	A: What the user clicked on. We'll search around it.
	user: Self explanatory, we know who they are so we'll ignore this
	adjacent: Irrelevant to us
	Params: Click params from the mouse action which caused this update, vitally important
	global clickpoint: Where the user clicked in world pixel coords
*/
/obj/item/rig_module/kinesis/proc/update(var/atom/A, mob/living/user, adjacent, params, var/vector2/global_clickpoint)

	if (subject)
		//Lets see if the clickpoint has actually changed
		if (global_clickpoint.x != target.x || global_clickpoint.y != target.y)
			//It has! Set the new target, and if we were at rest, we start moving again
			target = global_clickpoint
			at_rest = FALSE

	else
		//Okay we're trying to grab a new item, first lets find out what
		var/atom/movable/target_atom
		if(can_grip(A))
			target_atom = A
		else
			target_atom = find_target(A)

		if (target_atom)
			attempt_grip(target_atom)
	sleep(1)


/obj/item/rig_module/kinesis/proc/is_gripping()
	if (subject)
		return TRUE
	return FALSE






/*
	Hotkey
*/
/obj/item/rig_module/kinesis/rig_equipped(var/mob/user, var/slot)
	update_hotkeys()

/obj/item/rig_module/kinesis/rig_unequipped(var/mob/user, var/slot)
	remove_hotkeys()




/obj/item/rig_module/kinesis/proc/update_hotkeys()
	if (!holder || !holder.wearer)
		return
	var/mob/living/user = holder.wearer
	if (!user.client)
		return

	if (!hotkeys_set)
		add_hotkeys(user)
	//else
		//remove_hotkeys(user)


/obj/item/rig_module/kinesis/proc/add_hotkeys(var/mob/living/carbon/human/user)
	//user.client.show_popup_menus = FALSE
	user.verbs |= /mob/living/carbon/human/verb/kinesis_toggle
	winset(user, "kinesis_toggle", "parent=macro;name=F;command=kinesis_toggle")
	winset(user, "kinesis_toggle", "parent=hotkeymode;name=F;command=kinesis_toggle")
	hotkeys_set = TRUE

/obj/item/rig_module/kinesis/proc/remove_hotkeys(var/mob/living/carbon/human/user)
	winset(user, "macro.kinesis_toggle", "parent=")
	winset(user, "hotkeymode.kinesis_toggle", "parent=")
	user.verbs -= /mob/living/carbon/human/verb/kinesis_toggle
	hotkeys_set = FALSE


/mob/living/carbon/human/verb/kinesis_toggle()
	set name = "kinesis_toggle"
	set hidden = TRUE
	set popup_menu = FALSE
	set category = null

	if (wearing_rig)
		for (var/obj/item/rig_module/kinesis/K in wearing_rig.installed_modules)
			K.toggle()
			return


/*
	Target selection
*/

/*
	We will make several passes through the list, first grabbing things that might be important like projectiles in flight
*/
/obj/item/rig_module/kinesis/proc/find_target(var/atom/origin)
	var/list/nearby_stuff = range(2, origin)

	for (var/target_type in target_priority)
		for (var/atom/movable/A in nearby_stuff)
			if (!istype(A, target_type))
				continue
			if (!can_grip(A))
				nearby_stuff -= A
				continue


			//If we get this far, we've found a valid item matching the highest possible priority, we are done!
			return A

	return null