GLOBAL_DATUM_INIT(agents, /datum/antagonist/earthgov_agent, new)
GLOBAL_LIST_EMPTY(agents_list)

/datum/antagonist/earthgov_agent
	role_text = "EarthGov Agent"
	role_text_plural = "EarthGov Agents"
	welcome_text = "You are a well-trained agent of the government of Earth, sent to spy on the illegal planet cracking operation in the Cygnus system. In addition, you are investigating a lead that the Church of Unitology has infiltrated the crew of the Ishimura. It is your assignment to report back to your superiors, investigate the situation surrounding the Church, and protect the interests of Earth. You have been provided a direct comm-link to <b>EarthGov Command</b>. Remember, EarthGov directives come before your own..."
	id = MODE_EARTHGOV_AGENT
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	skill_setter = /datum/antag_skill_setter/station
	antaghud_indicator = "hudagent" // Used by the ghost antagHUD.
	antag_indicator = "hudagent"// icon_state for icons/mob/mob.dm visual indicator.
	preference_candidacy_toggle = TRUE

	// Spawn values (autotraitor and game mode)
	//Hard cap of 6 will only be reached at really high playercounts
	hard_cap = 2                        // Autotraitor var. Won't spawn more than this many antags.
	hard_cap_round = 2                  // As above but 'core' round antags ie. roundstart.
	initial_spawn_req = 0               // Gamemode using this template won't start without this # candidates.
	initial_spawn_target = 2            // Gamemode will attempt to spawn this many antags.

/datum/objective/unitologist
	explanation_text = "Spy on the Ishimura and protect EarthGov's interests."

/datum/antagonist/traitor/create_objectives(var/datum/mind/traitor)
	if(!..())
		return

		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = traitor
		traitor.objectives += survive_objective
	else
		switch(rand(1,100))
			if(1 to 25) // Really low chance of getting this. These objectives are ass.
				var/datum/objective/brig/brig_objective = new
				brig_objective.owner = traitor
				brig_objective.find_target()
				traitor.objectives += brig_objective
			else
				var/datum/objective/steal/steal_objective = new
				steal_objective.owner = traitor
				steal_objective.find_target()
				traitor.objectives += steal_objective
		switch(rand(1,100))
			if(1 to 100)
				if (!(locate(/datum/objective/escape) in traitor.objectives))
					var/datum/objective/escape/escape_objective = new
					escape_objective.owner = traitor
					traitor.objectives += escape_objective
			else
	return

/datum/antagonist/earthgov_agent/proc/give_collaborators(mob/living/our_owner)
	//our_owner.verbs |= /mob/proc/message_earthgov_agent
	to_chat(our_owner, "<span class='warning'>A comm link has been established between you and your fellow agents.</span>")
	to_chat(our_owner, "<span class='warning'><i>You are provided with several names, these people are your allies.</i></span>")
	for(var/mob/living/minion in GLOB.agents_list)
		if(minion && minion != our_owner)
			to_chat(our_owner, "Fellow agent: [minion.real_name]")
			our_owner.mind.store_memory("<b>Fellow agent</b>: [minion.real_name]")



/datum/codex_entry/concept/earthgov_agents
	display_name = "EarthGov"
	category = CATEGORY_CONCEPTS
	associated_strings = list("EarthGov", "agent", "Earth")
	lore_text = "The Earth Government Colonial Alliance, or EarthGov, is the executive branch of Earth and all its colonies."
	mechanics_text = "For the purpose of this game setting, no one is specifically associated with EarthGov unless:<br> \ * They are an EarthGov agent sent specifically with a task, or have been coopted into an EarthGov operation.<br>\ * Are a marine within the Earth Defense Force.<br><br>"

