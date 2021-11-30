#define VOTE_PERIOD	(2 MINUTES)
#define VOTE_DELAY (15 MINUTES)
SUBSYSTEM_DEF(vote)
	name = "Voting"
	wait = 1 SECOND
	priority = SS_PRIORITY_VOTE
	flags = SS_NO_TICK_CHECK | SS_KEEP_TIMING
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

	var/last_started_time        //To enforce delay between votes.
	var/antag_added              //Enforces a maximum of one added antag per round.

	var/datum/vote/active_vote   //The current vote. This handles most voting activity.
	var/list/old_votes           //Stores completed votes for reference.
	var/queued_auto_vote         //Used if a vote queues another vote to happen after it.

	var/list/voting = list()     //Clients recieving UI updates.
	var/list/vote_prototypes     //To run checks on whether they are available.

/datum/controller/subsystem/vote/Initialize()
	vote_prototypes = list()
	for(var/vote_type in subtypesof(/datum/vote))
		var/datum/vote/fake_vote = vote_type
		if(initial(fake_vote.manual_allowed))
			vote_prototypes[vote_type] = new vote_type
	return ..()

/datum/controller/subsystem/vote/fire(resumed = 0)
	if(!active_vote)
		if(queued_auto_vote)
			initiate_vote(queued_auto_vote, automatic = 1)
			queued_auto_vote = null
		return

	switch(active_vote.Process())
		if(VOTE_PROCESS_ABORT)
			QDEL_NULL(active_vote)
			reset()
			return
		if(VOTE_PROCESS_COMPLETE)
			active_vote.tally_result()      // Does math to figure out who won. Data is stored on the vote datum.
			active_vote.report_result()     // Announces the result; possibly alerts other entities of the result.
			LAZYADD(old_votes, active_vote) // Store the datum for future reference.
			reset()
			return
		/* Spam people with the voting panel every tick? Why??
		if(VOTE_PROCESS_ONGOING)
			for(var/client/C in voting)
				show_panel(C.mob)
		*/

/datum/controller/subsystem/vote/stat_entry()
	..("Vote:[active_vote ? "[active_vote.name], [active_vote.time_remaining]" : "none"]")

/datum/controller/subsystem/vote/Recover()
	last_started_time = SSvote.last_started_time
	antag_added = SSvote.antag_added
	active_vote = SSvote.active_vote
	queued_auto_vote = SSvote.queued_auto_vote

/datum/controller/subsystem/vote/proc/reset()
	active_vote = null
	SStgui.close_uis(src)
	voting.Cut()

//A false return means that a vote couldn't be started.
/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, mob/creator, automatic = 0)
	to_chat(world, "Initiating vote 1")
	if(active_vote)
		return FALSE
	to_chat(world, "Initiating vote 2")
	if(!automatic && (!istype(creator) || !creator.client))
		return FALSE

	to_chat(world, "Initiating vote 3")
	if(last_started_time != null && !(is_admin(creator) || automatic))
		var/next_allowed_time = (last_started_time + VOTE_DELAY)
		if(next_allowed_time > world.time)
			return FALSE

	to_chat(world, "Initiating vote 4")
	var/datum/vote/new_vote = new vote_type
	if(!new_vote.setup(creator, automatic))
		return FALSE

	to_chat(world, "Initiating vote 5")
	active_vote = new_vote
	last_started_time = world.time
	return TRUE




/*
	UI
*/


/datum/controller/subsystem/vote/ui_data(mob/user)
	var/list/data
	if (active_vote)
		data = active_vote.ui_data()
	
	else
		//This UI data is for when no vote is currently ongoing
		data = list(
			"allow_vote_mode" = CONFIG_GET(flag/allow_vote_mode),
			"allow_vote_restart" = CONFIG_GET(flag/allow_vote_restart),
			"lower_admin" = !!user.client?.holder,
			"mode" = "custom",
			"choices" = list(),
			//"question" = question,
			//"selected_choice" = choice_by_ckey[user.client?.ckey],
			//"time_remaining" = time_remaining,
			"admin" = check_rights(R_ADMIN, FALSE, user.client),
			"voting" = list(),
		)

	if(!!user.client?.holder)
		data["voting"] = voting

	/* This comes from the vote datum
	
	*/

	to_chat(world, "Data: [dump_list(data)]")

	return data

