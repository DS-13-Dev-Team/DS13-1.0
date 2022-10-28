/*
Basics, the most important.
*/

/datum/config_entry/string/server_name	// The name used for the server almost universally.

/datum/config_entry/flag/server_suffix  //generate numeric suffix based on server port

/datum/config_entry/string/title		//TITLE mainwindow

/datum/config_entry/flag/hub

/datum/config_entry/flag/hub/ValidateAndSet(str_val)
	. = ..()
	if(.)
		world.update_hub_visibility(config_entry_value)

/datum/config_entry/flag/log_ooc    //log OOC channel

/datum/config_entry/flag/log_looc	//log LOOC channel

/datum/config_entry/flag/log_necro  //log necrochat

/datum/config_entry/flag/log_access //log login/logout

/datum/config_entry/flag/log_say    //log client say

/datum/config_entry/flag/log_admin  //log admin actions

/datum/config_entry/flag/log_debug  //log debug output

/datum/config_entry/flag/log_game   //log game events

/datum/config_entry/flag/log_vote   //log voting

/datum/config_entry/flag/log_whisper    //log client whisper

/datum/config_entry/flag/log_emote  //log emotes

/datum/config_entry/flag/log_attack //log attack messages

/datum/config_entry/flag/log_adminchat  //log admin chat messages

/datum/config_entry/flag/log_adminwarn  //log warnings admins get about bomb construction and such

/datum/config_entry/flag/log_pda    //log pda messages

/datum/config_entry/flag/log_hrefs  //logs all links clicked in-game. Could be used for debugging and tracking down exploits
    protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/log_world_output   //log world.log << messages

/datum/config_entry/flag/log_world_topic	// log all world.Topic() calls

/datum/config_entry/flag/sql_enabled    //for sql switching

/datum/config_entry/flag/allow_admin_ooccolor   //Allows admins with relevant permissions to have their own ooc colour

/datum/config_entry/flag/allow_vote_restart //allow votes to restart

/datum/config_entry/flag/ert_admin_call_only    //ert can call only admins

/datum/config_entry/flag/allow_vote_mode    //allow votes to change mode

/datum/config_entry/flag/allow_map_voting
	deprecated_by = /datum/config_entry/flag/preference_map_voting

/datum/config_entry/flag/allow_map_voting/DeprecationUpdate(value)
	return value

/datum/config_entry/flag/preference_map_voting

/datum/config_entry/flag/maprotation

/datum/config_entry/flag/allow_admin_jump   //allows admin jumping
	config_entry_value = TRUE

/datum/config_entry/flag/disable_admin_spawn   //allows admin item spawning

/datum/config_entry/flag/disable_admin_rev    //allows admin revives

/datum/config_entry/number/vote_delay   //minimum time between voting sessions (deciseconds, 10 minute default)
    config_entry_value = 6000

/datum/config_entry/number/vote_period  //length of voting period (deciseconds, default 1 minute)
    config_entry_value = 600

/datum/config_entry/number/vote_autotransfer_initial //Length of time before the first autotransfer vote is called
    config_entry_value = 108000

/datum/config_entry/number/vote_autotransfer_interval   //length of time before next sequential autotransfer vote
    config_entry_value = 18000

/datum/config_entry/number/vote_autogamemode_timeleft  //Length of time before round start when autogamemode vote is called (in seconds, default 100).
    config_entry_value = 100

/datum/config_entry/flag/vote_no_default    //vote does not default to nochange/norestart (tbi)

/datum/config_entry/flag/vote_no_dead   //dead people can't vote (tbi)

/datum/config_entry/flag/vote_no_dead_crew_transfer //dead people can't vote on crew transfer votes

/datum/config_entry/flag/del_new_on_log //del's new players if they log before they spawn in

/datum/config_entry/flag/feature_object_spell_system    //spawns a spellbook which gives object-type spells instead of verb-type spells for the wizard

/datum/config_entry/flag/traitor_scaling    //if amount of traitors scales based on amount of players

/datum/config_entry/flag/objectives_disabled    //if objectives are disabled or not

/datum/config_entry/flag/protect_roles_from_antagonist  // If security and such can be traitor/cult/other

/datum/config_entry/flag/continous_rounds   //Gamemodes which end instantly will instead keep on going until the round ends by escape shuttle or nuke.

/datum/config_entry/flag/allow_Metadata // Metadata is supported.

/datum/config_entry/flag/popup_admin_pm //adminPMs to non-admins show in a pop-up 'reply' window when set to 1.

/datum/config_entry/flag/allow_vote_mode

/datum/config_entry/flag/default_no_vote

/datum/config_entry/flag/no_dead_vote

/datum/config_entry/number/lobby_countdown
	config_entry_value = 180

/datum/config_entry/number/round_end_countdown
	config_entry_value = 120

/datum/config_entry/number/fps
	default = 20
	integer = FALSE
	min_val = 1
	max_val = 100   //byond will start crapping out at 100, so this is just ridic
	var/sync_validate = FALSE

