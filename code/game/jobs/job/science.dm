/datum/job/cscio
	title = "Chief Science Officer"
	head_position = 1
	department = "Science"
	department_flag = COM|SCI
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#ad6bad"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 50
	starting_credits = 4995

	access = list(access_cscio, access_bridge, access_research, access_medical)
	outfit_type = /decl/hierarchy/outfit/job/science/cscio

/datum/job/ra
	title = "Research Assistant"
	department = "Science"
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