/datum/controller/subsystem/vote/ui_act(action, params)
	to_chat(world, "SSVote Handle TGUI: [action], [dump_list(params)]")
	. = ..()
	if(.)
		return

	to_chat(world, "SSVote 2")

	var/admin = FALSE
	if(usr.client.holder)
		admin = TRUE

	if (active_vote)
		active_vote.handle_tgui(action, params, admin)
		return TRUE

	to_chat(world, "SSVote 3")

	switch(action)
		if("toggle_restart")
			if(usr.client.holder && admin)
				CONFIG_SET(flag/allow_vote_restart, !CONFIG_GET(flag/allow_vote_restart))
		if("restart")
			if(CONFIG_GET(flag/allow_vote_restart) || usr.client.holder)
				initiate_vote(/datum/vote/restart,usr)
		if("toggle_gamemode")
			if(usr.client.holder && admin)
				CONFIG_SET(flag/allow_vote_mode, !CONFIG_GET(flag/allow_vote_mode))
		if("gamemode")
			to_chat(world, "SSVote 4")
			if(CONFIG_GET(flag/allow_vote_mode) || usr.client.holder)
				to_chat(world, "SSVote 5")
				initiate_vote(/datum/vote/gamemode,usr)
		if("custom")
			if(usr.client.holder)
				initiate_vote(/datum/vote/custom,usr)
		if("vote")
			submit_vote(usr, round(text2num(params["index"])))
	return TRUE


/*

/datum/controller/subsystem/vote/proc/interface(client/C)
	if(!C)
		return
	var/admin = is_admin(C)
	voting |= C

	. = list()
	. += "<html><head><title>Voting Panel</title></head><body>"
	if(active_vote)
		. += active_vote.interface(C.mob)
		if(admin)
			. += "(<a href='?src=\ref[src];cancel=1'>Cancel Vote</a>) "
	else
		. += "<h2>Start a vote:</h2><hr><ul>"
		for(var/vote_type in vote_prototypes)
			var/datum/vote/vote_datum = vote_prototypes[vote_type]
			. += "<li><a href='?src=\ref[src];vote=\ref[vote_datum.type]'>"
			if(vote_datum.can_run(C.mob))
				. += "[capitalize(vote_datum.name)]"
			else
				. += "<font color='grey'>[capitalize(vote_datum.name)] (Disallowed)</font>"
			. += "</a>"
			var/toggle = vote_datum.check_toggle()
			if(admin && toggle)
				. += "\t(<a href='?src=\ref[src];toggle=1;vote=\ref[vote_datum.type]'>toggle; currently [toggle]</a>)"
			. += "</li>"
		. += "</ul><hr>"

	. += "<a href='?src=\ref[src];close=1' style='position:absolute;right:50px'>Close</a></body></html>"
	return JOINTEXT(.)

/datum/controller/subsystem/vote/proc/show_panel(mob/user)
	var/win_x = 450
	var/win_y = 740
	if(active_vote)
		win_x = active_vote.win_x
		win_y = active_vote.win_y
	show_browser(user, interface(user.client),"window=vote;size=[win_x]x[win_y]")
	onclose(user, "vote", src)

	/datum/controller/subsystem/vote/proc/close_panel(mob/user)
	show_browser(user, null, "window=vote")
	if(user)
		voting -= user.client
*/

/datum/controller/subsystem/vote/tgui_interact(mob/user, datum/tgui/ui)
	// Tracks who is voting
	if(!(user.client?.ckey in voting))
		voting += user.client?.ckey
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Vote")
		ui.open()

/datum/controller/subsystem/vote/ui_state()
	return GLOB.tgui_always_state






/datum/controller/subsystem/vote/proc/cancel_vote(mob/user)
	if(!is_admin(user))
		return
	active_vote.report_result() // Will not make announcement, but do any override failure reporting tasks.
	QDEL_NULL(active_vote)
	reset()

/datum/controller/subsystem/vote/Topic(href,href_list[],hsrc)
	to_chat(world, "Handle Topic: [href]")
	if(href_list["vote_panel"])
		tgui_interact(usr)
		return

/* Topic is not used much, we have ui_act instead
	if(href_list["cancel"])
		cancel_vote(usr)
		return
	if(href_list["close"])
		close_panel(usr)
		return

	if(href_list["vote"])
		var/vote_path = locate(href_list["vote"])
		if(!ispath(vote_path, /datum/vote))
			return

		if(href_list["toggle"])
			var/datum/vote/vote_datum = vote_prototypes[vote_path]
			if(!vote_datum)
				return
			vote_datum.toggle(usr)
			show_panel(usr)
			return

		initiate_vote(vote_path, usr, 0) // Additional permission checking happens in here.
*/
//Helper for certain votes.
/datum/controller/subsystem/vote/proc/restart_world()
	set waitfor = FALSE

	to_world("World restarting due to vote...")
	//SSstatistics.set_field_details("end_error","restart vote")
	sleep(50)
	log_game("Rebooting due to restart vote")
	world.Reboot()

