
/mob/dead/get_status_tab_items()
	. = ..()
	. += ""

	if(!ticker)
		return
	if(check_rights(R_INVESTIGATE, 0, src))
		. += "Game Mode: [ticker.mode || master_mode][ticker.hide_mode ? "(Secret)" : ""]"
	else
		. += "Game Mode: [PUBLIC_GAME_MODE]"
	var/extra_antags = list2params(additional_antag_types)
	. += "Added Antagonists: [extra_antags ? extra_antags : "None"]"

	if(ticker.current_state == GAME_STATE_PREGAME)
		. += "Time To Start:[ticker.pregame_timeleft][round_progressing ? "" : " (DELAYED)"]"
		. += "Players: [ticker.totalPlayers]"
		. += "Players Ready: [ticker.totalPlayersReady]"
		for(var/i in GLOB.new_player_list)
			var/mob/dead/new_player/player = i
			var/highjob
			if(player.client && player.client.prefs && player.client.prefs.job_high)
				highjob = " as [player.client.prefs.job_high]"
			. += "[player.key] [player.ready ? "Playing[highjob]" : null]"
