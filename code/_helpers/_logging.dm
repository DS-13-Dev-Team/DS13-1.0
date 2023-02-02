//wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define DIRECT_INPUT(A, B) A >> B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)
#define READ_FILE(file, text) DIRECT_INPUT(file, text)
//This is an external call, "true" and "false" are how rust parses out booleans
#define WRITE_LOG(log, text) rustg_log_write(log, text, "true")
#define WRITE_LOG_NO_FORMAT(log, text) rustg_log_write(log, text, "false")

//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [UNLINT(src)] usr: [usr].")
/proc/warning(msg)
	msg = "## WARNING: [msg]"
	log_world(msg)

//not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	msg = "## NOTICE: [msg]"
	log_world(msg)

/proc/log_test(text)
	WRITE_LOG(GLOB.test_log, text)
	SEND_TEXT(world.log, text)

//print a testing-mode debug message to world.log and world
#ifdef TESTING
#define testing(msg) log_world("## TESTING: [msg]"); to_chat(world, "## TESTING: [msg]")
#else
#define testing(msg)
#endif

#ifdef REFERENCE_TRACKING_LOG
#define log_reftracker(msg) log_world("## REF SEARCH [msg]")
#else
#define log_reftracker(msg)
#endif

/* Items with private are stripped from public logs. */
/proc/log_admin(text)
	LAZYADD(GLOB.admin_log, "\[[station_time_timestamp()]\] ADMIN: [text]")
	if(CONFIG_GET(flag/log_admin))
		WRITE_LOG(GLOB.world_game_log, "ADMIN: [text]")


/proc/log_admin_private(text)
	LAZYADD(GLOB.adminprivate_log, "\[[station_time_timestamp()]\] PRIVATE: [text]")
	if(CONFIG_GET(flag/log_admin))
		WRITE_LOG(GLOB.world_game_log, "ADMINPRIVATE: [text]")


/proc/log_admin_private_asay(text)
	LAZYADD(GLOB.asay_log, "\[[station_time_timestamp()]\] ASAY: [text]")
	if(CONFIG_GET(flag/log_adminchat))
		WRITE_LOG(GLOB.world_game_log, "ADMINPRIVATE: ASAY: [text]")


/proc/log_admin_private_msay(text)
	LAZYADD(GLOB.msay_log, "\[[station_time_timestamp()]\] MSAY: [text]")
	if(CONFIG_GET(flag/log_adminchat))
		WRITE_LOG(GLOB.world_game_log, "ADMINPRIVATE: MSAY: [text]")


/proc/log_dsay(text)
	LAZYADD(GLOB.admin_log, "\[[station_time_timestamp()]\] DSAY: [text]")
	if(CONFIG_GET(flag/log_adminchat))
		WRITE_LOG(GLOB.world_game_log, "ADMIN: DSAY: [text]")

/proc/log_misc(text)
	LAZYADD(GLOB.game_log, "\[[station_time_timestamp()]\] MISC: [text]")
	WRITE_LOG(GLOB.world_game_log, "MISC: [text]")

/* All other items are public. */
/proc/log_game(text)
	LAZYADD(GLOB.game_log, "\[[station_time_timestamp()]\] GAME: [text]")
	if(CONFIG_GET(flag/log_game))
		WRITE_LOG(GLOB.world_game_log, "GAME: [text]")


/proc/log_access(text)
	LAZYADD(GLOB.access_log, "\[[station_time_timestamp()]\] ACCESS: [text]")
	if(CONFIG_GET(flag/log_access))
		WRITE_LOG(GLOB.world_game_log, "ACCESS: [text]")

/proc/log_paper(text)
	WRITE_LOG(GLOB.world_paper_log, "PAPER: [text]")

/proc/log_asset(text)
	WRITE_LOG(GLOB.world_asset_log, "ASSET: [text]")

