GLOBAL_LIST_EMPTY(emergency_call_datums)								//initialized at round start and stores the datums.
GLOBAL_DATUM_INIT(picked_call, /datum/emergency_call, null) //Which distress call is currently active
GLOBAL_VAR_INIT(on_distress_cooldown, FALSE)
GLOBAL_VAR_INIT(waiting_for_candidates, FALSE)

GLOBAL_VAR(antag_add_finished)		// Used in antag type voting.
GLOBAL_LIST(additional_antag_types)

/datum/game_mode
	var/name = "invalid"
	var/round_description = "How did you even vote this in?"
	var/extended_round_description = "This roundtype should not be spawned, let alone votable. Someone contact a developer and tell them the game's broken again."
	var/config_tag = null
	var/votable = FALSE
	var/probability = 0

	var/required_players = 0                 // Minimum players for round to start if voted in.
	var/required_enemies = 0                 // Minimum antagonists for round to start.
	var/newscaster_announcements = null
	var/end_on_antag_death = 0               // Round will end when all antagonists are dead.
	var/ert_disabled = 0                     // ERT cannot be called.
	var/deny_respawn = 0	                 // Disable respawn during this round.

	var/list/disabled_jobs = list()           // Mostly used for Malf.  This check is performed in job_controller so it doesn't spawn a regular AI.

	var/shuttle_delay = 1                    // Shuttle transit time is multiplied by this.
	var/auto_recall_shuttle = 0              // Will the shuttle automatically be recalled?

	var/list/antag_tags = list()             // Core antag templates to spawn.
	var/list/antag_templates                 // Extra antagonist types to include.
	var/list/latejoin_antag_tags = list()        // Antags that may auto-spawn, latejoin or otherwise come in midround.
	var/round_autoantag = 0                  // Will this round attempt to periodically spawn more antagonists?
	var/antag_scaling_coeff = 5              // Coefficient for scaling max antagonists to player count.
	var/require_all_templates = 0            // Will only start if all templates are checked and can spawn.
	var/addantag_allowed = ADDANTAG_ADMIN | ADDANTAG_AUTO

	var/station_was_nuked = 0                // See nuclearbomb.dm and malfunction.dm.
	var/explosion_in_progress = 0            // Sit back and relax

	var/event_delay_mod_moderate             // Modifies the timing of random events.
	var/event_delay_mod_major                // As above.

	var/round_finished
	var/round_end_states = list()

	var/waittime_l = 60 SECONDS				 // Lower bound on time before start of shift report
	var/waittime_h = 180 SECONDS		     // Upper bounds on time before start of shift report

	//Used for modes which end when everyone dies.
	var/list/dead_players = list()
	var/player_count = 0

/datum/game_mode/New()
	..()
	// Enforce some formatting.
	// This will probably break something.
	name = capitalize(lowertext(name))
	config_tag = lowertext(config_tag)

	if(round_autoantag && !latejoin_antag_tags.len)
		latejoin_antag_tags = antag_tags.Copy()
	else if(!round_autoantag && latejoin_antag_tags.len)
		round_autoantag = TRUE
	player_count = GLOB.all_crew_records.len

