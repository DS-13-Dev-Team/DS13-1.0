/client/proc/response_team()
	set name = "Dispatch Emergency Response Team"
	set category = "Special Verbs"
	set desc = "Send an emergency response team"

	if(!holder)
		to_chat(usr, "<span class='danger'>Only administrators may use this command.</span>")
		return
	if(!ticker)
		to_chat(usr, "<span class='danger'>The game hasn't started yet!</span>")
		return
	if(ticker.current_state == 1)
		to_chat(usr, "<span class='danger'>The round hasn't started yet!</span>")
		return
	if(alert("Do you want to dispatch an Emergency Response Team?",,"Yes","No") != "Yes")
		return

	if(ticker.mode.waiting_for_candidates)
		to_chat(src, "<span class='warning'>Please wait for the current beacon to be finalized.</span>")
		return

	if(ticker.mode.picked_call)
		ticker.mode.picked_call.reset()
		ticker.mode.picked_call = null

	var/list/list_of_calls = list()
	for(var/datum/emergency_call/L in ticker.mode.all_calls)
		if(L.name)
			list_of_calls += L.name

	list_of_calls += "Randomize"

	var/choice = input("Which distress do you want to call?") as null|anything in list_of_calls
	if(!choice)
		return

	if(choice == "Randomize")
		ticker.mode.picked_call	= ticker.mode.get_random_call()
	else
		for(var/datum/emergency_call/C in ticker.mode.all_calls)
			if(C.name == choice)
				ticker.mode.picked_call = C
				break

	if(!istype(ticker.mode.picked_call))
		return

	var/max = input("What should the maximum team size instead of number off members be?", "Max members", ticker.mode.picked_call.members_max) as null|num
	if(!max || max < 1)
		return

	ticker.mode.picked_call.members_max = max

	var/min = input("What should the minimum team size instead of number of members be?", "Min members", ticker.mode.picked_call.members_min) as null|num
	if(!min || min < 1)
		min = 0

	ticker.mode.picked_call.members_min = min

	var/is_announcing = TRUE
	if(alert(usr, "Would you like to announce the distress beacon to the server population? This will reveal the distress beacon to all players.", "Announce distress beacon?", "Yes", "No") != "Yes")
		is_announcing = FALSE

	ticker.mode.picked_call.activate(is_announcing)

	log_admin("[key_name(usr)] called a [choice == "Randomize" ? "randomized ":""]distress beacon: [ticker.mode.picked_call.name]. Min: [min], Max: [max].")
	message_admins("[key_name(usr)] called a [choice == "Randomize" ? "randomized ":""]distress beacon: [ticker.mode.picked_call.name] Min: [min], Max: [max].")


/client/verb/JoinResponseTeam()

	set name = "Join Response Team"
	set category = "IC"

	if(!MayRespawn(1))
		to_chat(usr, "<span class='warning'>You cannot join the response team at this time.</span>")
		return
	if(!isghost(usr))
		to_chat(usr, "<span class='warning'>You cannot join the response team because you are not ghost.</span>")

	var/datum/emergency_call/distress = ticker?.mode?.picked_call //Just to simplify things a bit

	if(!istype(distress) || !ticker.mode.waiting_for_candidates || distress.members_max < 1)
		to_chat(usr, "<span class='warning'>No distress beacons that need candidates are active. You will be notified if that changes.</span>")
		return

	if(usr.mind in distress.candidates)
		to_chat(usr, "<span class='warning'>You are already a candidate for this emergency response team.</span>")
		return

	if(distress.add_candidate(usr))
		to_chat(usr, "<span class='boldnotice'>You are now a candidate in the emergency response team! If there are enough candidates, you may be picked to be part of the team.</span>")
	else
		to_chat(usr, "<span class='warning'>Something went wrong while adding you into the candidate list!</span>")