// Helper proc for determining whether addantag vote can be called.
/datum/controller/subsystem/vote/proc/is_addantag_allowed(mob/creator, automatic)
	if(!config.allow_extra_antags)
		return 0
	// Gamemode has to be determined before we can add antagonists, so we can respect gamemode's add antag vote settings.
	if((GAME_STATE <= RUNLEVEL_SETUP) || !SSticker.mode)
		return 0
	if(automatic)
		return (SSticker.mode.addantag_allowed & ADDANTAG_AUTO) && !antag_added
	if(is_admin(creator))
		return SSticker.mode.addantag_allowed & (ADDANTAG_ADMIN|ADDANTAG_PLAYER)
	else
		return (SSticker.mode.addantag_allowed & ADDANTAG_PLAYER) && !antag_added

/mob/verb/vote()
	set category = "OOC"
	set name = "Vote"

	if(GAME_STATE < RUNLEVEL_LOBBY)
		to_chat(src, "It's too soon to do any voting!")
		return
	//SSvote.show_panel(src)
	SSvote.tgui_interact(usr)

/datum/controller/subsystem/vote/proc/submit_vote(var/mob/user, vote)
	if(active_vote)
		active_vote.submit_vote(user, vote)
	

/*
SUBSYSTEM_DEF(vote)
	name = "Vote"
	wait = 10

	flags = SS_KEEP_TIMING|SS_NO_INIT

	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/choices = list()
	var/list/choice_by_ckey = list()
	var/list/generated_actions = list()
	var/initiator
	var/mode
	var/question
	var/started_time
	var/time_remaining
	var/list/voted = list()
	var/list/voting = list()

// Called by master_controller
/datum/controller/subsystem/vote/fire()
	if(!mode)
		return
	time_remaining = round((started_time + CONFIG_GET(number/vote_period) - world.time)/10)
	if(time_remaining < 0)
		result()
		
		reset()

/datum/controller/subsystem/vote/proc/reset()
	choices.Cut()
	choice_by_ckey.Cut()
	initiator = null
	mode = null
	question = null
	time_remaining = 0
	voted.Cut()
	voting.Cut()
	SStgui.close_uis(src)

	//remove_action_buttons()

/datum/controller/subsystem/vote/proc/get_result()
	//get the highest number of votes
	var/greatest_votes = 0
	var/total_votes = 0
	for(var/option in choices)
		var/votes = choices[option]
		total_votes += votes
		if(votes > greatest_votes)
			greatest_votes = votes
	//default-vote for everyone who didn't vote
	if(!CONFIG_GET(flag/default_no_vote) && choices.len)
		var/list/non_voters = GLOB.ckey_directory.Copy()
		non_voters -= voted
		for (var/non_voter_ckey in non_voters)
			var/client/C = non_voters[non_voter_ckey]
			if (!C || C.is_afk())
				non_voters -= non_voter_ckey
		if(non_voters.len > 0)
			if(mode == "restart")
				choices["Continue Playing"] += non_voters.len
				if(choices["Continue Playing"] >= greatest_votes)
					greatest_votes = choices["Continue Playing"]

	. = list()
	if(greatest_votes)
		for(var/option in choices)
			if(choices[option] == greatest_votes)
				. += option
	return .

/datum/controller/subsystem/vote/proc/announce_result()
	var/list/winners = get_result()
	var/text
	if(winners.len > 0)
		if(question)
			text += "<b>[question]</b>"
		else
			text += "<b>[capitalize(mode)] Vote</b>"
		for(var/i=1,i<=choices.len,i++)
			var/votes = choices[choices[i]]
			if(!votes)
				votes = 0
			text += "\n<b>[choices[i]]:</b> [votes]"
		if(mode != "custom")
			if(winners.len > 1)
				text = "\n<b>Vote Tied Between:</b>"
				for(var/option in winners)
					text += "\n\t[option]"
			. = pick(winners)
			text += "\n<b>Vote Result: [.]</b>"
		else
			text += "\n<b>Did not vote:</b> [GLOB.clients.len-voted.len]"
	else
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	log_vote(text)
	//remove_action_buttons()
	to_chat(world, "\n<span class='infoplain'><font color='purple'>[text]</font></span>")
	return .

/datum/controller/subsystem/vote/proc/result()
	. = announce_result()
	var/restart = FALSE
	if(.)
		switch(mode)
			if("restart")
				if(. == "Restart Round")
					restart = TRUE
			if("gamemode")
				if(GLOB.master_mode != .)
					SSticker.save_mode(.)
					if(SSticker.HasRoundStarted())
						restart = TRUE
					else
						GLOB.master_mode = .

	if(restart)
		var/active_admins = FALSE
		for(var/client/C in GLOB.admins)
			if(!C.is_afk() && check_rights(R_SERVER, FALSE, C))
				active_admins = TRUE
				break
		if(!active_admins)
			// No delay in case the restart is due to lag
			to_chat(world, "<span class='infoplain'>World restarting due to vote...</span>")

			feedback_set_details("end_error","restart vote")
			if(blackbox)
				blackbox.save_all_data_to_sql()
			sleep(50)
			log_game("Rebooting due to restart vote")
			world.Reboot(ping=TRUE)
		else
			to_chat(world, "<span style='boldannounce'>Notice:Restart vote will not restart the server automatically because there are active admins on.</span>")
			message_admins("A restart vote has passed, but there are active admins on with +server, so it has been canceled. If you wish, you may restart the server.")

	return .



/datum/controller/subsystem/vote/proc/initiate_vote(vote_type, initiator_key)
	//Server is still intializing.
	if(!Master.current_runlevel)
		to_chat(usr, SPAN_WARNING("Cannot start vote, server is not done initializing."))
		return FALSE
	var/lower_admin = FALSE
	var/ckey = ckey(initiator_key)
	if(ckey && GLOB.admin_datums[ckey])
		lower_admin = TRUE

	if(!mode)
		if(started_time)
			var/next_allowed_time = (started_time + CONFIG_GET(number/vote_delay))
			if(mode)
				to_chat(usr, SPAN_WARNING("There is already a vote in progress! please wait for it to finish."))
				return FALSE
			if(next_allowed_time > world.time && !lower_admin)
				to_chat(usr, SPAN_WARNING("A vote was initiated recently, you must wait [DisplayTimeText(next_allowed_time-world.time)] before a new vote can be started!"))
				return FALSE

		reset()
		switch(vote_type)
			if("restart")
				choices.Add("Restart Round","Continue Playing")
			if("gamemode")
				for(var/datum/game_mode/mode as anything in config.votable_modes)
					var/players = length(GLOB.clients)
					if(players < mode.required_players)
						continue
					choices.Add(mode.config_tag)
			if("custom")
				question = stripped_input(usr,"What is the vote for?")
				if(!question)
					return FALSE
				for(var/i=1,i<=10,i++)
					var/option = capitalize(stripped_input(usr,"Please enter an option or hit cancel to finish"))
					if(!option || mode || !usr.client)
						break
					choices.Add(option)
			else
				return FALSE
		mode = vote_type
		initiator = initiator_key
		started_time = world.time
		var/text = "[capitalize(mode)] vote started by [initiator || "CentCom"]."
		if(mode == "custom")
			text += "\n[question]"
		log_vote(text)
		var/vp = CONFIG_GET(number/vote_period)
		to_chat(world, "\n<span class='infoplain'><font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='byond://winset?command=vote'>here</a> to place your votes.\nYou have [DisplayTimeText(vp)] to vote.</font></span>")
		time_remaining = round(vp/10)
		for(var/c in GLOB.clients)
			var/client/C = c
			//var/datum/action/vote/V = new
			//if(question)
			//	V.name = "Vote: [question]"
			//C.player_details.player_actions += V
			//V.Grant(C.mob)
			//generated_actions += V
			SEND_SOUND(C, sound('sound/misc/bloop.ogg'))
		return TRUE
	return FALSE

/datum/controller/subsystem/vote/proc/automatic_vote()
	initiate_vote("gamemode", null, TRUE)






/*
/datum/controller/subsystem/vote/proc/remove_action_buttons()
	for(var/v in generated_actions)
		var/datum/action/vote/V = v
		if(!QDELETED(V))
			V.remove_from_client()
			V.Remove(V.owner)
	generated_actions = list()
*/
/datum/controller/subsystem/vote/ui_close(mob/user)
	voting -= user.client?.ckey

/*
/datum/action/vote
	name = "Vote!"
	button_icon_state = "vote"

/datum/action/vote/Trigger()
	if(owner)
		owner.vote()
		remove_from_client()
		Remove(owner)

/datum/action/vote/IsAvailable()
	return TRUE

/datum/action/vote/proc/remove_from_client()
	if(!owner)
		return
	if(owner.client)
		owner.client.player_details.player_actions -= src
	else if(owner.ckey)
		var/datum/player_details/P = GLOB.player_details[owner.ckey]
		if(P)
			P.player_actions -= src
*/

*/