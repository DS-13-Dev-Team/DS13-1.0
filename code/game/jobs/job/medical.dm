/datum/job/smo
	title = "Senior Medical Officer"
	head_position = 1
	department = "Medical"
	abbreviation = "SMO"
	department_flag = COM|MED
	total_positions = 1
	spawn_positions = 1
#ifdef MAP_ISHIMURA
	supervisors = "the Captain"
#else
	supervisors = "the Colony Director"
#endif
	selection_color = "#026865"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 50
	starting_credits = 5080

	//This applies to all command staff
	necro_conversion_compatibility = 1
	necro_conversion_options = list(SPECIES_NECROMORPH_DIVIDER = 3)

	access = list(access_smo, access_bridge, access_maint_tunnels, access_medical, access_surgery, access_research, access_chemistry,
					access_psychologist, access_keycard_auth)
	outfit_type = /decl/hierarchy/outfit/job/medical/smo

	min_skill = list(   SKILL_ANATOMY     = SKILL_MAX,
						SKILL_MEDICAL	  = SKILL_MAX,
						SKILL_HAULING     = SKILL_BASIC,
						SKILL_DEVICES	  = SKILL_ADEPT)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_EXPERT)
	skill_points = 25

	salary = SALARY_COMMAND

/datum/job/smo/get_description_blurb()
#ifdef MAP_ISHIMURA
	return "You are the Senior Medical Officer. You are chiefly responsible for the health and well-being of all crewmembers aboard the ship. You are subordinate to the Captain and First Lieutenant."
#else
	return "You are the Senior Medical Officer. You are chiefly responsible for the health and well-being of all workers in the colony. You are subordinate to the Captain and First Lieutenant."
#endif


/datum/job/md
	title = "Medical Doctor"
	department = "Medical"
	abbreviation = "MD"
	department_flag = MED
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Senior Medical Officer"
	selection_color = "#013d3b"
	minimal_player_age = 18
	starting_credits = 3500

	#ifdef MAP_ISHIMURA
	access = list(access_medical, access_chemistry, access_research, access_maint_tunnels)
	#else
	access = list(access_medical, access_chemistry, access_maint_tunnels)
	#endif

	outfit_type = /decl/hierarchy/outfit/job/medical/md

	salary = SALARY_EDUCATED

	min_skill = list(   SKILL_ANATOMY     = SKILL_BASIC,
						SKILL_MEDICAL	  = SKILL_EXPERT,
						SKILL_HAULING     = SKILL_BASIC,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_EXPERT)
	skill_points = 20

/datum/job/md/get_description_blurb()
	return "You are a Medical Doctor. Your job is to treat and diagnose injured crewmembers, applying the appropriate skills and supplies to heal them. You may assist a Surgeon with surgery, if you have the appropriate skills. You are subordinate to the Senior Medical Officer."

/datum/job/surg
	title = "Surgeon"
	department = "Medical"
	abbreviation = "SRG"
	department_flag = MED
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Senior Medical Officer"
	selection_color = "#013d3b"
	minimal_player_age = 18
	starting_credits = 4440

	salary = SALARY_EDUCATED

	#ifdef MAP_ISHIMURA
	access = list(access_medical, access_surgery, access_chemistry, access_research, access_maint_tunnels)
	#else
	access = list(access_medical, access_surgery, access_chemistry, access_maint_tunnels)
	#endif

	outfit_type = /decl/hierarchy/outfit/job/medical/surg

	min_skill = list(	SKILL_ANATOMY     = SKILL_EXPERT,
						SKILL_MEDICAL	  = SKILL_EXPERT,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_EXPERT)
	skill_points = 24

/datum/job/surg/get_description_blurb()
	return "You are a Surgeon. Your job is to perform surgery on any wounded crewmembers who require it and are one of the few people given access to the surgical suites. You are subordinate to the Senior Medical Officer."

/datum/job/psychologist
	title = "Psychologist"
	abbreviation = "PSY"
	department_flag = MED
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Senior Medical Officer"
	selection_color = "#013d3b"
	minimal_player_age = 18
	ideal_character_age = 30
	starting_credits = 943

	#ifdef MAP_ISHIMURA
	access = list(access_medical, access_psychologist, access_research, access_chemistry, access_maint_tunnels)
	#else
	access = list(access_medical, access_psychologist, access_chemistry, access_maint_tunnels)
	#endif
	outfit_type = /decl/hierarchy/outfit/job/medical/psych

	min_skill = list(	SKILL_ANATOMY     = SKILL_BASIC,
						SKILL_MEDICAL	  = SKILL_EXPERT,
						SKILL_HAULING     = SKILL_BASIC,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_EXPERT)
	skill_points = 25

	salary = SALARY_EDUCATED //Church pays you more than CEC to miners and civs...

/datum/job/psychologist/get_description_blurb()
	return "You are the Psychologist. Your job is to meet with clients to identify emotional, mental, and behavioral problems. You are subordinate to the Senior Medical Officer."
