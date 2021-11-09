//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/mob/dead/new_player
	var/ready = 0
	var/spawning = 0//Referenced when you want to delete the new_player later on in the code.
	var/datum/browser/panel
	var/show_invalid_jobs = 0
	universal_speak = 1

	invisibility = 101

	density = 0
	stat = DEAD

	movement_handlers = list()
	anchored = 1	//  don't get pushed around

	virtual_mob = null // Hear no evil, speak no evil

/mob/dead/new_player/New()
	..()
	add_verb(src, /mob/proc/toggle_antag_pool)

/mob/dead/new_player/Initialize()
	. = ..()
	GLOB.new_player_list += src

/mob/dead/new_player/Destroy()
	GLOB.new_player_list -= src

	return ..()

/mob/dead/new_player/verb/new_player_panel()
	set src = usr
	new_player_panel_proc()

/mob/dead/new_player/proc/new_player_panel_proc()
	var/output = "<div align='center'>"
	output +="<hr>"
	output += "<p><a href='byond://?src=\ref[src];show_preferences=1'>Setup Character</A></p>"

	if(!ticker || ticker.current_state <= GAME_STATE_PREGAME)
		if(ready)
			output += "<p>\[ <span class='linkOn'><b>Ready</b></span> | <a href='byond://?src=\ref[src];ready=0'>Not Ready</a> \]</p>"
		else
			output += "<p>\[ <a href='byond://?src=\ref[src];ready=1'>Ready</a> | <span class='linkOn'><b>Not Ready</b></span> \]</p>"

	else
		output += "<a href='byond://?src=\ref[src];manifest=1'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];late_join=1'>Join Game!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];observe=1'>Observe</A></p>"

	if(!IsGuestKey(src.key))
		SSdbcore.Connect()
		if(SSdbcore.IsConnected())
			var/isadmin = 0
			if(src.client && src.client.holder)
				isadmin = 1
			var/datum/db_query/query = SSdbcore.NewQuery("SELECT id FROM erro_poll_question WHERE [(isadmin ? "" : "adminonly = false AND")] Now() BETWEEN starttime AND endtime AND id NOT IN (SELECT pollid FROM erro_poll_vote WHERE ckey = \"[ckey]\") AND id NOT IN (SELECT pollid FROM erro_poll_textreply WHERE ckey = \"[ckey]\")")
			query.Execute()
			var/newpoll = 0
			while(query.NextRow())
				newpoll = 1
				break
			qdel(query)

			if(newpoll)
				output += "<p><b><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A> (NEW!)</b></p>"
			else
				output += "<p><a href='byond://?src=\ref[src];showpoll=1'>Show Player Polls</A></p>"

	output += "</div>"

	panel = new(src, "Welcome","Welcome", 210, 280, src)
	panel.set_window_options("can_close=0;titlebar=0")
	panel.set_content(output)
	panel.open()
	return

