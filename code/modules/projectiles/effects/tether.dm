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
	var/vector2/offset = new /vector2(0,0)
	//var/offset_apply = 1	//0 = end only, 1 = start only, 2 = both
	animate_movement = 0
	lifespan = 0
	var/base_length = WORLD_ICON_SIZE


	//Optional. If set, we will track movements of the origin atom, regularly setting start to it
	var/atom/movable/origin_atom
	var/atom/movable/target_atom

/obj/effect/projectile/tether/proc/set_origin(var/atom/neworigin)
	origin_atom = neworigin
	GLOB.moved_event.register(origin_atom, src, /obj/effect/projectile/tether/proc/origin_moved)

/obj/effect/projectile/tether/proc/origin_moved()
	var/vector2/newstart = origin_atom.get_global_pixel_loc()
	set_ends(newstart, end, 3)
	release_vector(newstart)

/obj/effect/projectile/tether/proc/set_target(var/atom/newtarget)
	target_atom = newtarget
	GLOB.moved_event.register(target_atom, src, /obj/effect/projectile/tether/proc/target_moved)

/obj/effect/projectile/tether/proc/target_moved()
	var/vector2/newstart = target_atom.get_global_pixel_loc()
	set_ends(newstart, end, 3)
	release_vector(newstart)

//Takes start and endpoint as vector2s of global pixel coords
//The animate var should be either FALSE for instant, or a number of deciseconds for how long the animation should take
/obj/effect/projectile/tether/proc/set_ends(var/vector2/_start = null, var/vector2/_end = null, var/animate = FALSE, var/apply_offset = TRUE)

	//We copy the passed start and end vars into our own, without modifying the passed ones
	start.x = _start.x
	start.y = _start.y
	if (apply_offset)
		start.SelfAdd(offset)

	end.x = _end.x// + offset
	end.y = _end.y

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
	//delta.SelfAdd(offset)
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
	if (offset)
		release_vector(offset)
	if (origin_atom)
		GLOB.moved_event.unregister(origin_atom, src, /obj/effect/projectile/tether/proc/origin_moved)
		origin_atom = null
	if (target_atom)
		GLOB.moved_event.unregister(target_atom, src, /obj/effect/projectile/tether/proc/target_moved)
		target_atom = null
	.=..()


/obj/effect/projectile/tether/proc/retract(var/time = 1 SECOND, var/delete_on_finish = TRUE)

	//We'll retract the tongue to 1 pixel away from its origin
	var/vector2/tether_direction = start - end
	tether_direction.SelfNormalize()
	tether_direction.SelfAdd(start)
	set_ends(start, tether_direction, time, apply_offset = FALSE)
	if (delete_on_finish)
		QDEL_IN(src, time+1)