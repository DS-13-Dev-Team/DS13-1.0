	////////////
	//SECURITY//
	////////////
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?

//#define TOPIC_DEBUGGING 1

	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if (!asset_cache_job)
			return

	//Logs all hrefs, except chat pings
	if(!(href_list["window_id"] == "browseroutput" && href_list["type"] == "ping" && LAZYLEN(href_list) == 4))
		log_href("[src] (usr:[usr]\[[COORD(usr)]\]) : [hsrc ? "[hsrc] " : ""][href]")

	if(href_list["open_vote_menu"])
		SSvote.tgui_interact(mob)

	#if defined(TOPIC_DEBUGGING)
	log_debug("[src]'s Topic: [href] destined for [hsrc].")

	if(href_list["nano_err"]) //nano throwing errors
		log_debug("## NanoUI, Subject [src]: " + html_decode(href_list["nano_err"]))//NANO DEBUG HOOK


	#endif

	// Tgui Topic middleware
	if(tgui_Topic(href_list))
		return
	if(href_list["reload_tguipanel"])
		nuke_chat()
	if(href_list["reload_statbrowser"])
		stat_panel.reinitialize()

	//byond bug ID:2256651
	if (asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, "<span class = 'warning'> An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)</span>")
		DIRECT_OUTPUT(src, browse("...", "window=asset_cache_browser"))
		return

	if (href_list["asset_cache_preload_data"])
		asset_cache_preload_data(href_list["asset_cache_preload_data"])
		return

	//search the href for script injection
	if( findtext(href,"<script",1,0) )
		log_world("Attempted use of scripts within a topic call, by [src]")
		message_admins("Attempted use of scripts within a topic call, by [src]")
		//qdel(usr)
		return

	//Admin PM
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		var/datum/ticket/ticket = locate(href_list["ticket"])

		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		cmd_admin_pm(C, null, ticket)
		return

	if(href_list["irc_msg"])
		if(!holder && received_irc_pm < world.time - 6000) //Worse they can do is spam IRC for 10 minutes
			to_chat(usr, "<span class='warning'>You are no longer able to use this, it's been more then 10 minutes since an admin on IRC has responded to you</span>")
			return
		if(mute_irc)
			to_chat(usr, "<span class='warning'You cannot use this as your client has been muted from sending messages to the admins on IRC</span>")
			return
		cmd_admin_irc_pm(href_list["irc_msg"])
		return

	if(href_list["close_ticket"])
		var/datum/ticket/ticket = locate(href_list["close_ticket"])

		if(isnull(ticket))
			return

		ticket.close(client_repository.get_lite_client(usr.client))



	//Logs all hrefs
	if(config && CONFIG_GET(flag/log_hrefs) && href_logfile)
		to_chat(href_logfile, "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>")

	switch(href_list["_src_"])
		if("holder")
			hsrc = holder
		if("usr")
			hsrc = mob
		if("prefs")
			return prefs.process_link(usr,href_list)
		if("vars")
			return view_var_Topic(href,href_list,hsrc)
		if("vote")
			return SSvote.Topic(href, href_list)

	..()	//redirect to hsrc.Topic()

/client/proc/generate_clickcatcher()
	if(void)
		return
	void = new()
	screen += void


