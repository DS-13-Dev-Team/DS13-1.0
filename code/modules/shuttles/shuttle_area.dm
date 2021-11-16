/area/shuttle
	var/escape	=	FALSE
	//If true,this shuttle can be used to escape the ship/station
	//When false, this is just a transit shuttle for moving between map areas


/area/shuttle/escape
	escape	=	TRUE


//This returns true if this shuttle is currently acting as a valid escape vehicle. IE, it could theoretically be moving people to safety right now
/area/shuttle/has_escaped()

	if (!escape)
		return FALSE	//Invalid shuttle

	var/datum/shuttle/S = 	get_shuttle_datum()
	if (!S)
		return FALSE

	//If its moving, its cool
	if (S.moving_status == SHUTTLE_INTRANSIT)
		return TRUE

	//If its docked at an escape area, its cool
	if (S.current_location?.escape)
		return TRUE

	return FALSE

//Finds a shuttle datum associated with this area
//There should only be one unless someone screwed up
/area/shuttle/proc/get_shuttle_datum()

	for (var/id in SSshuttle.shuttles)
		var/datum/shuttle/S = SSshuttle.shuttles[id]

		if (islist(S.shuttle_area))
			for (var/area/A in S.shuttle_area)
				if (A == src)
					return S


	return null