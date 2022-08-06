GLOBAL_DATUM(using_map, /datum/map)
GLOBAL_LIST_INIT(all_maps, initialise_bay_map_list())

/proc/initialise_bay_map_list()
	.=list()
	for(var/type in subtypesof(/datum/map))
		var/datum/map/M = new type
		if(!M.path)
			log_debug("Map '[M]' does not have a defined path, not adding to map list!")
		else
			.[M.type] = M

/datum/map
	var/name = "Unnamed Map"
	var/full_name = "Unnamed Map"
	var/path

	var/list/station_levels = list() // Z-levels the station exists on
	var/list/admin_levels = list()   // Z-levels for admin functionality (Centcom, shuttle transit, etc)
	var/list/contact_levels = list() // Z-levels that can be contacted from the station, for eg announcements
	var/list/player_levels = list()  // Z-levels a character can typically reach
	var/list/sealed_levels = list()  // Z-levels that don't allow random transit at edge
	var/list/empty_levels = null     // Empty Z-levels that may be used for various things (currently used by bluespace jump)

	var/list/accessible_z_levels = list()

	var/list/map_levels              // Z-levels available to various consoles, such as the crew monitor. Defaults to station_levels if unset.

	var/list/base_turf_by_z = list() // Custom base turf by Z-level. Defaults to world.turf for unlisted Z-levels
	var/list/usable_email_tlds = list("freemail.nt")
	var/base_floor_type = /turf/simulated/floor/airless // The turf type used when generating floors between Z-levels at startup.
	var/base_floor_area                                 // Replacement area, if a base_floor_type is generated. Leave blank to skip.

	var/list/allowed_jobs = list(/datum/job/cap, /datum/job/fl, /datum/job/be, /datum/job/cseco,
						/datum/job/sso, /datum/job/security_officer, /datum/job/smo,
						/datum/job/md, /datum/job/surg, /datum/job/psychiatrist, /datum/job/cscio,
						/datum/job/ra, /datum/job/ce, /datum/job/tech_engineer, /datum/job/so,
						/datum/job/janitor, /datum/job/chaplain, /datum/job/serviceman,
						/datum/job/salvage, /datum/job/dom, /datum/job/foreman, /datum/job/planet_cracker,
						/datum/job/line_cook, /datum/job/bar, /datum/job/botanist
						)

	var/list/using_shuttles

	var/station_name  = "USG Ishimura"
	var/station_short = "Ishimura"
	var/dock_name     = "Aegis VII"
	var/boss_name     = "Concordance Extraction Corporation"
	var/boss_short    = "CEC"
	var/company_name  = "EarthGov"
	var/company_short = "EarthGov"
	var/system_name = "Cygnus System"

	var/map_admin_faxes = list()

	var/shuttle_docked_message
	var/shuttle_leaving_dock
	var/shuttle_called_message
	var/shuttle_recall_message
	var/emergency_shuttle_docked_message
	var/emergency_shuttle_leaving_dock
	var/emergency_shuttle_recall_message

	var/list/station_networks = list() 		// Camera networks that will show up on the console.

	var/list/holodeck_programs = list() // map of string ids to /datum/holodeck_program instances
	var/list/holodeck_supported_programs = list() // map of maps - first level maps from list-of-programs string id (e.g. "BarPrograms") to another map
												  // this is in order to support multiple holodeck program listings for different holodecks
	                                              // second level maps from program friendly display names ("Picnic Area") to program string ids ("picnicarea")
	                                              // as defined in holodeck_programs
	var/list/holodeck_restricted_programs = list() // as above... but EVIL!

	var/evac_controller_type = /datum/evacuation_controller

	var/music_track/lobby_track                     							// The track that will play in the lobby screen.
	var/list/lobby_tracks = list()                  							// The list of lobby tracks to pick() from. If left unset will randomly select among all available /music_track subtypes.
	var/welcome_sound = 'sound/AI/welcome.ogg'									// Sound played on roundstart

	var/default_law_type = /datum/ai_laws/nanotrasen  // The default lawset use by synth units, if not overriden by their laws var.
	var/security_state = /decl/security_state/default // The default security state system to use.

	var/num_exoplanets = 0
	var/list/planet_size  //dimensions of planet zlevel, defaults to world size. Due to how maps are generated, must be (2^n+1) e.g. 17,33,65,129 etc. Map will just round up to those if set to anything other.
	var/away_site_budget = 0

	var/skybox_foreground_objects

	//Economy stuff
	var/starting_money = 75000		//Money in station account
	var/department_money = 5000		//Money in department accounts
	var/salary_modifier	= 1			//Multiplier to starting character money
	var/station_departments = list()//Gets filled automatically depending on jobs allowed

	var/supply_currency_name = "Credits"
	var/local_currency_name = "credits"
	var/supply_currency_name_short = "Cr."

	//Factions prefs stuff
	var/list/citizenship_choices = list(
		"Earth",
		"Luna",
		"Mars",
		"Titan",
		"Venus"
	)

	var/list/home_system_choices = list(
		"Sol"
		)

	var/list/faction_choices = list(
		"C.E.C Employee",
		"EarthGov Contractor",
		"Church of Unitology Missionary",
		"Unaffiliated Employee"
		)

	var/list/religion_choices = list(
		"Unitologist",
		"Agnostic",
		"Atheist"
		)

	var/powernode_rooms = 6

	/*
		Which crew objectives are active on this map?
	*/
	var/list/crew_objectives
	var/list/post_round_safe_areas = list()

