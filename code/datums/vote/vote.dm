/datum/vote
	var/name = "default vote"
	var/template_mode	=	"custom"//Used for TGUI Template, this tells it which of several presets to use in laying out the window
	var/initiator
	var/question = "Description"
	var/list/choices = list()

	var/list/display_choices = list() // What's actually shown to the users.
	var/list/additional_text = list() // Stuff for UI formatting.
	var/additional_header

	var/start_time
	var/time_remaining
	var/status = VOTE_STATUS_PREVOTE

	var/list/result				// The results; format is list(choice = votes).
	var/result_length = 3		 // How many choices to show in the result. Must be >= 1

	var/list/votes = list()		// Format is list(ckey = list(a, b, ...)); a, b, ... are ordered by order of preference and are numbers, referring to the index in choices

	var/win_x = 450
	var/win_y = 740				// Vote window size.

	var/manual_allowed = 1		 // Whether humans can start it.

//Expected to be run immediately after creation; a false return means that the vote could not be run and the datum will be deleted.
/datum/vote/proc/setup(mob/creator, automatic)
	if(!can_run(creator, automatic))
		qdel(src)
		return FALSE
	setup_vote(creator, automatic)
	if(!can_run(creator, automatic))
		qdel(src)
		return FALSE
	start_vote()
	return TRUE

//Checks any conditions required for the vote to run. The argument is optional, in case a player started the vote.
/datum/vote/proc/can_run(mob/creator, automatic)
	return TRUE

//Performs functions relating to setting up the question and choices, if relevant.
/datum/vote/proc/setup_vote(mob/creator, automatic)
	initiator = (!automatic && istype(creator)) ? creator.ckey : "the server"
	for(var/choice in choices)
		display_choices[choice] = choice // Default behavior is that the choice name is displayed directly.

/datum/vote/proc/start_vote()
	start_time = world.time
	status = VOTE_STATUS_ACTIVE
	time_remaining = round(VOTE_PERIOD/10)

	var/text = get_start_text()

	log_vote(text)
	to_world("<font color='purple'><b>[text]</b>\nType <b>vote</b> or click <a href='?src=\ref[SSvote];vote_panel=1'>here</a> to place your votes.\nYou have [VOTE_PERIOD/10] seconds to vote.</font>")
	sound_to(world, sound('sound/ambience/alarm4.ogg', repeat = 0, wait = 0, volume = 50, channel = GLOB.vote_sound_channel))

/datum/vote/proc/get_start_text()
	return "[capitalize(name)] vote started by [initiator]."

//Modifies the vote totals based on non-voting mobs.
/datum/vote/proc/handle_default_votes()
	if(!config.vote_no_default)
		return length(GLOB.clients) - length(votes) //Number of non-voters (might not be active, though; should be revisited if the config option is used. This is legacy code.)

/datum/vote/proc/tally_result()
	handle_default_votes()

	result = list()
	var/list/remaining_choices = choices.Copy()
	var/list/remaining_votes = votes.Copy()

	var/list/runners_up = list()
	while(length(remaining_choices))
		sleep(1)
		remaining_choices = shuffle(remaining_choices)
		sortTim(remaining_choices, /proc/cmp_numeric_dsc, TRUE)
		// we ran out of options or votes, you get what we have
		if(!length(remaining_votes))
			runners_up += remaining_choices.Copy()
			break
		else
			//First of all, do we have more than two options remaining?
			if (length(remaining_choices) < 2)
				//If not, we'll just take the first one as the winner
				var/winner = remaining_choices[1]
				result[winner] = remaining_choices[remaining_choices[1]]

				if (length(remaining_choices) == 2)
					//And the second as a runner up if theres any
					var/runner =  remaining_choices[2]
					runners_up[runner] = remaining_choices[runner]

				//And we're outta here
				break

			//Okay we have at least three options, lets take the choice at the end away
			var/runner =  remaining_choices[length(remaining_choices)]
			runners_up[runner] = remaining_choices[runner]
			remove_candidate(remaining_choices, remaining_votes, runner)
	
	//End of the loop, lets sort those runners and append them
	sortTim(runners_up, /proc/cmp_numeric_dsc, TRUE)

	result += runners_up


	//And lets trim the result list
	result.Cut(min(result_length+1, length(result)))




// Remove candidate from choice_list and any votes for it from vote_list, transfering first choices to second
/datum/vote/proc/remove_candidate(list/choice_list, list/vote_list, candidate, var/transfer = TRUE)
	var/candidate_index = list_find(choices, candidate) // use choices instead of choice_list because we need the original indexing
	choice_list -= candidate
	if (transfer)
		for(var/ckey in vote_list)
			if(length(votes[ckey]) && vote_list[ckey][1] == candidate_index && length(vote_list[ckey]) > 1)
				var/new_first_choice = choices[vote_list[ckey][2]]
				choice_list[new_first_choice] += 1
			vote_list[ckey] -= candidate_index

			if(!length(vote_list[ckey]))
				vote_list -= ckey

