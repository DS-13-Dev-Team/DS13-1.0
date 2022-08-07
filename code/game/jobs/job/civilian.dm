/datum/job/bar
	title = "Bartender"
	abbreviation = "BTR"
	department_flag = SRV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Lieutenant"
	selection_color = "#006200"
	minimal_player_age = 18
	ideal_character_age = 30
	starting_credits = 943

	access = list(access_service, access_bartender, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/service/bar

	min_skill = list(   SKILL_COOKING     = SKILL_ADEPT)
	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20

	salary	= 500	//Miners and civilians are underpaid plebs

/datum/job/bar/get_description_blurb()
	return "You are the Bartender. Your job is to serve drinks to any crewmember that show up at your bar. You are subordinate to the First Lieutenant."

/datum/job/line_cook
	title = "Line Cook"
	abbreviation = "LC"
	department_flag = SRV
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Lieutenant"
	selection_color = "#006200"
	minimal_player_age = 18
	ideal_character_age = 21
	starting_credits = 1240

	salary	= 500	//Miners and civilians are underpaid plebs
	access = list(access_service, access_cook, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/service/line_cook

	min_skill = list(   SKILL_COOKING     = SKILL_EXPERT,
						SKILL_HAULING     = SKILL_BASIC)

	max_skill = list(	SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20

/datum/job/line_cook/get_description_blurb()
	return "You are a Line Cook. Your job is to cook meals and feed any crewmember that show up to the Cafeteria. You are subordinate to the First Lieutenant."

/datum/job/botanist
	title = "Botanist"
	abbreviation = "BOT"
	department_flag = SRV
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Lieutenant"
	selection_color = "#006200"
	minimal_player_age = 18
	ideal_character_age = 30
	starting_credits = 943

	access = list(access_service, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/service/botanist

	min_skill = list(   SKILL_BOTANY 	  = SKILL_EXPERT)
	max_skill = list(   SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20

	salary = SALARY_SKILLED

/datum/job/bar/get_description_blurb()
	return "You are the Bartender. Your job is to serve drinks to any crewmember that show up at your bar. You don't have a department head and are subordinate to the Captain and First Lieutenant."

/datum/job/janitor
	title = "Janitor"
	abbreviation = "JTR"
	department_flag = SRV
	total_positions = 3
	spawn_positions = 3
	supervisors = "the First Lieutenant"
	selection_color = "#6c0864"
	minimal_player_age = 18
	ideal_character_age = 20
	starting_credits = 943
	salary = SALARY_UNSKILLED

	access = list(access_maint_tunnels, access_service)
	outfit_type = /decl/hierarchy/outfit/job/service/janitor

	max_skill = list(	SKILL_BOTANY	= SKILL_ADEPT,
						SKILL_MEDICAL	= SKILL_ADEPT,
						SKILL_ANATOMY	= SKILL_ADEPT,
						SKILL_FORENSICS	= SKILL_ADEPT)
	skill_points = 20

	salary = 500	//Miners and civilians are underpaid plebs

/datum/job/janitor/get_description_blurb()
	return "You are the Janitor. Your job is to clean the ship from the mess created by the crew. You are subordinate to the First Lieutenant."

/datum/job/chaplain
	title = "Unitologist Chaplain"
	abbreviation = "CHP"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Lieutenant"
	selection_color = "#ac0e00"
	minimal_player_age = 18
	ideal_character_age = 30
	starting_credits = 943

	access = list(access_maint_tunnels, access_chaplain)
	outfit_type = /decl/hierarchy/outfit/job/service/chaplain

	max_skill = list(	SKILL_BOTANY	= SKILL_ADEPT,
						SKILL_MEDICAL	= SKILL_ADEPT,
						SKILL_ANATOMY	= SKILL_ADEPT,
						SKILL_FORENSICS	= SKILL_ADEPT)
	skill_points = 24

	salary = 700 //Church pays you more than CEC to miners and civs...

/datum/job/chaplain/get_description_blurb()
	return "You are the Chaplain of the Unitologist Church. Your job is to carry faith in the Marker. You are subordinate to the First Lieutenant."
