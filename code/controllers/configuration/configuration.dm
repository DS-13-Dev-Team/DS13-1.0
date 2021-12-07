/datum/controller/configuration
	name = "Configuration"

	var/directory = "config"

	var/warned_deprecated_configs = FALSE
	var/hiding_entries_by_type = TRUE //Set for readability, admins can set this to FALSE if they want to debug it
	var/list/entries
	var/list/entries_by_type

	var/list/list/maplist
	var/list/defaultmaps

	/// If the configuration is loaded
	var/loaded = FALSE

	var/list/modes // allowed modes
	var/list/gamemode_cache
	var/list/votable_modes // votable modes
	var/list/mode_names

	var/policy

	var/ooc_allowed 	= TRUE
	var/looc_allowed 	= TRUE
	var/dsay_allowed 	= TRUE
	var/aooc_allowed 	= TRUE
	var/dooc_allowed 	= TRUE

	var/static/regex/ic_filter_regex


	//These vars are not really used, just ported to make bay voting code compile
	/// allow votes to restart
	var/static/allow_vote_restart = FALSE
	/// allow votes to change mode
	var/static/allow_vote_mode = FALSE
	/// vote does not default to nochange/norestart (tbi)
	var/static/vote_no_default = FALSE
	/// dead people can't vote (tbi)
	var/static/vote_no_dead = FALSE
	/// dead people can't vote on crew transfer votes
	var/static/vote_no_dead_crew_transfer = FALSE
	/// length of time before next sequential autotransfer vote
	var/static/vote_autotransfer_interval = 30 MINUTES
	/// Whether map switching is allowed
	var/static/allow_map_switching = FALSE
	/// Automatically call a map vote at end of round and switch to the selected map
	var/static/auto_map_vote = FALSE
	var/static/allow_extra_antags = FALSE
	/// Whether or not secret modes show list of possible round types
	var/static/secret_hide_possibilities = FALSE

/datum/controller/configuration/proc/admin_reload()
	if(check_rights(R_ADMIN))
		return
	log_admin("[key_name(usr)] has forcefully reloaded the configuration from disk.")
	message_admins("[key_name(usr)] has forcefully reloaded the configuration from disk.")
	full_wipe()
	Load(world.params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])


/datum/controller/configuration/proc/Load(_directory)
	if(check_rights(R_ADMIN)) //If admin proccall is detected down the line it will horribly break everything.
		return
	if(_directory)
		directory = _directory
	if(entries)
		CRASH("/datum/controller/configuration/Load() called more than once!")
	InitEntries()
	LoadModes()
	if(fexists("[directory]/config.txt") && LoadEntries("config.txt") <= 1)
		var/list/legacy_configs = list("dbconfig.txt")
		for(var/I in legacy_configs)
			if(fexists("[directory]/[I]"))
				log_config("No $include directives found in config.txt! Loading legacy [legacy_configs.Join("/")] files...")
				for(var/J in legacy_configs)
					LoadEntries(J)
				break
	LoadMOTD()

	loaded = TRUE

	if(Master)
		Master.OnConfigLoad()


/datum/controller/configuration/proc/full_wipe()
	if(check_rights(R_ADMIN))
		return
	entries_by_type.Cut()
	QDEL_LIST_ASSOC_VAL(entries)
	entries = null
	for(var/list/L in maplist)
		QDEL_LIST_ASSOC_VAL(L)
	maplist = null
	QDEL_LIST_ASSOC_VAL(defaultmaps)
	defaultmaps = null


/datum/controller/configuration/Destroy()
	full_wipe()
	config = null

	return ..()


