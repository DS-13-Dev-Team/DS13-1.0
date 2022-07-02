#ifndef MAP_ISHIMURA
#define USING_MAP_DATUM /datum/map/colony
#endif
//	#include "DeadSpace/job.dm"

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
	base_turf_by_z = list(
		1 = /turf/simulated/floor/asteroid/outside_ds,
		2 = /turf/simulated/open,
		3 = /turf/simulated/open,
		4 = /turf/space,
	)
	accessible_z_levels = list("1"=1,"2"=1,"3"=1)
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
	usable_email_tlds = list("colony.cec")
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

	//Todo: Find good values for these

	//Spawnpoints:
	//These are display names of spawnpoint datums, taken from preferences_spawnpoints.dm
	allowed_spawns = list(SPAWNPOINT_CRYO, SPAWNPOINT_DORM, SPAWNPOINT_MAINT)
	evac_controller_type = /datum/evacuation_controller/starship

	crew_objectives = list(/datum/crew_objective/ads)

	lobby_screens = list('icons/hud/lobby_screens/DS13_lobby.gif')
	lobby_tracks = list(/music_track/ds13/twinkle,
		/music_track/ds13/nicole,
		/music_track/ds13/danik,
		/music_track/ds13/pensive,
		/music_track/ds13/rock,
		/music_track/ds13/violin,
		/music_track/ds13/unitology)

	allowed_jobs = list(/datum/job/cap, /datum/job/fl, /datum/job/bo, /datum/job/cseco,
						/datum/job/sso, /datum/job/security_officer, /datum/job/smo,
						/datum/job/md, /datum/job/surg, /datum/job/psychologist, /datum/job/cscio,
						/datum/job/ra, /datum/job/ce, /datum/job/tech_engineer, /datum/job/so,
						/datum/job/janitor, /datum/job/chaplain, /datum/job/serviceman,
						/datum/job/salvage, /datum/job/dom, /datum/job/foreman, /datum/job/planet_cracker,
						/datum/job/line_cook, /datum/job/bar, /datum/job/botanist
						)

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