//Skill-related mob helper procs

/mob/proc/get_skill_value(skill_path)
	return skillset.get_value(skill_path)

/mob/proc/reset_skillset()
	qdel(skillset)
	var/new_type = initial(skillset)
	skillset = new new_type(src)
	var/datum/job/job = mind && job_master.GetJob(mind.assigned_role)
	skillset.obtain_from_client(job, client)

// Use to perform skill checks
/mob/proc/skill_check(skill_path, needed)
	var/points = get_skill_value(skill_path)
	return points >= needed

//Returns a positive value when our skill is higher than the opponent
/mob/proc/get_skill_difference(skill_path, mob/opponent)
	if (!ismob(opponent))
		return get_skill_value(skill_path)
	return get_skill_value(skill_path) - opponent.get_skill_value(skill_path)

// A generic way of modifying times via skill values
/mob/proc/skill_delay_mult(skill_path, factor = 0.3)
	var/points = get_skill_value(skill_path)
	switch(points)
		if(SKILL_BASIC)
			return max(0, 1 + 3*factor)
		if(SKILL_NONE)
			return max(0, 1 + 6*factor)
		else
			return max(0, 1 + (SKILL_DEFAULT - points) * factor)

/mob/proc/do_skilled(base_delay, skill_path , atom/target = null, factor = 0.3)
	return do_after(src, base_delay * skill_delay_mult(skill_path, factor), target)

// A generic way of modifying success probabilities via skill values. Higher factor means skills have more effect. fail_chance is the chance at SKILL_NONE.
/mob/proc/skill_fail_chance(skill_path, fail_chance, no_more_fail = SKILL_MAX, factor = 1)
	var/points = get_skill_value(skill_path)
	if(points >= no_more_fail)
		return 0
	else
		return fail_chance * 2 ** (factor*(SKILL_MIN - points))


/mob/proc/get_skill_percentage_bonus(var/skill_path)
	//This gives a value in the range 1-5
	var/points = get_skill_value(skill_path)

	if (!isnum(points))
		return 0

	//Move it to a 0 - 4 range
	points--

	//10% per point
	return points*10