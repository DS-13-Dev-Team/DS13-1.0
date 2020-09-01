
/obj/effect/particle_system
	mouse_opacity = 0
	opacity = FALSE
	density = FALSE
	dir = NORTH
	var/duration = 3 SECONDS
	var/angle
	var/vector2/direction
	var/atom/origin
	var/tick_delay = 0.2 SECONDS
	var/particles_per_tick = 3
	var/particle_lifetime = 0.85 SECONDS
	var/particle_travel_distance = 3
	var/particle_type = /obj/effect/particle
	var/particle_color
	var/randpixel = 5
	var/autostart = TRUE

/obj/effect/particle_system/New(var/atom/host, var/direction, var/duration, var/particle_travel_distance, var/angle)
	origin = host
	src.direction = direction
	if (duration)
		src.duration = duration
	if (particle_travel_distance)
		src.particle_travel_distance = particle_travel_distance
	if (angle)
		src.angle = angle
	.=..()

/obj/effect/particle_system/Initialize()
	.=..()
	if (autostart)
		spawn()
			start()


/obj/effect/particle_system/proc/start()
	addtimer(CALLBACK(src, /obj/effect/particle_system/proc/end), duration)
	tick()

/obj/effect/particle_system/proc/end()
	qdel(src)

/obj/effect/particle_system/proc/tick()
	if (loc != origin.loc)
		forceMove(origin.loc)

	for (var/i in 1 to particles_per_tick)
		spawn_particle()
	addtimer(CALLBACK(src, /obj/effect/particle_system/proc/tick), tick_delay)

/obj/effect/particle_system/proc/set_direction(var/vector2/new_direction)
	if (!direction)
		direction = new_direction.Copy()
	else
		direction.x = new_direction.x
		direction.y = new_direction.y


/obj/effect/particle_system/proc/spawn_particle()

	//Lets calculate a random angle for this particle
	var/particle_angle = rand_between(0, angle) - angle*0.5	//We subtract half the angle to centre it
	var/vector2/particle_direction = direction.Turn(particle_angle)
	var/vector2/offset = get_new_vector(rand_between(-randpixel, randpixel), rand_between(-randpixel, randpixel))
	var/obj/effect/particle/S = new particle_type(loc, particle_direction, particle_lifetime, particle_travel_distance, offset, particle_color)
	return S

/*
/obj/effect/chem_spray(var/atom/location, var/atom/host, var/initial_target)
	origin = host
	if (initial(target))


/obj/effect/chem_spray/set_target(var/vector2/target)
	target_point = target
	direction = VecDirectionBetween(origin.get_global_pixel_loc(), target)
	default_rotation = direction.Rotation()


*/
