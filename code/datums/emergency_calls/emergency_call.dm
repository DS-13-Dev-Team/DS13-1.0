//This file deals with distress beacons. It randomizes between a number of different types when activated.
//There's also an admin commmand which lets you set one to your liking.


//The distress call parent.
/datum/emergency_call
	var/name = ""
	var/pref_name = ""
	var/members_max = 10
	var/members_min = 1
	var/landmark_tag
	var/dispatch_message = "An encrypted signal has been received from a nearby vessel. Stand by." //Message displayed to marines once the signal is finalized.
	var/objectives = "" //Objectives to display to the members.
	var/weight = 0 //So we can give different ERTs a different weight.
	var/list/members = list() //Currently-joined members.
	var/list/candidates = list() //Potential candidates for enlisting.
	var/mob/living/carbon/leader = null
	var/candidate_timer
	var/cooldown_timer
	var/spawn_type = /mob/living/carbon/human
	var/max_specs = 1
	var/specs = 0
	var/max_medics = 1
	var/medics = 0
	var/max_enginers = 1
	var/enginers = 0
	var/datum/announcement/priority/command/special/pr_announce = new(0)

/datum/game_mode/proc/initialize_emergency_calls()
	if(length(GLOB.all_calls)) //It's already been set up.
		return

	var/list/total_calls = typesof(/datum/emergency_call)
	if(!length(total_calls))
		CRASH("No distress Datums found.")

	for(var/x in total_calls)
		var/datum/emergency_call/D = new x()
		if(!D?.name)
			continue //The default parent, don't add it
		GLOB.all_calls += D


//Randomizes and chooses a call datum.
/datum/game_mode/proc/get_random_call()
	var/datum/emergency_call/chosen_call
	var/list/valid_calls = list()

	for(var/datum/emergency_call/E in GLOB.all_calls) //Loop through all potential candidates
		if(E.weight < 1) //Those that are meant to be admin-only
			continue

		valid_calls.Add(E)

		if(prob(E.weight))
			chosen_call = E
			break

	if(!istype(chosen_call))
		chosen_call = pick(valid_calls)

	return chosen_call

/datum/emergency_call/proc/show_join_message()
	if(!members_max || !ticker?.mode) //Not a joinable distress call.
		return

	for(var/i in GLOB.player_list)
		if(!isghost(i)) continue
		var/client/M = i
		to_chat(M, "<br><font size='3'><span class='attack'>An emergency beacon has been activated. Use the <B>IC > <a href='byond://?src=[REF(M)];join_ert=1'>Join Response Team</a></b> verb to join!</span></font><br>")
		to_chat(M, "<span class='attack'>You cannot join if you have Ghosted before this message.</span><br>")


/datum/game_mode/proc/activate_distress(datum/emergency_call/chosen_call)
	GLOB.picked_call = chosen_call || get_random_call()

	if(ticker?.mode?.GLOB.waiting_for_candidates) //It's already been activated
		return FALSE

	GLOB.picked_call.members_max = rand(5, 15)

	GLOB.picked_call.activate()

/datum/emergency_call/proc/reset()
	if(candidate_timer)
		deltimer(candidate_timer)
		candidate_timer = null
	if(cooldown_timer)
		deltimer(cooldown_timer)
		cooldown_timer = null
	members.Cut()
	candidates.Cut()
	GLOB.waiting_for_candidates = FALSE
	GLOB.on_distress_cooldown = FALSE
	message_admins("Distress beacon: [name] has been reset.")

/datum/emergency_call/proc/activate(announce = TRUE)
	if(!ticker?.mode) //Something horribly wrong with the gamemode ticker
		message_admins("Distress beacon: [name] attempted to activate but no gamemode exists")
		return FALSE

	if(GLOB.on_distress_cooldown) //It's already been called.
		message_admins("Distress beacon: [name] attempted to activate but distress is on cooldown")
		return FALSE

	if(members_max > 0)
		GLOB.waiting_for_candidates = TRUE

	show_join_message() //Show our potential candidates the message to let them join.
	message_admins("Distress beacon: '[name]' activated. Looking for candidates.")

	if(announce)
		pr_announce.Announce("A distress beacon has been launched from the USG Ishimura.", "Priority Alert")

	GLOB.on_distress_cooldown = TRUE

	candidate_timer = addtimer(CALLBACK(src, .proc/do_activate, announce), 5 MINUTES, TIMER_STOPPABLE)

