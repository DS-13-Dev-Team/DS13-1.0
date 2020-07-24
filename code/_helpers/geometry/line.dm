/proc/get_line_between(var/turf/source, var/turf/target, var/allow_diagonal = FALSE)



	var/dist_remaining = 5//hypot(world.maxx, world.maxy)	//The longest possible line across the map, as a safety
	//Must be on same zlevel
	if (source.z != target.z)
		target = locate(target.x, target.y, source.z)

	if (source == target)
		world << "Tried to find line between a turf and itself!"
		return list(source)

	var/list/line = list(source)	//Source is always in the list

	var/turf/current = source
	var/turf/next

	world << "Target is [jumplink(target)]"
	if (allow_diagonal)
		next = get_step_towards(current, target)
	else
		next = get_cardinal_step_towards(current, target)
		world << "Cardinal step gave us [jumplink(next)]"

	line += next

	while (next != target && dist_remaining)
		current = next
		//Possible Todo: This can return diagonals, break them into two steps
		if (allow_diagonal)
			next = get_step_towards(current, target)
		else
			next = get_cardinal_step_towards(current, target)
			world << "Cardinal step gave us [jumplink(next)]"

		dist_remaining--

	line += target

	return line