/datum/game_mode/Topic(href, href_list[])
	if(..())
		return
	if(href_list["toggle"])
		switch(href_list["toggle"])
			if("respawn")
				deny_respawn = !deny_respawn
			if("ert")
				ert_disabled = !ert_disabled
				announce_ert_disabled()
			if("shuttle_recall")
				auto_recall_shuttle = !auto_recall_shuttle
			if("autotraitor")
				round_autoantag = !round_autoantag
		message_admins("Admin [key_name_admin(usr)] toggled game mode option '[href_list["toggle"]]'.")
	else if(href_list["set"])
		var/choice = ""
		switch(href_list["set"])
			if("shuttle_delay")
				choice = input("Enter a new shuttle delay multiplier") as num
				if(!choice || choice < 1 || choice > 20)
					return
				shuttle_delay = choice
			if("antag_scaling")
				choice = input("Enter a new antagonist cap scaling coefficient.") as num
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				antag_scaling_coeff = choice
			if("event_modifier_moderate")
				choice = input("Enter a new moderate event time modifier.") as num
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				event_delay_mod_moderate = choice
				refresh_event_modifiers()
			if("event_modifier_severe")
				choice = input("Enter a new moderate event time modifier.") as num
				if(isnull(choice) || choice < 0 || choice > 100)
					return
				event_delay_mod_major = choice
				refresh_event_modifiers()
		message_admins("Admin [key_name_admin(usr)] set game mode option '[href_list["set"]]' to [choice].")
	else if(href_list["debug_antag"])
		if(href_list["debug_antag"] == "self")
			usr.client.debug_variables(src)
			return
		var/datum/antagonist/antag = GLOB.all_antag_types_[href_list["debug_antag"]]
		if(antag)
			usr.client.debug_variables(antag)
			message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")
	else if(href_list["remove_antag_type"])
		if(antag_tags && (href_list["remove_antag_type"] in antag_tags))
			to_chat(usr, "Cannot remove core mode antag type.")
			return
		var/datum/antagonist/antag = GLOB.all_antag_types_[href_list["remove_antag_type"]]
		if(antag_templates && antag_templates.len && antag && (antag in antag_templates) && (antag.id in GLOB.additional_antag_types))
			antag_templates -= antag
			GLOB.additional_antag_types -= antag.id
			message_admins("Admin [key_name_admin(usr)] removed [antag.role_text] template from game mode.")
	else if(href_list["add_antag_type"])
		var/choice = input("Which type do you wish to add?") as null|anything in GLOB.all_antag_types_
		if(!choice)
			return
		var/datum/antagonist/antag = GLOB.all_antag_types_[choice]
		if(antag)
			if(!islist(SSticker.mode.antag_templates))
				SSticker.mode.antag_templates = list()
			SSticker.mode.antag_templates |= antag
			message_admins("Admin [key_name_admin(usr)] added [antag.role_text] template to game mode.")

	// I am very sure there's a better way to do this, but I'm not sure what it might be. ~Z
	spawn(1)
		for(var/datum/admins/admin in world)
			if(usr.client == admin.owner)
				admin.show_game_mode(usr)
				return

/datum/game_mode/proc/announce() //to be called when round starts
	to_chat(world, "<span class='infoplain'><B>The current game mode is [capitalize(name)]!</B></span>")
	if(round_description)
		to_chat(world, "<span class='infoplain'>[round_description]</span>")
	if(round_autoantag)
		to_chat(world, "<span class='infoplain'>Antagonists will be added to the round automagically as needed.</span>")
	if(antag_templates && antag_templates.len)
		var/antag_summary = "<b>Possible antagonist types:</b> "
		var/i = 1
		for(var/datum/antagonist/antag in antag_templates)
			if(i > 1)
				if(i == antag_templates.len)
					antag_summary += " and "
				else
					antag_summary += ", "
			antag_summary += "[antag.role_text_plural]"
			i++
		antag_summary += "."
		if(antag_templates.len > 1 && GLOB.master_mode != "secret")
			to_chat(world, "<span class='infoplain'>[antag_summary]</span>")
		else
			message_admins("[antag_summary]")

/datum/game_mode/proc/can_start(bypass_checks = FALSE)
	if(length(SSticker.totalPlayersReady) < required_players && !bypass_checks)
		to_chat(world, "<b>Unable to start [name].</b> Not enough players, [required_players] players needed.")
		return FALSE
	return TRUE

/datum/game_mode/proc/setup()
	job_master.DivideOccupations()
	create_characters() //Create player characters and transfer them
	collect_minds()
	equip_characters()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!H.mind || player_is_antag(H.mind, only_offstation_roles = 1) || !job_master.ShouldCreateRecords(H.mind.assigned_role))
			continue
		CreateModularRecord(H)

	return TRUE

