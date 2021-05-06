/*
	Returns true if the mob is a crewmember, or a "good guy" antagonist (kellion repair crew, EDF marines, etc)
*/
/mob/proc/is_crew_aligned()
	return FALSE


/mob/living/carbon/human/is_crew_aligned()
	if (is_necromorph())
		return FALSE

	//TODO future: Finish this

	return TRUE