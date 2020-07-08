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
	var/atom/source
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
	var/tick_timer

	var/list/affected_turfs
	var/vector2/direction


	//Registry:
	var/datum/click_handler/spray/spray_handler	//Click handler for aiming the spray
	var/obj/effect/particle_system/chemspray/fx	//Particle system for chem particles

	var/obj/item/chem_atom
	var/datum/reagents/chem_holder

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

/datum/extension/spray/New(var/atom/source, var/atom/target, var/angle, var/length, var/chemical, var/volume, var/tick_delay, var/stun, var/duration, var/cooldown, var/mob/override_user = null)
	.=..()
	src.source = source
	if (override_user)
		user = override_user
	else if (isliving(source))
		user = source

	if (user && user.client)
		spray_handler = user.PushClickHandler(/datum/click_handler/spray)
		spray_handler.host = src

	set_target_loc(target.get_global_pixel_loc())
	src.angle = angle
	src.length = length
	src.chemical = chemical
	src.tick_delay = tick_delay
	src.volume_tick = volume / ((1 SECOND) / tick_delay)

	src.stun	=	stun
	src.duration = duration
	src.cooldown = cooldown
	//ongoing_timer = addtimer(CALLBACK(src, /datum/extension/spray/proc/start), 0)



/datum/extension/spray/proc/set_target_loc(var/vector2/newloc, var/target_object)
	target = newloc
	if (isliving(user) && target_object)
		user.face_atom(target_object)
	recalculate_cone()


/datum/extension/spray/proc/recalculate_cone()
	affected_turfs = list()
	direction = Vector2.VecDirectionBetween(source.get_global_pixel_loc(), target)
	affected_turfs = get_view_cone(source, direction, length, angle)
	affected_turfs -= get_turf(source)
	if (fx)
		fx.set_direction(direction)

/datum/extension/spray/proc/start()
	if (!started_at)
		started_at	=	world.time
		ongoing_timer = addtimer(CALLBACK(src, /datum/extension/spray/proc/stop), duration, TIMER_STOPPABLE)

		recalculate_cone()

		chem_atom = new(source)
		chem_holder = new (2**24, chem_atom)
		var/datum/reagent/R = chem_holder.add_reagent(/datum/reagent/acid/necromorph, chem_holder.maximum_volume, safety = TRUE)

		//Lets create the chemspray fx
		fx = new(source, direction, duration, length, angle)
		fx.particle_color = R.color
		fx.start()

		if (stun && isliving(user))
			user.set_move_cooldown(duration)

		tick()	//Start the first tick

/datum/extension/spray/proc/stop()
	deltimer(ongoing_timer)
	deltimer(tick_timer)
	if (spray_handler && user)
		user.RemoveClickHandlersByType(/datum/click_handler/spray)
		spray_handler = null
	stopped_at = world.time
	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/spray/proc/finish_cooldown), cooldown, TIMER_STOPPABLE)
	QDEL_NULL(fx)
	QDEL_NULL(chem_holder)
	QDEL_NULL(chem_atom)


/datum/extension/spray/proc/tick()
	for (var/t in affected_turfs)
		var/turf/T = t
		chem_holder.trans_to(T, volume_tick)
		for (var/atom/A in T)
			chem_holder.trans_to(A, volume_tick)
	tick_timer = addtimer(CALLBACK(src, /datum/extension/spray/proc/tick), tick_delay, TIMER_STOPPABLE)


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
	var/datum/extension/spray/E = get_extension(src, /datum/extension/spray)
	if(istype(E))
		if (error_messages)
			if (E.stopped_at)
				to_chat(src, SPAN_NOTICE("[E.name] is cooling down. You can use it again in [E.get_cooldown_time() /10] seconds"))
			else
				to_chat(src, SPAN_NOTICE("You're already Spraying"))
		return FALSE

	return TRUE

/mob/living/can_spray(var/error_messages = TRUE)
	if (incapacitated())
		return FALSE
	.=..()

/atom/proc/spray_ability(var/atom/target, var/angle, var/length, var/chemical, var/volume, var/tick_delay, var/stun, var/duration, var/cooldown, var/windup, var/mob/override_user = null)
	if (!can_spray())
		return FALSE
	var/datum/extension/spray/S = set_extension(src, /datum/extension/spray,target, angle, length, chemical, volume, tick_delay, stun, duration, cooldown, override_user)
	spawn(windup)
		S.start()
	return TRUE

/***********************
	Spray visual effect
************************/
/*
	Particle System
*/
/obj/effect/particle_system/chemspray
	particle_type = /obj/effect/particle/spray
	autostart = FALSE
	tick_delay = 0.15 SECONDS
	particles_per_tick = 6
	randpixel = 12




/obj/effect/particle/spray
	name = "spray"
	icon = 'icons/effects/effects.dmi'
	icon_state = "spray"
	scale_x_end = 2
	scale_y_end = 4
	color = "#FF0000"




/*-----------------------
	Click Handler
-----------------------*/
/datum/click_handler/spray
	var/datum/extension/spray/host
	has_mousemove = TRUE

/datum/click_handler/spray/MouseMove(object,location,control,params)
	if (host && user && user.client)
		var/vector2/mouseloc = get_global_pixel_click_location(params, user.client)
		host.set_target_loc(mouseloc, object)