// startRequirements()
// Checks to see if the game can be setup and ran with the current number of players or whatnot.
// Returns 0 if the mode can start and a message explaining the reason why it can't otherwise.
/datum/game_mode/proc/startRequirements()
	var/playerC = 0
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.client && player.ready)
			playerC++

	if(playerC < required_players)
		return "Not enough players, [src.required_players] players needed."

	var/enemy_count = 0
	var/list/all_antag_types = GLOB.all_antag_types_
	if(antag_tags && antag_tags.len)
		for(var/antag_tag in antag_tags)
			var/datum/antagonist/antag = all_antag_types[antag_tag]
			if(!antag)
				continue
			var/list/potential = list()
			if(antag_templates && antag_templates.len)
				if(antag.flags & ANTAG_OVERRIDE_JOB)
					potential = antag.pending_antagonists
				else
					potential = antag.candidates
			else
				potential = antag.get_potential_candidates(src)
			if(islist(potential))
				if(require_all_templates && potential.len < antag.initial_spawn_req)
					return "Not enough antagonists ([antag.role_text]), [antag.initial_spawn_req] required and [potential.len] available."
				enemy_count += potential.len
				if(enemy_count >= required_enemies)
					return 0
		return "Not enough antagonists, [required_enemies] required and [enemy_count] available."
	else
		return 0

/datum/game_mode/proc/refresh_event_modifiers()
	if(event_delay_mod_moderate || event_delay_mod_major)
		SSevent.report_at_round_end = 1
		if(event_delay_mod_moderate)
			var/datum/event_container/EModerate = SSevent.event_containers[EVENT_LEVEL_MODERATE]
			EModerate.delay_modifier = event_delay_mod_moderate
		if(event_delay_mod_moderate)
			var/datum/event_container/EMajor = SSevent.event_containers[EVENT_LEVEL_MAJOR]
			EMajor.delay_modifier = event_delay_mod_major

/datum/game_mode/proc/pre_setup()
	for(var/datum/antagonist/antag in antag_templates)
		antag.update_current_antag_max()
		antag.build_candidate_list() //compile a list of all eligible candidates

		//antag roles that replace jobs need to be assigned before the job controller hands out jobs.
		if(antag.flags & ANTAG_OVERRIDE_JOB)
			antag.attempt_spawn() //select antags to be spawned
	return TRUE

///post_setup()
/datum/game_mode/proc/post_setup()

	next_spawn = world.time + rand(min_autotraitor_delay, max_autotraitor_delay)

	refresh_event_modifiers()

	spawn (ROUNDSTART_LOGOUT_REPORT_TIME)
		display_roundstart_logout_report()

	spawn (rand(waittime_l, waittime_h))
		GLOB.using_map.send_welcome()
		sleep(rand(100,150))
		announce_ert_disabled()

	//Assign all antag types for this game mode. Any players spawned as antags earlier should have been removed from the pending list, so no need to worry about those.
	for(var/datum/antagonist/antag in antag_templates)
		if(!(antag.flags & ANTAG_OVERRIDE_JOB))
			antag.attempt_spawn() //select antags to be spawned
		antag.finalize_spawn() //actually spawn antags

	//Finally do post spawn antagonist stuff.
	for(var/datum/antagonist/antag in antag_templates)
		antag.post_spawn()

	if(evacuation_controller && auto_recall_shuttle)
		evacuation_controller.auto_recall(auto_recall_shuttle)


	feedback_set_details("round_start","[time2text(world.realtime)]")
	if(SSticker && SSticker.mode)
		feedback_set_details("game_mode","[SSticker.mode]")
	feedback_set_details("server_ip","[world.internet_address]:[world.port]")
	return 1

/datum/game_mode/proc/fail_setup()
	for(var/datum/antagonist/antag in antag_templates)
		antag.reset_antag_selection()

/datum/game_mode/proc/announce_ert_disabled()
	if(!ert_disabled)
		return

	var/list/reasons = list(
		"political instability",
		"quantum fluctuations",
		"hostile raiders",
		"derelict station debris",
		"REDACTED",
		"ancient alien artillery",
		"solar magnetic storms",
		"sentient time-travelling killbots",
		"gravitational anomalies",
		"wormholes to another dimension",
		"a telescience mishap",
		"radiation flares",
		"supermatter dust",
		"leaks into a negative reality",
		"antiparticle clouds",
		"residual bluespace energy",
		"suspected criminal operatives",
		"malfunctioning von Neumann probe swarms",
		"shadowy interlopers",
		"a stranded Vox arkship",
		"haywire IPC constructs",
		"rogue Martian exiles",
		"artifacts of eldritch horror",
		"a brain slug infestation",
		"killer bugs that lay eggs in the husks of the living",
		"a deserted transport carrying xenomorph specimens",
		"an emissary for the gestalt requesting a security detail",
		"a Tajaran slave rebellion",
		"radical Skrellian transevolutionaries",
		"classified security operations",
		"a gargantuan glowing goat"
		)
	command_announcement.Announce("The presence of [pick(reasons)] in the region is tying up all available local emergency resources; emergency response teams cannot be called at this time, and post-evacuation recovery efforts will be substantially delayed.","Emergency Transmission")