/client/proc/apply_clickcatcher()
	generate_clickcatcher()
	var/list/actualview = getviewsize(view)
	void.UpdateGreed(actualview[1], actualview[2])

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null

	if(findtext(ckey, "billymays"))
		alert(src, "Webclients aren't supported! Please, connect using Dream Seeker!")
		qdel(src)
		return

	// Instantiate stat panel
	stat_panel = new(src, "statbrowser")
	stat_panel.subscribe(src, .proc/on_stat_panel_message)

	// Instantiate tgui panel
	tgui_panel = new(src, "browseroutput")

	if(!CONFIG_GET(flag/guests_allowed) && IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest")
		qdel(src)
		return

	if(CONFIG_GET(number/player_limit) != 0 && (GLOB.clients.len >= CONFIG_GET(number/player_limit)))
		var/allowed = FALSE
		if (ckey in GLOB.admin_datums)
			allowed = TRUE
		if(CONFIG_GET(flag/always_admit_patrons) && (ckey in GLOB.patron_keys))
			allowed = TRUE

		if (!allowed)
			alert(src, "This server is currently full and not accepting new connections. Redirecting you to the second server.", "Server Full")
			src << link("byond://[CONFIG_GET(string/backup_server)]")
			qdel(src)
			return
	//DS13 - Give locally logged in users host status
	var/localhost_addresses = list("127.0.0.1", "::1")
	if(isnull(address) || (address in localhost_addresses))
		var/rights = admin_ranks["Host"]
		var/datum/admins/D = new /datum/admins("Host", rights, ckey)
		D.associate(src)

	if(byond_version < DM_VERSION)
		to_chat(src, "<span class='warning'>You are running an older version of BYOND than the server and may experience issues.</span>")
		to_chat(src, "<span class='warning'>It is recommended that you update to at least [DM_VERSION] at http://www.byond.com/download/.</span>")
	to_chat(src, "<span class='warning'>If the title screen is black, resources are still downloading. Please be patient until the title screen appears.</span>")
	GLOB.clients += src
	GLOB.ckey_directory[ckey] = src

	//Admin Authorisation
	holder = GLOB.admin_datums[ckey]
	if(holder)
		GLOB.admins |= src
		holder.owner = src

	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"
	log_access("Login: [key_name(src)] from [address ? address : "localhost"]-[computer_id] || BYOND v[full_version]")

	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = SScharacter_setup.preferences_datums[ckey]
	if(!prefs)
		prefs = new /datum/preferences(src)
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	fps = text2num(get_preference_value(/datum/client_preference/client_fps))

	if(GLOB.player_details[ckey])
		player_details = GLOB.player_details[ckey]
		player_details.byond_version = full_version
	else
		player_details = new
		player_details.byond_version = full_version
		GLOB.player_details[ckey] = player_details

	. = ..()	//calls mob.Login()

	// Initialize stat panel
	stat_panel.initialize(
		inline_html = file("html/statbrowser.html"),
		inline_js = file("html/statbrowser.js"),
		inline_css = file("html/statbrowser.css"),
	)
	addtimer(CALLBACK(src, .proc/check_panel_loaded), 30 SECONDS)

	// Initialize tgui panel
	tgui_panel.initialize()

	if(custom_event_msg && custom_event_msg != "")
		to_chat(src, "<h1 class='alert'>Custom Event</h1>")
		to_chat(src, "<h2 class='alert'>A custom event is taking place. OOC Info:</h2>")
		to_chat(src, "<span class='alert'>[custom_event_msg]</span>")
		to_chat(src, "<br>")

	connection_time = world.time
	connection_realtime = world.realtime
	connection_timeofday = world.timeofday
	winset(src, null, "command=\".configure graphics-hwmode on\"")

	if(holder)
		add_admin_verbs()
		admin_memo_show()


	log_client_to_db()

	send_resources()

	generate_clickcatcher()
	apply_clickcatcher()

	if(prefs.lastchangelog != GLOB.changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		to_chat(src, "<span class='info'>You have unread updates in the changelog.</span>")
		if(CONFIG_GET(flag/aggressive_changelog))
			changelog()
		else
			winset(src, "infowindow.changelog", "font-style=bold")

	if(isnum(player_age) && player_age < 7)
		src.lore_splash()
		to_chat(src, "<span class = 'notice'>Greetings, and welcome to the server! A link to the beginner's lore page has been opened, please read through it! This window will stop automatically opening once your account here is greater than 7 days old.</span>")

	if(!winexists(src, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, "<span class='warning'>Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you.</span>")

	//This is down here because of the browse() calls in tooltip/New()
	if(!tooltips)
		tooltips = new /datum/tooltip(src)

	if(holder)
		src.control_freak = 0 //Devs need 0 for profiler access

	winset(src, null, "mainwindow.title='[CONFIG_GET(string/title)] - [GLOB.using_map?.full_name]'")

/**
 * Handles incoming messages from the stat-panel TGUI.
 */
/client/proc/on_stat_panel_message(type, payload)
	switch(type)
		if("Update-Verbs")
			init_verbs()
		if("Remove-Tabs")
			panel_tabs -= payload["tab"]
		if("Send-Tabs")
			panel_tabs |= payload["tab"]
		if("Reset-Tabs")
			panel_tabs = list()
		if("Set-Tab")
			stat_tab = payload["tab"]
			SSstatpanels.immediate_send_stat_data(src)

//////////////
//DISCONNECT//
//////////////
/client/Del()
	if(!QDELING(src))
		Destroy() //Clean up signals and timers.
	return ..()

/client/Destroy()
	ticket_panels -= src
	if(src && watched_variables_window)
		STOP_PROCESSING(SSprocessing, watched_variables_window)
	if(holder)
		holder.owner = null
		GLOB.admins -= src
	GLOB.ckey_directory -= ckey
	GLOB.clients -= src

	QDEL_NULL(void)
	QDEL_NULL(tooltips)

	..()
	return QDEL_HINT_HARDDEL_NOW

// here because it's similar to below

// Returns null if no DB connection can be established, or -1 if the requested key was not found in the database

/proc/get_player_age(key)
	if(!SSdbcore.Connect())
		return null

	var/sql_ckey = sql_sanitize_text(ckey(key))

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()

	if(query.NextRow())
		qdel(query)
		return text2num(query.item[1])
	qdel(query)
	return -1


/client/proc/log_client_to_db()
	if(IsGuestKey(src.key))
		return

	if(!SSdbcore.Connect())
		return

	var/sql_ckey = sql_sanitize_text(src.ckey)

	var/datum/db_query/query = SSdbcore.NewQuery("SELECT id, datediff(Now(),firstseen) as age FROM erro_player WHERE ckey = '[sql_ckey]'")
	query.Execute()
	var/sql_id = 0
	player_age = 0	// New players won't have an entry so knowing we have a connection we set this to zero to be updated if their is a record.
	if(query.NextRow())
		sql_id = query.item[1]
		player_age = text2num(query.item[2])
	qdel(query)

	var/datum/db_query/query_ip = SSdbcore.NewQuery("SELECT ckey FROM erro_player WHERE ip = '[address]'")
	query_ip.Execute()
	related_accounts_ip = ""
	if(query_ip.NextRow())
		related_accounts_ip += "[query_ip.item[1]], "
	qdel(query_ip)

	var/datum/db_query/query_cid = SSdbcore.NewQuery("SELECT ckey FROM erro_player WHERE computerid = '[computer_id]'")
	query_cid.Execute()
	related_accounts_cid = ""
	if(query_cid.NextRow())
		related_accounts_cid += "[query_cid.item[1]], "
	qdel(query_cid)

	var/datum/db_query/query_staffwarn = SSdbcore.NewQuery("SELECT staffwarn FROM erro_player WHERE ckey = '[sql_ckey]' AND !ISNULL(staffwarn)")
	query_staffwarn.Execute()
	if(query_staffwarn.NextRow())
		src.staffwarn = query_staffwarn.item[1]
	qdel(query_staffwarn)

	//Just the standard check to see if it's actually a number
	if(sql_id)
		if(istext(sql_id))
			sql_id = text2num(sql_id)
		if(!isnum(sql_id))
			return

	var/admin_rank = "Player"
	if(src.holder)
		admin_rank = src.holder.rank
		for(var/client/C in GLOB.clients)
			if(C.staffwarn)
				C.mob.send_staffwarn(src, "is connected", 0)

	var/sql_ip = sql_sanitize_text(src.address)
	var/sql_computerid = sql_sanitize_text(src.computer_id)
	var/sql_admin_rank = sql_sanitize_text(admin_rank)


	if(sql_id)
		//Player already identified previously, we need to just update the 'lastseen', 'ip' and 'computer_id' variables
		var/datum/db_query/query_update = SSdbcore.NewQuery("UPDATE erro_player SET lastseen = Now(), ip = '[sql_ip]', computerid = '[sql_computerid]', lastadminrank = '[sql_admin_rank]' WHERE id = [sql_id]")
		query_update.Execute()
		qdel(query_update)
	else
		//New player!! Need to insert all the stuff
		var/datum/db_query/query_insert = SSdbcore.NewQuery("INSERT INTO erro_player (id, ckey, firstseen, lastseen, ip, computerid, lastadminrank) VALUES (null, '[sql_ckey]', Now(), Now(), '[sql_ip]', '[sql_computerid]', '[sql_admin_rank]')")
		query_insert.Execute()
		qdel(query_insert)


#undef UPLOAD_LIMIT

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

/client/proc/inactivity2text()
	var/seconds = inactivity/10
	return "[round(seconds / 60)] minute\s, [seconds % 60] second\s"

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_resources()
#if (PRELOAD_RSC == 0)
	var/static/next_external_rsc = 0
	var/list/external_rsc_urls = CONFIG_GET(keyed_list/external_rsc_urls)
	if(length(external_rsc_urls))
		next_external_rsc = WRAP(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]
#endif

	spawn (10) //removing this spawn causes all clients to not get verbs.

		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		if (CONFIG_GET(flag/asset_simple_preload))
			addtimer(CALLBACK(SSassets.transport, /datum/asset_transport.proc/send_assets_slow, src, SSassets.transport.preload), 5 SECONDS)


mob/proc/MayRespawn()
	return 0

client/proc/MayRespawn()
	if(mob)
		return mob.MayRespawn()

	// Something went wrong, client is usually kicked or transfered to a new mob at this point
	return 0

/// compiles a full list of verbs and sends it to the browser
/client/proc/init_verbs()
	var/list/verblist = list()
	var/list/verbstoprocess = verbs.Copy()
	if(mob)
		verbstoprocess += mob.verbs
		for(var/atom/movable/thing as anything in mob.contents)
			verbstoprocess += thing.verbs
	panel_tabs.Cut() // panel_tabs get reset in init_verbs on JS side anyway
	for(var/procpath/verb_to_init as anything in verbstoprocess)
		if(!verb_to_init)
			continue
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category))
			continue
		panel_tabs |= verb_to_init.category
		verblist[++verblist.len] = list(verb_to_init.category, verb_to_init.name)
	src.stat_panel.send_message("init_verbs", list(panel_tabs = panel_tabs, verblist = verblist))

/client/proc/check_panel_loaded()
	if(stat_panel.is_ready())
		return
	to_chat(src, SPAN_USERDANGER("Statpanel failed to load, click <a href='?src=[REF(src)];reload_statbrowser=1'>here</a> to reload the panel "))
