/proc/HasAbove(z)
	return SSmapping.multiz_levels[z]["[UP]"]

/proc/HasBelow(z)
	return SSmapping.multiz_levels[z]["[DOWN]"]

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(atom/atom)
	return get_step_multiz(atom, UP)

/proc/GetBelow(atom/atom)
	return get_step_multiz(atom, DOWN)

/proc/GetSolidBelow(atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	if(!turf.is_hole)
		return turf
	if(!turf_clear(turf))
		return turf

	return HasBelow(turf.z) ? GetSolidBelow(get_step(turf, DOWN)) : null

/proc/GetConnectedZlevels(z)
	. = list(z)
	var/level = z
	while(SSmapping.multiz_levels.len <= level && SSmapping.multiz_levels.len > 0)
		if(SSmapping.multiz_levels[level]["[DOWN]"])
			. |= level--
	level = z
	while(SSmapping.multiz_levels.len <= level && SSmapping.multiz_levels.len > 0)
		if(SSmapping.multiz_levels[level]["[UP]"])
			. |= level++

/proc/AreConnectedZLevels(zA, zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)