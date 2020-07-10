//Returns the number of crewmembers that have existed this round. This includes the living and the dead
/proc/get_historic_crew_total()
	return GLOB.all_crew.len

//Returns the number of live crewmembers
/proc/get_living_crew_total()
	return GLOB.living_crew.len
