var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/cap
	title = "Colony Director"
	abbreviation = "DIR"
	department = "Command"
	head_position = 1
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the CEC"
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 50
	starting_credits = 9070

	//This applies to all command staff
	necro_conversion_compatibility = 1
	necro_conversion_options = list(SPECIES_NECROMORPH_DIVIDER = 3)

	access = list(access_captain, access_bridge, access_security, access_armory, access_service,
				access_cargo, access_mining, access_engineering, access_bartender, access_chaplain,
				access_external_airlocks, access_medical, access_research, access_psychiatrist,
				access_chemistry, access_surgery, access_maint_tunnels, access_keycard_auth, access_keycard_modification)
	outfit_type = /decl/hierarchy/outfit/job/command/cap

	min_skill = list(   SKILL_HAULING     = SKILL_ADEPT,
						SKILL_WEAPONS     = SKILL_BASIC,
						SKILL_COMPUTER    = SKILL_ADEPT)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20
	salary = SALARY_HIGH_COMMAND
	exp_type = EXP_TYPE_COMMAND

/datum/job/cap/get_description_blurb()
	return "You are the Colony Director. You are in charge of the overall situation in the colony. You are there to ensure that, overall, the colony's operations are safe and productive. You only answer to the CEC."

/datum/job/fl
	title = "First Lieutenant"
	abbreviation = "FL"
	department_flag = COM
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Colony Director"
	selection_color = "#1d1d4f"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 35
	starting_credits = 6480

	//This applies to all command staff
	necro_conversion_compatibility = 1
	necro_conversion_options = list(SPECIES_NECROMORPH_DIVIDER = 3)

	access = list(access_fl, access_bridge, access_security, access_armory, access_maint_tunnels,
				access_keycard_auth, access_cargo, access_keycard_modification)
	outfit_type = /decl/hierarchy/outfit/job/command/fl

	min_skill = list(   SKILL_HAULING     = SKILL_ADEPT,
						SKILL_WEAPONS     = SKILL_BASIC,
						SKILL_COMPUTER    = SKILL_ADEPT)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20
	salary = SALARY_HIGH_COMMAND
	exp_type = EXP_TYPE_COMMAND

/datum/job/fl/get_description_blurb()
	return "You are the First Lieutenant. You are the second-in-command to the Colony Director and, should the Colony Director be unavailable, inccapacitated, or killed, the person next in line to command the ship. Your job, normally, is organize department heads and hand out orders and directives from the Colony Director to the ship overall. You are subordinate to the Colony Director."

/datum/job/be
	title = "Bridge Ensign"
	abbreviation = "BE"
	department_flag = COM
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Colony Director"
	selection_color = "#1d1d4f"
	minimal_player_age = 18
	ideal_character_age = 27
	starting_credits = 3400

	//This applies to all command staff
	necro_conversion_compatibility = 1
	necro_conversion_options = list(SPECIES_NECROMORPH_DIVIDER = 3)

	access = list(access_bridge, access_security, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/command/be

	min_skill = list(   SKILL_HAULING     = SKILL_BASIC,
						SKILL_COMPUTER    = SKILL_EXPERT)

	max_skill = list(   SKILL_BOTANY      = SKILL_EXPERT,
						SKILL_COOKING     = SKILL_EXPERT,
						SKILL_MEDICAL     = SKILL_EXPERT,
						SKILL_ANATOMY     = SKILL_ADEPT,
						SKILL_COMBAT      = SKILL_EXPERT,
						SKILL_FORENSICS   = SKILL_ADEPT)
	skill_points = 20
	salary = SALARY_EDUCATED
	exp_type = EXP_TYPE_COMMAND

/datum/job/be/get_description_blurb()
	return "You are a Bridge Ensign. You are the members of the crew that support Commmand and assist them in their endeavours. You are not in the line of succession if the Colony Director and First Lieutenant are unable to complete their duties. You are subordinate to the Colony Director and First Lieutenant."
