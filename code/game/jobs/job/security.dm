/datum/job/cseco
#ifdef MAP_ISHIMURA
	title = "Chief Security Officer"
	abbreviation = "CSECO"
	supervisors = "the Captain"
#else
	title = "P-Sec Commander"
	abbreviation = "PSC"
	supervisors = "the Colony Director"
#endif
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

	access = list(access_bridge, access_cseco, access_armory, access_security, access_maint_tunnels,
					access_external_airlocks, access_keycard_auth)
	outfit_type = /decl/hierarchy/outfit/job/security/cseco

	min_skill = list(   SKILL_WEAPONS     = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_EXPERT,
						SKILL_COMBAT	  = SKILL_ADEPT,
						SKILL_WEAPONS	  = SKILL_MAX,
						SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY	  = SKILL_ADEPT)
	skill_points = 20

/datum/job/cseco/get_description_blurb()
#ifdef MAP_ISHIMURA
	return "You are the Chief Security Officer. You are the head of Planet Cracker Starship Ishimura Security, or P.C.S.I. Sec, and are in charge of keeping the crew safe and secure. You are expected to know the Law better than the average officer. You are subordinate to the Captain and First Lieutenant."
#else
	return "You are the P-Sec Commander. You are the head of Planetside Security, or P-Sec, and are in charge of keeping the crew safe and secure. You are expected to know the Law better than the average officer. You are subordinate to the Captain and First Lieutenant."
#endif

/datum/job/sso
	title = "Senior Security Officer"
	department = "Security"
	abbreviation = "SSO"
	department_flag = SEC
	total_positions = 1
	spawn_positions = 1
#ifdef MAP_ISHIMURA
	supervisors = "the Chief Security Officer"
#else
	supervisors = "the P-Sec Commander"
#endif
	selection_color = "#601c1c"
	minimal_player_age = 18
	starting_credits = 3400

	salary = SALARY_SUPERVISOR

	access = list(access_armory, access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/sso

	min_skill = list(   SKILL_WEAPONS     = SKILL_ADEPT,
						SKILL_COMBAT	  = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_EXPERT,
						SKILL_WEAPONS	  = SKILL_EXPERT,
						SKILL_DEVICES	  = SKILL_ADEPT)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT)
	skill_points = 16

/datum/job/sso/get_description_blurb()
#ifdef MAP_ISHIMURA
	return "You are the Senior Security Officer. You are the second-in-command to the Chief Security Officer and should they be incapacitated or are unavailable, you are to assume command of the Planet Cracker Starship Ishimura Security, or P.C.S.I. Sec. You are expected to know the Law better than the average officer. You are typically in charge of foresnics investigations and lead security officers when the Chief Security Officer isn't present. You are subordinate to the Chief Security Officer."
#else
	return "You are the Senior Security Officer. You are the second-in-command to the Chief Security Officer and should they be incapacitated or are unavailable, you are to assume command of the Planetside Security, or P-Sec. You are expected to know the Law better than the average officer. You are typically in charge of foresnics investigations and lead security officers when the Chief Security Officer isn't present. You are subordinate to the P-Sec Commander."
#endif

/datum/job/security_officer
	title = "Security Officer"
	department = "Security"
	abbreviation = "SEC"
	department_flag = SEC
	total_positions = 4
	spawn_positions = 4
#ifdef MAP_ISHIMURA
	supervisors = "the Chief Security Officer and Senior Security Officer"
#else
	supervisors = "the P-Sec Commander and Senior Security Officer"
#endif
	selection_color = "#601c1c"
	minimal_player_age = 18
	starting_credits = 3072

	salary = SALARY_UNSKILLED

	access = list(access_security, access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/security/officer

	min_skill = list(   SKILL_WEAPONS     = SKILL_ADEPT,
						SKILL_COMBAT	  = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT,
						SKILL_DEVICES	  = SKILL_BASIC,
						SKILL_WEAPONS	  = SKILL_ADEPT)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT)
	skill_points = 10

/datum/job/security_officer/get_description_blurb()
#ifdef MAP_ISHIMURA
	return "You are a Security Officer. One of the many members of Planet Cracker Starship Ishimura Security, or P.C.S.I. Sec, you are there to provide safety and order to the crew. You are expected to have a good understanding of the Law. You are subordinate to the Chief Security Officer and Senior Security Officer."
#else
	return "You are a Security Officer. One of the many members of Planetside Security, or P-Sec, you are there to provide safety and order to the crew. You are expected to have a good understanding of the Law. You are subordinate to the P-Sec Commander and Senior Security Officer."
#endif
