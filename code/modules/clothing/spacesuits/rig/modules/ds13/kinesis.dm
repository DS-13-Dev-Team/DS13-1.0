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

	//The graphical filter we assigned to the held item
	var/dm_filter/filter



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

	//How much force does this impart upon objects. This determines:
		//How fast things move towards the cursor
		//The maximum mass we can lift and move
		//How fast things are thrown when we release them
	//In newtons
	var/max_force	=	20

	//When we throw the object, this much impulse is applied in a burst
	var/throw_force	=	60

	//When an object is fully accelerated, how fast can it possibly move while we're gripping it?
	//This is a hard cap and it will be reached fairly easily with half a second or so of accelerating
	//In metres per second
	var/max_speed = 5

	//How fast can the object's speed increase? Measured in metres per second per second
	//That was not a typo.
	//This needs to be limited to prevent small/light objects just going nuts
	var/max_acceleration = 5



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
		rip_health = result
		//Spawn off this process, it will take time
		spawn()
			rip_free()

	//We are ready to grip it.
	//Even if its anchored, we can start the grip, the object won't move until we pull it loose
	grip(AM)
	return TRUE

/obj/item/rig_module/kinesis/proc/grip(var/atom/movable/AM)
	subject = AM
	subject.telegripped(src)	//Tell the object it was picked up

	filter = filter(type = "ripple", radius = 0, size = 1)
	subject.filters.Add(filter)
	animate(filter, radius = 2, size = 0, time = 3, loop = -1)

	if (!target)
		target = subject.get_global_pixel_loc()

	start_processing()

//Can this module grip live mobs? False in most circumstances
//Future todo: Allow live mob gripping when standing in a Stasis Amplification Field
/obj/item/rig_module/kinesis/proc/can_grip_live()
	return FALSE


/obj/item/rig_module/kinesis/proc/can_grip(var/atom/movable/A)
//Check if we can grab it
	if (!A.can_telegrip(src))
		return FALSE

	//If its anchored and we can't rip it out, continue
	if (A.anchored && A.can_rip_free == null)
		return FALSE

	return TRUE

/*
	Grip: Release
*/
//Main release proc, drops the item but does nothing with it
/obj/item/rig_module/kinesis/proc/release()
	.=subject
	subject = null
	target = null
	stop_processing()





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


/obj/item/rig_module/kinesis/Process()
	//Don't need to do anything if we're at the goal
	if(at_rest)
		return

	if (!safety_checks())
		release()

	accelerate()




/obj/item/rig_module/kinesis/proc/safety_checks()
	//It ceased existing?
	if (QDELETED(subject))
		return FALSE

	//Cache this for use later in the stack
	distance_pixels = holder.get_global_pixel_distance(subject)

	//Too far from user
	if (distance_pixels > drop_range * WORLD_ICON_SIZE)
		return FALSE

	return TRUE


/*
	Motion and Physics
*/
/obj/item/rig_module/kinesis/proc/accelerate()
	//First of all, lets get the distance from subject to target point
	var/vector2/offset = subject.get_global_pixel_loc() - target
	var/distance = offset.Magnitude()

	var/effective_force = max_force

	//Are we close enough to use Control mode?
	var/control_percentage = distance / (control_range * WORLD_ICON_SIZE)	//
	if (control_percentage  < 1)
		effective_force *= control_percentage

	//Alright, how much will we change the speed
	var/acceleration = effective_force / subject.get_mass()

/*
	Click Handler Stuff
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
		if(can_grip(A)_
			target_atom = A
		else
			target_atom = find_target(A)

		if (target_atom)
			attempt_grip(target_atom)
/*
	Target selection
*/

/*
	We will make several passes through the list, first grabbing things that might be important like projectiles in flight
*/
/obj/item/rig_module/kinesis/proc/find_target(var/atom/origin)
	var/list/nearby_stuff = range(2, origin)

	for (var/target_type in target_priority)
		for (var/atom/movable/A as target_type in nearby_stuff)

			if (!can_grip(A))
				nearby_stuff -= A
				continue


			//If we get this far, we've found a valid item matching the highest possible priority, we are done!
			return A

	return null