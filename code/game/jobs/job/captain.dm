/datum/job/cap
	title = "Captain"
	department = "Command"
	head_position = 1
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the CEC"
	selection_color = "#1d1d4f"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 50

	access = list(access_captain, access_bridge, access_security, access_armory, access_service,
				access_cargo, access_mining, access_engineering,
				access_external_airlocks, access_medical, access_research,
				access_chemistry, access_surgery, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/command/cap

/datum/job/fl
	title = "First Lieutenant"
	department_flag = COM
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 35

	access = list(access_fl, access_bridge, access_security, access_armory, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/command/fl

/datum/job/bo
	title = "Bridge Ensign"
	department_flag = COM
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Captain and First Lieutenant"
	selection_color = "#2f2f7f"
	minimal_player_age = 18
	ideal_character_age = 27

	access = list(access_bridge, access_security, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/command/bo






var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)