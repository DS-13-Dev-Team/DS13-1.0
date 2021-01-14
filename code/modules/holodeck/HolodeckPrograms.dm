
/datum/holodeck_program
	var/target
	var/list/ambience = null

/datum/holodeck_program/New(var/target, list/ambience = null)
	src.target = target
	src.ambience = ambience