/datum/config_entry/number/fps/ValidateAndSet(str_val)
	. = ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/ticklag/TL = config.entries_by_type[/datum/config_entry/number/ticklag]
		if(!TL.sync_validate)
			TL.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/datum/config_entry/number/ticklag
	integer = FALSE
	var/sync_validate = FALSE

/datum/config_entry/number/ticklag/New()	//ticklag weirdly just mirrors fps
	var/datum/config_entry/CE = /datum/config_entry/number/fps
	config_entry_value = 10 / initial(CE.default)
	return ..()

/datum/config_entry/number/ticklag/ValidateAndSet(str_val)
	. = text2num(str_val) > 0 && ..()
	if(.)
		sync_validate = TRUE
		var/datum/config_entry/number/fps/FPS = config.entries_by_type[/datum/config_entry/number/fps]
		if(!FPS.sync_validate)
			FPS.ValidateAndSet(10 / config_entry_value)
		sync_validate = FALSE

/datum/config_entry/number/tick_limit_mc_init //SSinitialization throttling
    config_entry_value = TICK_LIMIT_MC_INIT_DEFAULT
    min_val = 0 //oranges warned us
    integer = FALSE

/datum/config_entry/keyed_list/resource_urls
	key_mode = KEY_MODE_TEXT
	value_mode = VALUE_MODE_TEXT

/datum/config_entry/flag/antag_hud_allowed  //Ghosts can turn on Antagovision to see a HUD of who is the bad guys this round.

/datum/config_entry/flag/antag_hud_restricted   //Ghosts that turn on Antagovision cannot rejoin the round.

/datum/config_entry/keyed_list/probabilities    //relative probability of each mode
    key_mode = KEY_MODE_TEXT
    value_mode = VALUE_MODE_TEXT

/datum/config_entry/keyed_list/probabilities/ValidateListEntry(key_name)
	return key_name in config.modes

/datum/config_entry/flag/humans_need_surnames

/datum/config_entry/flag/allow_random_events    //enables random events mid-round when set to 1

/datum/config_entry/flag/allow_ai   //allow ai job

/datum/config_entry/string/hostedby

/datum/config_entry/number/respawn_delay
    config_entry_value = 30

/datum/config_entry/flag/guest_jobban

/datum/config_entry/flag/usewhitelist

/datum/config_entry/number/kick_inactive  //force disconnect for inactive players after this many minutes, if non-0

/datum/config_entry/flag/mods_can_tempban

/datum/config_entry/flag/mods_can_job_tempban

/datum/config_entry/number/mod_tempban_max
    config_entry_value = 1440

/datum/config_entry/number/mod_job_tempban_max
    config_entry_value = 1440

/datum/config_entry/flag/load_jobs_from_txt

/datum/config_entry/flag/jobs_have_minimal_access //determines whether jobs use minimal access or expanded access.

/datum/config_entry/flag/use_cortical_stacks

/datum/config_entry/flag/cult_ghostwriter   //Allows ghosts to write in blood in cult rounds...

/datum/config_entry/number/cult_ghostwriter_req_cultists    //...so long as this many cultists are active.
    config_entry_value = 10

/datum/config_entry/number/character_slots  //The number of available character slots
    config_entry_value = 10

/datum/config_entry/number/max_maint_drones //This many drones can spawn.
    config_entry_value = 5

/datum/config_entry/flag/allow_drone_spawn  //assuming the admin allow them to.

/datum/config_entry/number/drone_build_time //A drone will become available every X ticks since last drone spawn. Default is 2 minutes.
    config_entry_value = 1200

/datum/config_entry/flag/disable_player_mice

/datum/config_entry/flag/uneducated_mice  //Set to 1 to prevent newly-spawned mice from understanding human speech

/datum/config_entry/flag/usealienwhitelist

/datum/config_entry/flag/usealienwhitelistSQL

/datum/config_entry/flag/limitalienplayers

/datum/config_entry/number/alien_to_human_ratio
    config_entry_value = 0.5
    integer = FALSE

/datum/config_entry/flag/allow_extra_antags

/datum/config_entry/flag/guests_allowed

/datum/config_entry/flag/debugparanoid

/datum/config_entry/string/serverurl

/datum/config_entry/string/server

/datum/config_entry/string/banappeals

/datum/config_entry/string/ruleurl

/datum/config_entry/string/loreurl

/datum/config_entry/string/wikiurl

/datum/config_entry/string/forumurl

/datum/config_entry/string/githuburl

/datum/config_entry/string/discord_url

/datum/config_entry/flag/forbid_singulo_possession

/datum/config_entry/flag/auto_profile

/datum/config_entry/number/rounds_until_hard_restart
	default = -1
	min_val = 0

//Fail2Topic settings.
/datum/config_entry/number/topic_rate_limit
	config_entry_value = 5
	min_val = 1
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/number/topic_max_fails
	config_entry_value = 5
	min_val = 1
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/topic_rule_name
	config_entry_value = "_DD_Fail2topic"
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/number/topic_max_size
	config_entry_value = 500
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/flag/topic_enabled
	protection = CONFIG_ENTRY_LOCKED
