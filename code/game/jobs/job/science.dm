/datum/job/cscio
	title = "Chief Science Officer"
	head_position = 1
	department = "Science"
	abbreviation = "CSCIO"
	department_flag = COM|SCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#ad6bad"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 50
	starting_credits = 4995

	access = list(access_cscio, access_bridge, access_research, access_medical, access_keycard_auth)
	outfit_type = /decl/hierarchy/outfit/job/science/cscio

	min_skill = list(   SKILL_ANATOMY     = SKILL_BASIC,
						SKILL_MEDICAL	  = SKILL_ADEPT,
						SKILL_COMPUTER	  = SKILL_ADEPT,
	                    SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_COMPUTER	  = SKILL_MAX,
	                    SKILL_DEVICES	  = SKILL_MAX)
	skill_points = 20

datum/job/cscio/get_description_blurb()
	return "You are the Chief Science Officer. You are in charge of the research department. Your job is to direct your assistants, do science, and further the scientific field. You are subordinate to the Captain and First Lieutenant."

/datum/job/ra
	title = "Research Assistant"
	department = "Science"
	abbreviation = "RA"
	department_flag = SCI
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief Science Officer"
	selection_color = "#633d63"
	minimal_player_age = 18
	ideal_character_age = 26
	starting_credits = 2690

	access = list(access_research, access_medical)
	outfit_type = /decl/hierarchy/outfit/job/science/ra

	min_skill = list(   SKILL_ANATOMY     = SKILL_BASIC,
						SKILL_MEDICAL	  = SKILL_BASIC,
						SKILL_COMPUTER	  = SKILL_ADEPT,
	                    SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_COMPUTER	  = SKILL_MAX,
	                    SKILL_DEVICES	  = SKILL_MAX)
	skill_points = 20

datum/job/ra/get_description_blurb()
	return "You are a Research Assistant. You are a member of the research department. Your job is to do science, assist the Chief Science Officer, and attempt to further your personal career. You are subodinate to the Chief Science Officer."