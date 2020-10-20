
//Executive

/datum/shuttle/autodock/ferry/executive
	name = "Executive Shuttle"
	warmup_time = 5	//Takes off quickly to keep the sacrifice element in play.
	shuttle_area = /area/shuttle/executive_shuttle
	dock_target = "executive_shuttle"
	waypoint_station = "nav_executive_start"
	waypoint_offsite = "nav_executive_out"
	landmark_transition = "executive_transition"

/obj/effect/shuttle_landmark/executive/start
	name = "Executive Shuttle EVAC"
	landmark_tag = "nav_executive_start"
	docking_controller = "executive_shuttle"
	base_area = /area/centcom
	base_turf = /turf/simulated/floor/plating

/obj/effect/shuttle_landmark/executive/transit
	landmark_tag = "executive_transition"

/obj/effect/shuttle_landmark/executive/out
	name = "Docking Bay"
	landmark_tag = "nav_executive_out"
//	docking_controller = "executive_dock_airlock"

/area/shuttle/executive_shuttle
	name = "\improper Executive Shuttle"
	icon_state = "shuttlered"

GLOBAL_LIST_INIT(executive_shuttle_controllers, list())

/obj/machinery/computer/shuttle_control/executive_master
	name = "Executive Shuttle Master Console"
	desc = "A master control console for the Executive shuttle, requires external authorisation to launch."
	shuttle_tag = "Executive Shuttle"
	var/requires_authorisation = FALSE //Does this console need external auth by the consoles? Admins can override this if they need to.
	var/list/slaved = list() //Slaved consoles.

/obj/machinery/computer/shuttle_control/executive_master/get_ui_data(datum/shuttle/autodock/shuttle)
	var/list/data = ..()
	data["can_launch"] = shuttle.can_launch() && can_launch()
	return data

//Overloadable if you want one that always launches.
/obj/machinery/computer/shuttle_control/executive_master/proc/can_launch()
	var/requisite = (requires_authorisation) ? GLOB.executive_shuttle_controllers.len : 0
	var/authcount = 0
	for(var/obj/machinery/computer/shuttle_control/executive/E in GLOB.executive_shuttle_controllers)
		if(E.authorised)
			authcount ++
	return authcount >= requisite

/obj/machinery/computer/shuttle_control/executive
	name = "Executive Shuttle Authorisation Console"
	desc = "A console used to provide authorisation for the Executive Shuttle to leave. All its sister consoles must authorise in unison before the shuttle can move."
	ui_template = "executive_shuttle.tmpl"
	shuttle_tag = "Executive Shuttle"
	var/authorised = FALSE
	var/auth_timeout = 10 SECONDS //How long do you have to launch before this one's auth times out?

/obj/machinery/computer/shuttle_control/executive/Initialize()
	. = ..()
	GLOB.executive_shuttle_controllers += src

/obj/machinery/computer/shuttle_control/executive/get_ui_data(datum/shuttle/autodock/shuttle)
	var/list/data = ..()
	data["authorised"] = authorised
	return data

/obj/machinery/computer/shuttle_control/executive/handle_topic_href(var/datum/shuttle/autodock/shuttle, var/list/href_list, var/user)
	. = ..()
	if(!istype(shuttle))
		return TOPIC_NOACTION

	if(href_list["authorise"])
		authorised = TRUE
		addtimer(CALLBACK(src, .proc/reset_auth), auth_timeout)
		return TOPIC_REFRESH

/obj/machinery/computer/shuttle_control/executive/proc/reset_auth()
	authorised = FALSE