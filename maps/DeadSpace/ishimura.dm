#define using_map_DATUM /datum/map/ishimura

//	#include "DeadSpace/job.dm"

/datum/map/ishimura
	name = "Ishimura"
	full_name = "USG Ishimura"
	path = "ishimura"
	station_levels = list(1,2)
	contact_levels = list(1,2,3)
	player_levels = list(1,2)
	admin_levels = list(5)
	empty_levels = list()
	accessible_z_levels = list("1"=1,"2"=1,"3"=2,"4"=3)
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
	usable_email_tlds = list("ishimura.cec")


	station_name  = "USG Ishimura"
	station_short = "Ishimura"
	dock_name     = "Aegis VII"
	boss_name     = "Concordance Extraction Corporation"
	boss_short    = "CEC"
	company_name  = "EarthGov"
	company_short = "EarthGov"
	system_name = "Cygnus System"

/*
	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/maintenance/exterior
*/
	post_round_safe_areas = list (
		/area/shuttle/escape_pod1/station,
		/area/shuttle/escape_pod2/station,
		/area/shuttle/escape_pod3/station,
		/area/shuttle/escape_pod4/station,
		/area/shuttle/escape_pod5/station,
		/area/shuttle/escape_pod6/station,
		/area/shuttle/escape_pod7/station,
		/area/shuttle/escape_pod8/station,
		/area/shuttle/escape_pod9/station,
	)

	//Todo: Find good values for these

	//Spawnpoints:
	//These are display names of spawnpoint datums, taken from preferences_spawnpoints.dm
	allowed_spawns = list(SPAWNPOINT_CRYO, SPAWNPOINT_DORM, SPAWNPOINT_MAINT)
	evac_controller_type = /datum/evacuation_controller/starship

	lobby_icon = 'maps/DeadSpace/icons/lobby.dmi'
	lobby_screens = list("lobby1")
	lobby_tracks = list(/music_track/ds13/twinkle,
/music_track/ds13/nicole,
/music_track/ds13/danik,
/music_track/ds13/pensive,
/music_track/ds13/rock,
/music_track/ds13/violin,
/music_track/ds13/unitology)

	allowed_jobs = list(/datum/job/cap, /datum/job/fl, /datum/job/bo, /datum/job/cseco,
						/datum/job/sso, /datum/job/security_officer, /datum/job/smo,
						/datum/job/md, /datum/job/surg, /datum/job/cscio, /datum/job/ra,
						/datum/job/ce, /datum/job/tech_engineer, /datum/job/so,
						/datum/job/serviceman, /datum/job/dom, /datum/job/foreman,
						/datum/job/planet_cracker, /datum/job/line_cook, /datum/job/bar, /datum/job/botanist
						)
/turf/simulated/wall
	name = "bulkhead"

/turf/simulated/floor
	name = "bare deck"

/turf/simulated/floor/tiled
	name = "deck"

/decl/flooring/tiling
	name = "deck"