/datum/emergency_call/proc/do_activate(announce = TRUE)
	candidate_timer = null
	GLOB.waiting_for_candidates = FALSE

	var/list/valid_candidates = list()

	for(var/i in candidates)
		var/datum/mind/M = i
		if(!istype(M)) // invalid
			continue
		if(M.current) //If they still have a body
			if(M.current.stat != DEAD) // and not dead or admin ghosting,
				to_chat(M.current, "<span class='warning'>You didn't get selected to join the distress team because you aren't dead.</span>")
				continue
			if(initial(GLOB.picked_call.pref_name) in M.current?.client?.prefs.never_be_special_role)
				continue
		valid_candidates += M

	message_admins("Distress beacon: [name] got [length(candidates)] candidates, [length(valid_candidates)] of them were valid.")

	if(members_min && length(valid_candidates) < members_min)
		message_admins("Aborting distress beacon [name], not enough candidates. Found: [length(valid_candidates)]. Minimum required: [members_min].")
		GLOB.waiting_for_candidates = FALSE
		members.Cut() //Empty the members list.
		candidates.Cut()

		if(announce)
			pr_announce.Announce("The distress signal has not received a response, the launch tubes are now recalibrating.", "Distress Beacon")

		GLOB.picked_call = null
		GLOB.on_distress_cooldown = TRUE

		cooldown_timer = addtimer(CALLBACK(src, .proc/reset), 5 MINUTES, TIMER_STOPPABLE)
		return

	var/list/datum/mind/picked_candidates = list()
	if(length(valid_candidates) > members_max)
		for(var/i in 1 to members_max)
			if(!length(valid_candidates)) //We ran out of candidates.
				break
			picked_candidates += pick_n_take(valid_candidates) //Get a random candidate, then remove it from the candidates list.

		for(var/datum/mind/M in valid_candidates)
			if(M.current)
				to_chat(M.current, "<span class='warning'>You didn't get selected to join the distress team. Better luck next time!</span>")
		message_admins("Distress beacon: [length(valid_candidates)] valid candidates were not selected.")
	else
		picked_candidates = valid_candidates // save some time
		message_admins("Distress beacon: All valid candidates were selected.")

	if(announce)
		pr_announce.Announce(dispatch_message, "Distress Beacon")

	message_admins("Distress beacon: [name] finalized, starting spawns.")

	if(members_min > 0)
		if(length(picked_candidates))
			max_specs    = max(round(length(picked_candidates) * 0.125), 1) // 1/8 team have spec
			max_medics   = max(round(length(picked_candidates) * 0.125), 1)
			max_enginers = max(round(length(picked_candidates) * 0.125), 1)
			for(var/i in picked_candidates)
				var/datum/mind/candidate_mind = i
				members += candidate_mind
				create_member(candidate_mind)
		else
			message_admins("ERROR: No picked candidates, aborting.")
			return

	message_admins("Distress beacon: [name] finished spawning.")

	candidates.Cut() //Blank out the candidates list for next time.

	cooldown_timer = addtimer(CALLBACK(src, .proc/reset), 5 MINUTES, TIMER_STOPPABLE)

/datum/emergency_call/proc/add_candidate(mob/M)
	if(!M.client)
		return FALSE  //Not connected

	if(!M.mind) //They don't have a mind
		return FALSE

	if(M.mind in candidates)
		return FALSE  //Already there.

	if(M.stat != DEAD)
		return FALSE  //Alive, could have been drafted into xenos or something else.

	candidates += M.mind
	return TRUE

/datum/emergency_call/proc/get_spawn_point()
	var/list/landmarks = list()
	for(var/obj/effect/landmark/O in landmarks_list)
		if(O.name == landmark_tag)
			landmarks += O
	var/obj/effect/landmark/L = pick(landmarks)
	if(L)
		return get_turf(L)

/datum/emergency_call/proc/create_member(datum/mind/mind_to_assign) //Overriden in each distress call file.
	var/turf/spawn_loc = get_spawn_point()

	if(!istype(spawn_loc))
		CRASH("[type] failed to find a proper spawn_loc")

	return spawn_type ? new spawn_type(spawn_loc) : spawn_loc

/datum/emergency_call/proc/print_backstory(mob/living/carbon/human/M)
	return