/datum/game_mode/proc/check_finished(var/force_ending)

	//Gameticker is trying to force the round to end, we won't stand in its way. An overriding subtype might
	if (force_ending)
		return TRUE

	if(station_was_nuked)
		return GAME_FINISHED
	if(end_on_antag_death && antag_templates && antag_templates.len)
		var/has_antags = 0
		for(var/datum/antagonist/antag in antag_templates)
			if(!antag.antags_are_dead())
				has_antags = 1
				break
		if(!has_antags)
			evacuation_controller.recall = 0
			return GAME_FINISHED
	return GAME_NOT_FINISHED


/datum/game_mode/proc/create_characters()
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player?.ready && player?.mind)
			if(player.mind.assigned_role=="AI")
				player.close_spawn_windows()
				player.AIize()
			else if(!player.mind.assigned_role)
				continue
			else
				if(player.create_character())
					player.client?.init_verbs()
					qdel(player)
		CHECK_TICK


/datum/game_mode/proc/collect_minds()
	for(var/mob/living/player in GLOB.player_list)
		if(player.mind)
			GLOB.minds += player.mind
		CHECK_TICK


/datum/game_mode/proc/equip_characters()
	var/captainless=1
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player && player.mind && player.mind.assigned_role)
			if(player.mind.assigned_role == "Captain")
				captainless=0
			if(!player_is_antag(player.mind, only_offstation_roles = 1))
				job_master.EquipRank(player, player.mind.assigned_role, 0)
				//equip_custom_items(player)
				equip_loadout(player, player.mind.assigned_role, player.client.prefs)
	if(captainless)
		for(var/mob/M in GLOB.player_list)
			if(!istype(M,/mob/dead/new_player))
				to_chat(M, "<span class='infoplain'>Captainship not forced on anyone.</span>")

/datum/game_mode/proc/cleanup()	//This is called when the round has ended but not the game, if any cleanup would be necessary in that case.
	return

