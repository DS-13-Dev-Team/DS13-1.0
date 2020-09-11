//Causes a mob to step one tile in a direction, and their camera goes with them
/mob/proc/lurch(var/direction, var/camera_shift = 64)
	if (!direction)
		direction = pick(GLOB.cardinal)

	if (!SelfMove(direction))
		return
	if (client)
		var/vector2/delta = Vector2.NewFromDir(direction)
		delta.SelfMultiply(camera_shift)
		animate(client, pixel_x = delta.x, pixel_y = delta.y, time = 3)
		animate(pixel_x = 0, pixel_y = 0, time = 10)


//Makes a mob unable to move under its own power. either for a limited duration or until the handler is removed
/mob/proc/root(var/duration = 0)
	return AddMovementHandler(/datum/movement_handler/root, null, duration)