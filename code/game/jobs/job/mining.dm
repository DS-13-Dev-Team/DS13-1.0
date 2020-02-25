/datum/job/dom
	title = "Director of Mining"
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#515151"
	minimal_player_age = 18
	ideal_character_age = 40

	access = list(access_bridge, access_mining)
	outfit_type = /decl/hierarchy/outfit/job/mining/dom

/datum/job/foreman
	title = "Mining Foreman"
	department = "Supply"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Director of Mining"
	selection_color = "#515151"
	minimal_player_age = 18

	access = list(access_mining)
	outfit_type = /decl/hierarchy/outfit/job/mining/foreman

/datum/job/planet_cracker
	title = "Planet Cracker"
	department = "Supply"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Director of Mining"
	selection_color = "#515151"
	minimal_player_age = 18

	access = list(access_mining)
	outfit_type = /decl/hierarchy/outfit/job/mining/planet_cracker