/datum/game_mode/proc/declare_completion()
	set waitfor = FALSE

	check_victory()
	sleep(2)

	var/list/all_antag_types = GLOB.all_antag_types_
	for(var/datum/antagonist/antag in antag_templates)
		antag.check_victory()
		antag.print_player_summary()
		sleep(2)
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(!antag.current_antagonists.len || (antag in antag_templates))
			continue
		sleep(2)
		antag.print_player_summary()
	sleep(2)

	uplink_purchase_repository.print_entries()

	var/surviving_humans = 0
	var/surviving_total = 0
	var/ghosts = 0
	var/escaped_humans = 0
	var/escaped_total = 0
	var/alive_necros = 0
	var/escaped_necros = 0

	for(var/mob/M in SSmobs.mob_list)
		if (QDELETED(M))
			continue

		if(isghost(M))
			ghosts++
		else if (isliving(M))
			if (M.stat == DEAD)
				continue
			var/escaped = FALSE
			var/area/A = get_area(M)
			if(A && is_type_in_list(A, GLOB.using_map.post_round_safe_areas))
				escaped = TRUE
			if(!M.is_necromorph())
				surviving_total++
				if(escaped)
					escaped_total++
					if(ishuman(M))
						surviving_humans++
						if(escaped)
							escaped_humans++
			else
				alive_necros++
				if(escaped)
					escaped_necros++

	var/text = ""
	if(escaped_humans > 0 && escaped_humans < 4) // Between 1 and 3 players escaped, count as Necro Minor Victory.
		round_finished = "Necromorph Minor"
		text += "<br><h2><b><center><span class='danger'>Necromorph Minor Victory!</span></center></b></h2>"
		text += "<br><center>Necromorphs have slain a majority of the crew!</center>"
		text += "<br><b><center>And so ends the struggle on [station_name()]...</center></b>"
		text += "<br><center>There [surviving_humans>1 ? "were <b>[surviving_humans] survivors</b>" : "was <b>one survivor</b>"], with [escaped_humans>1 ? "<b>[escaped_total] managing to evacuate</b>" : "was <b>one evacuee</b>"]</center>"
		SEND_SOUND(world, sound('sound/music/ds13/credits_violin.ogg', wait = 0, volume = 40, channel = GLOB.lobby_sound_channel))
		if(escaped_necros > 0)
			text += "<br><center>There [alive_necros>0 ? "were <b>[alive_necros] alive Necromorphs left</b>" : ""], with [escaped_necros>0 ? "<b>[escaped_necros] having left the Ishimura for greener pastures!</b>" : "<b>was one Necromorph that left the Ishimura for greener pastures!</b>"]</center>"
			if(escaped_necros > 0 && escaped_necros < 4) // Between 1 and 3 Necro's escaped? Marker is displeased.
				text += "<br><center><h3>The Marker is <span class ='warning'> displeased!</h3></span></center>"
			else if(escaped_necros > 3 && escaped_necros < 7) // Between 4 and 6 Necro's escaped? The Marker is angery.
				text += "<br><center><h3>The Marker is <span class ='danger'> angry!</h3></span></center>"
			else if(escaped_necros > 6) // More than 7? Marker now has abandonment issues.
				text += "<br><center><h3>The Marker now has <span class ='danger'> abandonment issues</span> and <span class='danger'>spent [rand(1500,150000)] credits in therapy to overcome this crippling condition!</h3></span></center>"
	else if(escaped_humans > 3 && escaped_humans < 9) // Between 4 and 8? Count as survivor minor.
		round_finished = "Survivor Minor"
		text += "<br><h2><b><center><span class='success'>Survivor Minor Victory!</span></center></b></h2>"
		text += "<br><center>Some survivors managed to evacuate!</center>"
		text += "<br><b><cennter>And so ends the struggle on [station_name()]...</center></b>"
		text += "<br><center>There [surviving_humans>1 ? "were <b>[surviving_humans] survivors</b>" : "was <b>one survivor</b>"], with [escaped_humans>1 ? "<b>[escaped_total] managing to evacuate</b>" : "was <b>one evacuee</b>"]</center>"
		SEND_SOUND(world, sound('sound/music/ds13/credits_violin.ogg', wait = 0, volume = 40, channel = GLOB.lobby_sound_channel))
		if(escaped_necros > 0)
			text += "<br><center>There [alive_necros>0 ? "were <b>[alive_necros] alive Necromorphs left</b>" : ""], with [escaped_necros>0 ? "<b>[escaped_necros] having left the Ishimura for greener pastures!</b>" : "<b>was one Necromorph that left the Ishimura for greener pastures!</b>"]</center>"
			if(escaped_necros > 0 && escaped_necros < 4) // Between 1 and 3 Necro's escaped? Marker is displeased.
				text += "<br><center><h3>The Marker is <span class ='warning'> displeased!</h3></span></center>"
			else if(escaped_necros > 3 && escaped_necros < 7) // Between 4 and 6 Necro's escaped? The Marker is angery.
				text += "<br><center><h3>The Marker is <span class ='danger'> angry!</h3></span></center>"
			else if(escaped_necros > 6) // More than 7? Marker now has abandonment issues.
				text += "<br><center><h3>The Marker now has <span class ='danger'> abandonment issues</span> and <span class='danger'>spent [rand(1500,150000)] credits in therapy to overcome this crippling condition!</h3></span></center>"
	else if(escaped_humans > 8) // 9 or more escaped? Big party. Survivor major.
		round_finished = "Survivor Major"
		text += "<br><h1><b><center><span class='success'>Survivor Major Victory!</span></center></b></h1>"
		text += "<br><center>A majority of the survivors managed to evacuate!</center>"
		text += "<br><center><b>And so ends the struggle on [station_name()]...</center></b>"
		text += "<br><center>There [surviving_humans>1 ? "were <b>[surviving_humans] survivors</b>" : "was <b>one survivor</b>"], with [escaped_humans>1 ? "<b>[escaped_total] managing to evacuate</b>" : "was <b>one evacuee</b>"]</center>"
		SEND_SOUND(world, sound('sound/music/ds13/credits_rock.ogg', wait = 0, volume = 40, channel = GLOB.lobby_sound_channel))
		if(escaped_necros > 0)
			text += "<br><center>There [alive_necros>0 ? "were <b>[alive_necros] alive Necromorphs left</b>" : ""], with [escaped_necros>0 ? "<b>[escaped_necros] having left the Ishimura for greener pastures!</b>" : "<b>was one Necromorph that left the Ishimura for greener pastures!</b>"]</center>"
			if(escaped_necros > 0 && escaped_necros < 4) // Between 1 and 3 Necro's escaped? Marker is displeased.
				text += "<br><center><h3>The Marker is <span class ='warning'> displeased!</h3></span></center>"
			else if(escaped_necros > 3 && escaped_necros < 7) // Between 4 and 6 Necro's escaped? The Marker is angery.
				text += "<br><center><h3>The Marker is <span class ='danger'> angry!</h3></span></center>"
			else if(escaped_necros > 6) // More than 7? Marker now has abandonment issues.
				text += "<br><center><h3>The Marker now has <span class ='danger'> abandonment issues</span> and <span class='danger'>spent [rand(1500,150000)] credits in therapy to overcome this crippling condition!</h3></span></center>"
	else if(escaped_humans < 1) // Big sad. Necro major. No evacuees.
		round_finished = "Necromorph Major"
		text += "<br><h1><b><center><span class='danger'>Necromorph Major Victory!</h1></center></b></large>"
		text += "<br><center>The Necromorphs have slain the entire crew!</center>"
		text += "<br><br><center><b>And so ends another struggle on [station_name()]...</b></center>"
		text += "<br><center>There [surviving_humans>1 ? "were <b>[surviving_humans] survivors</b>" : "was <b>one survivor</b>"] of which <b>none</b> managed to evacuate."
		SEND_SOUND(world, sound('sound/music/ds13/twinkle.ogg', wait = 0, volume = 40, channel = GLOB.lobby_sound_channel))
		if(escaped_necros > 0)
			text += "<br><center>There [alive_necros>0 ? "were <b>[alive_necros] alive Necromorphs left</b>" : ""], with [escaped_necros>0 ? "<b>[escaped_necros] having left the Ishimura for greener pastures!</b>" : "<b>was one Necromorph that left the Ishimura for greener pastures!</b>"]</center>"
			if(escaped_necros > 0 && escaped_necros < 4) // Between 1 and 3 Necro's escaped? Marker is displeased.
				text += "<br><center><h3>The Marker is <span class ='warning'> displeased!</h3></span></center>"
			else if(escaped_necros > 3 && escaped_necros < 7) // Between 4 and 6 Necro's escaped? The Marker is angery.
				text += "<br><center><h3>The Marker is <span class ='danger'> angry!</h3></span></center>"
			else if(escaped_necros > 6) // More than 6? Marker now has abandonment issues.
				text += "<br><center><h3>The Marker now has <span class ='danger'> abandonment issues</span> and <span class='danger'>spent [rand(1500,150000)] credits in therapy to overcome this crippling condition!</h3></span></center>"
	else // Safety clause. Pray to god this never gets ran. Wouldn't know why it would do that, if it did.
		text += "<br>DEBUG: You fucked up. This is not meant to happen."
		text += "<br>Contact Lion immediately."
	to_chat(world, "<span class='infoplain'>[text]</span>")

	var/obj/machinery/marker/M = get_marker()
	if (M?.player)
		to_chat(world, "<span class='infoplain'><b>The Marker player was: [M.player]!</b><br></span>")
	else
		to_chat(world, "<span class='infoplain'><b>There was no Marker at the end.</b><br></span>")

	to_chat(world, "<span class='infoplain'><b>The Marker accrued a total biomass of: [round(M.get_total_biomass())]kg</b><br></span>")

	to_chat(world, "<span class='infoplain'><b>The Marker spawned [get_historic_major_vessel_total() ] total necromorphs!</b><br></span>")

	if(ghosts > 0)
		feedback_set("round_end_ghosts",ghosts)
	if(surviving_humans > 0)
		feedback_set("surviving_humans",surviving_humans)
	if(surviving_total > 0)
		feedback_set("survived_total",surviving_total)
	if(escaped_humans > 0)
		feedback_set("escaped_humans",escaped_humans)
	if(escaped_total > 0)
		feedback_set("escaped_total",escaped_total)

	send2mainirc("A round of [src.name] has ended - [surviving_total] survivor\s, [ghosts] ghost\s.")

	return 0

