
/mob/dead/get_status_tab_items()
	. = ..()
	. += ""

	if(!SSticker)
		return
	if(check_rights(R_INVESTIGATE, 0, src))
		. += "Game Mode: [SSticker.mode || GLOB.master_mode][SSticker.hide_mode ? "(Secret)" : ""]"
	else
		. += "Game Mode: [PUBLIC_GAME_MODE]"
	. += "Added Antagonists: [GLOB.additional_antag_types ? GLOB.additional_antag_types : "None"]"

	if(SSticker.HasRoundStarted())
		return

	var/time_remaining = SSticker.GetTimeLeft()
	if(time_remaining > 0)
		. += "Time To Start: [round(time_remaining/10)]s"
	else if(time_remaining == -10)
		. += "Time To Start: DELAYED"
	else
		. += "Time To Start: SOON"
	. += "Players: [SSticker.totalPlayers]"
	. += "Players Ready: [SSticker.totalPlayersReady]"
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		var/highjob
		if(player.client && player.client.prefs && player.client.prefs.job_high)
			highjob = " as [player.client.prefs.job_high]"
		. += "[player.key] [player.ready ? "Playing[highjob]" : null]"