/proc/log_attack(text)
	LAZYADD(GLOB.attack_log, "\[[station_time_timestamp()]\] ATTACK: [text]")
	if(CONFIG_GET(flag/log_attack))
		WRITE_LOG(GLOB.world_attack_log, "ATTACK: [text]")

/proc/log_say(text)
	LAZYADD(GLOB.say_log, "\[[station_time_timestamp()]\] SAY: [text]")
	if(CONFIG_GET(flag/log_say))
		WRITE_LOG(GLOB.world_game_log, "SAY: [text]")

/proc/log_telecomms(text)
	LAZYADD(GLOB.telecomms_log, "\[[station_time_timestamp()]\] TCOMMS: [text]")
	WRITE_LOG(GLOB.world_telecomms_log, "TCOMMS: [text]")

/proc/log_ooc(text)
	LAZYADD(GLOB.say_log, "\[[station_time_timestamp()]\] OOC: [text]")
	if(CONFIG_GET(flag/log_ooc))
		WRITE_LOG(GLOB.world_game_log, "OOC: [text]")


/proc/log_looc(text)
	LAZYADD(GLOB.say_log, "\[[station_time_timestamp()]\] LOOC: [text]")
	if(CONFIG_GET(flag/log_looc))
		WRITE_LOG(GLOB.world_game_log, "LOOC: [text]")


/proc/log_necro(text)
	LAZYADD(GLOB.telecomms_log, "\[[station_time_timestamp()]\] NECRO: [text]")
	if(CONFIG_GET(flag/log_necro))
		WRITE_LOG(GLOB.world_game_log, "NECRO: [text]")


/proc/log_whisper(text)
	LAZYADD(GLOB.say_log, "\[[station_time_timestamp()]\] WHISPER: [text]")
	if(CONFIG_GET(flag/log_whisper))
		WRITE_LOG(GLOB.world_game_log, "WHISPER: [text]")


/proc/log_emote(text)
	LAZYADD(GLOB.say_log, "\[[station_time_timestamp()]\] EMOTE: [text]")
	if(CONFIG_GET(flag/log_emote))
		WRITE_LOG(GLOB.world_game_log, "EMOTE: [text]")


/proc/log_vote(text)
	LAZYADD(GLOB.game_log, "\[[station_time_timestamp()]\] VOTE: [text]")
	if(CONFIG_GET(flag/log_vote))
		WRITE_LOG(GLOB.world_game_log, "VOTE: [text]")


/proc/log_topic(text)
	WRITE_LOG(GLOB.world_game_log, "TOPIC: [text]")


/proc/log_href(text)
	if(CONFIG_GET(flag/log_hrefs))
		WRITE_LOG(GLOB.world_href_log, "HREF: [text]")


/proc/log_sql(text)
	WRITE_LOG(GLOB.sql_error_log, "SQL: [text]")


/proc/log_qdel(text)
	WRITE_LOG(GLOB.world_qdel_log, "QDEL: [text]")


/* Log to both DD and the logfile. */
/proc/log_world(text)
#ifdef USE_CUSTOM_ERROR_HANDLER
	WRITE_LOG(GLOB.world_runtime_log, text)
#endif
	SEND_TEXT(world.log, text)


/proc/log_debug(text)
	WRITE_LOG(GLOB.world_debug_log, "DEBUG: [text]")

/* Log to the logfile only. */
/proc/log_runtime(text)
	WRITE_LOG(GLOB.world_runtime_log, text)


/* Rarely gets called; just here in case the config breaks. */
/proc/log_config(text)
	WRITE_LOG(GLOB.config_error_log, text)
	SEND_TEXT(world.log, text)

/**
 * Appends a tgui-related log entry. All arguments are optional.
 */
