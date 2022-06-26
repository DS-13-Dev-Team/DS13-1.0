#define FRONTAL_METEOR_SPREAD	35

/datum/event/meteor_wave
	startWhen		= 30	// About one minute early warning
	endWhen 		= 60	// Adjusted automatically in tick()
	var/alarmWhen   = 30
	var/next_meteor = 40
	var/waves = 1
	var/start_side
	var/next_meteor_lower = 10
	var/next_meteor_upper = 20

	var/started_at

/*
	Subtypes
*/
/datum/event/meteor_wave/ishimura
	startWhen = 0
	next_meteor = 0
	start_side = EAST	//Meteors always come from the front





/datum/event/meteor_wave/ishimura/send_wave()
	var/obj/structure/asteroidcannon/AC = GLOB.asteroidcannon
	spawn()
		spawn_meteors(get_wave_size(), get_meteors(), start_side, AC.z, frontal = TRUE) //Overrode this so meteors only spawn on the Z-level that the asteroid cannon is on.
	next_meteor += rand(next_meteor_lower, next_meteor_upper) / severity
	waves--
	endWhen = worst_case_end()




//The boss wave called when ADS repair starts
/datum/event/meteor_wave/ishimura/final/calculate_waves()
	waves = INFINITY	//it goes until time expires

/datum/event/meteor_wave/ishimura/final/worst_case_end()
	return (15 MINUTES) / (EVENT_PROCESS_INTERVAL)//15 minute duration

/datum/event/meteor_wave/ishimura/final/announce()
	var/string = "Warning: [location_name()] is approaching a massive asteroid field. Activate emergency measures."
	if (!GLOB.asteroidcannon.operational)
		string += " Asteroid Defense System is offline, manual operation required."
	command_announcement.Announce(string, "[location_name()] Sensor Array", zlevels = affecting_z, new_sound = 'sound/misc/redalert1.ogg')






/datum/event/meteor_wave/setup()
	calculate_waves()
	started_at = world.time
	var/obj/structure/asteroidcannon/AC = GLOB.asteroidcannon
	start_side = AC.dir //Again, so they have a chance to shoot them down.
	endWhen = worst_case_end()


/datum/event/meteor_wave/proc/calculate_waves()
	waves = 0
	for(var/n in 1 to severity)
		waves += rand(5,15)


/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce(replacetext(GLOB.using_map.meteor_detected_message, "%STATION_NAME%", location_name()), "[location_name()] Sensor Array", new_sound = GLOB.using_map.meteor_detected_sound, zlevels = affecting_z)
		else
			command_announcement.Announce("The [location_name()] is now in a meteor shower.", "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/meteor_wave/tick()
	// Begin sending the alarm signals to shield diffusers so the field is already regenerated (if it exists) by the time actual meteors start flying around.
	if(alarmWhen < activeFor)
		for(var/obj/machinery/shield_diffuser/SD in SSmachines.machinery)
			if(isStationLevel(SD.z))
				SD.meteor_alarm(10)

	if(waves && activeFor >= next_meteor)
		send_wave()


/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((30 / severity) * waves) + 30

/datum/event/meteor_wave/proc/send_wave()
	var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))
	spawn() spawn_meteors(get_wave_size(), get_meteors(), pick_side, pick(affecting_z))

/datum/event/meteor_wave/proc/get_wave_size()
	return severity * rand(2,3)

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("The [location_name()] has cleared the meteor storm.", "[location_name()] Sensor Array", zlevels = affecting_z)
		else
			command_announcement.Announce("The [location_name()] has cleared the meteor shower", "[location_name()] Sensor Array", zlevels = affecting_z)

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return meteors_major
		if(EVENT_LEVEL_MODERATE)
			return meteors_moderate
		else
			return meteors_minor

/var/list/meteors_minor = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
)

/var/list/meteors_moderate = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
	/obj/effect/meteor/emp        = 10,
)

