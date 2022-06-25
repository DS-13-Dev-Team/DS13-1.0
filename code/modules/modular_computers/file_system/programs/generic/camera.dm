// Returns which access is relevant to passed network. Used by the program.
/proc/get_camera_access(var/network)
	if(!network)
		return 0
	. = GLOB.using_map.get_network_access(network)
	if(.)
		return

	switch(network)
		if(NETWORK_CARGO)
			return access_cargo
		if(NETWORK_COMMAND)
			return access_bridge
		if(NETWORK_COMMON)
			return 0
		if(NETWORK_CREW)
			return 0
		if(NETWORK_ENGINEERING, NETWORK_MAINTENANCE, NETWORK_ALARM_ATMOS, NETWORK_ALARM_CAMERA, NETWORK_ALARM_FIRE, NETWORK_ALARM_POWER)
			return access_engineering
		if(NETWORK_MEDICAL)
			return access_medical
		if(NETWORK_MINE)
			return access_mining
		if(NETWORK_RESEARCH)
			return access_research
		if(NETWORK_THUNDER)
			return 0

	return access_security // Default for all other networks

/datum/computer_file/program/camera_monitor
	filename = "cammon"
	filedesc = "Camera Monitoring"
	tguimodule_path = /datum/tgui_module/camera/ntos
	program_icon_state = "cameras"
	program_key_state = "generic_key"
	program_menu_icon = "search"
	extended_desc = "This program allows remote access to the camera system. Some camera networks may have additional access requirements."
	size = 12
	available_on_ntnet = 1
	requires_ntnet = 1

// ERT Variant of the program
/datum/computer_file/program/camera_monitor/ert
	filename = "ntcammon"
	filedesc = "Advanced Camera Monitoring"
	extended_desc = "This program allows remote access to the camera system. Some camera networks may have additional access requirements. This version has an integrated database with additional encrypted keys."
	size = 14
	tguimodule_path = /datum/tgui_module/camera/ntos/ert
	available_on_ntnet = 0
