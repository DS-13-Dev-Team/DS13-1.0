/datum/job/dom
	title = "Director of Mining"
	department = "Mining"
	department_flag = MIN
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#515151"
	minimal_player_age = 18
	ideal_character_age = 30
	starting_credits = 7620

	access = list(access_dom, access_bridge, access_mining)
	outfit_type = /decl/hierarchy/outfit/job/mining/dom

/datum/job/foreman
	title = "Mining Foreman"
	department = "MINING"
	department_flag = MIN
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Director of Mining"
	selection_color = "#515151"
	minimal_player_age = 18
	starting_credits = 2400

	access = list(access_mining)
	outfit_type = /decl/hierarchy/outfit/job/mining/foreman

/datum/job/planet_cracker
	title = "Planet Cracker"
	department = "Mining"
	department_flag = MIN
	total_positions = 14
	spawn_positions = 14
	supervisors = "the Director of Mining"
	selection_color = "#515151"
	minimal_player_age = 18
	starting_credits = 670

	access = list(access_mining)
	outfit_type = /decl/hierarchy/outfit/job/mining/planet_cracker