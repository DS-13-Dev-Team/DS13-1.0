SUBSYSTEM_DEF(ticker)
	name = "Ticker"
	init_order = SS_INIT_TICKER

	priority = SS_PRIORITY_TICKER
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_LOBBY | RUNLEVEL_SETUP | RUNLEVEL_GAME

	var/current_state = GAME_STATE_STARTUP	//State of current round used by process()
	var/force_ending = FALSE				//Round was ended by admin intervention
	var/bypass_checks = FALSE 				//Bypass mode init checks
	var/setup_failed = FALSE 				//If the setup has failed at any point

	var/start_immediately = FALSE			//If true, there is no lobby phase, the game starts immediately.
	var/setup_done = FALSE					//All game setup done including mode post setup and

	var/random_players = 0 					// if set to nonzero, ALL players who latejoin or declare-ready join will have random appearances/genders

	var/hide_mode = FALSE
	var/datum/game_mode/mode = null
	var/voted = FALSE
	var/list/gamemode_vote_results  //Will be a list, in order of preference, of form list(config_tag = number of votes).

	var/delay_end = FALSE					//If set true, the round will not restart on it's own
	var/admin_delay_notice = ""				//A message to display to anyone who tries to restart the world after a delay

	var/time_left							//Pre-game timer
	var/start_at

	var/gametime_offset = 432000			//Deciseconds to add to world.time for station time.
	var/station_time_rate_multiplier = 12	//factor of station time progressal vs real time.

	var/roundend_check_paused = FALSE

	var/round_start_time = 0
	var/list/round_start_events
	var/list/round_end_events

	var/graceful = FALSE 					//Will this server gracefully shut down?

	var/queue_delay = 0
	var/list/queued_players = list()		//used for join queues when the server exceeds the hard population cap

	var/totalPlayers = 0					//used for pregame stats on statpanel
	var/totalPlayersReady = 0				//used for pregame stats on statpanel

	var/bypass_gamemode_vote = 0    //Intended for use with admin tools. Will avoid voting and ignore any results.
	var/list/bad_modes = list()     //Holds modes we tried to start and failed to.
	var/revotes_allowed = 0         //How many times a game mode revote might be attempted before giving up.

/datum/controller/subsystem/ticker/Initialize(timeofday)
	load_mode()

	return ..()


/datum/controller/subsystem/ticker/fire()
	switch(current_state)
		if(GAME_STATE_STARTUP)
			if(Master.initializations_finished_with_no_players_logged_in && !length(GLOB.clients))
				return
			if(isnull(start_at))
				start_at = time_left || world.time + (CONFIG_GET(number/lobby_countdown) * 10)
			if (CONFIG_GET(flag/auto_start))
				start_immediately = TRUE
				voted = TRUE
			else
				to_chat(world, SPAN_ROUND_BODY("Welcome to the pre-game lobby of [CONFIG_GET(string/server_name)]!"))
				to_chat(world, SPAN_ROLE_BODY("Please, setup your character and select ready. Game will start in [round(time_left / 10) || CONFIG_GET(number/lobby_countdown)] seconds."))
			current_state = GAME_STATE_PREGAME
			fire()

		if(GAME_STATE_PREGAME)
			if(isnull(time_left))
				time_left = max(0, start_at - world.time)
			if(start_immediately)
				time_left = 0

			if(!voted)
				addtimer(CALLBACK(SSvote, /datum/controller/subsystem/vote.proc/initiate_vote, /datum/vote/gamemode, null, TRUE), 10 SECONDS)
				time_left += 10 SECONDS
				voted = TRUE

			totalPlayers = LAZYLEN(GLOB.new_player_list)
			totalPlayersReady = 0
			//countdown
			if(time_left < 0)
				return
			time_left -= wait

			if(time_left <= 0)
				current_state = GAME_STATE_SETTING_UP
				Master.SetRunLevel(RUNLEVEL_SETUP)
				if(start_immediately)
					fire()

		if(GAME_STATE_SETTING_UP)
			setup_failed = !setup()
			if(setup_failed)
				current_state = GAME_STATE_STARTUP
				time_left = null
				start_at = world.time + (CONFIG_GET(number/lobby_countdown) SECONDS)
				start_immediately = FALSE
				Master.SetRunLevel(RUNLEVEL_LOBBY)

		if(GAME_STATE_PLAYING)
			mode.process(wait * 0.1)

			var/mode_finished = mode.check_finished(force_ending)
			if (mode_finished)
			//if(!roundend_check_paused && mode.check_finished(force_ending) || force_ending)
				SSdatabase.handle_endround_schematics()
				current_state = GAME_STATE_FINISHED
				config.ooc_allowed = TRUE
				config.dooc_allowed = TRUE
				declare_completion(force_ending)
				addtimer(CALLBACK(src, .proc/Reboot), CONFIG_GET(number/vote_period) * 3 + 9 SECONDS)
				Master.SetRunLevel(RUNLEVEL_POSTGAME)

