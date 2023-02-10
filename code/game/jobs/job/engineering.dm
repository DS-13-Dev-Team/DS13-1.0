/datum/job/ce
	title = "Chief Engineer"
	head_position = 1
	department = "Engineering"
	abbreviation = "CE"
	department_flag = COM|ENG
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Colony Director"
	selection_color = "#7f6e2c"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 45
	starting_credits = 5349

	//This applies to all command staff
	necro_conversion_compatibility = 1
	necro_conversion_options = list(SPECIES_NECROMORPH_DIVIDER = 3)

	access = list(access_ce, access_bridge, access_engineering, access_maint_tunnels, access_external_airlocks, access_keycard_auth)
	outfit_type = /decl/hierarchy/outfit/job/engineering/ce

	min_skill = list(   SKILL_HAULING     = SKILL_BASIC,
						SKILL_EVA	      = SKILL_EXPERT,
						SKILL_COMPUTER    = SKILL_ADEPT,
						SKILL_CONSTRUCTION= SKILL_PROF,
						SKILL_ELECTRICAL  = SKILL_PROF,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_COMBAT      = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20

	salary = SALARY_COMMAND
	exp_type = EXP_TYPE_COMMAND

/datum/job/ce/get_description_blurb()
	return "You are the Chief Engineer. Your job is to keep the colony well-maintained and in one piece, along with directing the Technical Engineers. You are subordinate to the Colony Director and First Lieutenant."

/datum/job/tech_engineer
	title = "Technical Engineer"
	department = "Engineering"
	abbreviation = "TE"
	department_flag = ENG
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief Engineer"
	selection_color = "#5b4d20"
	minimal_player_age = 18
	ideal_character_age = 30
	starting_credits = 4520

	salary = SALARY_SKILLED
	access = list(access_engineering, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/engineering/tech_engineer

	min_skill = list(	SKILL_HAULING     = SKILL_BASIC,
						SKILL_EVA	      = SKILL_ADEPT,
						SKILL_COMPUTER    = SKILL_ADEPT,
						SKILL_CONSTRUCTION= SKILL_ADEPT,
						SKILL_ELECTRICAL  = SKILL_EXPERT)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_COMBAT      = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 14

/datum/job/tech_engineer/get_description_blurb()
	return "You are a Technical Engineer. Your job is to maintain and clean the colony, keeping it in one piece and productive. You are subordinate to the Captain and First Lieutenant."
