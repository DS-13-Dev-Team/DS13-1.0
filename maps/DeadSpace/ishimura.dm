#define using_map_DATUM /datum/map/ishimura
/datum/map/ishimura
	name = "Ishimura"
	full_name = "SEV Torch"
	path = "ishimura"
	station_levels = list(1,2)
	contact_levels = list(1,2,3)
	player_levels = list(1,2,3)
	admin_levels = list()
	empty_levels = list(5)
	accessible_z_levels = list("1"=1,"2"=1,"3"=2,"4"=3)
	/*
	base_floor_type = /turf/simulated/floor/reinforced/airless
	base_floor_area = /area/maintenance/exterior

	post_round_safe_areas = list (
		/area/centcom,
		/area/shuttle/escape/centcom,
		/area/shuttle/escape_pod1/centcom,
		/area/shuttle/escape_pod2/centcom,
		/area/shuttle/escape_pod3/centcom,
		/area/shuttle/escape_pod5/centcom,
		/area/shuttle/transport1/centcom,
		/area/shuttle/administration/centcom,
		/area/shuttle/specops/centcom,
	)
	*/
	//Todo: Find good values for these

	//Spawnpoints:
	//These are display names of spawnpoint datums, taken from preferences_spawnpoints.dm
	allowed_spawns = list(SPAWNPOINT_CRYO)

	lobby_icon = 'maps/DeadSpace/icons/lobby.dmi'
	lobby_screens = list("lobby1","lobby2","lobby3","lobby4", "lobby5")
	lobby_tracks = list(/music_track/ds13/twinkle,
/music_track/ds13/nicole,
/music_track/ds13/danik,
/music_track/ds13/pensive,
/music_track/ds13/rock,
/music_track/ds13/violin,
/music_track/ds13/unitology)
