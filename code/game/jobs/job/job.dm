/datum/job

	//The name of the job
	var/title = "NOPE"
	//Job access. The use of minimal_access or access is determined by a config setting: jobs_have_minimal_access
	var/list/minimal_access = list()      // Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()              // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/list/software_on_spawn = list()   // Defines the software files that spawn on tablets and labtops
	var/department_flag = 0
	var/abbreviation = ""
	var/total_positions = 0               // How many players can be this job
	var/spawn_positions = 0               // How many players can spawn in as this job
	var/current_positions = 0             // How many players have this job

	var/supervisors = null                // Supervisors, who this person answers to directly
	var/selection_color = "#ffffff"       // Selection screen color
	var/list/alt_titles                   // List of alternate titles, if any and any potential alt. outfits as assoc values.
	var/req_admin_notify                  // If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/minimal_player_age = 0            // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/department = null                 // Does this position have a department tag?
	var/head_position = 0                 // Is this position Command?
	var/minimum_character_age = 0
	var/ideal_character_age = 30
	var/create_record = 1                 // Do we announce/make records for people who spawn on this job?

	var/account_allowed = 1               // Does this job type come with a station account?
	var/economic_modifier = 2             // With how much does this job modify the initial account amount?
	var/starting_credits = 0		 	  // Starting amount decided on by job. Overrides economic modifier.
	var/bonus_shares =	1				  // When deciding how departmental bonuses are divided, this job gets this many shares of the total
	var/salary	= SALARY_SKILLED	//How much money this job earns, every 30-minute pay period

	var/outfit_type                       // The outfit the employee will be dressed in, if any

	var/loadout_allowed = TRUE            // Whether or not loadout equipment is allowed and to be created when joining.

	var/announced = TRUE                  //If their arrival is announced on radio
	var/latejoin_at_spawnpoints           //If this job should use roundstart spawnpoints for latejoin (offstation jobs etc)

	var/hud_icon						  //icon used for Sec HUD overlay

	var/min_skill = list()				  //Minimum skills allowed for the job. List should contain skill (as in /decl/hierarchy/skill path), with values which are numbers.
	var/max_skill = list()				  //Maximum skills allowed for the job.
	var/skill_points = 16				  //The number of unassigned skill points the job comes with (on top of the minimum skills).
	var/no_skill_buffs = FALSE			  //Whether skills can be buffed by age/species modifiers.

	var/necro_conversion_compatibility = 0	//When converted to a necromorph, crewmen of this job have this amount of bonus compatibility. This influences the rarity/power of necros they convert into
	var/list/necro_conversion_options = list()	//When converted to a necromorph, crewmen of this job have these extra possibilities added to the pool

	var/exp_type

/datum/job/New()
	..()
	if(department_flag & COM)
		GLOB.command_positions |= title
	if(department_flag & SPT)
		GLOB.support_positions |= title
	if(department_flag & SEC)
		GLOB.security_positions |= title
	if(department_flag & ENG)
		GLOB.engineering_positions |= title
	if(department_flag & MED)
		GLOB.medical_positions |= title
	if(department_flag & SCI)
		GLOB.science_positions |= title
	if(department_flag & MIN)
		GLOB.mining_positions |= title
	if(department_flag & SUP)
		GLOB.supply_positions |= title
	if(department_flag & SRV)
		GLOB.service_positions |= title
	if(department_flag & CIV)
		GLOB.civilian_positions |= title
	if(department_flag & MSC)
		GLOB.nonhuman_positions |= title

/datum/job/dd_SortValue()
	return title

/datum/job/New()
	..()
	if(!hud_icon)
		hud_icon = "hud[ckey(title)]"

/datum/job/proc/equip(var/mob/living/carbon/human/H, var/alt_title, var/no_outfit = FALSE)
	//The no outfit flag skips the baseline behaviour, but this proc can still be overridden to do any special/extra functionality
	if (no_outfit)
		return TRUE

	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title)
	if(!outfit)
		return FALSE
	. = outfit.equip(H, title, alt_title)

