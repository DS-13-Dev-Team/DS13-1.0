/datum/tgui_module/crew_monitor
	name = "Crew monitor"
	tgui_id = "CrewMonitor"

/datum/tgui_module/crew_monitor/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/nanomaps),
	)

/datum/tgui_module/crew_monitor/ui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	if(action && !issilicon(usr))
		playsound(ui_host(), "terminal_type", 50, 1)

	var/turf/T = get_turf(usr)
	if(!T || !(T.z in GLOB.using_map.player_levels))
		to_chat(usr, "<span class='warning'><b>Unable to establish a connection</b>: You're too far away from the station!</span>")
		return FALSE

	switch(action)
		if("track")
			if(isAI(usr))
				var/mob/living/silicon/ai/AI = usr
				var/mob/living/carbon/human/H = locate(params["track"]) in GLOB.human_mob_list
				if(hassensorlevel(H, RIG_SENSOR_TRACKING))
					AI.ai_actual_track(H)
			return TRUE
		if("setZLevel")
			ui.set_map_z_level(params["mapZLevel"])
			return TRUE

/datum/tgui_module/crew_monitor/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, tgui_id, name)
		ui.autoupdate = TRUE
		ui.open()


/datum/tgui_module/crew_monitor/ui_data(mob/user)
	var/data[0]

	data["isAI"] = isAI(user)

	var/list/map_levels = GLOB.using_map.contact_levels
	data["map_levels"] = map_levels

	var/list/crewmembers = list()
	for(var/zlevel in map_levels)
		crewmembers += GLOB.crew_repository.health_data(zlevel)

	// This is apparently necessary, because the above loop produces an emergent behavior
	// of telling you what coordinates someone is at even without sensors on,
	// because it strictly sorts by zlevel from bottom to top, and by coordinates from top left to bottom right.
	shuffle_inplace(crewmembers)
	data["crewmembers"] = crewmembers

	return data

/datum/tgui_module/crew_monitor/proc/has_alerts()
	for(var/z_level in GLOB.using_map.map_levels)
		if (GLOB.crew_repository.has_health_alert(z_level))
			return TRUE
	return FALSE

/datum/tgui_module/crew_monitor/ntos
	ntos = TRUE