/datum/game_mode/proc/check_win() //universal trigger to be called at mob death, nuke explosion, etc. To be called from everywhere.
	return 0

/datum/game_mode/proc/get_players_for_role(var/antag_id)
	var/list/players = list()
	var/list/candidates = list()

	var/list/all_antag_types = GLOB.all_antag_types_
	var/datum/antagonist/antag_template = all_antag_types[antag_id]
	if(!antag_template)
		return candidates

	// If this is being called post-roundstart then it doesn't care about ready status.
	if(SSticker && SSticker.current_state == GAME_STATE_PLAYING)
		for(var/mob/player in GLOB.player_list)
			if(!player.client)
				continue
			if(istype(player, /mob/dead/new_player))
				continue
			if(!antag_id || (antag_id in player.client.prefs.be_special_role))
				log_debug("[player.key] had [antag_id] enabled, so we are drafting them.")
				candidates += player.mind

	else
		// Assemble a list of active players without jobbans.
		for(var/i in GLOB.new_player_list)
			var/mob/dead/new_player/player = i
			if(player.client && player.ready)
				players += player

		// Get a list of all the people who want to be the antagonist for this round
		for(var/mob/dead/new_player/player in players)
			if(!antag_id || (antag_id in player.client.prefs.be_special_role))
				log_debug("[player.key] had [antag_id] enabled, so we are drafting them.")
				candidates += player.mind
				players -= player

		// If we don't have enough antags, draft people who voted for the round.
		if(candidates.len < max(required_enemies, antag_template.initial_spawn_target))
			for(var/mob/dead/new_player/player in players)
				if(!antag_id || (antag_id in player.client.prefs.be_special_role))
					log_debug("[player.key] has not selected never for this role, so we are drafting them.")
					candidates += player.mind
					players -= player
					if(candidates.len == required_enemies || players.len == 0)
						break

	return candidates		// Returns: The number of people who had the antagonist role set to yes, regardless of recomended_enemies, if that number is greater than required_enemies
							//			required_enemies if the number of people with that role set to yes is less than recomended_enemies,
							//			Less if there are not enough valid players in the game entirely to make required_enemies.

