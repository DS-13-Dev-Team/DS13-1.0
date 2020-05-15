/datum/job/dom
	title = "Director of Mining"
	head_position = 1
	department = "Mining"
	abbreviation = "DOM"
	department_flag = MIN|COM
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#515151"
	req_admin_notify = 1
	minimal_player_age = 18
	ideal_character_age = 30
	starting_credits = 7620

	access = list(access_dom, access_bridge, access_mining, access_keycard_auth)
	outfit_type = /decl/hierarchy/outfit/job/mining/dom

	min_skill = list(   SKILL_COMPUTER	  = SKILL_BASIC,
	                    SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_COMPUTER	  = SKILL_MAX,
	                    SKILL_DEVICES     = SKILL_MAX)
	skill_points = 30

datum/job/dom/get_description_blurb()
	return "You are the Director of Mining. You are the closest direct connection to CEC's regional headquarters besides the Captain. You set local policy for mining quotas and the type of materials to mine to the Foreman. You are subordinate to the CEC and work with the Captain."

/datum/job/foreman
	title = "Mining Foreman"
	department = "MINING"
	abbreviation = "FMN"
	department_flag = MIN
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Director of Mining"
	selection_color = "#515151"
	minimal_player_age = 18
	starting_credits = 2400

	access = list(access_mining)
	outfit_type = /decl/hierarchy/outfit/job/mining/foreman

	min_skill = list(   SKILL_EVA	      = SKILL_EXPERT,
						SKILL_HAULING	  = SKILL_ADEPT,
	                    SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_EVA		  = SKILL_MAX,
	                    SKILL_HAULING     = SKILL_MAX)
	skill_points = 20

datum/job/foreman/get_description_blurb()
	return "You are the Mining Foreman. You are the blue-collar adminstrative worker among the mining crew aboard the ship. Your job is to take quotas and directives from the Director of Mining and inform the Planet Cracker crew of them, along with their enforcement. You are subordinate to the Director of Mining."

/datum/job/planet_cracker
	title = "Planet Cracker"
	department = "Mining"
	abbreviation = "PC"
	department_flag = MIN
	total_positions = 14
	spawn_positions = 14
	supervisors = "the Director of Mining"
	selection_color = "#515151"
	minimal_player_age = 18
	starting_credits = 670

	access = list(access_mining)
	outfit_type = /decl/hierarchy/outfit/job/mining/planet_cracker

	min_skill = list(   SKILL_EVA	      = SKILL_ADEPT,
						SKILL_HAULING	  = SKILL_ADEPT,
	                    SKILL_DEVICES	  = SKILL_BASIC)

	max_skill = list(   SKILL_EVA		  = SKILL_MAX,
	                    SKILL_HAULING     = SKILL_MAX)
	skill_points = 20

datum/job/planet_cracker/get_description_blurb()
	return "You are a Planet Cracker. You are the manual labor that keeps the ship on task with it's CEC mining quota and, as such, the whole ship relies on you. Your job is exteremely dangerous and but many find solace in the benefits, such as organ and limb replacements and potential for pay on commission. You are subordinate to the Director of Mining and the Mining Foreman."