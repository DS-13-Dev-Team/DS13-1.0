/datum/antagonist
	var/base_type = /datum/antagonist

	// Text shown when becoming this antagonist.
	var/list/restricted_jobs = 		list()   // Jobs that cannot be this antagonist at roundstart (depending on config)
	var/list/protected_jobs = 		list()   // As above.
	var/list/blacklisted_jobs =		list()   // Jobs that can NEVER be this antagonist

	// Strings.
	var/welcome_text = "Cry havoc and let slip the dogs of war!"
	var/leader_welcome_text                 // Text shown to the leader, if any.
	var/victory_text                        // World output at roundend for victory.
	var/loss_text                           // As above for loss.
	var/victory_feedback_tag                // Used by the database for end of round loss.
	var/loss_feedback_tag                   // Used by the database for end of round loss.

	// Role data.
	var/id = "traitor"                      // Unique datum identifier. Also preferences option for this role.
	var/role_text = "Traitor"               // special_role text.
	var/role_text_plural = "Traitors"       // As above but plural.
	var/category = ""						// Category is a shared faction or grouping

	// Visual references.
	var/antaghud_indicator = "hudsyndicate" // Used by the ghost antagHUD.
	var/antag_indicator                     // icon_state for icons/mob/mob.dm visual indicator.
	var/faction_indicator                   // See antag_indicator, but for factionalized people only.
	var/faction_invisible                   // Can members of the faction identify other antagonists?

	// Faction data.
	var/faction_role_text                   // Role for sub-antags. Mandatory for faction role.
	var/faction_descriptor                  // Description of the cause. Mandatory for faction role.
	var/faction_verb                        // Verb added when becoming a member of the faction, if any.
	var/faction_welcome                     // Message shown to faction members.
	var/faction = "neutral"					// Actual faction name. Used primarily in stuff like simple_animals seeing if you are a threat or not.

	// Spawn values (autotraitor and game mode)
	var/hard_cap = 3                        // Max number at roundstart
	var/hard_cap_round = 5                  // Max number with adding during round
	var/initial_spawn_req = 1               // Gamemode using this template won't start without this # candidates.
	var/initial_spawn_target = 3            // Gamemode will attempt to spawn this many antags.
	var/finalize_minimum_req = FALSE		// If true, when finalize spawn is called, it will fail and not spawn any antags, if the number of pending is below initial_spawn_req
	var/override_scaling	=	null		// Set this to true or false to override the antag quantity scaling of the gamemode
	var/announced                           // Has an announcement been sent?
	var/spawn_announcement                  // When the datum spawn proc is called, does it announce to the world? (ie. xenos)
	var/spawn_announcement_title            // Report title.
	var/spawn_announcement_sound            // Report sound clip.
	var/spawn_announcement_delay            // Time between initial spawn and round announcement.

	// Misc.
	var/landmark_id                         // Spawn point identifier.
	var/mob_path = /mob/living/carbon/human // Mobtype this antag will use if none is provided.
	var/feedback_tag = "traitor_objective"  // End of round
	var/minimum_player_age = 7            	// Players need to be at least minimum_player_age days old before they are eligable for auto-spawning
	var/suspicion_chance = 50               // Prob of being on the initial Command report
	var/flags = 0                           // Various runtime options.
	var/show_objectives_on_creation = 1     // Whether or not objectives are shown when a player is added to this antag datum
	var/datum/antag_skill_setter/skill_setter = /datum/antag_skill_setter/generic // Used to set up skills.

	// Used for setting appearance.
	var/list/valid_species =       list(SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_SKRELL,SPECIES_HUMAN,SPECIES_VOX)
	var/min_player_age = 14

	// Runtime vars.
	var/datum/mind/leader                   // Current leader, if any.
	var/cur_max = 0                         // Autotraitor current effective maximum.
	var/spawned_nuke                        // Has a bomb been spawned?
	var/nuke_spawn_loc                      // If so, where should it be placed?
	var/list/current_antagonists = list()   // All marked antagonists for this type.
	var/list/pending_antagonists = list()   // Candidates that are awaiting finalized antag status.
	var/list/starting_locations =  list()   // Spawn points.
	var/list/global_objectives =   list()   // Universal objectives if any.
	var/list/candidates =          list()   // Potential candidates.
	var/list/faction_members =     list()   // Semi-antags (in-round revs, borer thralls)
	var/preference_candidacy_toggle = FALSE	// Whether to show an option in preferences to toggle candidacy
	var/preference_candidacy_category = "Antagonists"

	/*
		This list holds various bits of information about the last attempt at spawning that was done with this antag
		This data may be held indefinitely, and often for the whole round. But it is wiped at the start of any new spawning attempt
		It includes
			success:	Did we spawn any antags at all?
			spawn_target:	How many members did we want to spawn in ideal circumstances? Note that spawning may be successful even if this fails
			spawns:	A list of weak references to mind datums who we actually spawned as antags. Use locate(thing) to convert them back to actual datums
				These are weak refs to not interfere with GC

	*/
	var/list/last_spawn_data = list()

	// ID card stuff.
	var/default_access = list()
	var/id_type = /obj/item/weapon/card/id

	var/antag_text = "You are an antagonist! Within the rules, \
		try to act as an opposing force to the crew. Further RP and try to make sure \
		other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to antagonists.</b>"


