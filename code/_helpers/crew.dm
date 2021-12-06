//Returns the number of crewmembers that have existed this round. This includes the living and the dead
/proc/get_historic_crew_total()
	return GLOB.all_crew.len

//Returns the number of live crewmembers
/proc/get_living_crew_total()
	return GLOB.living_crew.len

/*
	Returns a list of all living crewmembers whose role fits the filter
	If role type is true, checks special role (AKA, antag status)
	If false, checks assigned job
*/
//Option sets either to check assigned role or special role. Default to assigned.
/proc/find_targets_by_role(role, role_type=0)
	. = list()
	for(var/datum/mind/possible_target in GLOB.minds)
		if(((role_type ? possible_target.special_role : possible_target.assigned_role) == role) )
			. += possible_target



/*
	This aggregate proc gives you a big list of all crew data
*/
/proc/get_crew_totals()
	var/list/crewlist = list()
	for (var/datum/mind/M as anything in GLOB.all_crew)
		LAZYAPLUS(crewlist, "total", 1)
		var/status = M.get_round_status()
		if (status)
			LAZYAPLUS(crewlist, status, 1)

	return crewlist


/atom/proc/has_escaped()
	var/area/A = get_area(src)
	if(A)
		if (is_type_in_list(A, GLOB.using_map.post_round_safe_areas))
			return TRUE

		//Shuttle handling
		if (istype(A, /area/shuttle))
			var/area/shuttle/AS = A
			if (AS.has_escaped())
				return TRUE