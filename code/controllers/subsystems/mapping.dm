SUBSYSTEM_DEF(mapping)
	name = "Mapping"
	init_order = SS_INIT_MAPPING
	flags = SS_NO_FIRE

	var/datum/map_config/config
	var/datum/map_config/next_map_config

	var/map_voted = FALSE

	var/list/map_templates = list()

	var/list/areas_in_z = list()

	var/loading_ruins = FALSE

	///All possible biomes in assoc list as type || instance
	var/list/biomes = list()

	// Z-manager stuff
	var/station_start  // should only be used for maploading-related tasks
	var/space_levels_so_far = 0
	///list of all z level datums in the order of their z (z level 1 is at index 1, etc.)
	var/list/datum/space_level/z_list
	///list of all z level indices that form multiz connections and whether theyre linked up or down.
	///list of lists, inner lists are of the form: list("up or down link direction" = TRUE)
	var/list/multiz_levels = list()
	var/datum/space_level/transit
	var/datum/space_level/empty_space
	var/num_of_res_levels = 1
	/// True when in the process of adding a new Z-level, global locking
	var/adding_new_zlevel = FALSE

/datum/controller/subsystem/mapping/Initialize(timeofday)
	if(initialized)
		return
	config = load_map_config(error_if_missing = FALSE)
	if(config.defaulted)
		var/old_config = config
		config = global.config.defaultmap
		if(!config || config.defaulted)
			to_chat(world, SPAN_BOLDANNOUNCE("Unable to load next or default map config, defaulting to The Colony."))
			config = old_config
	loadWorld()
	preloadTemplates()

	// Set up Z-level transitions.
	setup_map_transitions()
	generate_station_area_list()
	generate_z_level_linkages()

	return ..()

/datum/controller/subsystem/mapping/proc/generate_z_level_linkages()
	for(var/z_level in 1 to length(z_list))
		generate_linkages_for_z_level(z_level)

/datum/controller/subsystem/mapping/proc/generate_linkages_for_z_level(z_level)
	if(!isnum(z_level) || z_level <= 0)
		return FALSE

	if(multiz_levels.len < z_level)
		multiz_levels.len = z_level

	var/linked_down = level_trait(z_level, ZTRAIT_DOWN)
	var/linked_up = level_trait(z_level, ZTRAIT_UP)
	multiz_levels[z_level] = list()
	if(linked_down)
		multiz_levels[z_level]["[DOWN]"] = TRUE
	if(linked_up)
		multiz_levels[z_level]["[UP]"] = TRUE

/datum/controller/subsystem/mapping/Recover()
	flags |= SS_NO_INIT
	initialized = SSmapping.initialized
	map_templates = SSmapping.map_templates
	transit = SSmapping.transit
	areas_in_z = SSmapping.areas_in_z

	config = SSmapping.config
	next_map_config = SSmapping.next_map_config

	z_list = SSmapping.z_list
	multiz_levels = SSmapping.multiz_levels

#define INIT_ANNOUNCE(X) to_chat(world, SPAN_BOLDANNOUNCE("[X]")); log_world(X)
/datum/controller/subsystem/mapping/proc/LoadGroup(list/errorList, name, path, files, list/traits, list/default_traits, silent = FALSE)
	. = list()
	var/start_time = REALTIMEOFDAY

	if (!islist(files))  // handle single-level maps
		files = list(files)

	// check that the total z count of all maps matches the list of traits
	var/total_z = 0
	var/list/parsed_maps = list()
	for (var/file in files)
		var/full_path = "maps/[path]/[file]"
		var/datum/parsed_map/pm = new(file(full_path))
		var/bounds = pm?.bounds
		if (!bounds)
			errorList |= full_path
			continue
		parsed_maps[pm] = total_z  // save the start Z of this file
		total_z += bounds[MAP_MAXZ] - bounds[MAP_MINZ] + 1

	if (!length(traits))  // null or empty - default
		for (var/i in 1 to total_z)
			traits += list(default_traits)
	else if (total_z != traits.len)  // mismatch
		INIT_ANNOUNCE("WARNING: [traits.len] trait sets specified for [total_z] z-levels in [path]!")
		if (total_z < traits.len)  // ignore extra traits
			traits.Cut(total_z + 1)
		while (total_z > traits.len)  // fall back to defaults on extra levels
			traits += list(default_traits)

	// preload the relevant space_level datums
	var/start_z = world.maxz + 1
	var/i = 0
	for (var/level in traits)
		add_new_zlevel("[name][i ? " [i + 1]" : ""]", level)
		++i

	// load the maps
	for (var/P in parsed_maps)
		var/datum/parsed_map/pm = P
		if (!pm.load(1, 1, start_z + parsed_maps[P], no_changeturf = TRUE))
			errorList |= pm.original_path
	if(!silent)
		INIT_ANNOUNCE("Loaded [name] in [(REALTIMEOFDAY - start_time)/10]s!")
	return parsed_maps

