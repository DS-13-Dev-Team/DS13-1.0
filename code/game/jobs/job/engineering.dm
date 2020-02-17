/datum/job/ce
	title = "Chief Engineer"
	head_position = 1
	department = "Engineering"
	department_flag = ENG|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#7f6e2c"
	req_admin_notify = 1
	ideal_character_age = 45
	minimal_player_age = 14

	access = list(access_bridge, access_engineering, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/engineering/ce

/datum/job/tech_engineer
	title = "Technical Engineer"
	department = "Engineering"
	department_flag = ENG
	total_positions = 4
	spawn_positions = 4
	supervisors = "the chief engineer"
	selection_color = "#5b4d20"
	ideal_character_age = 30
	minimal_player_age = 7

	access = list(access_engineering, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/engineering/tech_engineer
