/*
	Individual Particle
*/
/obj/effect/particle
	name = "particle"
	mouse_opacity = 0
	opacity = FALSE
	density = FALSE
	dir = NORTH

	var/vector2/destination_pixels
	var/vector2/origin_pixels

	var/scale_x_start = 	1
	var/scale_y_start = 	1
	var/alpha_start	=	255

	var/scale_x_end = 	1
	var/scale_y_end = 	1
	var/alpha_end	=	0

	var/matrix/target_transform

	var/lifespan	=	1 SECOND
	var/vector2/direction

/obj/effect/particle/New(var/location, var/vector2/direction, var/lifespan, var/range, var/vector2/offset, var/color)
	//Set starting pixel offset
	if (offset)
		pixel_x = offset.x
		pixel_y = offset.y

	//Rotate towards facing direction
	src.direction = direction
	if (direction)
		transform = direction.Rotation()

	if (color)
		src.color = color

	//Set starting scale
	transform.Scale(scale_x_start, scale_y_start)

	//Setup expiration
	src.lifespan = lifespan
	QDEL_IN(src, lifespan)

	//Lets calculate the destination pixel_loc
	origin_pixels = get_global_pixel_loc()
	destination_pixels = origin_pixels + (direction * (range * WORLD_ICON_SIZE))


	//And the transform we'll eventually transition to
	target_transform = matrix(transform)
	target_transform.Scale(scale_x_end, scale_y_end)
	.=..()

/obj/effect/particle/Initialize()
	.=..()
	var/vector2/pixel_delta = destination_pixels - origin_pixels

	//Lets start the animation!
	animate(src,
	pixel_x = pixel_x+pixel_delta.x,
	pixel_y = pixel_y+pixel_delta.y,
	transform = target_transform,
	alpha = alpha_end,
	time = lifespan,
	flags = ANIMATION_LINEAR_TRANSFORM)

