/datum/job/bar
	title = "Bartender"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#2f2f7f"
	ideal_character_age = 21

	access = list(access_service)
	outfit_type = /decl/hierarchy/outfit/job/bar

/datum/job/line_cook
	title = "Line Cook"
	department_flag = CIV
	total_positions = 3
	spawn_positions = 3
	supervisors = "the captain"
	selection_color = "#2f2f7f"
	ideal_character_age = 21

	access = list(access_service)
	outfit_type = /decl/hierarchy/outfit/job/line_cook

/datum/job/dom
	title = "Director of Mining"
	head_position = 1
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the CEC"
	selection_color = "#515151"
	minimal_player_age = 3
	ideal_character_age = 55

	access = list(access_bridge, access_mining)
	outfit_type = /decl/hierarchy/outfit/job/cargo/dom

/datum/job/so
	title = "Supply Officer"
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#515151"
	minimal_player_age = 3
	ideal_character_age = 40

	access = list(access_bridge, access_cargo)
	outfit_type = /decl/hierarchy/outfit/job/cargo/so

/datum/job/serviceman
	title = "Cargo Serviceman"
	department = "Supply"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "the supply officer"
	selection_color = "#515151"

	access = list(access_cargo)
	outfit_type = /decl/hierarchy/outfit/job/cargo/serviceman

/datum/job/planet_cracker
	title = "Planet Cracker"
	department = "Supply"
	department_flag = SUP
	total_positions = 4
	spawn_positions = 4
	supervisors = "the mining foreman and the captain"
	selection_color = "#515151"

	access = list(access_mining)
	outfit_type = /decl/hierarchy/outfit/job/cargo/planet_cracker

/datum/job/foreman
	title = "Mining Foreman"
	department = "Supply"
	department_flag = SUP
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#515151"

	access = list(access_bridge, access_mining)
	outfit_type = /decl/hierarchy/outfit/job/cargo/foreman