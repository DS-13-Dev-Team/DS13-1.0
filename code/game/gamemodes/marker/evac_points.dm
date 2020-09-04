/datum/game_mode/marker
	var/evac_points = 0
	var/evac_threshold = 60
	var/minimum_evac_time = 45// in minutes. How soon after marker setup that evac can be called, assuming all systems remain working (they won't)


	var/last_pointgain_time	= 0
	var/last_pointgain_quantity = 0
	var/pointgain_timer

/datum/game_mode/marker/proc/charge_evac_points()
	deltimer(pointgain_timer) //Recursive function that will slowly tick down the clock until the valour comes to rescue the ishimura's crew.

	//We get a basic pointgain based on ship systems
	var/pointgain = GLOB.shipsystem.get_point_gen()

	//The minimum time is used as a scalar on this
	pointgain *= evac_threshold / minimum_evac_time

	//And finally, we'll factor in the real time that has passed to compensate for lag and/or time dilation
	var/minutes_passed = (world.timeofday - last_pointgain_time) / 600	//In ideal circumstances, this value will be 1, but it may be more than 1 if server is lagging
	pointgain *= minutes_passed


	last_pointgain_quantity = pointgain
	evac_points += pointgain

	last_pointgain_time = world.timeofday

	if(evac_points >= evac_threshold)
		auto_recall_shuttle = FALSE //Allow shuttles now.
		evac_points = evac_threshold
		//No addtimer call here, so we'll stop gaining points now
	else
		pointgain_timer = addtimer(CALLBACK(src, .proc/charge_evac_points), 1 MINUTE, TIMER_STOPPABLE) //Shuttle was unable to be called. Try again recursively.
	return FALSE



/datum/evacuation_predicate/travel_points/New()
	return

/datum/evacuation_predicate/travel_points/Destroy()
	return 0

/datum/evacuation_predicate/travel_points/is_valid()
	var/datum/game_mode/marker/GM = ticker.mode
	if (istype(GM))
		return TRUE
	return FALSE

/datum/evacuation_predicate/travel_points/can_call(var/user)

	var/datum/game_mode/marker/GM = ticker.mode
	if (GM.evac_points >= GM.evac_threshold)
		return TRUE

	if (user && GM && GM.last_pointgain_quantity)

		var/time_remaining = ((GM.evac_threshold - GM.evac_points) / GM.last_pointgain_quantity) MINUTES
		to_chat(user, SPAN_DANGER("There is no viable site within range for evacuation at the present time. ETA: [time2text(time_remaining, "mm:ss")]"))

	return FALSE