#define PING_BUFFER_TIME 25

SUBSYSTEM_DEF(server_maint)
	name = "Server Tasks"
	wait = 6
	flags = SS_POST_FIRE_TIMING
	priority = SS_PRIORITY_SERVER_MAINT
	init_order = SS_INIT_SERVER_MAINT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	init_stage = INITSTAGE_EARLY
	var/list/currentrun
	var/cleanup_ticker = 0

/datum/controller/subsystem/server_maint/PreInit()
	world.hub_password = "" //quickly! before the hubbies see us.

/datum/controller/subsystem/server_maint/Initialize(timeofday)
	if (CONFIG_GET(flag/hub))
		world.update_hub_visibility(TRUE)
	return ..()

/datum/controller/subsystem/server_maint/fire(resumed = FALSE)
	if(!resumed)
		if(listclearnulls(GLOB.clients))
			log_world("Found a null in clients list!")
		src.currentrun = GLOB.clients.Copy()

		switch (cleanup_ticker) // do only one of these at a time, once per 5 fires
			if (0)
				if(listclearnulls(GLOB.player_list))
					log_world("Found a null in player_list!")
				cleanup_ticker++
			if (5)
				if(listclearnulls(GLOB.human_mob_list))
					log_world("Found a null in human_mob_list!")
				cleanup_ticker++
			if (10)
				if(listclearnulls(GLOB.living_mob_list))
					log_world("Found a null in living_mob_list!")
				cleanup_ticker++
			if (15)
				if(listclearnulls(SSnecromorph.necromorph_players))
					log_world("Found a null in SSnecromorph.necromorph_players!")
				cleanup_ticker++
			if (20)
				if(listclearnulls(GLOB.dead_mob_list))
					log_world("Found a null in dead_mob_list!")
				cleanup_ticker++
			if (25)
				cleanup_ticker = 0
			else
				cleanup_ticker++

	var/list/currentrun = src.currentrun

	for(var/I in currentrun)
		var/client/C = I

		if (!(!C || world.time - C.connection_time < PING_BUFFER_TIME || C.inactivity >= (wait-1)))
			winset(C, null, "command=.update_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")

		if (MC_TICK_CHECK) //one day, when ss13 has 1000 people per server, you guys are gonna be glad I added this tick check
			return

/datum/controller/subsystem/server_maint/Shutdown()
	kick_clients_in_lobby("<span class='boldannounce'>The round came to an end with you in the lobby.</span>", TRUE) //second parameter ensures only afk clients are kicked
	var/server = CONFIG_GET(string/server)
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		C?.tgui_panel?.send_roundrestart()
		if(server) //if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")

/datum/controller/subsystem/server_maint/proc/UpdateHubStatus()
	if(!CONFIG_GET(flag/hub))
		return FALSE //no point, hub / auto hub controls are disabled
	world.update_hub_visibility(TRUE)
#undef PING_BUFFER_TIME
