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
	for(var/datum/vote/fake_vote as anything in subtypesof(/datum/vote))
		if(initial(fake_vote.manual_allowed))
			vote_prototypes[fake_vote] = new fake_vote
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
	if(active_vote)
		return FALSE
	
	if(!automatic && (!istype(creator) || !creator.client))
		return FALSE

	if(last_started_time != null && !(is_admin(creator) || automatic))
		var/next_allowed_time = (last_started_time + VOTE_DELAY)
		if(next_allowed_time > world.time)
			return FALSE

	var/datum/vote/new_vote = new vote_type
	if(!new_vote.setup(creator, automatic))
		return FALSE

	active_vote = new_vote
	last_started_time = world.time
	return TRUE




/*
	UI
*/


/datum/controller/subsystem/vote/ui_data(mob/user)
	var/list/data = list("admin" = check_rights(R_ADMIN, FALSE, user.client),
			"allow_vote_mode" = CONFIG_GET(flag/allow_vote_mode),
			"allow_vote_restart" = CONFIG_GET(flag/allow_vote_restart),
			"mode" = "custom")
	if (active_vote)
		data += active_vote.ui_data(user)
	
	else
		//This UI data is for when no vote is currently ongoing
		data += list(
			"choices" = list(),
			"voting" = list(),
		)

	if(!!user.client?.holder)
		data["voting"] = voting


	return data

/datum/controller/subsystem/vote/ui_act(action, params)
	. = ..()
	if(.)
		return


	var/admin = FALSE
	if(usr.client.holder)
		admin = TRUE

	if (active_vote)
		active_vote.handle_tgui(action, params, admin)
		return TRUE


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
			if(CONFIG_GET(flag/allow_vote_mode) || usr.client.holder)
				initiate_vote(/datum/vote/gamemode,usr)
		if("custom")
			if(usr.client.holder)
				initiate_vote(/datum/vote/custom,usr)
		if("vote")
			submit_vote(usr, round(text2num(params["index"])))
	return TRUE



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
	if(href_list["vote_panel"])
		tgui_interact(usr)
		return

//Helper for certain votes.
/datum/controller/subsystem/vote/proc/restart_world()
	set waitfor = FALSE

	to_world("World restarting due to vote...")
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
	
