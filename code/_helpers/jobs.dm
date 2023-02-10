/proc/guest_jobbans(var/job)
	return ((job in GLOB.command_positions) || (job in GLOB.nonhuman_positions) || (job in GLOB.security_positions))

/proc/get_alternate_titles(var/job)
	for(var/datum/job/J as anything in SSjobs.occupations)
		if(J.title == job)
			return J.alt_titles
