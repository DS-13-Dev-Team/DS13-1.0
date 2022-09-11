/datum/job/cseco
	title = "P-Sec Commander"
	abbreviation = "PSC"
	supervisors = "the Colony Director"
	head_position = 1
	department = "Security"
	department_flag = SEC|COM
	total_positions = 1
	spawn_positions = 1
	selection_color = "#8e2929"
	req_admin_notify = 1
	minimal_player_age = 18
	starting_credits = 4595

	salary = SALARY_COMMAND

	//This applies to all command staff
	necro_conversion_compatibility = 1
	necro_conversion_options = list(SPECIES_NECROMORPH_DIVIDER = 3)

	access = list(access_bridge, access_cseco, access_armory, access_security, access_maint_tunnels, access_cargo,
					access_external_airlocks, access_keycard_auth, access_medical, access_research, access_mining)

	outfit_type = /decl/hierarchy/outfit/job/security/cseco

	min_skill = list(   SKILL_WEAPONS     = SKILL_PROF,
						SKILL_FORENSICS   = SKILL_PROF,
						SKILL_COMBAT	  = SKILL_PROF,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY	  = SKILL_ADEPT)
	skill_points = 20

/datum/job/cseco/get_description_blurb()
	return "You are the Chief Security Officer. You are the head of Planet Cracker Starship Ishimura Security, or P.C.S.I. Sec, and are in charge of keeping the crew safe and secure. You are expected to know the Law better than the average officer. You are subordinate to the Captain and First Lieutenant."

/datum/job/sso
	title = "Senior Security Officer"
	department = "Security"
	abbreviation = "SSO"
	department_flag = SEC
	total_positions = 1
	spawn_positions = 1
	supervisors = "the P-Sec Commander"
	selection_color = "#601c1c"
	minimal_player_age = 18
	starting_credits = 3400

	salary = SALARY_SUPERVISOR

	access = list(access_armory, access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/sso

	min_skill = list(   SKILL_WEAPONS     = SKILL_EXPERT,
						SKILL_COMBAT	  = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_PROF,
						SKILL_DEVICES	  = SKILL_ADEPT)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT)
	skill_points = 18

/datum/job/sso/get_description_blurb()
	return "You are the Senior Security Officer. You are the second-in-command to the Chief Security Officer and should they be incapacitated or are unavailable, you are to assume command of the Planetside Security, or P-Sec. You are expected to know the Law better than the average officer. You are typically in charge of foresnics investigations and lead security officers when the Chief Security Officer isn't present. You are subordinate to the P-Sec Commander."

/datum/job/security_officer
	title = "Security Officer"
	department = "Security"
	abbreviation = "SEC"
	department_flag = SEC
	total_positions = 4
	spawn_positions = 4
	supervisors = "the P-Sec Commander and Senior Security Officer"
	selection_color = "#601c1c"
	minimal_player_age = 18
	starting_credits = 3072

	salary = SALARY_SKILLED

	access = list(access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/officer

	min_skill = list(   SKILL_WEAPONS     = SKILL_ADEPT,
						SKILL_COMBAT	  = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT)
	skill_points = 15

/datum/job/security_officer/get_description_blurb()
	return "You are a Security Officer. One of the many members of Planetside Security, or P-Sec, you are there to provide safety and order to the crew. You are expected to have a good understanding of the Law. You are subordinate to the P-Sec Commander and Senior Security Officer."
