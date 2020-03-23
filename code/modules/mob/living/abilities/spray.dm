//DO NOT INCLUDE THIS FILE
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
	var/vector2/direction = VecDirectionBetween(holder.get_global_pixel_loc(), target)
	affected_turfs = get_cone(holder, direction, length, angle)

/datum/extension/spray/proc/start()
	started_at	=	world.time
	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/spray/proc/stop), duration)


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
/obj/effect/chem_spray
	var/cached_rotation
	var/vector2/target_point


/*-----------------------
	Click Handler
-----------------------*/
/datum/click_handler/spray
	var/datum/extension/spray/host

/datum/click_handler/spray/MouseMove(object,location,control,params)
	var/vector2/mouseloc = get_global_pixel_click_location(params, holder.client)
	host.set_target_loc(mouseloc)