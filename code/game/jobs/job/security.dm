/datum/job/cseco
	title = "Chief Security Officer"
	head_position = 1
	department = "Security"
	abbreviation = "CSECO"
	department_flag = SEC|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#8e2929"
	req_admin_notify = 1
	minimal_player_age = 18
	starting_credits = 4595

	access = list(access_bridge, access_cseco, access_armory, access_security, access_maint_tunnels,
					access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/cseco

/datum/job/sso
	title = "Senior Security Officer"
	department = "Security"
	abbreviation = "SSO"
	department_flag = SEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Chief Security Officer"
	selection_color = "#601c1c"
	minimal_player_age = 18
	starting_credits = 3400

	access = list(access_armory, access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/sso

/datum/job/security_officer
	title = "Security Officer"
	department = "Security"
	abbreviation = "SEC"
	department_flag = SEC
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Chief Security Officer and Senior Security Officer"
	selection_color = "#601c1c"
	minimal_player_age = 18
	starting_credits = 3072

	access = list(access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/officer