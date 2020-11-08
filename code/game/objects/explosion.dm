//Reference
#define EXPLOSION_STANDARD explosion(4, 2)
#define EXPLOSION_LARGE explosion(5, 2)
#define EXPLOSION_HUGE explosion(15, 3)

/atom/var/explosion_resistance
/atom/proc/get_explosion_resistance()
	if(simulated)
		return explosion_resistance

/turf/get_explosion_resistance()
	. = ..()
	for(var/obj/O in src)
		. += O.get_explosion_resistance()

/turf/space
	explosion_resistance = 3

/turf/simulated/floor/get_explosion_resistance()
	. = ..()
	if(is_below_sound_pressure(src))
		. *= 3

/turf/simulated/floor
	explosion_resistance = 1

/turf/simulated/mineral
	explosion_resistance = 2

/turf/simulated/shuttle/wall
	explosion_resistance = 10

/turf/simulated/wall
	explosion_resistance = 10

/obj/machinery/door/get_explosion_resistance()
	if(!density)
		return 0
	else
		return ..()

/**

Wrapper method for /turf/explosion, allowing you to call explosion() on any atom, and have it auto-forward to the turf it's on.

*/

/atom/proc/explosion(radius, max_power=3, adminlog=TRUE)
	var/turf/T = get_turf(src)
	T.explosion(radius,max_power,adminlog)

/**
Method to create an explosion at a given turf.
*/

/turf/explosion(radius, max_power=3, adminlog = TRUE)
	if(adminlog)
		message_admins("Explosion with size ([radius]) in area [get_area(src).name] ([x],[y],[z]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)")
		log_game("Explosion with size ([radius]) in area [get_area(src).name] ")
	set_extension(src, /datum/extension/explosion, radius, max_power)

/**

Method to spawn explosion particles.
@param epicenter -> The epicenter of the explosion, where you want the kaboom to emanate from
@param max_range -> The maximum audible range of the explosion
@param explosion_sound -> The sound the explosion shall play
@param use_smoke -> Whether or not to spawn smoke particles with this explosion.

*/
proc/explosion_FX(turf/epicenter, max_range, explosion_sound=get_sfx("explosion"), use_smoke=TRUE)
	set waitfor = FALSE //Gotta go fast
	max_range += world.view
	var/datum/effect/system/explosion/E = new/datum/effect/system/explosion()
	E.set_up(epicenter, use_smoke)
	E.start()


	for(var/mob/M in GLOB.player_list)
		if(M.z == epicenter.z)
			var/turf/M_turf = get_turf(M)
			var/dist = get_dist(M_turf, epicenter)
			// If inside the blast radius + world.view - 2
			if(dist <= max_range)
				M.playsound_local(epicenter, explosion_sound , VOLUME_MAX, 1) // get_sfx() is so that everyone gets the same sound
			else
				var/volume = VOLUME_HIGH
				if (dist >= max_range * 2)
					volume = VOLUME_MID
				if (dist >= max_range * 3)
					volume = VOLUME_LOW
				M.playsound_local(epicenter, 'sound/effects/explosionfar.ogg', volume, 1)
		CHECK_TICK

/datum/extension/explosion
	name = "Explosion"
	base_type = /datum/extension/explosion
	expected_type = /turf
	flags = EXTENSION_FLAG_IMMEDIATE

//Prevents atoms from being hit by multiple explosion waves at once, and cuts a little bit of cost.
/atom/movable
	var/next_explosion_impact = 0

/turf
	var/next_explosion_impact = 0

/turf/proc/explosion_ripple(strength)
	set waitfor = FALSE
	if(world.time < next_explosion_impact)
		return
	next_explosion_impact = world.time + 0.45 SECONDS //Prevents getting spammed by multiple explosions and causing unecessary lag. Yeah this is a little lazy, but I'd rather not assign lists of "processed" turfs or whatever for memory's sake
	if(!istype(src, /turf/space))
		shake_animation(strength)
	for(var/atom/movable/AM in contents)
		if(world.time < AM.next_explosion_impact)
			continue
		AM.next_explosion_impact = world.time + 0.45 SECONDS
		AM.ex_act(strength)
	ex_act(strength)

/datum/extension/explosion/New(atom/parent, radius, max_power)
	.=..()
	explosion(parent, radius, max_power)

/datum/explosion_wave
	var/turf/location = null
	var/dir = null
	var/power = 0
	var/distance_travelled = 0
	var/power_cap = 0

/datum/explosion_wave/New(location, dir, power, power_cap=3)
	. = ..()
	src.location = location
	src.dir = dir
	src.power = power
	src.power_cap = power_cap/power
	START_PROCESSING(SSexplosions,src)

//Why the hell are there two definitions for process() and Process() ????
/datum/explosion_wave/Process()
	location = get_step(location, dir)
	if(!location || power <= 0)
		qdel(src)
		return PROCESS_KILL
	//Firstly, the centre turf takes a hit.
	power -= location.get_explosion_resistance() > 1 ? location.get_explosion_resistance() : (power_cap + (location.get_explosion_resistance()))
	location.explosion_ripple(explosion_power_to_ex_act(MAP(power, 0, 100, 0, 3)))
	//Secondly, we push the wave outwards from the centre turf, blocking it off as needed.
	for(var/turf/T in orange(distance_travelled, location))
		var/resistance = T.get_explosion_resistance()
		//Prevent unmitigated explosions.
		var/epower = power
		epower -= resistance ? resistance : 1
		if(epower <= 0)
			continue
		T.explosion_ripple(explosion_power_to_ex_act(MAP(epower, 0, 100, 0, 3)))

	distance_travelled ++

//Why doesn't ex_act have some kind of scaling formula rather than 3 specific stat- oh forget it. We'll just do this jank.
///Converts an explosion power to be an ex_actable power.
/proc/explosion_power_to_ex_act(adjusted)
	switch(adjusted)
		if(0 to 1)
			return 3
		if(1 to 2)
			return 2
		if(2 to 3)
			return 1

//Causes the actual explosion logic at a target turf.
/datum/extension/explosion/proc/explosion(turf/epicenter, radius, max_power=3)
	. = ..()
	explosion_FX(epicenter, radius)
	for(var/dir in GLOB.alldirs)
		new /datum/explosion_wave(epicenter, dir, radius, max_power)
	//And ensure the epicenter takes the full whack.
	epicenter.explosion_ripple(1) //All explosions are always going to hit badly at the epicenter.

//Near instant "cheap" explosion that doesn't take into account things blocking it.
/datum/extension/explosion/proc/simple_explosion(atom/movable/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog, z_transfer, shaped)
	. = ..()
	for(var/turf/T in orange(devastation_range, epicenter)) //TODO: Account for the other ranges.
		var/dist = get_dist(T, epicenter)
		dist = (dist > 0) ? dist : 1
		T.explosion_ripple(round(devastation_range/dist*dist))