/datum/controller/subsystem/ticker/proc/setup()
	to_chat(world, SPAN_BOLDNOTICE("<b>Enjoy the game!</b>"))
	SEND_SOUND(world, sound(GLOB.using_map.welcome_sound))
	var/init_start = world.timeofday
	//Create and announce mode
	if(GLOB.master_mode=="secret")
		hide_mode = TRUE
	else
		hide_mode = FALSE

	if(GLOB.master_mode=="secret")
		if(secret_force_mode != "secret")
			mode = config.pick_mode(secret_force_mode)
		if(!mode)
			mode = config.pick_mode(GLOB.master_mode)
	else
		mode = config.pick_mode(GLOB.master_mode)



	
//--------------------------------------
	CHECK_TICK
	if(!mode.can_start(bypass_checks))
		to_chat(world, "Reverting to pre-game lobby.")
		QDEL_NULL(mode)
		job_master.ResetOccupations()
		return FALSE


	CHECK_TICK
	if(!mode.pre_setup() && !bypass_checks)
		QDEL_NULL(mode)
		to_chat(world, "<b>Error in pre-setup for [GLOB.master_mode].</b> Reverting to pre-game lobby.")
		job_master.ResetOccupations()
		return FALSE

	CHECK_TICK
	if(!mode.setup() && !bypass_checks)
		QDEL_NULL(mode)
		to_chat(world, "<b>Error in setup for [GLOB.master_mode].</b> Reverting to pre-game lobby.")
		job_master.ResetOccupations()
		return FALSE


	callHook("roundstart")

	CHECK_TICK
	if(hide_mode)
		to_chat(world, "<span class='infoplain'><B>The current game mode is - Secret!</B></span>")
	else
		mode.announce()

	if(CONFIG_GET(flag/ooc_allowed))
		config.ooc_allowed = TRUE

	CHECK_TICK
	//Here we will trigger the auto-observe and auto bst debug things
	if (CONFIG_GET(flag/auto_observe))
		for(var/client/C in GLOB.clients)
			if (C.mob)
				make_observer(C.mob)

	CHECK_TICK

	if (CONFIG_GET(flag/auto_bst))
		for(var/client/C in GLOB.clients)
			if (C.mob)
				C.cmd_dev_bst(TRUE)

	if (CONFIG_GET(flag/debug_verbs))
		for(var/client/C in GLOB.clients)
			C.enable_debug_verbs(TRUE)

	CHECK_TICK
	for(var/I in round_start_events)
		var/datum/callback/cb = I
		cb.InvokeAsync()
	LAZYCLEARLIST(round_start_events)
	CHECK_TICK

	log_world("Game start took [(world.timeofday - init_start) / 10]s")
	round_start_time = world.time

	current_state = GAME_STATE_PLAYING
	Master.SetRunLevel(RUNLEVEL_GAME)

	CHECK_TICK
	PostSetup()
	if(CONFIG_GET(flag/sql_enabled))
		statistic_cycle() // Polls population totals regularly and stores them in an SQL DB -- TLE

	return TRUE


