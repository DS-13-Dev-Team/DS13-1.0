//Returns the number of crewmembers that have existed this round. This includes the living and the dead
/proc/get_historic_crew_total()
	return GLOB.all_crew.len

//Returns the number of alive humans aboard Ishimura
/proc/get_living_crew_total()
	var/crew_count = 0
	for(var/datum/mind/M in GLOB.living_crew)
		if(!M || QDELETED(M.current) || !ishuman(M.current))	//regular sanity checks
			continue
		var/mob/living/L = M.current
		if(!L.client || L.stat == DEAD || !isStationLevel(L.z))	//only count alive active humans onboard Ishimura, the rest are marooned
			continue
		crew_count++

	return crew_count

/*
	Returns a list of all living crewmembers whose role fits the filter
	If role type is true, checks special role (AKA, antag status)
	If false, checks assigned job
*/
//Option sets either to check assigned role or special role. Default to assigned.
/proc/find_targets_by_role(role, role_type=0)
	. = list()
	for(var/datum/mind/possible_target in ticker.minds)
		if(((role_type ? possible_target.special_role : possible_target.assigned_role) == role) )
			. += possible_target