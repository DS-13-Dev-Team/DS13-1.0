GLOBAL_DATUM_INIT(shipsystem, /datum/ship_subsystems, new)


/*
	Main gamemode. Marker starts aboard ishimura
*/
/datum/game_mode/marker/containment
	name = "Containment"
	round_description = "The USG Ishimura has brough aboard a strange artifact and is tasked with discovering what its purpose is."
	extended_round_description = "The crew must holdout until help arrives"
	config_tag = "containment"
	votable = TRUE

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
	antag_tags = list(MODE_UNITOLOGIST_SHARD)

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
	antag_tags = list(MODE_UNITOLOGIST)
	latejoin_antag_tags = list(MODE_UNITOLOGIST)
	antag_templates = list(/datum/antagonist/unitologist)
	require_all_templates = FALSE
	votable = FALSE
	var/marker_setup_time = 45 MINUTES
	var/marker_active = FALSE
	antag_scaling_coeff = 8
	var/minimum_alive_percentage = 10 //How much grace do you want to give the necros for killing people? The default value for this is 5. If we have a crew of 10 people, then you have to kill 9 of them to win as necro.

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

	var/datum/game_mode/marker/GM = ticker.mode
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

//Method to be called when a human player dies for any reason, this will check the amount of players that should be alive, and sees if they're dead or not. We're doing it via an almost signal (bay lacks signals) to avoid processing overhead.
/datum/game_mode/marker/check_finished()
	if(!marker_active)
		return ..()  //Change this to FALSE if you want to override all other win conditions until the marker activates.
	if(dead_players.len >= round(player_count-(player_count*((minimum_alive_percentage > 0) ? minimum_alive_percentage/100 : 0)))) //Allows the necromorphs a bit of grace so they don't have to hunt down _everyone_, as that could lead to cheese. The ? statement is there to handle a config value of 0% grace, if you decide to go for that.
		return TRUE //Necros win!
	return ..() //Fallback to the default game end conditions like all antags dying, shuttles being docked, etc.