/mob/dead/new_player/Topic(href, href_list[])
	if(!client)	return FALSE

	.=..()

	if(href_list["show_preferences"])
		client.prefs.ShowChoices(src)
		return TRUE

	if(href_list["ready"])
		if(!ticker || ticker.current_state <= GAME_STATE_PREGAME) // Make sure we don't ready up after the round has started
			ready = text2num(href_list["ready"])
		else
			ready = 0

	if(href_list["refresh"])
		panel.close()
		new_player_panel_proc()

	if(href_list["observe"])
		if(!(initialization_stage&INITIALIZATION_COMPLETE))
			to_chat(src, "<span class='warning'>Please wait for server initialization to complete...</span>")
			return

		if(!CONFIG_GET(number/respawn_delay) || client.holder || tgui_alert(src,"Are you sure you wish to observe? You will have to wait [CONFIG_GET(number/respawn_delay)] minute\s before being able to respawn!","Player Setup", list("Yes","No")) == "Yes")
			return make_observer(src)



	if(href_list["late_join"])

		if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
			to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
			return
		LateChoices() //show the latejoin job selection menu

	if(href_list["manifest"])
		ViewManifest()

	if(href_list["SelectedJob"])
		var/datum/job/job = job_master.GetJob(href_list["SelectedJob"])

		if(!job_master.CheckGeneralJoinBlockers(src, job))
			return FALSE

		var/datum/species/S = all_species[client.prefs.species]
		if(!check_species_allowed(S))
			return FALSE

		//Sanitize the spawnpoint incase an invalid value is saved in
		client.prefs.spawnpoint = sanitize_inlist(client.prefs.spawnpoint, spawntypes(), initial(client.prefs.spawnpoint))

		AttemptLateSpawn(job, client.prefs.spawnpoint)
		return

	if(href_list["privacy_poll"])
		SSdbcore.Connect()
		if(!SSdbcore.IsConnected())
			return
		var/voted = 0

		//First check if the person has not voted yet.
		var/datum/db_query/query = SSdbcore.NewQuery("SELECT * FROM erro_privacy WHERE ckey='[src.ckey]'")
		query.Execute()
		while(query.NextRow())
			voted = 1
			break
		qdel(query)

		//This is a safety switch, so only valid options pass through
		var/option = "UNKNOWN"
		switch(href_list["privacy_poll"])
			if("signed")
				option = "SIGNED"
			if("anonymous")
				option = "ANONYMOUS"
			if("nostats")
				option = "NOSTATS"
			if("later")
				usr << browse(null,"window=privacypoll")
				return
			if("abstain")
				option = "ABSTAIN"

		if(option == "UNKNOWN")
			return

		if(!voted)
			var/sql = "INSERT INTO erro_privacy VALUES (null, Now(), '[src.ckey]', '[option]')"
			var/datum/db_query/query_insert = SSdbcore.NewQuery(sql)
			query_insert.Execute()
			qdel(query_insert)
			to_chat(usr, "<b>Thank you for your vote!</b>")
			usr << browse(null,"window=privacypoll")

	if(!ready && href_list["preference"])
		if(client)
			client.prefs.process_link(src, href_list)
	else if(!href_list["late_join"])
		new_player_panel()

	if(href_list["showpoll"])

		handle_player_polling()
		return

	if(href_list["pollid"])

		var/pollid = href_list["pollid"]
		if(istext(pollid))
			pollid = text2num(pollid)
		if(isnum(pollid))
			src.poll_player(pollid)
		return

	if(href_list["invalid_jobs"])
		show_invalid_jobs = !show_invalid_jobs
		LateChoices()

	if(href_list["votepollid"] && href_list["votetype"])
		var/pollid = text2num(href_list["votepollid"])
		var/votetype = href_list["votetype"]
		switch(votetype)
			if("OPTION")
				var/optionid = text2num(href_list["voteoptionid"])
				vote_on_poll(pollid, optionid)
			if("TEXT")
				var/replytext = href_list["replytext"]
				log_text_poll_reply(pollid, replytext)
			if("NUMVAL")
				var/id_min = text2num(href_list["minid"])
				var/id_max = text2num(href_list["maxid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["o[optionid]"]))	//Test if this optionid was replied to
						var/rating
						if(href_list["o[optionid]"] == "abstain")
							rating = null
						else
							rating = text2num(href_list["o[optionid]"])
							if(!isnum(rating))
								return

						vote_on_numval_poll(pollid, optionid, rating)
			if("MULTICHOICE")
				var/id_min = text2num(href_list["minoptionid"])
				var/id_max = text2num(href_list["maxoptionid"])

				if( (id_max - id_min) > 100 )	//Basic exploit prevention
					to_chat(usr, "The option ID difference is too big. Please contact administration or the database admin.")
					return

				for(var/optionid = id_min; optionid <= id_max; optionid++)
					if(!isnull(href_list["option_[optionid]"]))	//Test if this optionid was selected
						vote_on_poll(pollid, optionid, 1)

/mob/dead/new_player/proc/get_branch_pref()
	if(client)
		return client.prefs.char_branch

/mob/dead/new_player/proc/get_rank_pref()
	if(client)
		return client.prefs.char_rank

/mob/dead/new_player/proc/AttemptLateSpawn(var/datum/job/job, var/spawning_at)
	if(src != usr)
		return FALSE
	if(!ticker || ticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, "<span class='warning'>The round is either not ready, or has already finished...</span>")
		return FALSE
	if(!CONFIG_GET(flag/enter_allowed))
		to_chat(usr, "<span class='notice'>There is an administrative lock on entering the game!</span>")
		return FALSE

	if(!job || !job.is_available(client))
		tgui_alert(src, "[job.title] is not available. Please try another.")
		return FALSE
	if(job.is_restricted(client.prefs, src))
		return

	var/datum/spawnpoint/spawnpoint
	var/turf/spawn_turf
	if(job.latejoin_at_spawnpoints)
		var/obj/S = job_master.get_roundstart_spawnpoint(job.title)
		spawn_turf = get_turf(S)
	else
		spawnpoint = job_master.get_spawnpoint_for(client, job.title, client.prefs, check_safety = TRUE)
		spawn_turf = spawnpoint.get_safe_turf(src, TRUE)

	/*
	if(!job_master.CheckUnsafeSpawn(src, spawn_turf))
		return
	*/
	// Just in case someone stole our position while we were waiting for input from tgui_alert() proc
	if(!job || !job.is_available(client))
		to_chat(src, tgui_alert(src, "[job.title] is not available. Please try another."))
		return FALSE


	job_master.AssignRole(src, job.title, 1)

	var/mob/living/character = create_character(spawn_turf)	//creates the human and transfers vars and mind
	if(!character)
		return FALSE


	character = job_master.EquipRank(character, job.title, 1)					//equips the human
	//equip_custom_items(character)
	equip_loadout(character, job.title, character.client.prefs)




	// AIs don't need a spawnpoint, they must spawn at an empty core
	if(character.mind.assigned_role == "AI")

		character = character.AIize(move=0) // AIize the character, but don't move them yet

		// is_available for AI checks that there is an empty core available in this list
		var/obj/structure/AIcore/deactivated/C = empty_playable_ai_cores[1]
		empty_playable_ai_cores -= C

		character.forceMove(C.loc)
		var/mob/living/silicon/ai/A = character
		A.on_mob_init()

		AnnounceCyborg(character, job.title, "has been downloaded to the empty core in \the [character.loc.loc]")
		ticker.mode.handle_latejoin(character)

		qdel(C)
		qdel(src)
		return

	ticker.mode.handle_latejoin(character)
	GLOB.universe.OnPlayerLatejoin(character)
	if(job_master.ShouldCreateRecords(job.title))
		if(character.mind.assigned_role != "Robot")
			CreateModularRecord(character)


			ticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
			AnnounceArrival(character, job, spawnpoint.msg)
		else
			AnnounceCyborg(character, job, spawnpoint.msg)
		matchmaker.do_matchmaking()
	if(job.head_position)
		log_and_message_admins("has joined the round as [character.mind.assigned_role].", character)

	if(character.cannot_stand())
		equip_wheelchair(character)

	spawnpoint.post_spawn(character, spawn_turf)

	qdel(src)


/mob/dead/new_player/proc/AnnounceCyborg(var/mob/living/character, var/rank, var/join_message)
	if (ticker.current_state == GAME_STATE_PLAYING)
		if(character.mind.role_alt_title)
			rank = character.mind.role_alt_title
		// can't use their name here, since cyborg namepicking is done post-spawn, so we'll just say "A new Cyborg has arrived"/"A new Android has arrived"/etc.
		GLOB.global_announcer.autosay("A new[rank ? " [rank]" : " visitor" ] [join_message ? join_message : "has arrived"].", "Arrivals Announcement Computer")

/mob/dead/new_player/proc/LateChoices()
	var/name = client.prefs.be_random_name ? "friend" : client.prefs.real_name

	var/list/dat = list("<html><body><center>")
	dat += "<b>Welcome, [name].<br></b>"
	dat += "Round Duration: [roundduration2text()]<br>"

	if(evacuation_controller.has_evacuated())
		dat += "<font color='red'><b>The [station_name()] has been evacuated.</b></font><br>"
	else if(evacuation_controller.is_evacuating())
		if(evacuation_controller.emergency_evacuation) // Emergency shuttle is past the point of no recall
			dat += "<font color='red'>The [station_name()] is currently undergoing evacuation procedures.</font><br>"
		else                                           // Crew transfer initiated
			dat += "<font color='red'>The [station_name()] is currently undergoing crew transfer procedures.</font><br>"

	dat += "Choose from the following open/valid positions:<br>"
	dat += "<a href='byond://?src=\ref[src];invalid_jobs=1'>[show_invalid_jobs ? "Hide":"Show"] unavailable jobs.</a><br>"
	dat += "<table>"
	dat += "<tr><td colspan = 3><b>[GLOB.using_map.station_name]:</b></td></tr>"

	// TORCH JOBS
	var/list/job_summaries = list()
	for(var/datum/job/job in job_master.occupations)
		var/summary = job.get_join_link(client, "byond://?src=\ref[src];SelectedJob=[job.title]", show_invalid_jobs)
		if(summary && summary != "")
			job_summaries += summary
	if(LAZYLEN(job_summaries))
		dat += job_summaries
	else
		dat += "No available positions."
	// END TORCH JOBS

	// SUBMAP JOBS
	for(var/thing in SSmapping.submaps)
		var/datum/submap/submap = thing
		if(submap && submap.available())
			dat += "<tr><td colspan = 3><b>[submap.name] ([submap.archetype.descriptor]):</b></td></tr>"
			job_summaries = list()
			for(var/otherthing in submap.jobs)
				var/datum/job/job = submap.jobs[otherthing]
				var/summary = job.get_join_link(client, "byond://?src=\ref[submap];joining=\ref[src];join_as=[otherthing]", show_invalid_jobs)
				if(summary && summary != "")
					job_summaries += summary
			if(LAZYLEN(job_summaries))
				dat += job_summaries
			else
				dat += "No available positions."
	// END SUBMAP JOBS

	dat += "</table></center>"
	src << browse(jointext(dat, null), "window=latechoices;size=450x640;can_close=1")

/mob/dead/new_player/proc/create_character(var/turf/spawn_turf)
	spawning = 1
	close_spawn_windows()

	//Sanitize the spawnpoint incase an invalid value is saved in
	client.prefs.spawnpoint = sanitize_inlist(client.prefs.spawnpoint, spawntypes(), initial(client.prefs.spawnpoint))

	var/mob/living/carbon/human/new_character

	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!spawn_turf)
		var/datum/spawnpoint/spawnpoint = job_master.get_spawnpoint_for(client, get_rank_pref())
		spawn_turf = pick(spawnpoint.turfs)

	if(chosen_species)
		if(!check_species_allowed(chosen_species))
			spawning = 0 //abort
			return null
		new_character = new(spawn_turf, chosen_species.name)
		if(chosen_species.has_organ[BP_POSIBRAIN] && client && client.prefs.is_shackled)
			var/obj/item/organ/internal/posibrain/B = new_character.internal_organs_by_name[BP_POSIBRAIN]
			if(B)	B.shackle(client.prefs.get_lawset())

	if(!new_character)
		new_character = new(spawn_turf)

	new_character.lastarea = get_area(spawn_turf)

	for(var/lang in client.prefs.alternate_languages)
		var/datum/language/chosen_language = all_languages[lang]
		if(chosen_language)
			var/is_species_lang = (chosen_language.name in new_character.species.secondary_langs)
			if(is_species_lang || ((!(chosen_language.flags & RESTRICTED) || has_admin_rights()) && is_alien_whitelisted(src, chosen_language)))
				new_character.add_language(lang)

	if(ticker.random_players)
		new_character.gender = pick(MALE, FEMALE)
		client.prefs.real_name = random_name(new_character.gender)
		client.prefs.randomize_appearance_and_body_for(new_character)
	else
		client.prefs.copy_to(new_character)

	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))// MAD JAMS cant last forever yo
	deltimer(client.lobby_trackchange_timer) //Ensures that the client doesn't attempt to start another lobby music track

	if(mind)
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		if(client.prefs.memory)
			mind.store_memory(client.prefs.memory)
		if(client.prefs.relations.len)
			for(var/T in client.prefs.relations)
				var/TT = matchmaker.relation_types[T]
				var/datum/relation/R = new TT
				R.holder = mind
				R.info = client.prefs.relations_info[T]
			mind.gen_relations_info = client.prefs.relations_info["general"]


		//Here we add them to the all crew list
		//Possible future TODO: Check if they have an assigned role which is actually part of crew.
		//Not needed now since there are no noncrew roles except response teams
		GLOB.all_crew |= mind
		GLOB.living_crew |= mind

		mind.transfer_to(new_character)					//won't transfer key since the mind is not active

		client.prefs.copy_to_mind(new_character.mind)

	new_character.SetName(real_name)
	new_character.dna.ready_dna(new_character)
	new_character.dna.b_type = client.prefs.b_type
	new_character.sync_organ_dna()
	if(client.prefs.disabilities)
		// Set defer to 1 if you add more crap here so it only recalculates struc_enzymes once. - N3X
		new_character.dna.SetSEState(GLOB.GLASSESBLOCK,1,0)
		new_character.disabilities |= NEARSIGHTED

	// Give them their cortical stack if we're using them.
	if(config && CONFIG_GET(flag/use_cortical_stacks) && client && client.prefs.has_cortical_stack /*&& new_character.should_have_organ(BP_BRAIN)*/)
		new_character.create_stack()

	// Do the initial caching of the player's body icons.
	new_character.force_update_limbs()
	new_character.update_eyes()
	new_character.regenerate_icons()

	new_character.key = key		//Manually transfer the key to log them in

	//Register that they've joined the round
	character_spawned(new_character.mind)

	return new_character

