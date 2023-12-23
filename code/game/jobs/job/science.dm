/datum/job/cscio
	title = "Chief Science Officer"
	head_position = 1
	department = "Science"
	abbreviation = "CSCIO"
	department_flag = COM|SCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Colony Director"
	selection_color = "#ad6bad"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 50
	starting_credits = 4995

	salary = SALARY_COMMAND

	access = list(access_cscio, access_bridge, access_research, access_medical, access_maint_tunnels, access_keycard_auth)

	//This applies to all command staff
	necro_conversion_compatibility = 1
	necro_conversion_options = list(SPECIES_NECROMORPH_DIVIDER = 3)

	outfit_type = /decl/hierarchy/outfit/job/science/cscio

	min_skill = list(   SKILL_ANATOMY     = SKILL_BASIC,
						SKILL_MEDICAL	  = SKILL_ADEPT,
						SKILL_COMPUTER	  = SKILL_ADEPT,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_COMBAT      = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20
	exp_type = EXP_TYPE_COMMAND

/datum/job/cscio/get_description_blurb()
	return "You are the Chief Science Officer. You are in charge of the research department. Your job is to direct your assistants, do science, and further the scientific field. You are subordinate to the Colony Director and First Lieutenant."

/datum/job/ra
	title = "Research Assistant"
	department = "Science"
	abbreviation = "RA"
	department_flag = SCI
	total_positions = 10
	spawn_positions = 10
	supervisors = "the Chief Science Officer"
	selection_color = "#633d63"
	minimal_player_age = 18
	ideal_character_age = 26
	starting_credits = 2690

	salary = SALARY_EDUCATED

	access = list(access_research, access_maint_tunnels)

	//This applies to all research
	necro_conversion_options = list(SPECIES_NECROMORPH_DIVIDER = 3)

	outfit_type = /decl/hierarchy/outfit/job/science/ra

	min_skill = list(   SKILL_ANATOMY     = SKILL_BASIC,
						SKILL_MEDICAL	  = SKILL_BASIC,
						SKILL_COMPUTER	  = SKILL_ADEPT,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_COMBAT      = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20
	exp_type = EXP_TYPE_SCIENCE

/datum/job/ra/get_description_blurb()
	return "You are a Research Assistant. You are a member of the research department. Your job is to do science, assist the Chief Science Officer, and attempt to further your personal career. You are subodinate to the Chief Science Officer."