/datum/controller/subsystem/ticker/proc/PostSetup()
	set waitfor = FALSE
	mode.post_setup()

	//Holiday Round-start stuff	~Carn
	Holiday_Game_Start()

	setup_done = TRUE


//These callbacks will fire after roundstart key transfer
/datum/controller/subsystem/ticker/proc/OnRoundstart(datum/callback/cb)
	if(!HasRoundStarted())
		LAZYADD(round_start_events, cb)
	else
		cb.InvokeAsync()


//These callbacks will fire before roundend report
/datum/controller/subsystem/ticker/proc/OnRoundend(datum/callback/cb)
	if(current_state >= GAME_STATE_FINISHED)
		cb.InvokeAsync()
	else
		LAZYADD(round_end_events, cb)


/datum/controller/subsystem/ticker/proc/station_explosion_cinematic(station_missed=0, override = null)
	if(GLOB.cinematic)
		return	//already a cinematic in progress!

	//initialise our cinematic screen object
	var/atom/movable/screen/cinematic = new(src)
	cinematic.icon = 'icons/effects/station_explosion.dmi'
	cinematic.icon_state = "station_intact"
	cinematic.plane = HUD_PLANE
	cinematic.layer = HUD_ABOVE_ITEM_LAYER
	cinematic.mouse_opacity = 0
	cinematic.screen_loc = "1,0"
	GLOB.cinematic = cinematic

	if(station_missed)
		for(var/mob/living/M in GLOB.living_mob_list)
			if(M.client)
				M.client.screen += cinematic	//show every client the cinematic
	else	//nuke kills everyone on z-level 1 to prevent "hurr-durr I survived"
		for(var/mob/living/M in GLOB.living_mob_list)
			if(M.client)
				M.client.screen += cinematic

			switch(M.z)
				if(0)	//inside a crate or something
					var/turf/T = get_turf(M)
					if(T && (T.z in GLOB.using_map.station_levels))				//we don't use M.death(0) because it calls a for(/mob) loop and
						M.health = 0
						M.set_stat(DEAD)
				if(1)	//on a z-level 1 turf.
					M.health = 0
					M.set_stat(DEAD)

	//Now animate the cinematic
	switch(station_missed)
		if(1)	//nuke was nearby but (mostly) missed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke wasn't on station when it blew up
					flick("intro_nuke",cinematic)
					sleep(35)
					SEND_SOUND(world, sound('sound/effects/explosionfar.ogg'))
					flick("station_intact_fade_red",cinematic)
					cinematic.icon_state = "summary_nukefail"
				else
					flick("intro_nuke",cinematic)
					sleep(35)
					SEND_SOUND(world, sound('sound/effects/explosionfar.ogg'))
					//flick("end",cinematic)


		if(2)	//nuke was nowhere nearby	//TODO: a really distant explosion animation
			sleep(50)
			SEND_SOUND(world, sound('sound/effects/explosionfar.ogg'))
		else	//station was destroyed
			if( mode && !override )
				override = mode.name
			switch( override )
				if("mercenary") //Nuke Ops successfully bombed the station
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					SEND_SOUND(world, sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_nukewin"
				if("AI malfunction") //Malf (screen,explosion,summary)
					flick("intro_malf",cinematic)
					sleep(76)
					flick("station_explode_fade_red",cinematic)
					SEND_SOUND(world, sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_malf"
				if("blob") //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red",cinematic)
					SEND_SOUND(world, sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_selfdes"
				else //Station nuked (nuke,explosion,summary)
					flick("intro_nuke",cinematic)
					sleep(35)
					flick("station_explode_fade_red", cinematic)
					SEND_SOUND(world, sound('sound/effects/explosionfar.ogg'))
					cinematic.icon_state = "summary_selfdes"
			for(var/mob/living/M in GLOB.living_mob_list)
				if(is_station_turf(get_turf(M)))
					M.death()//No mercy
	//If its actually the end of the round, wait for it to end.
	//Otherwise if its a verb it will continue on afterwards.
	sleep(300)

	if(cinematic)
		qdel(cinematic)		//end the cinematic
	return

/datum/controller/subsystem/ticker/proc/HasRoundStarted()
	return current_state >= GAME_STATE_PLAYING


/datum/controller/subsystem/ticker/proc/IsRoundInProgress()
	return current_state == GAME_STATE_PLAYING


/datum/controller/subsystem/ticker/Recover()
	current_state = SSticker.current_state
	force_ending = SSticker.force_ending
	mode = SSticker.mode

	delay_end = SSticker.delay_end

	time_left = SSticker.time_left


	queue_delay = SSticker.queue_delay
	queued_players = SSticker.queued_players

	switch(current_state)
		if(GAME_STATE_SETTING_UP)
			Master.SetRunLevel(RUNLEVEL_SETUP)
		if(GAME_STATE_PLAYING)
			Master.SetRunLevel(RUNLEVEL_GAME)
		if(GAME_STATE_FINISHED)
			Master.SetRunLevel(RUNLEVEL_POSTGAME)


/datum/controller/subsystem/ticker/proc/GetTimeLeft()
	if(isnull(SSticker.time_left))
		return round(max(0, start_at - world.time) / 10)
	return round(time_left / 10)


/datum/controller/subsystem/ticker/proc/SetTimeLeft(newtime)
	if(newtime >= 0 && isnull(time_left))	//remember, negative means delayed
		start_at = world.time + newtime
	else
		time_left = newtime


/datum/controller/subsystem/ticker/proc/load_mode()
	var/mode = trim(file2text("data/mode.txt"))
	if(mode)
		GLOB.master_mode = mode
	else
		GLOB.master_mode = "Extended"
	log_game("Saved mode is '[GLOB.master_mode]'")


/datum/controller/subsystem/ticker/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	WRITE_FILE(F, the_mode)

/datum/controller/subsystem/ticker/proc/declare_completion()
	to_chat(world, "<span class='infoplain'><br><br><br><span class='big bold'>A round of [mode.name] has ended!</span></span>")
	for(var/client/C)
		if(!C.credits)
			C.RollCredits()
	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(evacuation_controller.round_over() && evacuation_controller.emergency_evacuation)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, "<span class='infoplain'><font color='blue'><b>You managed to survive, but were marooned on [station_name()] as [Player.real_name]...</b></font></span>")
					else
						to_chat(Player, "<span class='infoplain'><font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font></span>")
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, "<span class='infoplain'><font color='green'><b>You successfully underwent crew transfer after events on [station_name()] as [Player.real_name].</b></font></span>")
				else if(issilicon(Player))
					to_chat(Player, "<span class='infoplain'><font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font></span>")
				else
					to_chat(Player, "<span class='infoplain'><font color='blue'><b>You got through just another workday on [station_name()] as [Player.real_name].</b></font></span>")
			else
				if(isghost(Player))
					var/mob/dead/observer/ghost/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<span class='infoplain'><font color='red'><b>You did not survive the events on [station_name()]...</b></font></span>")
				else
					to_chat(Player, "<span class='infoplain'><font color='red'><b>You did not survive the events on [station_name()]...</b></font></span>")
	to_chat(world, "<br>")


	for (var/mob/living/silicon/ai/aiPlayer in SSmobs.mob_list)
		if (aiPlayer.stat != 2)
			to_chat(world, "<span class='infoplain'><b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws at the end of the round were:</b></span>")

		else
			to_chat(world, "<span class='infoplain'><b>[aiPlayer.name] (Played by: [aiPlayer.key])'s laws when it was deactivated were:</b></span>")

		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = "<span class='infoplain'><b>The AI's loyal minions were:</b></span> "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated) (Played by: [robo.key]), ":" (Played by: [robo.key]), "]"
			to_chat(world, "<span class='infoplain'>[robolist]</span>")


	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in SSmobs.mob_list)

		if(istype(robo,/mob/living/silicon/robot/drone))
			dronecount++
			continue

		if (!robo.connected_ai)
			if (robo.stat != 2)
				to_chat(world, "<span class='infoplain'><b>[robo.name] (Played by: [robo.key]) survived as an AI-less synthetic! Its laws were:</b></span>")

			else
				to_chat(world, "<span class='infoplain'><b>[robo.name] (Played by: [robo.key]) was unable to survive the rigors of being a synthetic without an AI. Its laws were:</b></span>")


			if(robo) //How the hell do we lose robo between here and the world messages directly above this?
				robo.laws.show_laws(world)

	if(dronecount)
		to_chat(world, "<span class='infoplain'><b>There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.</b></span>")

	if(all_money_accounts.len)
		var/datum/money_account/max_profit = all_money_accounts[1]
		var/datum/money_account/max_loss = all_money_accounts[1]
		for(var/datum/money_account/D in all_money_accounts)
			if(D == vendor_account) //yes we know you get lots of money
				continue
			var/saldo = D.get_balance()
			if(saldo >= max_profit.get_balance())
				max_profit = D
			if(saldo <= max_loss.get_balance())
				max_loss = D
		to_chat(world, "<span class='infoplain'><b>[max_profit.owner_name]</b> received most <font color='green'><B>PROFIT</B></font> today, with net profit of <b>T[max_profit.get_balance()]</b>.")
		to_chat(world, "<span class='infoplain'>On the other hand, <b>[max_loss.owner_name]</b> had most <font color='red'><B>LOSS</B></font>, with total loss of <b>T[max_loss.get_balance()]</b>.")

	mode.declare_completion()//To declare normal completion.

	//Ask the event manager to print round end information
	SSevent.RoundEnd()

	//Print a list of antagonists to the server log
	var/list/total_antagonists = list()
	//Look into all mobs in world, dead or alive
	for(var/datum/mind/Mind in GLOB.minds)
		var/temprole = Mind.special_role
		if(temprole)							//if they are an antagonist of some sort.
			if(temprole in total_antagonists)	//If the role exists already, add the name to it
				total_antagonists[temprole] += ", [Mind.name]([Mind.key])"
			else
				total_antagonists.Add(temprole) //If the role doesnt exist in the list, create it and add the mob
				total_antagonists[temprole] += ": [Mind.name]([Mind.key])"

	//Now print them all into the log!
	log_game("Antagonists at round end were...")
	for(var/i in total_antagonists)
		log_game("[i]s[total_antagonists[i]].")

	return TRUE