/datum/antagonist/New()
	reset_last_spawn_data()
	GLOB.all_antag_types_[id] = src
	sortTim(GLOB.all_antag_types_, /proc/cmp_antagonist_category, TRUE)
	GLOB.all_antag_spawnpoints_[landmark_id] = list()
	GLOB.antag_names_to_ids_[role_text] = id
	skill_setter = new skill_setter
	..()

/datum/antagonist/proc/Initialize()
	cur_max = hard_cap
	get_starting_locations()
	if(!role_text_plural)
		role_text_plural = role_text
	if(CONFIG_GET(flag/protect_roles_from_antagonist))
		restricted_jobs |= protected_jobs
	if(antaghud_indicator)
		if(!GLOB.hud_icon_reference)
			GLOB.hud_icon_reference = list()
		if(role_text) GLOB.hud_icon_reference[role_text] = antaghud_indicator
		if(faction_role_text) GLOB.hud_icon_reference[faction_role_text] = antaghud_indicator

/datum/antagonist/proc/tick()
	return 1

// Get the raw list of potential players.
/datum/antagonist/proc/build_candidate_list(var/ghosts_only)
	candidates = list() // Clear.

	// Prune restricted status. Broke it up for readability.
	// Note that this is done before jobs are handed out.
	for(var/datum/mind/player in SSticker.mode.get_players_for_role(id))
		if(ghosts_only)
			if(!isghostmind(player))
				log_debug("[key_name(player)] is not eligible to become a [role_text]: Only ghosts may join as this role!")
				continue
		else
			if(isghostmind(player))
				log_debug("[key_name(player)] is not eligible to become a [role_text]: Ghosts may not join as this role!")
				continue

		if(CONFIG_GET(flag/use_age_restriction_for_antags) && player.current.client.player_age < minimum_player_age)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: Is only [player.current.client.player_age] day\s old, has to be [minimum_player_age] day\s!")
		else if(player.special_role && !ghosts_only)	//Ghosts are no longer what their body was, it shouldn't prevent them taking a new role
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They already have a special role ([player.special_role])!")
		else if (player in pending_antagonists)
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They have already been selected for this role!")
		else if(!can_become_antag(player))
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are blacklisted for this role!")
		else if(player_is_antag(player) && !ghosts_only)	//Ghosts are no longer what their body was, it shouldn't prevent them taking a new role
			log_debug("[key_name(player)] is not eligible to become a [role_text]: They are already an antagonist!")
		else
			candidates[player] = player.get_antag_weight(category, id)
	return candidates

// Builds a list of potential antags without actually setting them. Used to test mode viability.
/datum/antagonist/proc/get_potential_candidates(var/datum/game_mode/mode, var/ghosts_only)
	var/candidates = list()

	// Keeping broken up for readability
	for(var/datum/mind/player in mode.get_players_for_role(id))
		if(ghosts_only)
			if(!isghostmind(player))
				log_debug("[key_name(player)] is not eligible to become a [role_text]: Only ghosts may join as this role!")
				continue
		else
			if(isghostmind(player))
				log_debug("[key_name(player)] is not eligible to become a [role_text]: Ghosts may not join as this role!")
				continue

		if(CONFIG_GET(flag/use_age_restriction_for_antags) && player.current.client.player_age < minimum_player_age)
		else if(player.special_role && !ghosts_only)
		else if (player in pending_antagonists)
		else if(!can_become_antag(player))
		else if(player_is_antag(player) && !ghosts_only)
		else
			candidates[player] = player.get_antag_weight(category, id)

	return candidates

/datum/antagonist/proc/attempt_random_spawn()

	update_current_antag_max()
	build_candidate_list(flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))
	attempt_spawn()
	finalize_spawn()