// Truthy return indicates that either no one votes or there was another error.
/datum/vote/proc/report_result()
	if(!length(result))
		return 1

	var/text = get_result_announcement()
	log_vote(text)
	to_world("<font color='purple'>[text]</font>")

	if(!(result[result[1]] > 0))
		return 1

/datum/vote/proc/get_result_announcement()
	var/list/text = list()
	if(!(result[result[1]] > 0)) // No one votes.
		text += "<b>Vote Result: Inconclusive - No Votes!</b>"
	else
		text += "<b>Vote Result: [display_choices[result[1]]]</b>"
		if(result_length > 1)
			text += "\nRunner ups: "
			var/list/runner_ups = list()
			for(var/runner_up in result.Copy(2))
				runner_ups += display_choices[runner_up]
			text += english_list(runner_ups)

	return JOINTEXT(text)


/*
	This takes a mob and a numerical index of which option they're voting for
*/
/datum/vote/proc/submit_vote(var/mob/voter, var/vote)
	if(mob_not_participating(voter))
		return

	var/ckey = voter.ckey
	if(!votes[ckey])
		votes[ckey] = list()

	var/choice = choices[vote]
	if(vote in votes[ckey])
		if(votes[ckey][1] == vote)
			choices[choice] -= 1
			if(length(votes[ckey]) > 1) // If the player has rescinded their first choice, their second choice is promoted to their first choice, if it exists.
				var/new_choice = choices[votes[ckey][2]]
				choices[new_choice] += 1  // Update the running tally to reflect that
		votes[ckey] -= vote

		if(!length(votes[ckey]))
			votes -= ckey
	else
		votes[ckey] += vote
		if(votes[ckey][1] == vote)
			choices[choice] += 1




// Checks if the mob is participating in the round sufficiently to vote, as per config settings.
/datum/vote/proc/mob_not_participating(mob/voter)
	if(config.vote_no_dead && voter.stat == DEAD && !voter.client.holder)
		return 1

//null = no toggle set. This is for UI purposes; a text return will give a link (toggle; currently "return") in the vote panel.
/datum/vote/proc/check_toggle()

//Called when toggle is hit.
/datum/vote/proc/toggle(mob/user)

//Will be run by the SS while the vote is running.
/datum/vote/Process()
	if(status == VOTE_STATUS_ACTIVE)
		if(time_remaining > 0)
			time_remaining = round((start_time + VOTE_PERIOD - world.time)/10)
			return VOTE_PROCESS_ONGOING
		else
			status = VOTE_STATUS_COMPLETE
			return VOTE_PROCESS_COMPLETE
	return VOTE_PROCESS_ABORT

/datum/vote/proc/interface(mob/user)
	. = list()
	if(mob_not_participating(user))
		. += "<h2>You can't participate in this vote unless you're participating in the round.</h2><br>"
		return
	if(question)
		. += "<h2>Vote: '[question]'</h2>"
	else
		. += "<h2>Vote: [capitalize(name)]</h2>"
	. += "Time Left: [time_remaining] s<hr>"
	. += "<table width = '100%'><tr><th>Choices</th><th>Order</th>"
	. += additional_header
	. += "</tr>"

	for(var/i = 1, i <= display_choices.len, i++)
		var/choice = choices[i]
		var/voted_for = votes[user.ckey] && (i in votes[user.ckey])

		. += "<tr><td><a href='?src=\ref[src];choice=[i]'[voted_for ? " style='font-weight: bold'" : ""]>"
		. += "[display_choices[i]]"
		. += "</a></td>"

		. += "<td style='text-align: center;'>"
		if(voted_for)
			var/list/vote = votes[user.ckey]
			. += "[list_find(vote, i)]"
		. += "</td>"

		if (additional_text[choice])
			. += "[additional_text[choice]]" //Note lack of cell wrapper, to allow for dynamic formatting.
		. += "</tr>"
	. += "</table><hr>"

/datum/vote/Topic(href, href_list, hsrc)
	var/mob/user = usr
	if(!istype(user) || !user.client)
		return

	if(!href_list["choice"])
		return

	var/choice = text2num(href_list["choice"])
	if(!is_valid_index(choice, choices))
		return

	submit_vote(user, choice)


/datum/vote/proc/handle_tgui(action, params, admin)
	var/mob/user = usr
	switch(action)
		if("cancel")
			if(admin)
				SSvote.cancel_vote(user)
			return TRUE

		if("vote")
			submit_vote(user, params["index"])


/datum/vote/ui_data(var/mob/user)
	var/list/data = list("mode" = template_mode,
	"question" = question, 
	"time_remaining" = time_remaining)
	var/index = 0
	for(var/key in display_choices)
		index++
		var/priority = ""
        //If this user has placed at least two votes, we'll show the priority of them
		if (index in votes[user.ckey])
			priority =  votes[user.ckey].Find(index)

		data["choices"] += list(list(
			"name" = key,	//The name is in display choices
			"votes" = choices[display_choices[key]] || 0,	//The number of votes is gotten from choices, using the datum in display choices
			
			"priority"  =  priority 
			
		))
	return data

/datum/controller/subsystem/vote/ui_state()
	return GLOB.tgui_always_state

