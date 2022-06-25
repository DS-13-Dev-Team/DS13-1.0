/datum/computer_file/program/suit_sensors
	filename = "rigsensormonitor"
	filedesc = "RIG Sensors Monitoring"
	tguimodule_path = /datum/tgui_module/crew_monitor/ntos
	ui_header = "crew_green.gif"
	program_icon_state = "crew"
	program_key_state = "med_key"
	program_menu_icon = "heart"
	extended_desc = "This program connects to life signs monitoring system to provide basic information on crew health."
	required_access = access_medical
	requires_ntnet = 1
	network_destination = "crew lifesigns monitoring system"
	size = 11
	var/has_alert = FALSE

/datum/computer_file/program/suit_sensors/process_tick()
	.=..()

	var/datum/tgui_module/crew_monitor/TMC = TM
	if(istype(TMC) && (TMC.has_alerts() != has_alert))
		if(!has_alert)
			program_icon_state = "crew-red"
			ui_header = "crew_red.gif"
		else
			program_icon_state = "crew"
			ui_header = "crew_green.gif"
		update_computer_icon()
		has_alert = !has_alert

	return 1
