/datum/vote/gamemode
	name = "game mode"
	additional_header = "<th>Minimum Players</th>"
	win_x = 500
	win_y = 1100
	result_length = 3
	question = "Place your vote for the next gamemode."

/datum/vote/gamemode/can_run(mob/creator, automatic)
	if(!automatic && (!is_admin(creator)))
		return FALSE // Admins and autovotes bypass the config setting.
	if(GAME_STATE >= RUNLEVEL_GAME)
		return FALSE
	return ..()

/datum/vote/gamemode/Process()
	if(GAME_STATE >= RUNLEVEL_GAME)
		to_world("<b>Voting aborted due to game start.</b>")
		return VOTE_PROCESS_ABORT
	return ..()

/datum/vote/gamemode/setup_vote(mob/creator, automatic)
	..()
	for (var/datum/game_mode/M in config.votable_modes)
		//Check if its votable right now, this will be useful in future as the votability status of a mode will be able to change mid round
		if (!M.is_votable())
			return
		choices += M
		display_choices[M.name] = M
		additional_text[M] ="<td align = 'center'>[M.required_players]</td>"


/datum/vote/gamemode/handle_default_votes()
	var/non_voters = ..()
	if(GLOB.master_mode in display_choices)
		var/datum/game_mode/M = display_choices[GLOB.master_mode]
		choices[M] += non_voters

/datum/vote/gamemode/report_result()

	if(..())
		SSticker.gamemode_vote_results = list() //This signals to SSticker that the vote is over but there were no winners.
		return 1
	if(GLOB.master_mode != result[1])
		var/datum/game_mode/G = result[1]
		SSticker.save_mode(G.name)
		if(SSticker.mode)
			SSvote.restart_world() //This is legacy behavior for votes after the mode is set, e.g. if an admin halts the ticker and holds another vote before gamestart.
			return                 //Potenitally the new vote after restart can then be cancelled, to use this vote's result.
		GLOB.master_mode = G.config_tag
	SSticker.gamemode_vote_results = result.Copy()

/datum/vote/gamemode/check_toggle()
	return config.allow_vote_mode ? "Allowed" : "Disallowed"