/datum/antagonist/proc/attempt_auto_spawn()
	reset_last_spawn_data()
	if(!can_late_spawn())
		return 0

	update_current_antag_max()
	var/active_antags = get_active_antag_count()
	log_debug("[uppertext(id)]: Found [active_antags]/[cur_max] active [role_text_plural].")

	if(active_antags >= cur_max)
		log_debug("Could not auto-spawn a [role_text], active antag limit reached.")
		return 0

	build_candidate_list(flags & (ANTAG_OVERRIDE_MOB|ANTAG_OVERRIDE_JOB))
	if(!candidates.len)
		log_debug("Could not auto-spawn a [role_text], no candidates found.")
		return 0

	attempt_spawn(1) //auto-spawn antags one at a time
	if(!pending_antagonists.len)
		log_debug("Could not auto-spawn a [role_text], none of the available candidates could be selected.")
		return 0

	var/datum/mind/player = pending_antagonists[1]
	if(!add_antagonist(player,0,0,0,1,1))
		log_debug("Could not auto-spawn a [role_text], failed to add antagonist.")
		return 0

	reset_antag_selection()

	return 1

/*
	Called both at roundstart and for latespawning, this is the core entrypoint
	Selects players that will be spawned in the antagonist role from the potential candidates
	Selected players are added to the pending_antagonists lists.
	Attempting to spawn an antag role with ANTAG_OVERRIDE_JOB should be done before jobs are assigned,
	so that they do not occupy regular job slots. All other antag roles should be spawned after jobs are
	assigned, so that job restrictions can be respected.
*/
/datum/antagonist/proc/attempt_spawn(var/spawn_target = null)
	if(spawn_target == null)
		spawn_target = initial_spawn_target

	//Record how many we wanted to spawn
	last_spawn_data["spawn_target"] = spawn_target

	// Update our boundaries.
	if(!candidates.len)
		return 0

	//Grab candidates randomly until we have enough.
	while(candidates.len && pending_antagonists.len < spawn_target)
		var/datum/mind/player = pickweight(candidates)
		candidates -= player
		draft_antagonist(player)

	return 1


/*
	Attempts to turn a specified player into an antagonist
*/
/datum/antagonist/proc/draft_antagonist(var/datum/mind/player)
	//Check if the player can join in this antag role, or if the player has already been given an antag role.
	if(!can_become_antag(player))
		log_debug("[player.key] was selected for [role_text] by lottery, but is not allowed to be that role.")
		return 0
	if(player.special_role && !isghostmind(player))
		log_debug("[player.key] was selected for [role_text] by lottery, but they already have a special role.")
		return 0
	if(!(flags & ANTAG_OVERRIDE_JOB) && (!player.current || istype(player.current, /mob/dead/new_player)))
		log_debug("[player.key] was selected for [role_text] by lottery, but they have not joined the game.")
		return 0
	if(SSticker.current_state >= GAME_STATE_PLAYING && (isghostmind(player) || isnewplayer(player.current)) && !(player.ghost_role_valid()))
		log_debug("[player.key] was selected for [role_text] by lottery, but they are a ghost not in the antag pool.")
		return 0

	pending_antagonists |= player
	log_debug("[player.key] has been selected for [role_text] by lottery.")

	//Ensure that antags with ANTAG_OVERRIDE_JOB do not occupy job slots.
	if(flags & ANTAG_OVERRIDE_JOB)
		player.assigned_role = role_text
		player.role_alt_title = null

	//Ensure that a player cannot be drafted for multiple antag roles, taking up slots for antag roles that they will not fill.
	player.set_special_role(role_text)

	return 1

//Spawns all pending_antagonists. This is done separately from attempt_spawn in case the game mode setup fails.
/datum/antagonist/proc/finalize_spawn()
	if(!pending_antagonists)
		return


	if (finalize_minimum_req && pending_antagonists.len < initial_spawn_req)
		return

	for(var/datum/mind/player in pending_antagonists)
		add_antagonist(player,0,0,1)


	reset_antag_selection()

//Procced after /ALL/ antagonists have finished setting up and spawning.
/datum/antagonist/proc/post_spawn()
	return

//Resets the antag selection, clearing all pending_antagonists and their special_role
//(and assigned_role if ANTAG_OVERRIDE_JOB is set) as well as clearing the candidate list.
//Existing antagonists are left untouched.
/datum/antagonist/proc/reset_antag_selection()
	for(var/datum/mind/player in pending_antagonists)
		if(flags & ANTAG_OVERRIDE_JOB)
			player.assigned_role = null
		player.set_special_role(null)
	pending_antagonists.Cut()
	candidates.Cut()



/datum/antagonist/proc/reset_last_spawn_data()
	last_spawn_data = list()
	last_spawn_data["spawns"] = list()
	last_spawn_data["success"] = FALSE