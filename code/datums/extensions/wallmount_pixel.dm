//Is this atom a "vertical surface" which is connected to at least one other such atom?
//This can be true for walls, low walls, full tile windows, and airlocks
/atom/proc/is_connected_vertical_surface()

/turf/is_connected_vertical_surface()
	//Nonwall turfs will check the things within them
	//In addition, they return exactly which atom is the surface if they find one
	for (var/atom/A in contents)
		if (A.is_connected_vertical_surface())
			to_chat(world, "Wall found atom [A]")
			return A

/turf/simulated/wall/is_connected_vertical_surface()
	var/list/things = other_connections + wall_connections
	for (var/thing in things)
		if (thing && thing != "0")
			return src


/obj/structure/is_connected_vertical_surface()
	var/list/things = other_connections + connections
	for (var/thing in things)
		if (thing && thing != "0")
			return TRUE


/obj/machinery/door/is_connected_vertical_surface()
	var/list/things = connections
	for (var/thing in things)
		if (thing && thing != "0")
			return TRUE

/*Possible future todo:
	Low walls
	Grilles
	Wall frames
	Vending Machines
*/

/datum/extension/mount
	var/vector2/pixel_offset

/datum/extension/mount/proc/adjust_pixel_offset()
	to_chat(world, "adjust_pixel_offset")
	if (pixel_offset)
		release_vector(pixel_offset)
	//Get a vector for the direction perpendicular to us
	var/vector2/direction = Vector2.NewFromDir(turn(mount_facing_dir, 90))

	//Grab our two adjacent tiles along that perpendicular axis
	var/turf/neighbor1 = locate(mountpoint.x + direction.x, mountpoint.y + direction.y, mountpoint.z)
	var/turf/neighbor2 = locate(mountpoint.x - direction.x, mountpoint.y - direction.y, mountpoint.z)

	var/filled_1 = neighbor1.is_connected_vertical_surface()
	var/filled_2 = neighbor2.is_connected_vertical_surface()

	//What direction will we offset? By default, towards neighbor 1
	var/offset_direction = 1

	if (!filled_1 && !filled_2)
		//We are on an island as far as perpendicular connections go.
		//Possible future todo: Squeeze ourselves a little to fit better?
		//We cant move anywhere, so we're done
		to_chat(world, "No neighbor walls, returning")
		return

	else if (filled_1 && filled_2)
		//We're on a long section of wall. This is fine, do nothing
		to_chat(world, "Both neighbor walls, returning")
		return
	else if (filled_2)
		//only 2 is filled, so we move towards it
		to_chat(world, "Only wall 2 is filled")
		offset_direction = -1
	else
		to_chat(world, "Only wall 1 is filled")

	//How far are we going to move in the desired direction? This is just hardcoded for now, maybe do something better in future
	//We offset by different amounts on X and Y axes because more vertical offset is needed to look right on our isometric walls
	var/offset_multiplier_x = 0.1875 * WORLD_ICON_SIZE //About 6 pixels
	var/offset_multiplier_y = 0.375 * WORLD_ICON_SIZE //About 12 pixels


	pixel_offset = direction * (offset_direction)
	mountee.default_pixel_x += pixel_offset.x * offset_multiplier_x
	mountee.default_pixel_y += pixel_offset.y * offset_multiplier_y

	release_vector(direction)