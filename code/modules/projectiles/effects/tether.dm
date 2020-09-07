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


	//Optional. If set, we will track movements of the origin atom, regularly setting start to it
	var/atom/movable/origin_atom
	var/atom/movable/target_atom


	unbreakable = TRUE

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
	world << "Calling set ends"
	//We copy the passed start and end vars into our own, without modifying the passed ones
	start.x = _start.x
	start.y = _start.y
	if (apply_offset == 1 || apply_offset == 3)
		world << "Applying start offset [vstr(start_offset)]"
		start.SelfAdd(start_offset)

	end.x = _end.x
	end.y = _end.y
	if (apply_offset == 2 || apply_offset == 3)
		world << "Applying end offset [vstr(end_offset)]"
		end.SelfAdd(end_offset)
	else
		world << "Not applying end offset"

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

	//We'll retract the tongue to 1 pixel away from its origin
	//This is done in several steps to prevent visual glitches
	var/vector2/tether_direction = end - start
	var/magnitude = tether_direction.Magnitude()



	var/step_time = time / steps
	var/step_percent = 1 / steps
	world << "Retracting, [steps]. steptime [step_time], percent [step_percent] dir [vstr(tether_direction)], magnitude [magnitude]"
	for (var/i = 1; i <= steps; i++)
		var/vector2/delta = tether_direction.ToMagnitude(max(1,magnitude * (1 - (i * step_percent))))
		var/vector2/temp_end = start + delta
		world << "Retraction step [i], Start [vstr(start)] endpoint [vstr(temp_end)] delta [vstr(delta)]"
		set_ends(start, temp_end, step_time-0.5, apply_offset = FALSE)
		release_vector(delta)
		release_vector(temp_end)
	if (delete_on_finish)
		QDEL_IN(src, time+1)

/obj/effect/projectile/tether/attackby(var/obj/item/C, var/mob/user)
	if (!unbreakable)
		playsound(src, C.hitsound, VOLUME_MID, 1)
		user.do_attack_animation(src)
		take_damage(C.force, C.damtype, user, C)
		user.set_click_cooldown(DEFAULT_ATTACK_COOLDOWN)
		return
	.=..()