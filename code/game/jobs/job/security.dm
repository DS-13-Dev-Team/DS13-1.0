/datum/job/cseco
	title = "Chief Security Officer"
	head_position = 1
	department = "Security"
	department_flag = SEC|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#8e2929"
	req_admin_notify = 1

	access = list(access_bridge, access_armory, access_security, access_maint_tunnels,
					access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/cseco

/datum/job/sso
	title = "Senior Security Officer"
	department = "Security"
	department_flag = SEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the chief security officer"
	selection_color = "#601c1c"

	access = list(access_armory, access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/sso

/datum/job/security_officer
	title = "Security Officer"
	department = "Security"
	department_flag = SEC
	total_positions = 4
	spawn_positions = 4
	supervisors = "the chief security officer"
	selection_color = "#601c1c"

	access = list(access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/officer


////////////////////////////////////////////////////////////////////////////////
////			DEFAULT ROLES BELOW HERE.									////
////			PLACEHOLDERS FOR GAMEMODES TO PREVENT ERRORS, ETC.			////
////////////////////////////////////////////////////////////////////////////////




/datum/job/hos
	title = "Head of Security"
	head_position = 1
	department = "Security"
	department_flag = SEC|COM

	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#8e2929"
	req_admin_notify = 1

	access = list()
	minimal_access = list()
	minimal_player_age = 14

/datum/job/hos/equip(var/mob/living/carbon/human/H)
	. = ..()
	if(.)
		H.implant_loyalty(H)

/datum/job/warden
	title = "Warden"
	department = "Security"
	department_flag = SEC

	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of security"
	selection_color = "#601c1c"

	access = list()
	minimal_access = list()
	minimal_player_age = 7

/datum/job/detective
	title = "Detective"
	department = "Security"
	department_flag = SEC

	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of security"
	selection_color = "#601c1c"

	access = list()
	minimal_access = list()
	minimal_player_age = 7

/datum/job/officer
	title = "Security Officer"
	department = "Security"
	department_flag = SEC

	total_positions = 4
	spawn_positions = 4
	supervisors = "the head of security"
	selection_color = "#601c1c"


	access = list()
	minimal_access = list()
	minimal_player_age = 7