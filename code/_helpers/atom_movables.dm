/proc/get_turf_pixel(atom/checked_atom)
	if(!istype(checked_atom))
		return

	//Find checked_atom's matrix so we can use it's X/Y pixel shifts
	var/matrix/atom_matrix = matrix(checked_atom.transform)

	var/pixel_x_offset = checked_atom.pixel_x + atom_matrix.get_x_shift()
	var/pixel_y_offset = checked_atom.pixel_y + atom_matrix.get_y_shift()

	//Irregular objects
	var/icon/checked_atom_icon = icon(checked_atom.icon, checked_atom.icon_state)
	var/checked_atom_icon_height = checked_atom_icon.Height()
	var/checked_atom_icon_width = checked_atom_icon.Width()
	if(checked_atom_icon_height != world.icon_size || checked_atom_icon_width != world.icon_size)
		pixel_x_offset += ((checked_atom_icon_width / world.icon_size) - 1) * (world.icon_size * 0.5)
		pixel_y_offset += ((checked_atom_icon_height / world.icon_size) - 1) * (world.icon_size * 0.5)

	//DY and DX
	var/rough_x = round(round(pixel_x_offset, world.icon_size) / world.icon_size)
	var/rough_y = round(round(pixel_y_offset, world.icon_size) / world.icon_size)

	//Find coordinates
	var/turf/atom_turf = get_turf(checked_atom) //use checked_atom's turfs, as it's coords are the same as checked_atom's AND checked_atom's coords are lost if it is inside another atom
	if(!atom_turf)
		return null
	var/final_x = atom_turf.x + rough_x
	var/final_y = atom_turf.y + rough_y

	if(final_x || final_y)
		return locate(final_x, final_y, atom_turf.z)

// Walks up the loc tree until it finds a holder of the given holder_type
/proc/get_holder_of_type(atom/A, holder_type)
	if(!istype(A)) return
	for(A, A && !istype(A, holder_type), A=A.loc);
	return A

/atom/movable/proc/throw_at_random(var/include_own_turf, var/maxrange, var/speed)
	var/list/turfs = RANGE_TURFS(src, maxrange)
	if(!maxrange)
		maxrange = 1

	if(!include_own_turf)
		turfs -= get_turf(src)
	src.throw_at(pick(turfs), maxrange, speed, src)