/datum/map/New()
	if(!map_levels)
		map_levels = station_levels.Copy()
	if(!planet_size)
		planet_size = list(world.maxx, world.maxy)
	if(!using_shuttles)
		using_shuttles = subtypesof(/datum/shuttle)

/datum/map/proc/setup_map()
	var/lobby_track_type
	if(lobby_tracks.len)
		lobby_track_type = pick(lobby_tracks)
	else
		lobby_track_type = pick(subtypesof(/music_track))

	lobby_track = decls_repository.get_decl(lobby_track_type)
	world.update_status()
	setup_economy()

	if(!post_round_safe_areas.len)
		for(var/area/A)
			if(isspace(A))
				continue
			if(A.z && (A.z in admin_levels))
				post_round_safe_areas += A.type

	for(var/client/client as anything in GLOB.clients)
		client.playtitlemusic()
		winset(client, null, "mainwindow.title='[CONFIG_GET(string/title)] - [full_name]'")

	//It uses station location for the code too
	if(!syndicate_code_phrase)
		syndicate_code_phrase	= generate_code_phrase()
	if(!syndicate_code_response)
		syndicate_code_response	= generate_code_phrase()

//Called late in the load order after other subsystems are done
/datum/map/proc/post_setup()
	if(powernode_rooms)
		setup_powernode_rooms()
	if(length(crew_objectives))
		setup_crew_objectives()

//Gets a random lobby track, excluding a list of tracks we've already heard
/datum/map/proc/get_lobby_track(var/list/played)
	var/list/possible_tracks = lobby_tracks - played
	if (!possible_tracks.len)
		possible_tracks = lobby_tracks	//If we've already heard them all, this no-repeat feature does nothing

	return pick(possible_tracks)


/datum/map/proc/send_welcome()
	return

// Used to apply various post-compile procedural effects to the map.
/datum/map/proc/refresh_mining_turfs(var/zlevel)

	set background = 1
	set waitfor = 0

	for(var/thing in mining_walls["[zlevel]"])
		var/turf/simulated/mineral/M = thing
		M.update_icon()
	for(var/thing in mining_floors["[zlevel]"])
		var/turf/simulated/floor/asteroid/M = thing
		if(istype(M))
			M.updateMineralOverlays()

/datum/map/proc/get_network_access(var/network)
	return 0

// By default transition randomly to another zlevel
/datum/map/proc/get_transit_zlevel(var/current_z_level)
	var/list/candidates = GLOB.using_map.accessible_z_levels.Copy()
	candidates.Remove(num2text(current_z_level))

	if(!candidates.len)
		return current_z_level
	return text2num(pickweight(candidates))

/datum/map/proc/get_empty_zlevel()
	if(empty_levels == null)
		world.maxz++
		empty_levels = list(world.maxz)
	return pick(empty_levels)


/datum/map/proc/setup_economy()
	news_network.CreateFeedChannel("Nyx Daily", "SolGov Minister of Information", 1, 1)
	news_network.CreateFeedChannel("The Gibson Gazette", "Editor Mike Hammers", 1, 1)

	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len

	if(!station_account)
		station_account = create_account("[station_name()] Primary Account", starting_money)

	for(var/datum/job/job as anything in allowed_jobs)
		var/dep = initial(job.department)
		if(dep)
			station_departments |= dep

	for(var/department in station_departments)
		department_accounts[department] = create_account("[department] Account", department_money)

	department_accounts["Vendor"] = create_account("Vendor Account", 0)
	vendor_account = department_accounts["Vendor"]

/datum/map/proc/bolt_saferooms()
	return // overriden by torch

/datum/map/proc/unbolt_saferooms()
	return // overriden by torch

/datum/map/proc/make_maint_all_access(var/radstorm = 0) // parameter used by torch
	maint_all_access = 1
	priority_announcement.Announce("The maintenance access requirement has been revoked on all maintenance airlocks.", "Attention!")

/datum/map/proc/revoke_maint_all_access(var/radstorm = 0) // parameter used by torch
	maint_all_access = 0
	priority_announcement.Announce("The maintenance access requirement has been readded on all maintenance airlocks.", "Attention!")

// Access check is of the type requires one. These have been carefully selected to avoid allowing the janitor to see channels he shouldn't
// This list needs to be purged but people insist on adding more cruft to the radio.
/datum/map/proc/default_internal_channels()
	return list(
		num2text(PUB_FREQ)   = list(),
		//num2text(AI_FREQ)    = list(access_synth),
		num2text(ENT_FREQ)   = list(),
		//num2text(ERT_FREQ)   = list(access_cent_specops),
		num2text(COMM_FREQ)  = list(access_bridge),
		num2text(ENG_FREQ)   = list(access_engineering),
		num2text(MED_FREQ)   = list(access_medical),
		num2text(MED_I_FREQ) = list(access_medical),
		num2text(SEC_FREQ)   = list(access_security),
		num2text(SEC_I_FREQ) = list(access_security),
		num2text(SCI_FREQ)   = list(access_research),
		num2text(SUP_FREQ)   = list(access_cargo),
		num2text(SRV_FREQ)   = list(access_service),
	)

/datum/map/proc/setup_crew_objectives()
	for(var/subtype in crew_objectives)
		var/datum/crew_objective/CO = GLOB.all_crew_objectives[subtype]
		CO.Initialize()
