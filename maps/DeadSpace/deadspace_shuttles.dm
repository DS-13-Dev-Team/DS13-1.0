//////// MINING SHUTTLES \\\\\\\\

/datum/shuttle/autodock/ferry/mining_one
	name = "Mining Shuttle One"
	location = 1
	warmup_time = 10
	shuttle_area = /area/ishimura/lower/mining/shuttle/one
	dock_target = "mining_shuttle_one"
	waypoint_offsite = "shuttle_bay_one"
	waypoint_station = "aegis_hangar_one"

/obj/effect/shuttle_landmark/ferry/mining_one/start
	name = "Mining Shuttle One"
	landmark_tag = "shuttle_bay_one"
	docking_controller = "ishimura_shuttle_bay_one"
	base_area = /area/ishimura/lower/mining/shuttlebay/port
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/ferry/mining_one/out
	name = "Aegis Hangar"
	landmark_tag = "aegis_hangar_one"
	docking_controller = "aegis_hangar_one"
	base_area = /area/aegis/colony/hangar
	base_turf = /turf/simulated/floor/plating


/datum/shuttle/autodock/ferry/mining_two
	name = "Mining Shuttle Two"
	location = 1
	warmup_time = 10
	shuttle_area = /area/ishimura/lower/mining/shuttle/two
	dock_target = "mining_shuttle_two"
	waypoint_offsite = "shuttle_bay_two"
	waypoint_station = "aegis_hangar_two"

/obj/effect/shuttle_landmark/ferry/mining_two/start
	name = "Mining Shuttle Two"
	landmark_tag = "shuttle_bay_two"
	docking_controller = "ishimura_shuttle_bay_two"
	base_area = /area/ishimura/lower/mining/shuttlebay/starboard
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/ferry/mining_two/out
	name = "Aegis Hangar"
	landmark_tag = "aegis_hangar_two"
	docking_controller = "aegis_hangar_two"
	base_area = /area/aegis/colony/hangar
	base_turf = /turf/simulated/floor/plating


//////// SUPPLY ELEVATOR \\\\\\\\

/datum/shuttle/autodock/ferry/supply/drone
	name = "Supply Drone"
	location = 1
	warmup_time = 10
	shuttle_area = /area/supply/dock
	waypoint_offsite = "supply_elevator_start"
	waypoint_station = "supply_elevator_up"

/obj/effect/shuttle_landmark/supply/start
	name = "Below Deck"
	landmark_tag = "supply_elevator_start"

/obj/effect/shuttle_landmark/supply/ishimura
	name = "Cargo Bay"
	landmark_tag = "supply_elevator_up"
	base_area = /area/ishimura/lower/cargo/bay
	base_turf = /turf/simulated/floor/plating


//////// ERT SHUTTLES \\\\\\\\

/datum/shuttle/autodock/multi/antag/deliverance
	name = "Deliverance"
	warmup_time = 10
	destination_tags = list(
		"deliverance_start",
		"deliverance_landing"
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

/datum/shuttle/autodock/multi/antag/kellion
	name = "Kellion"
	warmup_time = 10
	destination_tags = list(
		"kellion_start",
		"kellion_landing"
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

/datum/shuttle/autodock/multi/antag/valor
	name = "Valor"
	warmup_time = 10
	destination_tags = list(
		"valor_start",
		"valor_landing"
	)
	shuttle_area = /area/ERT/valor/shuttle
	current_location = "valor_start"
	landmark_transition = "valor_transition"


/obj/effect/shuttle_landmark/valor/start
	name = "Space"
	landmark_tag = "valor_start"

/obj/effect/shuttle_landmark/valor/transition
	name = "In transit"
	landmark_tag = "valor_transition"

/obj/effect/shuttle_landmark/valor/landing
	name = "Ishimura Hangar #1"
	landmark_tag = "valor_landing"