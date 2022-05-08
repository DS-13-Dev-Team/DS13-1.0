/obj/effect/shuttle_landmark/supply/start
	name = "Below Deck"
	landmark_tag = "supply_elevator_start"

// ESCAPE SHUTTLES

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod
	category = /datum/shuttle/autodock/ferry/escape_pod/ishimurapod
	sound_takeoff = 'sound/effects/rocket.ogg'
	sound_landing = 'sound/effects/rocket_backwards.ogg'
	var/number

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/New()
	name = "Escape Pod [number]"
	dock_target = "escape_pod_[number]"
	arming_controller = "escape_pod_[number]_berth"
	waypoint_station = "escape_pod_[number]_start"
	landmark_transition = "escape_pod_[number]_internim"
	waypoint_offsite = "escape_pod_[number]_out"
	..()

/obj/effect/shuttle_landmark/escape_pod/
	var/number

/obj/effect/shuttle_landmark/escape_pod/start
	name = "Docked"

/obj/effect/shuttle_landmark/escape_pod/start/New()
	landmark_tag = "escape_pod_[number]_start"
	docking_controller = "escape_pod_[number]_berth"
	..()

/obj/effect/shuttle_landmark/escape_pod/transit
	name = "In transit"

/obj/effect/shuttle_landmark/escape_pod/transit/New()
	landmark_tag = "escape_pod_[number]_internim"
	..()

/obj/effect/shuttle_landmark/escape_pod/out
	name = "Escaped"
	escape = TRUE

/obj/effect/shuttle_landmark/escape_pod/out/New()
	landmark_tag = "escape_pod_[number]_out"
	..()

//PODS

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod1
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod1/station
	number = 1
/obj/effect/shuttle_landmark/escape_pod/start/pod1
	number = 1
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod1
	number = 1
/obj/effect/shuttle_landmark/escape_pod/transit/pod1
	number = 1


/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod2
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod2/station
	number = 2
/obj/effect/shuttle_landmark/escape_pod/start/pod2
	number = 2
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod2
	number = 2
/obj/effect/shuttle_landmark/escape_pod/transit/pod2
	number = 2

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod3
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod3/station
	number = 3
/obj/effect/shuttle_landmark/escape_pod/start/pod3
	number = 3
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod3
	number = 3
/obj/effect/shuttle_landmark/escape_pod/transit/pod3
	number = 3

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod4
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod4/station
	number = 4
/obj/effect/shuttle_landmark/escape_pod/start/pod4
	number = 4
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod4
	number = 4
/obj/effect/shuttle_landmark/escape_pod/transit/pod4
	number = 4

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod5
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod5/station
	number = 5
/obj/effect/shuttle_landmark/escape_pod/start/pod5
	number = 5
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod5
	number = 5
/obj/effect/shuttle_landmark/escape_pod/transit/pod5
	number = 5

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod6
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod6/station
	number = 6
/obj/effect/shuttle_landmark/escape_pod/start/pod6
	number = 6
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod6
	number = 6
/obj/effect/shuttle_landmark/escape_pod/transit/pod6
	number = 6

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod7
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod7/station
	number = 7
/obj/effect/shuttle_landmark/escape_pod/start/pod7
	number = 7
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod7
	number = 7
/obj/effect/shuttle_landmark/escape_pod/transit/pod7
	number = 7

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod8
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod8/station
	number = 8
/obj/effect/shuttle_landmark/escape_pod/start/pod8
	number = 8
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod8
	number = 8
/obj/effect/shuttle_landmark/escape_pod/transit/pod8
	number = 8

/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod9
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod9/station
	number = 9
/obj/effect/shuttle_landmark/escape_pod/start/pod9
	number = 9
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod9
	number = 9
/obj/effect/shuttle_landmark/escape_pod/transit/pod9
	number = 9
/*
/datum/shuttle/autodock/ferry/escape_pod/ishimurapod/escape_pod10
	warmup_time = 10
	shuttle_area = /area/shuttle/escape_pod10/station
	number = 10
/obj/effect/shuttle_landmark/escape_pod/start/pod10
	number = 10
	base_turf =/turf/simulated/floor/airless
/obj/effect/shuttle_landmark/escape_pod/out/pod10
	number = 10
/obj/effect/shuttle_landmark/escape_pod/transit/pod10
	number = 10
*/

//////// ERT SHUTTLES \\\\\\\\

/datum/shuttle/autodock/multi/antag/deliverance
	name = "Deliverance"
	warmup_time = 10
	destination_tags = list(
		"deliverance_start",
		"deliverance_landing",
		"deliverance_landing2"
	)
	shuttle_area = /area/ERT/deliverance
	current_location = "deliverance_start"
	landmark_transition = "deliverance_transition"


/obj/effect/shuttle_landmark/deliverance/start
	name = "Space"
	landmark_tag = "deliverance_start"

/obj/effect/shuttle_landmark/deliverance/transition
	name = "In transit"
	landmark_tag = "deliverance_transition"

/obj/effect/shuttle_landmark/deliverance/landing
	name = "Ishimura Hangar #2"
	landmark_tag = "deliverance_landing"
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/multi/antag/kellion
	name = "Kellion"
	warmup_time = 10
	destination_tags = list(
		"kellion_start",
		"kellion_landing",
		"kellion_landing2"
	)
	shuttle_area = /area/ERT/kellion
	current_location = "kellion_start"
	landmark_transition = "kellion_transition"


/obj/effect/shuttle_landmark/kellion/start
	name = "Space"
	landmark_tag = "kellion_start"

/obj/effect/shuttle_landmark/kellion/transition
	name = "In transit"
	landmark_tag = "kellion_transition"

/obj/effect/shuttle_landmark/kellion/landing
	name = "Ishimura Hangar #3"
	landmark_tag = "kellion_landing"
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/multi/antag/valor
	name = "Valor"
	warmup_time = 10
	destination_tags = list(
		"valor_start",
		"valor_landing",
		"valor_landing2"
	)
	shuttle_area = /area/ERT/valor/shuttle
	current_location = "valor_start"
	landmark_transition = "valor_transition"


/obj/effect/shuttle_landmark/valor/start
	name = "Space"
	landmark_tag = "valor_start"
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/valor/transition
	name = "In transit"
	landmark_tag = "valor_transition"

/obj/effect/shuttle_landmark/valor/landing
	name = "Ishimura Hangar #1"
	landmark_tag = "valor_landing"
	base_turf = /turf/simulated/floor/plating

// Tram //

/datum/shuttle/autodock/multi/tram
	name = "Tram"
	warmup_time = 10
	destination_tags = list(
		"nav_forwardships",
		"nav_amidships",
		"nav_aftships"
		)
	shuttle_area = /area/shuttle/tram
	current_location = "nav_forwardships"
	sound_takeoff = 'sound/effects/tramdepart.ogg'
	sound_arrival = 'sound/effects/tramarrive.ogg'

//	landmark_transition = "nav_tramtrans"

// Something else. //

/obj/effect/shuttle_landmark/valor/landing2
	name = "Evacuation Site - Alpha #2"
	landmark_tag = "valor_landing2"
	base_turf = /turf/simulated/floor/plating
	escape = TRUE

/obj/effect/shuttle_landmark/kellion/landing2
	name = "Evacuation Site - Alpha #1"
	landmark_tag = "kellion_landing2"
	base_turf = /turf/simulated/floor/plating
	escape = TRUE

/obj/effect/shuttle_landmark/deliverance/landing2
	name = "Evacuation Site - Alpha #3"
	landmark_tag = "deliverance_landing2"
	base_turf = /turf/simulated/floor/plating
	escape = TRUE