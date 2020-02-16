/*
	This file contains a selection of helper functions to mount an atom onto a wall or similar dense object

	Some basic rules:
		Wallmounted atoms can face a cardinal or diagonal direction.
		Wallmounted atoms can be mounted onto any wall, or dense atom
		Wallmounted atoms must face away from the thing they are mounted on, by at least 135 degree angle


	Most of these helpers work with locations and directions, rather than with an actual atom being passed.
	This is done to accomodate virtual checking, as used in placement datums where the atom hasn't been spawned yet
*/

/datum/wallmount_parameters
	var/attach_walls	=	TRUE	//Can this be attached to wall turfs?
	var/attach_anchored	=	TRUE	//Can this be attached to anchored objects, eg heaving machinery
	var/attach_unanchored	=	TRUE	//Can this be attached to unanchored objects, like janicarts?
	var/attach_mob		=	TRUE		//Can this be attached to dense mobs, like brutes?


/*
	Attaches the subject to mountpoint
*/
/proc/mount_to_atom(var/atom/movable/subject, var/atom/mountpoint)
	subject.on_mount(mountpoint)


//Checks for a valid mount point in the specified location and facing. Returns that atom if we find one, returns null/false if there's nothing to mount to
/proc/get_wallmount_target_at_direction(var/location, var/direction,	var/datum/wallmount_parameters/WP = new())
	var/list/searchdirs = get_opposite_cardinal_directions(direction)
	var/list/searchtiles = list()
	for (var/direction2 in searchdirs)
		searchtiles.Add(get_step(location, direction2))

	return search_for_wallmount_target(searchtiles, WP)

//Checks for a valid mount point in the specified location, but in any direction. Returns that atom if we find one, returns null/false if there's nothing to mount to
/proc/get_wallmount_target_at_location(var/location, var/datum/wallmount_parameters/WP = new())
	var/list/searchtiles = list()
	for (var/direction in GLOB.cardinal)
		searchtiles.Add(get_step(location, direction))

	return search_for_wallmount_target(searchtiles, WP)

//Called to search for mount point in a list of turfs. Meant to be called by the previous functions
/proc/search_for_wallmount_target(var/list/searchtiles, var/datum/wallmount_parameters/WP = new())
	for (var/turf/T as anything in searchtiles)
		if (T.density	&& WP.attach_walls)
			return T

		for (var/atom/movable/AM as anything in T)
			if (AM.density)
				if (ismob(AM)	&&	!WP.attach_mob)
					continue
				if (!AM.anchored &&	!WP.attach_unanchored)
					continue
				if (AM.anchored &&	!WP.attach_anchored)
					continue
				return AM

	return null





//For cardinals (NSEW) simply returns the opposite
//For diagonals, returns the two cardinals around the opposite
/proc/get_opposite_cardinal_directions(var/direction)
	var/antipode = GLOB.reverse_dir[direction]
	var/list/opposites = list()
	for (var/cdir in GLOB.cardinal)
		if (antipode & cdir)
			opposites += cdir

	return opposites



//Called when this atom is mounted on mountpoint
/atom/movable/proc/on_mount(var/atom/mountpoint)