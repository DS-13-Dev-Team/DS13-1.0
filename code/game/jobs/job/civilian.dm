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

/datum/job/janitor
	title = "Janitor"
	abbreviation = "JN"
	department_flag = CIV
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#2f2f7f"
	minimal_player_age = 18
	ideal_character_age = 21
	starting_credits = 732

	access = list(access_service, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/service/janitor

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