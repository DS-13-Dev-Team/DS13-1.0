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
	animate_movement = 0
	lifespan = 0
	var/base_length = WORLD_ICON_SIZE

//Takes start and endpoint as vector2s of global pixel coords
//The animate var should be either FALSE for instant, or a number of deciseconds for how long the animation should take
/obj/effect/projectile/tether/proc/set_ends(var/vector2/_start = null, var/vector2/_end = null, var/animate = FALSE)
	start.x = _start.x
	start.y = _start.y

	end.x = _end.x// + offset
	end.y = _end.y


	var/matrix/M = matrix()

	//Get the vector between them first
	var/vector2/delta = end - start

	//Figuring out scale
	var/length = delta.Magnitude()
	var/scale = length / base_length //The length of the beam
	M.Scale(scale, 1)

	//Now rotation
	var/rot = Atan2(delta.y, delta.x)
	M.Turn(rot-90)

	//Delta is now the pixel loc where we need to place ourselves
	delta.SelfMultiply(0.5)
	delta.SelfAdd(offset)

	if (!animate)
		//Apply the transform to ourselves
		transform = M

		//And finally, place our location halfway along the delta line
		delta.SelfAdd(start)
		set_global_pixel_loc(delta)

	else
		animate(src, transform = M, pixel_x = pixel_x + delta.x, pixel_y = pixel_y + delta.y, time = animate)

/obj/effect/projectile/tether/Destroy()
	if (start)
		release_vector(start)
	if (end)
		release_vector(end)
	if (offset)
		release_vector(offset)
	.=..()