GLOBAL_DATUM_INIT(shipsystem, /datum/ship_subsystems, new)


/*
	Main gamemode. Marker starts aboard ishimura
*/
/datum/game_mode/marker/containment
	name = "Containment"
	round_description = "The crew of the USG Ishimura has brought aboard a strange artifact and is tasked with discovering what its purpose is."
	extended_round_description = "The crew must holdout until help arrives"
	config_tag = "containment"
	votable = TRUE//Debug TRUE

/datum/game_mode/marker/containment/get_marker_location()
	return pick(SSnecromorph.marker_spawns_ishimura)


/*
	Alternate Gamemode: Marker starts on aegis, unitologists start with a shard
*/

/datum/game_mode/marker/enemy_within
	name = "Enemy Within"
	round_description = "The USG Ishimura has discovered a strange artifact on Aegis VII, but it is not whole. Some piece of it has been broken off and smuggled aboard"
	extended_round_description = "The crew must holdout until help arrives"
	config_tag = "enemy_within"
	votable = TRUE
	antag_tags = list(MODE_UNITOLOGIST_SHARD, MODE_EARTHGOV_AGENT)
	latejoin_antag_tags = list(MODE_UNITOLOGIST_SHARD)

/datum/game_mode/marker/enemy_within/get_marker_location()
	return pick(SSnecromorph.marker_spawns_aegis)

/datum/game_mode/marker
	name = "unnamed"
	round_description = "The USG Ishimura has unearthed a strange artifact and is tasked with discovering what its purpose is."
	extended_round_description = "The crew must holdout until help arrives"
	config_tag = "unnamed"
	required_players = 0
	required_enemies = 0
	end_on_antag_death = 0
	round_autoantag = TRUE
	auto_recall_shuttle = FALSE
	antag_tags = list(MODE_UNITOLOGIST, MODE_EARTHGOV_AGENT)
	latejoin_antag_tags = list(MODE_UNITOLOGIST, MODE_EARTHGOV_AGENT)
	antag_templates = list(/datum/antagonist/unitologist, /datum/antagonist/earthgov_agent)
	require_all_templates = FALSE
	votable = FALSE
	var/marker_setup_time = 60 MINUTES
	var/marker_active = FALSE
	antag_scaling_coeff = 8

	//Auto End condition stuff. To make the round auto end when necromorphs kill everyone

	//For it to trigger, there needs to be only this percentage of humans remaining
	var/minimum_alive_percentage = 0.2 //0.2 = 20% TODO: Uncomment 0.2

	//When did we last call a vote to restart
	var/last_restart_vote = 0

	var/restart_vote_interval	=	15 MINUTES	//Minimum time between restart votes

/datum/game_mode/marker/post_setup() //Mr Gaeta. Start the clock.
	. = ..()
	//Alright lets spawn the marker
	spawn_marker()

	if(!SSnecromorph.marker)
		message_admins("There are no markers on this map!")
		return
	evacuation_controller.add_can_call_predicate(new /datum/evacuation_predicate/travel_points)
	command_announcement.Announce("Delivery of alien artifact successful at [get_area(SSnecromorph.marker)].","Ishimura Deliveries Subsystem") //Placeholder
	addtimer(CALLBACK(src, .proc/activate_marker), rand_between(0.85, 1.15)*marker_setup_time) //We have to spawn the marker quite late, so guess we'd best wait :)


/datum/game_mode/marker/proc/spawn_marker()
	var/turf/T = get_marker_location()
	if (T)
		return new /obj/machinery/marker(T)


/datum/game_mode/marker/proc/get_marker_location()
	return null

/datum/game_mode/marker/proc/pick_marker_player()
	if (SSnecromorph.marker.player)
		return	//There's already a marker player

	var/mob/M
	if(!SSnecromorph.signals.len) //No signals? We can't pick one
		message_admins("No signals, unable to pick a marker player! The marker is now active and awaiting anyone who wishes to control it")
		return FALSE

	var/list/marker_candidates = SSnecromorph.signals.Copy()
	while (marker_candidates.len)
		M = pick_n_take(marker_candidates)
		if (!M.client)
			continue


		//Alright pick them!
		to_chat(M, "<span class='warning'>You have been selected to become the marker!</span>")
		SSnecromorph.marker.become_master_signal(M)
		return M

	message_admins("No signals, unable to pick a marker player! The marker is now active and awaiting anyone who wishes to control it")
	return FALSE

/datum/game_mode/marker/proc/activate_marker()
	last_pointgain_time = world.timeofday
		//This handles preventing evac until we have enough points
	charge_evac_points()
	SSnecromorph.marker.make_active() //Allow controlling
	pick_marker_player()
	marker_active = TRUE
	return TRUE

/client/proc/activate_marker()
	set name = "Activate Marker"
	set category = "Admin"
	set desc = "Forces the marker to immediately activate"

	var/confirm = tgui_alert(src, "You will be activating the marker. Are you super duper sure?", "Make us Whole?", list("Send in the Necromorphs!", "On second thought, maybe not..."))
	if(confirm != "Send in the Necromorphs!")
		return

	var/datum/game_mode/marker/GM = SSticker.mode
	if (!istype(GM))
		return

	if (GM.marker_active)
		to_chat(src, "The marker is already active")
		return
	GM.activate_marker()

/**

There is probably a better way to do this, but I've added some more stringent checks to the gamemode win conditions to prevent things like:
Admin characters being counted as crew, and on their deletion, ending the game
Non-critical characters like any ghost-roles you may wish to add, or even antags, from counting as "dead crew" (Antags fallback to their own "are the antags dead checks"

*/

//Marker gamemode can end when necros kill most of the crew
/datum/game_mode/marker/check_finished()
	to_chat(world, "Checking finished")
	if(marker_active)	//Marker must be active
		var/list/crewlist = get_crew_totals()
		var/valid_historic_crew = crewlist["total"] - crewlist[STATUS_REMOVED]	//We don't count those who left the round
		to_chat(world, "Marker active, historic crew [valid_historic_crew]")
		//Lets see how many are left alive
		var/remaining = valid_historic_crew - (crewlist[STATUS_DEAD] + crewlist[STATUS_ESCAPED])
		if (remaining <= 0)
			//No humans left alive? Immediate end
			to_chat(world, SPAN_EXECUTION("All the humans are dead, Necromorphs win!"))
			return TRUE
		

		var/remaining_percent = remaining / valid_historic_crew
		to_chat(world, "Remaining crew/percent [remaining]/[remaining_percent], min alive [minimum_alive_percentage]")

		if (remaining_percent <= minimum_alive_percentage)	//We need to have had a minimum total crewcount
			/*
				There are not enough people left to definitely continue the round, so now we put it to a vote
			*/
			handle_restart_vote()
			//But we aren't ending immediately

	return ..() //Fallback to the default game end conditions like all antags dying, shuttles being docked, etc.


/datum/game_mode/marker/proc/handle_restart_vote()
	to_chat(world, " restart vote 1 [world.time - last_restart_vote]	/	[restart_vote_interval]")

	if (world.time - last_restart_vote >= restart_vote_interval)
		to_chat(world, " restart vote 2 doing vote")

		SSvote.initiate_vote(/datum/vote/extinction, automatic = TRUE)
		last_restart_vote = world.time