/mob/dead/new_player/proc/ViewManifest()
	var/dat = "<div align='center'>"
	dat += html_crew_manifest(OOC = 1)
	//src << browse(dat, "window=manifest;size=370x420;can_close=1")
	var/datum/browser/popup = new(src, "Crew Manifest", "Crew Manifest", 370, 420, src)
	popup.set_content(dat)
	popup.open()

/mob/dead/new_player/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	return FALSE

/mob/dead/new_player/proc/close_spawn_windows()
	src << browse(null, "window=latechoices") //closes late choices window
	if (panel)
		panel.close()

/mob/dead/new_player/proc/has_admin_rights()
	return check_rights(R_ADMIN, 0, src)

/mob/dead/new_player/proc/check_species_allowed(datum/species/S, var/show_alert=1)
	if(!(S.spawn_flags & SPECIES_CAN_JOIN) && !has_admin_rights())
		if(show_alert)
			tgui_alert(src, "Your current species, [client.prefs.species], is not available for play.")
		return FALSE
	if(!is_alien_whitelisted(src, S))
		if(show_alert)
			tgui_alert(src, "You are currently not whitelisted to play [client.prefs.species].")
		return FALSE
	return TRUE

/mob/dead/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = all_species[client.prefs.species]

	if(!chosen_species || !check_species_allowed(chosen_species, 0))
		return SPECIES_HUMAN

	return chosen_species.name

/mob/dead/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/dead/new_player/is_ready()
	return ready && ..()

/mob/dead/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
	return

/mob/dead/new_player/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0)
	return

/mob/dead/new_player/show_message(msg, type, alt, alt_type)
	return

mob/new_player/MayRespawn()
	return TRUE

/mob/dead/new_player/touch_map_edge()
	return

/mob/dead/new_player/say(var/message)
	sanitize_and_communicate(/decl/communication_channel/ooc, client, message)

/mob/dead/new_player/proc/ShowTitleScreen()
	winset(client, "lobbybrowser", "is-disabled=false;is-visible=true")

	show_browser(client, GLOB.using_map.current_lobby_screen, "file=titlescreen.png;display=0")
	show_browser(client, file('html/browser/lobby_titlescreen.html'), "window=lobbybrowser")

/mob/dead/new_player/proc/HideTitleScreen()
	if(my_client.mob) // Check if the client is still connected to something
		// Hide title screen, allowing player to see the map
		winset(my_client, "lobbybrowser", "is-disabled=true;is-visible=false")
