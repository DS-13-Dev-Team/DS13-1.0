//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101

	var/landmark_tag
	//ID of the controller on the dock side
	var/datum/computer/file/embedded_program/docking/docking_controller
	//ID of controller used for this landmark for shuttles with multiple ones.
	var/list/special_dock_targets

	//when the shuttle leaves this landmark, it will leave behind the base area
	//also used to determine if the shuttle can arrive here without obstruction
	var/area/base_area
	//Will also leave this type of turf behind if set.
	var/turf/base_turf
	//If true, will set base area and turf type to same as where it was spawned at
	//if -1, will overwrite these only if not set
	var/autoset


	var/escape	= FALSE	//If true, this destination is located in a designated escape zone. Any humans aboard a shuttle at this location are considered safe

/obj/effect/shuttle_landmark/Initialize()
	. = ..()
	if(autoset)
		if(autoset == TRUE || (autoset == -1 && !base_area))
			base_area = get_area(src)
		var/turf/T = get_turf(src)
		if(T && (autoset == TRUE || (autoset == -1 && !base_area)))
			base_turf = T.type

	//If the base area is null or a typepath after the above, lets initialize it
	if (!istype(base_area))
		base_area = locate(base_area || world.area)

	SetName(name + " ([x],[y])")

	if(docking_controller)
		var/docking_tag = docking_controller
		docking_controller = locate(docking_tag)
		if(!istype(docking_controller))
			log_debug("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")

	SSshuttle.register_landmark(landmark_tag, src)

/obj/effect/shuttle_landmark/proc/is_valid(var/datum/shuttle/shuttle)
	if(shuttle.current_location == src)
		return FALSE
	for(var/area/A in shuttle.shuttle_area)
		var/list/translation = get_turf_translation(get_turf(shuttle.current_location), get_turf(src), A.contents)
		if(check_collision(base_area, list_values(translation)))
			return FALSE
	return TRUE

/proc/check_collision(area/target_area, list/target_turfs)
	for(var/target_turf in target_turfs)
		var/turf/target = target_turf
		if(!target)
			message_admins("Edge of map")
			return TRUE //collides with edge of map

		if(target.loc != target_area)
			message_admins("Area collision ([target.loc] & [target_area])")
			return TRUE //collides with another area
		if(target.density)
			message_admins("Dense turf")
			return TRUE //dense turf
	return FALSE
