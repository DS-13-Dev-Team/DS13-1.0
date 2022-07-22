/datum/map/colony
	name = "Colony"
	full_name = "Aegis Colony"
	path = "colony"
	station_levels = list(1,2,3)
	contact_levels = list(1,2,3)
	player_levels = list(1,2,3)
	sealed_levels = list(4)
	admin_levels = list(4)
	empty_levels = list()
	accessible_z_levels = list("2" = 1, "3" = 1, "4" = 1)
	base_turf_by_z = list(
		1 = /turf/space,
		2 = /turf/simulated/floor/asteroid/outside_ds,
		3 = /turf/simulated/open,
		4 = /turf/simulated/open,
	)

	using_shuttles = list(
		/datum/shuttle/autodock/ferry/supply/drone,
		/datum/shuttle/autodock/ferry/escape1,
		/datum/shuttle/autodock/ferry/escape2,
		/datum/shuttle/autodock/ferry/escape3,
		/datum/shuttle/autodock/ferry/escape_fix,
		/datum/shuttle/autodock/multi/antag/deliverance,
		/datum/shuttle/autodock/multi/antag/kellion,
		/datum/shuttle/autodock/multi/antag/valor,
	)

	local_currency_name = "credits"
	station_networks = list(
		NETWORK_CARGO,
		NETWORK_COMMAND,
		NETWORK_COMMON,
		NETWORK_CREW,
		NETWORK_ENGINEERING,
		NETWORK_MAINTENANCE,
		NETWORK_MEDICAL,
		NETWORK_MINE,
		NETWORK_RESEARCH,
		NETWORK_SECURITY
	)
	usable_email_tlds = list("cec.corp")
	map_admin_faxes = list("Earth Government Colonial Alliance Headquarters")


	station_name  = "Colony"
	station_short = "Colony"
	dock_name     = "Aegis VII"
	boss_name     = "Concordance Extraction Corporation"
	boss_short    = "CEC"
	company_name  = "EarthGov"
	company_short = "EarthGov"
	system_name = "Cygnus System"


	skybox_foreground_objects = list(/datum/skybox_foreground_object/aegis_vii)

/*
	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/maintenance/exterior
*/
	post_round_safe_areas = list (
		/area/mining_colony/interior/shuttle_bay/shuttle_1,
		/area/mining_colony/interior/shuttle_bay/shuttle_2,
		/area/shuttle/executive_shuttle,
		/area/ERT/deliverance,
		/area/ERT/valor,
		/area/ERT/kellion,
		/area/ERT/escapebase,
	)

	evac_controller_type = /datum/evacuation_controller/starship

	crew_objectives = list(/datum/crew_objective/ads)

	lobby_tracks = list(/music_track/ds13/twinkle,
		/music_track/ds13/nicole,
		/music_track/ds13/danik,
		/music_track/ds13/pensive,
		/music_track/ds13/rock,
		/music_track/ds13/violin,
		/music_track/ds13/unitology)

/datum/map/colony/post_setup()
	.=..()
	if(GLOB.shuttlerepairspawnlocs.len < 5)
		CRASH("Couldn't spawn enough shuttle parts to fix the shuttle!")
	for(var/i=1 to 7)
		var/turf/turf = pick(GLOB.shuttlerepairspawnlocs)
		if(!turf)
			break
		GLOB.shuttlerepairspawnlocs -= turf
		new /obj/item/shuttle_part(turf)

/turf/simulated/wall
	name = "bulkhead"

/turf/simulated/floor
	name = "bare deck"

/turf/simulated/floor/tiled
	name = "deck"

/decl/flooring/tiling
	name = "deck"