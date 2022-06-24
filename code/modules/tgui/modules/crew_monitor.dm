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
	var/list/healthbars = list()
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.wearing_rig?.healthbar)
			healthbars |= H.wearing_rig.healthbar

	for(var/obj/item/rig_module/healthbar/HB as anything in healthbars)
		var/turf/pos = get_turf(HB)
		if(HB.tracking_level != RIG_SENSOR_OFF && HB.holder?.active)
			var/list/crewmemberData = list("stat"=0, "oxy"=-1, "tox"=-1, "fire"=-1, "brute"=-1, "area"="", "x"=-1, "y"=-1, "ref" = "\ref[HB.holder.wearer]")

			crewmemberData["sensor_type"] = HB.tracking_level
			crewmemberData["name"] = HB.holder.wearer.get_authentification_name(if_no_id="Unknown")
			crewmemberData["rank"] = HB.holder.wearer.get_authentification_rank(if_no_id="Unknown", if_no_job="No Job")
			crewmemberData["assignment"] = HB.holder.wearer.get_assignment(if_no_id="Unknown", if_no_job="No Job")

			if(HB.tracking_level >= RIG_SENSOR_BINARY)
				crewmemberData["stat"] = HB.holder.wearer.stat

			if(HB.tracking_level >= RIG_SENSOR_VITAL)
				crewmemberData["oxy"] = round(HB.holder.wearer.getOxyLoss(), 1)
				crewmemberData["tox"] = round(HB.holder.wearer.getToxLoss(), 1)
				crewmemberData["fire"] = round(HB.holder.wearer.getFireLoss(), 1)
				crewmemberData["brute"] = round(HB.holder.wearer.getBruteLoss(), 1)

			if(HB.tracking_level >= RIG_SENSOR_TRACKING)
				var/area/A = pos.loc
				crewmemberData["area"] = sanitize(A.name)
				crewmemberData["x"] = pos.x
				crewmemberData["y"] = pos.y
				crewmemberData["z"] = pos.z

			crewmembers[++crewmembers.len] = crewmemberData

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