/datum/controller/subsystem/ticker/proc/Reboot(reason, delay)
	set waitfor = FALSE

	if(usr && !check_rights(R_SERVER))
		return

	if(istype(GLOB.tgs, /datum/tgs_api/v3210))
		var/datum/tgs_api/v3210/API = GLOB.tgs
		if(API.reboot_mode == 2)
			graceful = TRUE
	else if(istype(GLOB.tgs, /datum/tgs_api/v4))
		var/datum/tgs_api/v4/API = GLOB.tgs
		if(API.reboot_mode == 1)
			graceful = TRUE

	if(graceful)
		to_chat_immediate(world, "<h3>[SPAN_BOLDNOTICE("Shutting down...")]</h3>")
		world.Reboot(FALSE)
		return

	if(!delay)
		delay = CONFIG_GET(number/round_end_countdown) * 10

	var/skip_delay = check_rights()
	if(delay_end && !skip_delay)
		to_chat(world, SPAN_BOLDNOTICE("An admin has delayed the round end."))
		return

	to_chat(world, SPAN_BOLDNOTICE("Rebooting World in [DisplayTimeText(delay)]. [reason]"))

	var/start_wait = world.time
	sleep(delay - (world.time - start_wait))

	if(delay_end && !skip_delay)
		to_chat(world, SPAN_BOLDNOTICE("Reboot was cancelled by an admin."))
		return

	log_game("Rebooting World. [reason]")
	to_chat_immediate(world, "<h3>[SPAN_BOLDNOTICE("Rebooting...")]</h3>")

	world.Reboot(TRUE)