/datum/controller/subsystem/mapping/proc/loadWorld()
	//if any of these fail, something has gone horribly, HORRIBLY, wrong
	var/list/FailedZs = list()

	// ensure we have space_level datums for compiled-in maps
	InitializeDefaultZLevels()

	// load the station
	station_start = world.maxz + 1
	INIT_ANNOUNCE("Loading [config.map_name]...")
	LoadGroup(FailedZs, "Station", config.map_path, config.map_file, config.traits, ZTRAITS_STATION)

	if(LAZYLEN(FailedZs)) //but seriously, unless the server's filesystem is messed up this will never happen
		var/msg = "RED ALERT! The following map files failed to load: [FailedZs[1]]"
		if(FailedZs.len > 1)
			for(var/I in 2 to FailedZs.len)
				msg += ", [FailedZs[I]]"
		msg += ". Yell at your server host!"
		INIT_ANNOUNCE(msg)
#undef INIT_ANNOUNCE

	// Custom maps are removed after station loading so the map files does not persist for no reason.
	if(config.map_path == CUSTOM_MAP_PATH)
		fdel("maps/custom/[config.map_file]")
		// And as the file is now removed set the next map to default.
		next_map_config = load_default_map_config()

GLOBAL_LIST_EMPTY(the_station_areas)

/datum/controller/subsystem/mapping/proc/generate_station_area_list()
	var/static/list/station_areas_blacklist = typecacheof(list(/area/space, /area/tdome))
	for(var/area/A in world)
		if (A && length(station_areas_blacklist) && station_areas_blacklist[(ispath(A) ? A : A:type)])
			continue
		if (!A.contents.len)
			continue
		var/turf/picked = A.contents[1]
		if (is_station_level(picked.z))
			GLOB.the_station_areas += A.type

	if(!GLOB.the_station_areas.len)
		log_world("ERROR: Station areas list failed to generate!")

/datum/controller/subsystem/mapping/proc/maprotate()
	if(map_voted || SSmapping.next_map_config) //If voted or set by other means.
		return

	var/players = GLOB.clients.len
	var/list/mapvotes = list()
	//count votes
	var/pmv = CONFIG_GET(flag/preference_map_voting)
	if(pmv)
		for (var/client/c in GLOB.clients)
			var/vote = c.prefs.preferred_map
			if (!vote)
				if (global.config.defaultmap)
					mapvotes[global.config.defaultmap.map_name] += 1
				continue
			mapvotes[vote] += 1
	else
		for(var/M in global.config.maplist)
			mapvotes[M] = 1

	//filter votes
	for (var/map in mapvotes)
		if (!map)
			mapvotes.Remove(map)
			continue
		if (!(map in global.config.maplist))
			mapvotes.Remove(map)
			continue
		var/datum/map_config/VM = global.config.maplist[map]
		if (!VM)
			mapvotes.Remove(map)
			continue
		if (VM.voteweight <= 0)
			mapvotes.Remove(map)
			continue
		if (VM.config_min_users > 0 && players < VM.config_min_users)
			mapvotes.Remove(map)
			continue
		if (VM.config_max_users > 0 && players > VM.config_max_users)
			mapvotes.Remove(map)
			continue

		if(pmv)
			mapvotes[map] = mapvotes[map]*VM.voteweight

	var/pickedmap = pickweight(mapvotes)
	if (!pickedmap)
		return
	var/datum/map_config/VM = global.config.maplist[pickedmap]
	message_admins("Randomly rotating map to [VM.map_name]")
	. = changemap(VM)
	if (. && VM.map_name != config.map_name)
		to_chat(world, SPAN_BOLDANNOUNCE("Map rotation has chosen [VM.map_name] for next round!"))

/datum/controller/subsystem/mapping/proc/mapvote()
	if(map_voted || SSmapping.next_map_config) //If voted or set by other means.
		return
	if(SSvote.mode) //Theres already a vote running, default to rotation.
		maprotate()
		return
	SSvote.initiate_vote("next_map", "automatic map rotation")

/datum/controller/subsystem/mapping/proc/changemap(datum/map_config/change_to)
	if(!change_to.MakeNextMap())
		next_map_config = load_default_map_config()
		message_admins("Failed to set new map with next_map.json for [change_to.map_name]! Using default as backup!")
		return

	if (change_to.config_min_users > 0 && GLOB.clients.len < change_to.config_min_users)
		message_admins("[change_to.map_name] was chosen for the next map, despite there being less current players than its set minimum population range!")
		log_game("[change_to.map_name] was chosen for the next map, despite there being less current players than its set minimum population range!")
	if (change_to.config_max_users > 0 && GLOB.clients.len > change_to.config_max_users)
		message_admins("[change_to.map_name] was chosen for the next map, despite there being more current players than its set maximum population range!")
		log_game("[change_to.map_name] was chosen for the next map, despite there being more current players than its set maximum population range!")

	next_map_config = change_to
	return TRUE

/datum/controller/subsystem/mapping/proc/preloadTemplates(path = "maps/templates/") //see master controller setup
	var/list/filelist = flist(path)
	for(var/map in filelist)
		var/datum/map_template/T = new(path = "[path][map]", rename = "[map]")
		map_templates[T.name] = T

/datum/controller/subsystem/mapping/proc/reg_in_areas_in_z(list/areas)
	for(var/B in areas)
		var/area/A = B
		A.reg_in_areas_in_z()