/proc/log_tgui(user, message, context,
		datum/tgui_window/window,
		datum/src_object)
	var/entry = ""
	// Insert user info
	if(!user)
		entry += "<nobody>"
	else if(istype(user, /mob))
		var/mob/mob = user
		entry += "[mob.ckey] (as [mob] at [mob.x],[mob.y],[mob.z])"
	else if(istype(user, /client))
		var/client/client = user
		entry += "[client.ckey]"
	// Insert context
	if(context)
		entry += " in [context]"
	else if(window)
		entry += " in [window.id]"
	// Resolve src_object
	if(!src_object && window?.locked_by)
		src_object = window.locked_by.src_object
	// Insert src_object info
	if(src_object)
		entry += "\nUsing: [src_object.type] [REF(src_object)]"
	// Insert message
	if(message)
		entry += "\n[message]"
	WRITE_LOG(GLOB.tgui_log, entry)

/// Logging for mapping errors
/proc/log_mapping(text, skip_world_log)
	WRITE_LOG(GLOB.world_map_error_log, text)
	if(skip_world_log)
		return
	SEND_TEXT(world.log, text)

/* For logging round startup. */
/proc/start_log(log)
	WRITE_LOG(log, "Starting up round ID [GLOB.round_id].\n-------------------------")


/* Close open log handles. This should be called as late as possible, and no logging should hapen after. */
/proc/shutdown_logging()
	rustg_log_close_all()

//pretty print a direction bitflag, can be useful for debugging.
/proc/dir_text(dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")

//more or less a logging utility
/proc/key_name(whom, include_link = null, include_name = 1, highlight_special_characters = 1, datum/ticket/ticket = null)
	var/mob/M
	var/client/C
	var/key

	if(!whom)	return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
	else if(istype(whom, /datum/mind))
		var/datum/mind/D = whom
		key = D.key
		M = D.current
		if(D.current)
			C = D.current.client
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "*invalid:[D.type]*"
	else
		return "*invalid*"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_msg=\ref[C];ticket=\ref[ticket]'>"

		. += key

		if(include_link)
			if(C)	. += "</a>"
			else	. += " (DC)"
	else
		. += "*no key*"

	if(include_name && M)
		var/name

		if(M.real_name)
			name = M.real_name
		else if(M.name)
			name = M.name


		if(include_link && is_special_character(M) && highlight_special_characters)
			. += "/(<font color='#ffa500'>[name]</font>)" //Orange
		else
			. += "/([name])"

	return .

/proc/key_name_admin(whom, include_name = 1)
	return key_name(whom, 1, include_name)

// Helper procs for building detailed log lines
/datum/proc/get_log_info_line()
	return "[src] ([type]) ([any2ref(src)])"

/area/get_log_info_line()
	return "[..()] ([isnum(z) ? "[x],[y],[z]" : "0,0,0"])"

/turf/get_log_info_line()
	return "[..()] ([x],[y],[z]) ([loc ? loc.type : "NULL"])"

/atom/movable/get_log_info_line()
	var/turf/t = get_turf(src)
	return "[..()] ([t ? t : "NULL"]) ([t ? "[t.x],[t.y],[t.z]" : "0,0,0"]) ([t ? t.type : "NULL"])"

/mob/get_log_info_line()
	return ckey ? "[..()] ([ckey])" : ..()

/proc/log_info_line(datum/d)
	if(isnull(d))
		return "*null*"
	if(islist(d))
		var/list/L = list()
		for(var/e in d)
			L += log_info_line(e)
		return "\[[jointext(L, ", ")]\]" // We format the string ourselves, rather than use json_encode(), because it becomes difficult to read recursively escaped "
	if(!istype(d))
		return json_encode(d)
	return d.get_log_info_line()


/proc/report_progress(progress_message)
	log_world(progress_message)
	admin_notice(progress_message, R_DEBUG)

/proc/loc_name(atom/A)
	if(!istype(A))
		return "(INVALID LOCATION)"

	var/turf/T = A
	if (!istype(T))
		T = get_turf(A)

	if(istype(T))
		return "([AREACOORD(T)])"
	else if(A.loc)
		return "(UNKNOWN (?, ?, ?))"

/proc/log_query_debug(text)
	WRITE_LOG(GLOB.query_debug_log, "SQL: [text]")