/datum/controller/configuration/proc/InitEntries()
	var/list/_entries = list()
	entries = _entries
	var/list/_entries_by_type = list()
	entries_by_type = _entries_by_type

	for(var/I in typesof(/datum/config_entry))	//typesof is faster in this case
		var/datum/config_entry/E = I
		if(initial(E.abstract_type) == I)
			continue
		E = new I
		var/esname = E.name
		var/datum/config_entry/test = _entries[esname]
		if(test)
			log_config("Error: [test.type] has the same name as [E.type]: [esname]! Not initializing [E.type]!")
			qdel(E)
			continue
		_entries[esname] = E
		_entries_by_type[I] = E


/datum/controller/configuration/proc/RemoveEntry(datum/config_entry/CE)
	entries -= CE.name
	entries_by_type -= CE.type


/datum/controller/configuration/proc/LoadEntries(filename, list/stack = list())
	if(check_rights(R_ADMIN))
		return

	var/filename_to_test = world.system_type == MS_WINDOWS ? lowertext(filename) : filename
	if(filename_to_test in stack)
		log_config("Warning: Config recursion detected ([english_list(stack)]), breaking!")
		return
	stack = stack + filename_to_test

	log_config("Loading config file [filename]...")
	var/list/lines = file2list("[directory]/[filename]")
	var/list/_entries = entries
	for(var/L in lines)
		L = trim(L)
		if(!L)
			continue

		var/firstchar = L[1]
		if(firstchar == "#")
			continue

		var/lockthis = firstchar == "@"
		if(lockthis)
			L = copytext(L, length(firstchar) + 1)

		var/pos = findtext(L, " ")
		var/entry = null
		var/value = null

		if(pos)
			entry = lowertext(copytext(L, 1, pos))
			value = copytext(L, pos + length(L[pos]))
		else
			entry = lowertext(L)

		if(!entry)
			continue

		if(entry == "$include")
			if(!value)
				log_config("Warning: Invalid $include directive: [value]")
			else
				LoadEntries(value, stack)
				++.
			continue

		var/datum/config_entry/E = _entries[entry]
		if(!E)
			log_config("Unknown setting in configuration: '[entry]'")
			continue

		if(lockthis)
			E.protection |= CONFIG_ENTRY_LOCKED

		if(E.deprecated_by)
			var/datum/config_entry/new_ver = entries_by_type[E.deprecated_by]
			var/new_value = E.DeprecationUpdate(value)
			var/good_update = istext(new_value)
			log_config("Entry [entry] is deprecated and will be removed soon. Migrate to [new_ver.name]![good_update ? " Suggested new value is: [new_value]" : ""]")
			if(!warned_deprecated_configs)
				DelayedMessageAdmins("This server is using deprecated configuration settings. Please check the logs and update accordingly.")
				warned_deprecated_configs = TRUE
			if(good_update)
				value = new_value
				E = new_ver
			else
				warning("[new_ver.type] is deprecated but gave no proper return for DeprecationUpdate()")

		var/validated = E.ValidateAndSet(value)
		if(!validated)
			log_config("Failed to validate setting \"[value]\" for [entry]")
		else
			if(E.modified && !E.dupes_allowed)
				log_config("Duplicate setting for [entry] ([value], [E.resident_file]) detected! Using latest.")

		E.resident_file = filename

		if(validated)
			E.modified = TRUE

	++.


/datum/controller/configuration/stat_entry(msg)
	msg = "Edit"
	return msg


/datum/controller/configuration/proc/Get(entry_type)
	var/datum/config_entry/E = entry_type
	var/entry_is_abstract = initial(E.abstract_type) == entry_type
	if(entry_is_abstract)
		CRASH("Tried to retrieve an abstract config_entry: [entry_type]")
	E = entries_by_type[entry_type]
	if(!E)
		CRASH("Missing config entry for [entry_type]!")
	if((E.protection & CONFIG_ENTRY_HIDDEN) && check_rights(R_ADMIN))
		log_admin("Config access of [entry_type] attempted by [key_name(usr)]")
		return
	return E.config_entry_value


