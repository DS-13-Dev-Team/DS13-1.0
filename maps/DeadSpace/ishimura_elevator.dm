/obj/machinery/computer/shuttle_control/lift/tramswitch
	name = "switching station lift controls"
	shuttle_tag = "Switching Station Cargo Lift"
	ui_template = "shuttle_control_console_lift.tmpl"
	icon_state = "tiny"
	icon_keyboard = "tiny_keyboard"
	icon_screen = "lift"
	density = 0

/obj/effect/shuttle_landmark/lift/tramswitch_top
	name = "Upper Switching Station"
	landmark_tag = "nav_switch_lift_top"
//	base_area = /area/quartermaster/storage/upper
	base_turf = /turf/simulated/open

/obj/effect/shuttle_landmark/lift/tramswitch_bottom
	name = "Lower Switching Station"
	landmark_tag = "nav_switch_lift_bottom"
//	base_area = /area/quartermaster/storage
	base_turf = /turf/simulated/floor/plating