/datum/job/proc/get_outfit(var/mob/living/carbon/human/H, var/alt_title)
	if(alt_title && alt_titles)
		. = alt_titles[alt_title]
	. = . || outfit_type
	. = outfit_by_type(.)

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	var/datum/money_account/M = create_account(H.real_name, starting_credits, null)

	if(H.mind)
		var/remembered_info = ""
		remembered_info += "<b>Your account number is:</b> #[M.account_number]<br>"
		remembered_info += "<b>Your account pin is:</b> [M.remote_access_pin]<br>"
		remembered_info += "<b>Your account funds are:</b> T[M.money]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += "<b>Your account was created:</b> [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	to_chat(H, "<span class='notice'><b>Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]</b></span>")

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/qdel()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, var/alt_title, var/additional_skips)
	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title)
	if(!outfit)
		return FALSE
	. = outfit.equip(H, title, alt_title, OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP|OUTFIT_ADJUSTMENT_SKIP_ID_PDA|additional_skips)

/datum/job/proc/get_access()
	if(minimal_access.len && (!config || CONFIG_GET(flag/jobs_have_minimal_access)))
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	return (available_in_days(C) == 0) //Available in 0 days = available right now = player is old enough to play.

/datum/job/proc/available_in_days(client/C)
	if(C && CONFIG_GET(flag/use_age_restriction_for_jobs) && isnull(C.holder) && isnum(C.player_age) && isnum(minimal_player_age))
		return max(0, minimal_player_age - C.player_age)
	return FALSE

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/target)
	if(!istype(target))
		return FALSE
	for(var/obj/item/item in target.contents)
		apply_fingerprints_to_item(target, item)
	return TRUE

/datum/job/proc/apply_fingerprints_to_item(var/mob/living/carbon/human/holder, var/obj/item/item)
	item.add_fingerprint(holder,1)
	if(item.contents.len)
		for(var/obj/item/sub_item in item.contents)
			apply_fingerprints_to_item(holder, sub_item)

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)

/datum/job/proc/has_alt_title(var/mob/H, var/supplied_title, var/desired_title)
	return (supplied_title == desired_title) || (H.mind && H.mind.role_alt_title == desired_title)

/datum/job/proc/is_restricted(var/datum/preferences/prefs, var/feedback)

	if(minimum_character_age && (prefs.age < minimum_character_age))
		to_chat(feedback, "<span class='boldannounce'>Not old enough. Minimum character age is [minimum_character_age].</span>")
		return TRUE

	var/datum/species/S = all_species[prefs.species]
	if(!is_species_allowed(S))
		to_chat(feedback, "<span class='boldannounce'>Restricted species, [S], for [title].</span>")
		return TRUE

	return FALSE

/datum/job/proc/get_join_link(var/client/caller, var/href_string, var/show_invalid_jobs)
	if(is_available(caller))
		if(is_restricted(caller.prefs))
			if(show_invalid_jobs)
				return "<tr><td><a style='text-decoration: line-through' href='[href_string]'>[title]</a></td><td>[current_positions]</td><td>(Active: [get_active_count()])</td></tr>"
		else
			return "<tr><td><a href='[href_string]'>[title]</a></td><td>[current_positions]</td><td>(Active: [get_active_count()])</td></tr>"
	return ""

// Only players with the job assigned and AFK for less than 10 minutes count as active
/datum/job/proc/check_is_active(var/mob/M)
	return (M.mind && M.client && M.mind.assigned_role == title && M.client.inactivity <= 10 * 60 * 10)

/datum/job/proc/get_active_count()
	var/active = 0
	for(var/mob/M in GLOB.player_list)
		if(check_is_active(M))
			active++
	return active

/datum/job/proc/is_species_allowed(var/datum/species/S)
	return GLOB.using_map ? !GLOB.using_map.is_species_job_restricted(S, src) : TRUE

/datum/job/proc/get_description_blurb()
	return ""

/datum/job/proc/dress_mannequin(var/mob/living/carbon/human/dummy/mannequin/mannequin)
	mannequin.delete_inventory(TRUE)
	equip_preview(mannequin, additional_skips = OUTFIT_ADJUSTMENT_SKIP_BACKPACK)

/datum/job/proc/is_available(var/client/caller)
	if(!is_position_available())
		return FALSE
	if(jobban_isbanned(caller, title))
		return FALSE
	if(!player_old_enough(caller))
		return FALSE
	return TRUE

/datum/job/proc/make_position_available()
	total_positions++



