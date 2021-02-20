//This file deals with distress beacons. It randomizes between a number of different types when activated.
//There's also an admin commmand which lets you set one to your liking.
#define DISTRESS_COOLDOWN_FAIL	5 MINUTES
#define DISTRESS_COOLDOWN_SUCCESS	1 HOUR

//The distress call parent.
/datum/emergency_call
	var/name = ""
	var/pref_name = ""
	var/members_max = 10
	var/members_min = 1
	var/landmark_tag
	var/dispatch_message = "An encrypted signal has been received from a nearby vessel. Stand by." //Message displayed to marines once the signal is finalized.
	var/objectives = "" //Objectives to display to the members.
	var/weight = 1 //So we can give different ERTs a different weight.
	var/list/members = list() //Currently-joined members.
	var/list/candidates = list() //Potential candidates for enlisting.
	var/candidate_timer
	var/cooldown_timer
	var/spawn_type = /mob/living/carbon/human
	var/datum/announcement/priority/command/special/pr_announce = new(0)
	var/datum/antagonist/antag
	var/antag_id = MODE_ERT

/proc/initialize_emergency_calls()
	if(length(GLOB.emergency_call_datums)) //It's already been set up.
		return

	for(var/x in typesof(/datum/emergency_call))
		var/datum/emergency_call/D = new x()
		if(!D?.name)
			continue //The default parent, don't add it

		D.antag = GLOB.all_antag_types_[D.antag_id]
		GLOB.emergency_call_datums[D] = D.weight


//Randomizes and chooses a call datum.
/datum/game_mode/proc/get_random_call()
	return pickweight(GLOB.emergency_call_datums)


/datum/game_mode/proc/activate_distress(datum/emergency_call/chosen_call)
	GLOB.picked_call = chosen_call || get_random_call()

	//if(ticker?.mode?.GLOB.waiting_for_candidates) //It's already been activated
		//return FALSE
	GLOB.on_distress_cooldown = TRUE

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

	if(announce)
		pr_announce.Announce("A distress beacon has been launched from the USG Ishimura.", "Priority Alert")

	do_activate(announce)


/datum/emergency_call/proc/do_activate(announce = TRUE)

	//This handles everything related to creating the team
	antag.attempt_random_spawn()



	//Right, lets examine the data from the last spawn
	var/list/spawns = antag.last_spawn_data["spawns"]
	var/target = antag.last_spawn_data["spawn_target"]

	if (!antag.last_spawn_data["success"])
		message_admins("Aborting distress beacon [name], Failed to spawn a response team")
		cooldown_timer = addtimer(CALLBACK(src, .proc/reset), DISTRESS_COOLDOWN_FAIL, TIMER_STOPPABLE)
		addtimer(CALLBACK(src, .proc/announce_fail), DISTRESS_COOLDOWN_FAIL, TIMER_STOPPABLE)
		//It will take some time for the crew to be told whether or not the beacon was recieved
		return

	else if  (LAZYLEN(spawns) < target)
		message_admins("Spawning incomplete response team [name]. We have [LAZYLEN(spawns)]/[target] members, some specialists may not be present")

	else
		message_admins("Successfully spawned response team [name]. We have [LAZYLEN(spawns)]/[target] members, some specialists may not be present")

	cooldown_timer = addtimer(CALLBACK(src, .proc/reset), DISTRESS_COOLDOWN_SUCCESS, TIMER_STOPPABLE)
	addtimer(CALLBACK(src, .proc/announce_success), DISTRESS_COOLDOWN_FAIL, TIMER_STOPPABLE)


/datum/emergency_call/proc/announce_success()
	pr_announce.Announce("USG Ishimura distress beacon has been noticed. A vessel has been detected on long range sensors", "Priority Alert")

/datum/emergency_call/proc/announce_fail()
	pr_announce.Announce("USG Ishimura distress beacon has drawn no response. Another beacon is ready to launch.", "Priority Alert")


/client/proc/trigger_response_team()
	set name = "Response Team"
	set desc = "Triggers a specific Emergency Response Team instantly"
	set category = "Fun"

	var/datum/emergency_call/C = input(mob,"Pick which response team to trigger","Trigger response team") as null|anything in GLOB.emergency_call_datums
	if (!C)
		return
	C.activate(TRUE)