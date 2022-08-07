/datum/job/so
	title = "Supply Officer"
	department = "Supply"
	abbreviation = "SO"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Lieutenant"
	selection_color = "#515151"
	minimal_player_age = 18
	ideal_character_age = 40
	starting_credits = 2380
	salary = SALARY_COMMAND

	access = list(access_so, access_bridge, access_cargo, access_maint_tunnels, access_keycard_auth)
	outfit_type = /decl/hierarchy/outfit/job/cargo/so

	min_skill = list(   SKILL_HAULING     = SKILL_ADEPT,
						SKILL_COMPUTER    = SKILL_ADEPT,
						SKILL_COMBAT	  = SKILL_BASIC)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20

/datum/job/so/get_description_blurb()
	return "You are the Supply Officer. Your job is to direct Cargo Serviceman and balance the requests of the rest of the crew to the ship's requisition points. You are subordinate to the First Lieutenant."

/datum/job/serviceman
	title = "Cargo Serviceman"
	department = "Supply"
	abbreviation = "CS"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Supply Officer"
	selection_color = "#3b3b3b"
	minimal_player_age = 18
	starting_credits = 1970
	salary = SALARY_SKILLED	//Miners and civilians are underpaid plebs

	access = list(access_cargo, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/cargo/serviceman

	min_skill = list(   SKILL_HAULING     = SKILL_EXPERT,
						SKILL_COMPUTER    = SKILL_BASIC)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20

/datum/job/serviceman/get_description_blurb()
	return "You are a Cargo Serviceman. Your job is to haul around cargo according to the Supply Officer's whim and deliver cargo shipments to departments, if needed. You are subordinate to the Supply Officer."


/datum/job/salvage
	title = "Salvage Technician"
	department = "Supply"
	abbreviation = "ST"
	department_flag = SUP
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Supply Officer"
	selection_color = "#3b3b3b"
	minimal_player_age = 18
	salary	= 0	//Paid on commission only

	access = list(access_cargo, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/cargo/serviceman

	min_skill = list(   SKILL_CONSTRUCTION= SKILL_BASIC,
						SKILL_ELECTRICAL  = SKILL_BASIC,
						SKILL_EVA 		  = SKILL_BASIC)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 15

/datum/job/salvage/get_description_blurb()
	return "You are a Salvage Technician, part of CEC's reclamation project. Your job is to comb dark and abandoned areas, recovering valueable equipment. You recieve no salary, but may keep some of the things you recover\n\
	You may enlist other cargo servicemen to help you when short staffed. You are subordinate to the Supply Officer."
