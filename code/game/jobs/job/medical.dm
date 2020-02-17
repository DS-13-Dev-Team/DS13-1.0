/datum/job/smo
	title = "Senior Medical Officer"
	head_position = 1
	department = "Medical"
	department_flag = MED|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#026865"
	req_admin_notify = 1
	minimal_player_age = 7
	ideal_character_age = 50

	access = list(access_bridge, access_medical, access_maint_tunnels, access_chemistry, access_surgery)
	outfit_type = /decl/hierarchy/outfit/job/medical/smo

/datum/job/md
	title = "Medical Doctor"
	department = "Medical"
	department_flag = MED
	minimal_player_age = 5
	total_positions = 6
	spawn_positions = 6
	supervisors = "the senior medical officer"
	selection_color = "#013d3b"

	access = list(access_medical, access_chemistry)
	outfit_type = /decl/hierarchy/outfit/job/medical/md

/datum/job/surg
	title = "Surgeon"
	department = "Medical"
	department_flag = MED
	minimal_player_age = 7
	total_positions = 2
	spawn_positions = 2
	supervisors = "the senior medical officer"
	selection_color = "#013d3b"

	access = list(access_medical, access_surgery)
	outfit_type = /decl/hierarchy/outfit/job/medical/surg
