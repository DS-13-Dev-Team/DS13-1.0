w//DO NOT INCLUDE THIS FILE
//ITs here as a template for abilites to copypaste

//spray
//Spray
//Spraying
///atom
/datum/extension/spray
	name = "Spray"
	base_type = /datum/extension/spray
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE

	var/status
	var/mob/living/user
	var/vector2/target
	var/angle
	var/length
	var/chemical
	var/volume_tick
	var/tick_delay
	var/stun
	var/duration
	var/cooldown

	var/started_at
	var/stopped_at

	var/ongoing_timer

	var/list/affected_turfs

	var/obj/effect/chem_spray/FX
	var/direction

/*
Vars/
	User:		Who or what is spraying chems
	Target:		Where are we spraying? This should be a turf, only used for direction
	Angle:		Angle of Cone
	Length:		How long is cone, in tiles
	Chemical:	What chem? Should be a /datum/reagent typepath
	Volume:		Units of the chemical to spray, per tile, per second
	Tick Delay:	Time between spray ticks
	Stun:		If true, user cant move for duration
	Duration:	How long to spray for
	Cooldown:	Starts after duration
*/

/datum/extension/spray/New(var/atom/source, var/atom/target, var/angle, var/length, var/chemical, var/volume, var/tick_delay, var/stun, var/duration, var/cooldown)
	.=..()
	if (isliving(source))
		user = source
	set_target_loc(target.get_global_pixel_loc())
	src.chemical = chemical
	src.tick_delay = tick_delay
	src.volume_tick = volume / ((1 SECOND) / tick_delay)

	src.stun	=	stun
	src.duration = duration
	src.cooldown = cooldown
	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/spray/proc/start), 0)
	start()


/datum/extension/spray/proc/set_target_loc(var/vector2/newloc)
	//TODO: Rotate the visual effect here
	//TODO: Recalculate the cone
	target = newloc

/datum/extension/spray/proc/recalculate_cone()
	affected_turfs = list()
	direction = VecDirectionBetween(holder.get_global_pixel_loc(), target)
	affected_turfs = get_cone(holder, direction, length, angle)

/datum/extension/spray/proc/start()
	started_at	=	world.time
	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/spray/proc/stop), duration)

	//Lets create the chemspray fx
	fx = new


/datum/extension/spray/proc/stop()
	deltimer(ongoing_timer)
	stopped_at = world.time
	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/spray/proc/finish_cooldown), cooldown)


/datum/extension/spray/proc/finish_cooldown()
	deltimer(ongoing_timer)
	remove_extension(holder, base_type)


/datum/extension/spray/proc/get_cooldown_time()
	var/elapsed = world.time - stopped_at
	return cooldown - elapsed





/***********************
	Safety Checks
************************/
//Access Proc
/atom/proc/can_spray(var/error_messages = TRUE)
	if (incapacitated())
		return FALSE

	var/datum/extension/spray/E = get_extension(src, /datum/extension/spray)
	if(istype(E))
		if (error_messages)
			if (E.stopped_at)
				to_chat(src, SPAN_NOTICE("[E.name] is cooling down. You can use it again in [E.get_cooldown_time() /10] seconds"))
			else
				to_chat(src, SPAN_NOTICE("You're already Spraying"))
		return FALSE

	return TRUE



/***********************
	Spray visual effect
************************/
/*
	Particle System
*/
/obj/effect/particle_system
	var/angle
	var/direction
	var/atom/origin
	var/tick_delay = 0.2 SECONDS
	var/particles_per_tick = 3
	var/particle_lifetime = 0.85
	var/particle_type = /obj/effect/particle
	var/randpixel = 5

/obj/effect/chem_spray(var/atom/location, var/atom/host, var/initial_target)
	origin = host
	if (initial(target))


/obj/effect/chem_spray/set_target(var/vector2/target)
	target_point = target
	direction = VecDirectionBetween(origin.get_global_pixel_loc(), target)
	cached_rotation = direction.Rotation()

/obj/effect/chem_spray/tick()
	if (loc != origin.loc)
		forceMove(origin.loc)

	for (var/i in 1 to particles_per_tick)

		//Lets calculate a random angle for this particle
		var/particle_angle = rand_between(0, angle) - angle*0.5	//We subtract half the angle to centre it
		var/particle_direction = direction.Turn(particle_angle)

		var/obj/effect/particle/S = new(loc, direction, var/lifespan)



/*
	Individual Particle
*/
/obj/effect/particle/spray
	name = "spray"
	icon = 'icons/effects/effects.dmi'
	icon_state = "spray"
	density = 0
	dir = NORTH
	randpixel

/obj/effect/spray_particle/New(var/location, var/direction, var/lifespan)
	transform = turn(transform, starting_rotation)
	//Sprays will reach the target length with half movement and half stretching)
	var/matrix/target_transform = new(transform)
	target_transform = transform.Scale(0, 0.5*length)
	animate(src, transform = target_transform, alpha = 0, time = lifespan)
	QDEL_IN(src, lifespan)
	.=..()



/*-----------------------
	Click Handler
-----------------------*/
/datum/click_handler/spray
	var/datum/extension/spray/host

/datum/click_handler/spray/MouseMove(object,location,control,params)
	var/vector2/mouseloc = get_global_pixel_click_location(params, holder.client)
	host.set_target_loc(mouseloc)