//Takes click params as input, returns a list of global x and y pixel offsets, from world zero
/proc/get_screen_pixel_click_location(var/params)
	var/screen_loc = params2list(params)["screen-loc"]
	/* This regex matches a screen-loc of the form
			"[tile_x]:[step_x],[tile_y]:[step_y]"
		given by the "params" argument of the mouse events.
	*/
	var global/regex/ScreenLocRegex = regex("(\\d+):(\\d+),(\\d+):(\\d+)")
	var/vector2/position = new /vector2(0,0)
	if(ScreenLocRegex.Find(screen_loc))
		var list/data = ScreenLocRegex.group
		//position.x = text2num(data[2]) + (text2num(data[1])) * world.icon_size
		//position.y = text2num(data[4]) + (text2num(data[3])) * world.icon_size

		position.x = text2num(data[2]) + (text2num(data[1]) - 1) * world.icon_size
		position.y = text2num(data[4]) + (text2num(data[3]) - 1) * world.icon_size

	return position


//Gets a global-context pixel location. This requires a client to use
/proc/get_global_pixel_click_location(var/params, var/client/client)
	var/vector2/world_loc = new /vector2(0,0)
	if (!client)
		return world_loc

	world_loc = get_screen_pixel_click_location(params)
	world_loc = client.ViewportToWorldPoint(world_loc)
	return world_loc


/atom/proc/get_global_pixel_loc()
	return new /vector2(((x-1)*world.icon_size) + pixel_x + 16, ((y-1)*world.icon_size) + pixel_y + 16)



//Given a set of global pixel coords as input, this moves the atom and sets its pixel offsets so that it sits exactly on the specified point
/atom/movable/proc/set_global_pixel_loc(var/vector2/coords)

	var/vector2/tilecoords = new /vector2(round(coords.x / world.icon_size)+1, round(coords.y / world.icon_size)+1)
	forceMove(locate(tilecoords.x, tilecoords.y, z))
	pixel_x = (coords.x % world.icon_size)-16
	pixel_y = (coords.y % world.icon_size)-16


//Takes pixel coordinates relative to a tile. Returns true if those coords would offset an object to outside the tile
/proc/is_outside_cell(var/vector2/newpix)
	if (newpix.x < -16 || newpix.x > 16 || newpix.y < -16 || newpix.y > 16)
		return TRUE

//Takes pixel coordinates relative to a tile. Returns true if those coords would offset an object to more than 8 pixels into an adjacent tile
/proc/is_far_outside_cell(var/vector2/newpix)
	if (newpix.x < -24 || newpix.x > 24 || newpix.y < -24 || newpix.y > 24)
		return TRUE

//Returns the turf over which the mob's view is centred. Only relevant if view offset is set
/mob/proc/get_view_centre()
	if (!view_offset)
		return get_turf(src)

	var/vector2/offset = (Vector2.FromDir(dir))*view_offset
	return get_turf_at_pixel_offset(offset)



//Given a pixel offset relative to this atom, finds the turf under the target point.
//This does not account for the object's existing pixel offsets, roll them into the input first if you wish
/atom/proc/get_turf_at_pixel_offset(var/vector2/newpix)
	//First lets just get the global pixel position of where this atom+newpix is
	var/vector2/new_global_pixel_loc = new /vector2(((x-1)*world.icon_size) + newpix.x + 16, ((y-1)*world.icon_size) + newpix.y + 16)

	return get_turf_at_pixel_coords(new_global_pixel_loc, z)



//Global version of the above, requires a zlevel to check on
/proc/get_turf_at_pixel_coords(var/vector2/coords, var/zlevel)
	coords = new /vector2(round(coords.x / world.icon_size)+1, round(coords.y / world.icon_size)+1)
	return locate(coords.x, coords.y, zlevel)



//Client Procs

//This proc gets the client's total pixel offset from its eyeobject
/client/proc/get_pixel_offset()
	var/vector2/offset = new /vector2(0,0)
	if (ismob(eye))
		var/mob/M = eye
		offset = (Vector2.FromDir(M.dir))*M.view_offset

	offset.x += pixel_x
	offset.y += pixel_y

	return offset


//Figures out the offsets of the bottomleft and topright corners of the game window
/client/proc/get_pixel_bounds()
	var/radius = view*world.icon_size
	var/vector2/bottomleft = new /vector2(-radius, -radius)
	var/vector2/topright = new /vector2(radius, radius)
	var/vector2/offset = get_pixel_offset()
	bottomleft += offset
	topright += offset

	return list("BL" = bottomleft, "TR" = topright, "OFFSET" = offset)


//Figures out the offsets of the bottomleft and topright corners of the game window in tiles
//There are no decimal tiles, it will always be a whole number. Partially visible tiles can be included or excluded
/client/proc/get_tile_bounds(var/include_partial = TRUE)
	var/list/bounds = get_pixel_bounds()
	for (var/thing in bounds)
		var/vector2/corner = bounds[thing]
		corner /= WORLD_ICON_SIZE
		if (include_partial)
			corner = corner.CeilingVec()
		else
			corner = corner.FloorVec()
		bounds[thing] = corner
	return bounds