/datum/game_mode/proc/num_players()
	. = 0
	for(var/mob/dead/new_player/P in GLOB.player_list)
		if(P.client && P.ready)
			. ++

/datum/game_mode/proc/check_antagonists_topic(href, href_list[])
	return 0

/datum/game_mode/proc/create_antagonists()

	if(!CONFIG_GET(flag/traitor_scaling))
		antag_scaling_coeff = 0

	var/list/all_antag_types = GLOB.all_antag_types_
	if(antag_tags && antag_tags.len)
		antag_templates = list()
		for(var/antag_tag in antag_tags)
			var/datum/antagonist/antag = all_antag_types[antag_tag]
			if(antag)
				antag_templates |= antag

	if(GLOB.additional_antag_types && GLOB.additional_antag_types.len)
		if(!antag_templates)
			antag_templates = list()
		for(var/antag_type in GLOB.additional_antag_types)
			var/datum/antagonist/antag = all_antag_types[antag_type]
			if(antag)
				antag_templates |= antag

	shuffle(antag_templates) //In the case of multiple antag types
	newscaster_announcements = pick(newscaster_standard_feeds)

/datum/game_mode/proc/check_victory()
	return

//////////////////////////
//Reports player logouts//
//////////////////////////
proc/display_roundstart_logout_report()
	var/msg = "<span class='notice'><b>Roundstart logout report</b>\n\n"
	for(var/mob/living/L in SSmobs.mob_list)

		if(L.ckey)
			var/found = 0
			for(var/client/C in GLOB.clients)
				if(C.ckey == L.ckey)
					found = 1
					break
			if(!found)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Disconnected</b></font>)\n"

		if(L.ckey && L.client)
			if(L.client.inactivity >= (ROUNDSTART_LOGOUT_REPORT_TIME / 2))	//Connected, but inactive (alt+tabbed or something)
				msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (<font color='#ffcc00'><b>Connected, Inactive</b></font>)\n"
				continue //AFK client
			if(L.stat)
				if(L.stat == UNCONSCIOUS)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dying)\n"
					continue //Unconscious
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([L.ckey]), the [L.job] (Dead)\n"
					continue //Dead

			continue //Happy connected client
		for(var/mob/dead/observer/ghost/D in SSmobs.mob_list)
			if(D.mind && (D.mind.original == L || D.mind.current == L))
				if(L.stat == DEAD)
					msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (Dead)\n"
					continue //Dead mob, ghost abandoned
				else
					if(D.can_reenter_corpse)
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Adminghosted</b></font>)\n"
						continue //Lolwhat
					else
						msg += "<b>[L.name]</b> ([ckey(D.mind.key)]), the [L.job] (<font color='red'><b>Ghosted</b></font>)\n"
						continue //Ghosted while alive

	msg += "</span>" // close the span from right at the top

	for(var/mob/M in SSmobs.mob_list)
		if(M.client && M.client.holder)
			to_chat(M, msg)
