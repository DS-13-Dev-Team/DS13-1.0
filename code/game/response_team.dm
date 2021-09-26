/client/proc/response_team()
	set name = "Dispatch Emergency Response Team"
	set category = "Admin"
	set desc = "Send an emergency response team"

	if(!holder)
		to_chat(usr, "<span class='danger'>Only administrators may use this command.</span>")
		return
	if(!SSticker)
		to_chat(usr, "<span class='danger'>The game hasn't started yet!</span>")
		return
	if(SSticker.current_state == 1)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return
	if(alert("Do you want to dispatch an Emergency Response Team?",,"Yes","No") != "Yes")
		return

	if(GLOB.waiting_for_candidates)
		to_chat(src, "<span class='warning'>Please wait for the current beacon to be finalized.</span>")
		return

	if(GLOB.picked_call)
		GLOB.picked_call.reset()
		GLOB.picked_call = null

	var/list/list_of_calls = list()
	for(var/datum/emergency_call/L in GLOB.emergency_call_datums)
		if(L.name)
			list_of_calls += L.name

	list_of_calls += "Randomize"

	var/choice = input("Which distress do you want to call?") as null|anything in list_of_calls
	if(!choice)
		return

	if(choice == "Randomize")
		GLOB.picked_call	= SSticker.mode.get_random_call()
	else
		for(var/datum/emergency_call/C in GLOB.emergency_call_datums)
			if(C.name == choice)
				GLOB.picked_call = C
				break

	if(!istype(GLOB.picked_call))
		return

	/*
	var/max = input("What should the maximum team size instead of number of members be?", "Max members", GLOB.picked_call.members_max) as null|num
	if(!max || max < 1)
		return

	GLOB.picked_call.members_max = max

	var/min = input("What should the minimum team size instead of number of members be?", "Min members", GLOB.picked_call.members_min) as null|num
	if(!min || min < 1)
		min = 0

	GLOB.picked_call.members_min = min
	*/
	var/is_announcing = TRUE
	if(alert(usr, "Would you like to announce the distress beacon to the server population? This will reveal the distress beacon to all players.", "Announce distress beacon?", "Yes", "No") != "Yes")
		is_announcing = FALSE

	GLOB.picked_call.activate(is_announcing)

	log_admin("[key_name(usr)] called a [choice == "Randomize" ? "randomized ":""]distress beacon: [GLOB.picked_call.name]..")
	message_admins("[key_name(usr)] called a [choice == "Randomize" ? "randomized ":""]distress beacon: [GLOB.picked_call.name] ")


