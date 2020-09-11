/*
	This file contains a selection of helper functions to mount an atom onto a wall or similar dense object

	Some basic rules:
		mounted atoms can face a cardinal or diagonal direction.
		mounted atoms can be mounted onto any wall, or dense atom
		mounted atoms must face away from the thing they are mounted on, by at least 135 degree angle


	Most of these helpers work with locations and directions, rather than with an actual atom being passed.
	This is done to accomodate virtual checking, as used in placement datums where the atom hasn't been spawned yet
*/

/datum/mount_parameters
	var/attach_walls	=	TRUE	//Can this be attached to wall turfs?
	var/attach_anchored	=	TRUE	//Can this be attached to anchored objects, eg heaving machinery
	var/attach_unanchored	=	TRUE	//Can this be attached to unanchored objects, like janicarts?
	var/dense_only = TRUE	//If true, only sticks to dense atoms
	var/attach_mob_standing		=	TRUE		//Can this be attached to mobs, like brutes?
	var/attach_mob_downed		=	TRUE	//Can this be/remain attached to mobs that are lying down?
	var/attach_mob_dead	=	FALSE	//Can this be/remain attached to mobs that are dead?

/*
	Attaches the subject to mountpoint
*/
/proc/mount_to_atom(var/atom/movable/subject, var/atom/mountpoint, var/mount_type = /datum/extension/mount, var/datum/mount_parameters/WP = new())
	set_extension(subject, mount_type, mountpoint, WP)


//Checks for a valid mount point in the specified location and facing. Returns that atom if we find one, returns null/false if there's nothing to mount to
/proc/get_mount_target_at_direction(var/location, var/direction,	var/datum/mount_parameters/WP = new())
	var/list/searchdirs = get_opposite_cardinal_directions(direction)
	var/list/searchtiles = list()
	for (var/direction2 in searchdirs)
		searchtiles.Add(get_step(location, direction2))

	return search_for_mount_target(searchtiles, WP)

//Checks for a valid mount point in the specified location, but in any direction. Returns that atom if we find one, returns null/false if there's nothing to mount to
/proc/get_mount_target_at_location(var/location, var/datum/mount_parameters/WP = new())
	var/list/searchtiles = list()
	for (var/direction in GLOB.cardinal)
		searchtiles.Add(get_step(location, direction))

	return search_for_mount_target(searchtiles, WP)

//Called to search for mount point in a list of turfs. Meant to be called by the previous functions
/proc/search_for_mount_target(var/list/searchtiles, var/datum/mount_parameters/WP = new())
	for (var/turf/T as anything in searchtiles)
		if (is_valid_mount_target(T, WP))
			return T

		for (var/atom/movable/AM in T)
			if(is_valid_mount_target(AM, WP))
				return AM

	return null


/proc/is_valid_mount_target(var/atom/movable/AM, var/datum/mount_parameters/WP = new())
	.=FALSE
	if (QDELETED(AM))
		return
	if (isturf(AM))
		var/turf/T = AM
		if (T.density && WP.attach_walls)
			return TRUE

	if (!AM.density && WP.dense_only)
		return

	if (isliving(AM))
		var/mob/living/L = AM
		if 	(L.stat == DEAD &&	!WP.attach_mob_dead)
			return
		if (L.lying &&	!WP.attach_mob_downed)
			return
		if (!L.lying && !WP.attach_mob_standing)
			return

		return TRUE
	if (!AM.anchored &&	!WP.attach_unanchored)
		return
	if (AM.anchored &&	!WP.attach_anchored)
		return

	return TRUE


//For cardinals (NSEW) simply returns the opposite
//For diagonals, returns the two cardinals around the opposite
/proc/get_opposite_cardinal_directions(var/direction)
	var/antipode = GLOB.reverse_dir[direction]
	var/list/opposites = list()
	for (var/cdir in GLOB.cardinal)
		if (antipode & cdir)
			opposites += cdir

	return opposites





/*
	Extension to manage things
*/
/datum/extension/mount
	name = "Mount"
	base_type = /datum/extension/mount
	expected_type = /atom/movable
	flags = EXTENSION_FLAG_IMMEDIATE
	var/atom/movable/mountee
	var/atom/mountpoint
	var/vector2/offset
	var/datum/mount_parameters/WP

	//Are we currently mounted?
	var/mounted  = FALSE

	//When true, ignore the next move by the mountee, and set this back to false
	//Used when mountee is moved to sync with mountpoint
	var/ignore_mountee_move = FALSE

/datum/extension/mount/New(var/atom/holder, var/atom/target, var/datum/mount_parameters/WP = new())
	.=..()
	src.WP = WP
	mountee = holder
	mountpoint = target
	offset = get_new_vector(mountee.x - mountpoint.x,mountee.y - mountpoint.y)
	if (istype(target, /atom/movable))
		GLOB.moved_event.register(mountpoint, src, /datum/extension/mount/proc/on_mountpoint_move)
	GLOB.moved_event.register(mountee, src, /datum/extension/mount/proc/on_mountpoint_move)
	GLOB.destroyed_event.register(mountpoint, src, /datum/extension/mount/proc/on_dismount)
	GLOB.density_set_event.register(mountpoint, src, /datum/extension/mount/proc/mountpoint_updated)
	if (isliving(mountpoint))
		if (!WP.attach_mob_dead)
			GLOB.death_event.register(mountpoint, src, /datum/extension/mount/proc/mountpoint_updated)
	on_mount()

/datum/extension/mount/Destroy()
	mountpoint = null
	mountee = null
	if (offset)
		release_vector(offset)
	WP = null
	.=..()

/datum/extension/mount/proc/on_mount()
	mounted  = TRUE

//Called immediately after this atom is unmounted from mountpoint.
	//WARNING: You cannot rely on mountpoint to still exist at this time. Check it before doing anything to it
/datum/extension/mount/proc/on_dismount()
	mounted  = FALSE

/datum/extension/mount/proc/dismount()
	on_dismount()
	remove_extension(holder, src)

//Called when the atom we are mounted to moves
/datum/extension/mount/proc/on_mountpoint_move(var/atom/mover, var/oldloc, var/newloc)
	if (mounted)
		ignore_mountee_move = TRUE
		mountee.forceMove(locate(mountpoint.x + offset.x, mountpoint.y + offset.y, mountpoint.z))

/datum/extension/mount/proc/on_mountee_move(var/atom/mover, var/oldloc, var/newloc)
	if (ignore_mountee_move)
		ignore_mountee_move = FALSE
		return

	mountpoint_updated()

/datum/extension/mount/proc/mountpoint_updated()
	if (mounted)
		if (!is_valid_mount_target(mountpoint, WP))
			dismount()
			return

		var/desired_turf = locate(mountpoint.x + offset.x, mountpoint.y + offset.y, mountpoint.z)
		if (get_turf(mountee) != desired_turf)
			dismount()
			return



//Helpers
/atom/proc/is_mounted()
	var/datum/extension/mount/M = get_extension(src, /datum/extension/mount)
	if (M)
		return M

	return FALSE