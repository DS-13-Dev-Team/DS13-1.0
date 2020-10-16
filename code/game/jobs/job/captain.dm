/datum/job/cap
	title = "Captain"
	department = "Command"
	abbreviation = "CPT"
	head_position = 1
	department_flag = COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the CEC"
	selection_color = "#1d1d4f"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 50
	starting_credits = 9070

	access = list(access_captain, access_bridge, access_security, access_armory, access_service,
				access_cargo, access_mining, access_engineering,
				access_external_airlocks, access_medical, access_research,
				access_chemistry, access_surgery, access_maint_tunnels, access_keycard_auth, access_ID_access)
	outfit_type = /decl/hierarchy/outfit/job/command/cap

	min_skill = list(   SKILL_HAULING     = SKILL_BASIC,
						SKILL_WEAPONS     = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_ADEPT)

	max_skill = list(   SKILL_HAULING     = SKILL_MAX,
						SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_COMPUTER    = SKILL_MAX)
	skill_points = 20

datum/job/cap/get_description_blurb()
	return "You are the Captain. You are in charge of the overall situation aboard your ship. You are there to ensure that, overall, the ship's operations are safe and productive. You only answer to the CEC and work with the Director of Mining, normally."

/datum/job/fl
	title = "First Lieutenant"
	abbreviation = "FL"
	department_flag = COM
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#2f2f7f"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 35
	starting_credits = 6480

	access = list(access_fl, access_bridge, access_security, access_armory, access_maint_tunnels,
				access_keycard_auth, access_ID_access)
	outfit_type = /decl/hierarchy/outfit/job/command/fl

	min_skill = list(   SKILL_HAULING     = SKILL_ADEPT,
						SKILL_WEAPONS     = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_ADEPT)

	max_skill = list(   SKILL_HAULING     = SKILL_MAX,
						SKILL_WEAPONS     = SKILL_MAX,
	                    SKILL_COMPUTER    = SKILL_MAX)
	skill_points = 20

datum/job/fl/get_description_blurb()
	return "You are the First Lieutenant. You are the second-in-command to the Captain and, should the Captain be unavailable, inccapacitated, or killed, the person next in line to command the ship. Your job, normally, is organize department heads and hand out orders and directives from the Captain to the ship overall. You are subordinate to the Captain."

/datum/job/bo
	title = "Bridge Ensign"
	abbreviation = "BE"
	department_flag = COM
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Captain and First Lieutenant"
	selection_color = "#2f2f7f"
	minimal_player_age = 18
	ideal_character_age = 27
	starting_credits = 3400

	access = list(access_bridge, access_security, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/command/bo

	min_skill = list(   SKILL_HAULING     = SKILL_BASIC,
	                    SKILL_COMPUTER    = SKILL_EXPERT)

	max_skill = list(   SKILL_HAULING     = SKILL_MAX,
	                    SKILL_COMPUTER    = SKILL_MAX)
	skill_points = 20

datum/job/bo/get_description_blurb()
	return "You are a Bridge Ensign. You are the members of the crew that support Commmand and assist them in their endeavours. You are not in the line of succession if the Captain and First Lieutenant are unable to complete their duties. You are subordinate to the Captain and First Lieutenant."



var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)