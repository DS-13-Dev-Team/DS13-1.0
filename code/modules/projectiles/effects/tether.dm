//----------------------------
// Sustained tracer beams
//----------------------------
//There is some special code here
/obj/effect/projectile/tether
	light_outer_range = 5
	light_max_bright = 1
	light_color = COLOR_DEEP_SKY_BLUE
	icon_state = "gravity_tether"

	//Start and endpoints are in world pixel coordinates
	var/vector2/start = new /vector2(0,0)
	var/vector2/end = new /vector2(0,0)
	var/vector2/start_offset = new /vector2(0,0)
	var/vector2/end_offset = new /vector2(0,0)

	animate_movement = 0
	lifespan = 0
	var/base_length = WORLD_ICON_SIZE

	atom_flags = ATOM_FLAG_INTANGIBLE
	obj_flags = OBJ_FLAG_INVINCIBLE

	//Optional. If set, we will track movements of the origin atom, regularly setting start to it
	var/atom/movable/origin_atom
	var/atom/movable/target_atom

/obj/effect/projectile/tether/New()
	//Only physical tethers can be clicked on
	if (atom_flags & ATOM_FLAG_INTANGIBLE)
		mouse_opacity = 0
	.=..()

/obj/effect/projectile/tether/proc/set_origin(var/atom/neworigin)
	origin_atom = neworigin
	GLOB.moved_event.register(origin_atom, src, /obj/effect/projectile/tether/proc/origin_moved)

/obj/effect/projectile/tether/proc/origin_moved()
	var/vector2/newstart = origin_atom.get_global_pixel_loc()
	set_ends(newstart, end, 3, 1)
	release_vector(newstart)

/obj/effect/projectile/tether/proc/set_target(var/atom/newtarget)
	target_atom = newtarget
	GLOB.moved_event.register(target_atom, src, /obj/effect/projectile/tether/proc/target_moved)

/obj/effect/projectile/tether/proc/target_moved()
	var/vector2/newend = target_atom.get_global_pixel_loc()
	set_ends(start, newend, 3, 2)
	release_vector(newend)

//Takes start and endpoint as vector2s of global pixel coords
//The animate var should be either FALSE for instant, or a number of deciseconds for how long the animation should take
//apply offset values0 = neither, 1= start only, 2 = end only, 3 = both
/obj/effect/projectile/tether/proc/set_ends(var/vector2/_start = null, var/vector2/_end = null, var/animate = FALSE, var/apply_offset = 3)
	//We copy the passed start and end vars into our own, without modifying the passed ones
	start.x = _start.x
	start.y = _start.y
	if (apply_offset == 1 || apply_offset == 3)
		start.SelfAdd(start_offset)

	end.x = _end.x
	end.y = _end.y
	if (apply_offset == 2 || apply_offset == 3)
		end.SelfAdd(end_offset)

	var/matrix/M = matrix()

	//Get the vector between them first
	var/vector2/delta = end - start

	//Figuring out scale
	var/length = delta.Magnitude()
	var/scale = abs(length / base_length) //The length of the beam
	M.Scale(scale, 1)

	//Now rotation
	var/rot = Atan2(delta.y, delta.x)
	M.Turn(rot-90)

	//Delta is now the pixel loc where we need to place ourselves
	delta.SelfMultiply(0.5)
	//delta.SelfAdd(start_offset)
	delta.SelfAdd(start)
	if (!animate)
		//Apply the transform to ourselves
		transform = M

		//And finally, place our location halfway along the delta line

		set_global_pixel_loc(delta)

	else
		var/vector2/move_offset = get_global_pixel_offset_from_vector(delta)
		move_offset.SelfMultiply(-1)
		animate(src, transform = M, pixel_x = pixel_x + move_offset.x, pixel_y = pixel_y + move_offset.y, time = (animate-1))
		release_vector(move_offset)

	release_vector(delta)

