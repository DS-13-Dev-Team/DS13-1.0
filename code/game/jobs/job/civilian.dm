/datum/job/bar
	title = "Bartender"
	abbreviation = "BTR"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#2f2f7f"
	minimal_player_age = 18
	ideal_character_age = 30
	starting_credits = 943

	access = list(access_service, access_bartender)
	outfit_type = /decl/hierarchy/outfit/job/service/bar

	min_skill = list(   SKILL_COOKING     = SKILL_ADEPT)
	max_skill = list(   SKILL_COOKING     = SKILL_MAX)
	skill_points = 20

datum/job/bar/get_description_blurb()
	return "You are the Bartender. Your job is to serve drinks to any crewmember that show up at your bar. You don't have a department head and are subordinate to the Captain and First Lieutenant."

/datum/job/line_cook
	title = "Line Cook"
	abbreviation = "LC"
	department_flag = CIV
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Captain"
	selection_color = "#2f2f7f"
	minimal_player_age = 18
	ideal_character_age = 21
	starting_credits = 1240

	access = list(access_service)
	outfit_type = /decl/hierarchy/outfit/job/service/line_cook

	min_skill = list(   SKILL_COOKING     = SKILL_EXPERT,
						SKILL_HAULING     = SKILL_BASIC)

	max_skill = list(   SKILL_COOKING     = SKILL_MAX)
	skill_points = 20

datum/job/line_cook/get_description_blurb()
	return "You are a Line Cook. Your job is to cook meals and feed any crewmember that show up to the Cafeteria. You don't have a department head and are subordinate to the Captain and First Lieutenant."

/datum/job/so
	title = "Supply Officer"
	department = "Supply"
	abbreviation = "SO"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#515151"
	minimal_player_age = 18
	ideal_character_age = 40
	starting_credits = 2380

	access = list(access_so, access_bridge, access_cargo)
	outfit_type = /decl/hierarchy/outfit/job/cargo/so

	min_skill = list(   SKILL_HAULING     = SKILL_ADEPT,
	                    SKILL_COMPUTER    = SKILL_ADEPT,
	                    SKILL_COMBAT	  = SKILL_BASIC)

	max_skill = list(   SKILL_HAULING     = SKILL_MAX,
	                    SKILL_COMPUTER    = SKILL_MAX)
	skill_points = 20

datum/job/so/get_description_blurb()
	return "You are the Supply Officer. Your job is to direct Cargo Serviceman and balance the requests of the rest of the crew to the ship's requisition points. You are subordinate the Captain and First Lieutenant."

/datum/job/serviceman
	title = "Cargo Serviceman"
	department = "Supply"
	abbreviation = "CS"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Supply Officer"
	selection_color = "#515151"
	minimal_player_age = 18
	starting_credits = 1970

	access = list(access_cargo)
	outfit_type = /decl/hierarchy/outfit/job/cargo/serviceman

	min_skill = list(   SKILL_HAULING     = SKILL_EXPERT,
	                    SKILL_COMPUTER    = SKILL_BASIC)

	max_skill = list(   SKILL_HAULING     = SKILL_MAX,
	                    SKILL_COMPUTER    = SKILL_MAX)
	skill_points = 20

datum/job/serviceman/get_description_blurb()
	return "You are a Cargo Serviceman. Your job is to haul around cargo according to the Supply Officer's whim and deliver cargo shipments to departments, if needed. You are subordinate to the Supply Officer. "