/var/list/meteors_major = list(
	/obj/effect/meteor/medium     = 80,
	/obj/effect/meteor/big        = 30,
	/obj/effect/meteor/dust       = 30,
	/obj/effect/meteor/irradiated = 30,
	/obj/effect/meteor/emp        = 30,
	/obj/effect/meteor/flaming    = 10,
	/obj/effect/meteor/golden     = 10,
	/obj/effect/meteor/silver     = 10,
	///obj/effect/meteor/tunguska   = 1,	//This thing is too much
)




/proc/spaceDebrisFrontalStartLoc(startSide, Z)
	var/obj/structure/asteroidcannon/AC = GLOB.asteroidcannon
	var/starty
	var/startx
	switch(startSide)	//TODO: Other sides
		if(NORTH)
			starty = world.maxy-(TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(EAST)
			starty = rand(AC.y + FRONTAL_METEOR_SPREAD,AC.y - FRONTAL_METEOR_SPREAD)
			startx = world.maxx-(TRANSITIONEDGE+1)
		if(SOUTH)
			starty = (TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(WEST)
			starty = rand(AC.y + FRONTAL_METEOR_SPREAD,AC.y - FRONTAL_METEOR_SPREAD)
			startx = (TRANSITIONEDGE+1)
	var/turf/T = locate(startx, starty, Z)
	return T


///////////////////////////////
//Meteor spawning global procs
///////////////////////////////

/proc/spawn_meteors(var/number = 10, var/list/meteortypes, var/startSide, var/zlevel, var/frontal = FALSE)
	for(var/i = 0; i < number; i++)
		spawn_meteor(meteortypes, startSide, zlevel, frontal)

/proc/spawn_meteor(var/list/meteortypes, var/startSide, var/zlevel, var/frontal = FALSE)
	var/turf/pickedstart

	if (frontal)
		pickedstart = spaceDebrisFrontalStartLoc(startSide, zlevel)
	else
		pickedstart = spaceDebrisStartLoc(startSide, zlevel)
	var/turf/pickedgoal = spaceDebrisFinishLoc(startSide, zlevel)

	var/Me = pickweight(meteortypes)
	var/obj/effect/meteor/M = new Me(pickedstart)
	M.start_side = startSide
	M.velocity = new /vector2()
	if(pickedgoal.x != pickedstart.x)
		M.velocity.x = (pickedgoal.x < pickedstart.x) ? -2 : 2
	if(pickedgoal.y != pickedstart.y)
		M.velocity.y = (pickedgoal.y < pickedstart.y) ? -2 : 2
	M.set_destination(pickedgoal)
	return

/proc/spaceDebrisStartLoc(startSide, Z)
	var/starty
	var/startx
	switch(startSide)
		if(NORTH)
			starty = world.maxy-(TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(EAST)
			starty = rand((TRANSITIONEDGE+1),world.maxy-(TRANSITIONEDGE+1))
			startx = world.maxx-(TRANSITIONEDGE+1)
		if(SOUTH)
			starty = (TRANSITIONEDGE+1)
			startx = rand((TRANSITIONEDGE+1), world.maxx-(TRANSITIONEDGE+1))
		if(WEST)
			starty = rand((TRANSITIONEDGE+1), world.maxy-(TRANSITIONEDGE+1))
			startx = (TRANSITIONEDGE+1)
	var/turf/T = locate(startx, starty, Z)
	return T

/proc/spaceDebrisFinishLoc(startSide, Z)
	var/endy
	var/endx
	switch(startSide)
		if(NORTH)
			endy = TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(EAST)
			endy = rand(TRANSITIONEDGE, world.maxy-TRANSITIONEDGE)
			endx = TRANSITIONEDGE
		if(SOUTH)
			endy = world.maxy-TRANSITIONEDGE
			endx = rand(TRANSITIONEDGE, world.maxx-TRANSITIONEDGE)
		if(WEST)
			endy = rand(TRANSITIONEDGE,world.maxy-TRANSITIONEDGE)
			endx = world.maxx-TRANSITIONEDGE
	var/turf/T = locate(endx, endy, Z)
	return T