/obj/effect/projectile/tether/Destroy()
	if (start)
		release_vector(start)
	if (end)
		release_vector(end)
	if (start_offset)
		release_vector(start_offset)
	if (end_offset)
		release_vector(end_offset)
	if (origin_atom)
		GLOB.moved_event.unregister(origin_atom, src, /obj/effect/projectile/tether/proc/origin_moved)
		origin_atom = null
	if (target_atom)
		GLOB.moved_event.unregister(target_atom, src, /obj/effect/projectile/tether/proc/target_moved)
		target_atom = null
	.=..()


/obj/effect/projectile/tether/proc/retract(var/time = 1 SECOND, var/delete_on_finish = TRUE, var/steps = 3)
	set waitfor = FALSE
	//We'll retract the tongue to 1 pixel away from its origin
	//This is done in several steps to prevent visual glitches
	var/vector2/tether_direction = end - start
	var/magnitude = tether_direction.Magnitude()



	var/step_time = time / steps
	var/step_percent = 1 / steps
	if (delete_on_finish)
		QDEL_IN(src, time+1)
	for (var/i = 1; i <= steps; i++)
		var/vector2/delta = tether_direction.ToMagnitude(max(1,magnitude * (1 - (i * step_percent))))
		var/vector2/temp_end = start + delta
		set_ends(start, temp_end, step_time, apply_offset = FALSE)
		release_vector(delta)
		release_vector(temp_end)
		sleep(step_time)














/*
	Damage Procs
	These are somewhat temporary, eventually we'll have unified object damage
*/


// When destroyed by explosions, properly handle contents.
/obj/effect/projectile/tether/ex_act(severity, var/atom/epicentre)
	switch(severity)
		if(1.0)
			for(var/atom/movable/AM in contents)
				AM.ex_act(severity++, epicentre)

			take_damage(rand(150,300), BRUTE, null, epicentre)
		if(2.0)
			if(prob(50))
				for(var/atom/movable/AM in contents)
					AM.ex_act(severity++, epicentre)

			take_damage(rand(60,150), BRUTE, null, epicentre)

		if(3.0)
			take_damage(rand(25,60), BRUTE, null, epicentre)

/obj/effect/projectile/tether/bullet_act(var/obj/item/projectile/P)
	take_damage(P.get_structure_damage(), user = P.firer, used_weapon = P)
	if (health > 0)
		return FALSE
	return TRUE


/obj/effect/projectile/tether/attackby(var/obj/item/C, var/mob/user)
	if (!(obj_flags & OBJ_FLAG_INVINCIBLE))
		playsound(src, C.hitsound, VOLUME_MID, 1)
		user.do_attack_animation(src)
		take_damage(C.force, C.damtype, user, C)
		user.set_click_cooldown(DEFAULT_ATTACK_COOLDOWN)
		return
	.=..()

/obj/effect/projectile/tether/hitby(AM as mob|obj, var/speed=THROWFORCE_SPEED_DIVISOR)
	..()
	if(ismob(AM))
		return
	var/obj/O = AM
	var/tforce = O.throwforce * (speed/THROWFORCE_SPEED_DIVISOR)

	take_damage(tforce, BRUTE, O.thrower, O)

//Called when a structure takes damage
/obj/effect/projectile/tether/proc/take_damage(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist = FALSE)
	if ((obj_flags & OBJ_FLAG_INVINCIBLE))
		return

	//if (!bypass_resist)
		//amount -= resistance

	if (amount <= 0)
		return 0

	health -= amount

	if (health <= 0)
		health = 0
		return zero_health(amount, damtype, user, used_weapon, bypass_resist)//Some zero health overrides do things with a return value
	else
		update_icon()
		return amount

/obj/effect/projectile/tether/proc/updatehealth()
	if (health <= 0)
		health = 0
		return zero_health()

//Called when health drops to zero. Parameters are the params of the final hit that broke us, if this was called from take_damage
/obj/effect/projectile/tether/proc/zero_health(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist)
	if ((!obj_flags & OBJ_FLAG_INVINCIBLE))
		qdel(src)
	return TRUE

/obj/effect/projectile/tether/repair(var/repair_power, var/datum/repair_source, var/mob/user)
	health = clamp(health+repair_power, 0, max_health)
	updatehealth()
	update_icon()