/datum/controller/configuration/proc/Set(entry_type, new_val)
	var/datum/config_entry/E = entry_type
	var/entry_is_abstract = initial(E.abstract_type) == entry_type
	if(entry_is_abstract)
		CRASH("Tried to set an abstract config_entry: [entry_type]")
	E = entries_by_type[entry_type]
	if(!E)
		CRASH("Missing config entry for [entry_type]!")
	if((E.protection & CONFIG_ENTRY_LOCKED) && check_rights(R_ADMIN))
		log_admin("Config rewrite of [entry_type] to [new_val] attempted by [key_name(usr)]")
		return
	return E.ValidateAndSet("[new_val]")


/datum/controller/configuration/proc/LoadModes()
	gamemode_cache = typecacheof(/datum/game_mode, TRUE)
	modes = list()
	mode_names = list()
	votable_modes = list()
	for(var/T in gamemode_cache)
		var/datum/game_mode/M = new T()
		if(!M.config_tag)
			continue
		if((M.config_tag in modes)) //Ensure each mode is added only once
			continue
		modes += M.config_tag
		mode_names[M.config_tag] = M.name
		if(M.votable)
			votable_modes += M
	log_config("Loading config file [CONFIG_MODES_FILE]...")
	var/filename = "[directory]/[CONFIG_MODES_FILE]"
	var/list/Lines = file2list(filename)
	var/datum/game_mode/currentmode
	for(var/t in Lines)
		if(!t)
			continue

		t = trim(t)
		if(length(t) == 0)
			continue
		else if(copytext(t, 1, 2) == "#")
			continue

		var/pos = findtext(t, " ")
		var/command = null
		var/data = null

		if(pos)
			command = lowertext(copytext(t, 1, pos))
			data = copytext(t, pos + 1)
		else
			command = lowertext(t)

		if(!command)
			continue

		if(!currentmode && command != "mode")
			continue

		switch(command)
			if("mode")
				for(var/datum/game_mode/mode as anything in votable_modes)
					if(mode.config_tag == data)
						currentmode = mode
						break
			if("requiredplayers")
				currentmode.required_players = text2num(data)
			if("required_enemies")
				currentmode.required_enemies = text2num(data)
			if("endmode")
				currentmode = null
			else
				log_config("Unknown command in map vote config: '[command]'")



/datum/controller/configuration/proc/LoadMOTD()
	GLOB.motd = file2text("[directory]/motd.txt")
/*
Policy file should be a json file with a single object.
Value is raw html.
Possible keywords :
Job titles / Assigned roles (ghost spawners for example) : Assistant , Captain , Ash Walker
Mob types : /mob/living/simple_animal/hostile/carp
Antagonist types : /datum/antagonist/highlander
Species types : /datum/species/lizard
special keywords defined in _DEFINES/admin.dm
Example config:
{
	"Assistant" : "Don't kill everyone",
	"/datum/antagonist/highlander" : "<b>Kill everyone</b>",
	"Ash Walker" : "Kill all spacemans"
}
*/

/datum/controller/configuration/proc/pick_mode(mode_name)
	to_chat(world, "pick mode [mode_name]")
	for(var/T in gamemode_cache)
	
		var/datum/game_mode/M = T
		var/ct = initial(M.config_tag)
		to_chat(world, "Testing [T]  [ct]")
		if(ct && ct == mode_name)
			to_chat(world, "Got a match!")
			return new T
	to_chat(world, "No match!")
	return new /datum/game_mode/extended()


/datum/controller/configuration/proc/get_runnable_modes()
	var/list/result = list()
	for (var/tag in gamemode_cache)
		var/datum/game_mode/M = gamemode_cache[tag]
		if (!M.startRequirements())
			result[tag] = 1//probabilities[tag]
	return result


//Message admins when you can.
/datum/controller/configuration/proc/DelayedMessageAdmins(text)
	addtimer(CALLBACK(GLOBAL_PROC, /proc/message_admins, text), 1, TIMER_UNIQUE)