proc/get_nt_opposed()
	var/list/dudes = list()
	for(var/mob/living/carbon/human/man in GLOB.player_list)
		if(man.client)
			if(man.client.prefs.nanotrasen_relation == COMPANY_OPPOSED)
				dudes += man
			else if(man.client.prefs.nanotrasen_relation == COMPANY_SKEPTICAL && prob(50))
				dudes += man
	if(dudes.len == 0) return null
	return pick(dudes)

/proc/show_objectives(var/datum/mind/player)

	if(!player || !player.current) return

	if(CONFIG_GET(flag/objectives_disabled) == CONFIG_OBJECTIVE_NONE || !player.objectives.len)
		return

	var/obj_count = 1
	to_chat(player.current, "<span class='notice'>Your current objectives:</span>")
	for(var/datum/objective/objective in player.objectives)
		to_chat(player.current, "<B>Objective #[obj_count]</B>: [objective.explanation_text]")
		obj_count++

/mob/verb/check_round_info()
	set name = "Check Round Info"
	set category = "OOC"

	GLOB.using_map.map_info(src)

	if(!SSticker || !SSticker.mode)
		to_chat(usr, "Something is terribly wrong; there is no gametype.")
		return

	if(!SSticker.hide_mode)
		to_chat(usr, "<b>The roundtype is [capitalize(SSticker.mode.name)]</b>")
		if(SSticker.mode.round_description)
			to_chat(usr, "<i>[SSticker.mode.round_description]</i>")
		if(SSticker.mode.extended_round_description)
			to_chat(usr, "[SSticker.mode.extended_round_description]")
	else
		to_chat(usr, "<i>Shhhh</i>. It's a secret.")

//Handlers for people dying / being revived.
/datum/game_mode/proc/on_crew_death(mob/living/carbon/human/H)
	update_living_crew()
	return TRUE

/datum/game_mode/proc/on_crew_revive(mob/living/carbon/human/H)
	update_living_crew()
	return TRUE

/datum/game_mode/proc/on_crew_despawn(mob/living/carbon/human/H)
	if (H.mind)
		H.mind.removed = TRUE
	update_living_crew()
	return TRUE


/datum/game_mode/proc/update_living_crew()
	GLOB.living_crew = list()
	for (var/datum/mind/M in GLOB.all_crew)
		if (M && !QDELETED(M.current) && ishuman(M.current))
			var/mob/living/L = M.current
			if (L.stat != DEAD) //They're alive!
				GLOB.living_crew |= M

//proc returns the amount of alive active humans onboard Ishimura (space turfs are excluded), the rest are considered marooned
/datum/game_mode/proc/get_living_active_crew_aboard_ship()
	var/crew_count = 0
	for(var/datum/mind/M in GLOB.living_crew)
		var/mob/living/L = M.current
		if(!L.client || L.client.is_afk(2 MINUTES))	//activity check
			continue
		if(!isStationLevel(L.z) || istype(get_turf(L), /turf/space))	//location check
			continue
		crew_count++

	return crew_count

/datum/game_mode/proc/is_votable()
	return votable