/datum/controller/subsystem/ticker/proc/choose_gamemode()
	. = (revotes_allowed && !bypass_gamemode_vote) ? CHOOSE_GAMEMODE_REVOTE : CHOOSE_GAMEMODE_RESTART

	var/mode_to_try = GLOB.master_mode //This is the config tag
	var/datum/game_mode/mode_datum

	//Decide on the mode to try.
	if(!bypass_gamemode_vote && gamemode_vote_results)
		gamemode_vote_results -= bad_modes
		if(length(gamemode_vote_results))
			
			mode_to_try = gamemode_vote_results[1]
			. = CHOOSE_GAMEMODE_RETRY //Worth it to try again at least once.
		else
			mode_to_try = "extended"

	if(!mode_to_try)
		log_debug("Could not find a valid game mode from config or vote results.")
		return
	if(mode_to_try in bad_modes)
		log_debug("Could not start game mode [mode_to_try] - Mode is listed in bad_modes.")
		return

	//Find the relevant datum, resolving secret in the process.
	var/list/base_runnable_modes = config.get_runnable_modes() //format: list(config_tag = weight)
	if((mode_to_try=="random") || (mode_to_try=="secret"))
		var/list/runnable_modes = base_runnable_modes - bad_modes
		if(secret_force_mode != "secret") // Config option to force secret to be a specific mode.
			mode_datum = config.pick_mode(secret_force_mode)
		else if(!length(runnable_modes))  // Indicates major issues; will be handled on return.
			bad_modes += mode_to_try
			log_debug("Could not start game mode [mode_to_try] - No runnable modes available to start, or all options listed under bad modes.")
			return
		else
			mode_datum = config.pick_mode(pickweight(runnable_modes))
			if(length(runnable_modes) > 1) // More to pick if we fail; we won't tell anyone we failed unless we fail all possibilities, though.
				. = CHOOSE_GAMEMODE_SILENT_REDO
	else
		
		mode_datum = config.pick_mode(mode_to_try)
	if(!istype(mode_datum))
		bad_modes += mode_to_try
		log_debug("Could not find a valid game mode for [mode_to_try].")
		return

	//Deal with jobs and antags, check that we can actually run the mode.
	mode_datum.create_antagonists() // Init operation on the mode; sets up antag datums and such.
	mode_datum.pre_setup() // Makes lists of viable candidates; performs candidate draft for job-override roles; stores the draft result both internally and on the draftee.
	
	if(mode_datum.startRequirements())
		mode_datum.fail_setup()
		bad_modes += mode_datum.config_tag
		log_debug("Could not start game mode [mode_to_try] ([mode_datum.name]) - Failed to meet requirements.")
		return

	//Declare victory, make an announcement.
	. = CHOOSE_GAMEMODE_SUCCESS
	mode = mode_datum
	GLOB.master_mode = mode_to_try
	if(mode_to_try == "secret")
		to_world("<B>The current game mode is Secret!</B>")
		var/list/mode_names = list()
		for (var/mode_tag in base_runnable_modes)
			var/datum/game_mode/M = config.gamemode_cache[mode_tag]
			if(M)
				mode_names += M.name
		if (config.secret_hide_possibilities)
			message_admins("<B>Possibilities:</B> [english_list(mode_names)]")
		else
			to_world("<B>Possibilities:</B> [english_list(mode_names)]")
	else
		mode.announce()