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
	base_area = /area/mining_colony/interior/cargo/logistics
	base_turf = /turf/simulated/floor/plating

/datum/shuttle/autodock/ferry/escape1
	name = "Escape Shuttle 1"
	warmup_time = 5
	shuttle_area = /area/mining_colony/interior/shuttle_bay/shuttle_1
	dock_target = "executive_shuttle"
	waypoint_station = "colony_escape1_start"
	waypoint_offsite = "colony_escape1_end"
	landmark_transition = "colony_escape1_transition"

/datum/shuttle/autodock/ferry/escape1/can_launch()
	if (evacuation_controller.state < EVAC_LAUNCHING)
		return FALSE

	return (next_location && moving_status == SHUTTLE_IDLE)

/obj/effect/shuttle_landmark/escape1/start
	name = "The Colony"
	landmark_tag = "colony_escape1_start"
	//docking_controller = "executive_shuttle"
	base_area = /area/mining_colony/interior/shuttle_bay/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/escape1/transit
	landmark_tag = "colony_escape1_transition"

/obj/effect/shuttle_landmark/escape1/end
	name = "Docking Bay"
	base_area = /area/ERT/escapebase
	landmark_tag = "colony_escape1_end"
	escape = TRUE

/datum/shuttle/autodock/ferry/escape2
	name = "Escape Shuttle 2"
	warmup_time = 5	//Takes off quickly to keep the sacrifice element in play.
	shuttle_area = /area/mining_colony/interior/shuttle_bay/shuttle_2
	dock_target = "executive_shuttle"
	waypoint_station = "colony_escape2_start"
	waypoint_offsite = "colony_escape2_end"
	landmark_transition = "colony_escape2_transition"

/datum/shuttle/autodock/ferry/escape2/can_launch()
	if (evacuation_controller.state < EVAC_LAUNCHING)
		return FALSE

	return (next_location && moving_status == SHUTTLE_IDLE)

/obj/effect/shuttle_landmark/escape2/start
	name = "The Colony"
	landmark_tag = "colony_escape2_start"
	//docking_controller = "executive_shuttle"
	base_area =/area/mining_colony/interior/shuttle_bay/hangar
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/escape2/transit
	landmark_tag = "colony_escape2_transition"

/obj/effect/shuttle_landmark/escape2/end
	name = "Docking Bay"
	base_area = /area/ERT/escapebase
	landmark_tag = "colony_escape2_end"
	escape = TRUE

/datum/shuttle/autodock/ferry/escape_fix
	name = "Repaired Shuttle"
	warmup_time = 5	//Takes off quickly to keep the sacrifice element in play.
	shuttle_area = /area/shuttle/executive_shuttle
	dock_target = "executive_shuttle"
	waypoint_station = "colony_escape_fix_start"
	waypoint_offsite = "colony_escape_fix_end"
	landmark_transition = "colony_escape_fix_transition"

/obj/effect/shuttle_landmark/escape_fix/start
	name = "The Colony"
	landmark_tag = "colony_escape_fix_start"
	//docking_controller = "executive_shuttle"
	base_area = /area/mining_colony/c12_deadspace
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/escape_fix/transit
	landmark_tag = "colony_escape_fix_transition"

/obj/effect/shuttle_landmark/escape_fix/end
	name = "Docking Bay"
	base_area = /area/ERT/escapebase
	landmark_tag = "colony_escape_fix_end"
	escape = TRUE

/area/shuttle/executive_shuttle
	name = "\improper Escape Shuttle"
	icon_state = "shuttlered"

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
	name = "The Colony"
	landmark_tag = "deliverance_landing"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/mining_colony/interior/excavation/hangar

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
	name = "The Colony"
	landmark_tag = "kellion_landing"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/mining_colony/interior/kellion_arrival

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
	name = "The Colony"
	landmark_tag = "valor_landing"
	base_turf = /turf/simulated/floor/plating
	base_turf = /area/mining_colony

/obj/effect/shuttle_landmark/kellion/landing2
	name = "Evacuation Site - Alpha #1"
	landmark_tag = "kellion_landing2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/ERT/escapebase
	escape = TRUE

/obj/effect/shuttle_landmark/valor/landing2
	name = "Evacuation Site - Alpha #2"
	landmark_tag = "valor_landing2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/ERT/escapebase
	escape = TRUE

/obj/effect/shuttle_landmark/deliverance/landing2
	name = "Evacuation Site - Alpha #3"
	landmark_tag = "deliverance_landing2"
	base_turf = /turf/simulated/floor/plating
	base_area = /area/ERT/escapebase
	escape = TRUE