GLOBAL_DATUM_INIT(unitologists, /datum/antagonist/unitologist, new)
GLOBAL_LIST_EMPTY(unitologists_list)

/mob/proc/message_unitologists()
	set category = "Unitologist"
	set name = "Commune with the marker"
	set src = usr
	var/message = input("Say what?","Text") as null|text
	message = sanitize(message)
	for(var/atom/M in GLOB.unitologists_list)
		to_chat(M, "<span class='cult'>[src]: [message]</span>")

/datum/antagonist/unitologist
	role_text = "Unitologist"
	role_text_plural = "Unitologists"
	welcome_text = "You are part of a new religion which worships strange alien artifacts, believing that only through them can humanity truly transcend. You have been blessed with a psychic connection created by the <b>marker</b>, one of these artifacts. Serve the marker's will at all costs by bringing it human sacrifices and remember that its objectives come before your own..."
	id = MODE_UNITOLOGIST
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	skill_setter = /datum/antag_skill_setter/station
	antaghud_indicator = "hudunitologist" // Used by the ghost antagHUD.
	antag_indicator = "hudunitologist"// icon_state for icons/mob/mob.dm visual indicator.

datum/objective/unitologist
	explanation_text = "Serve the marker at all costs."

/datum/antagonist/unitologist/create_objectives(var/datum/mind/marker_minion)
	if(!..())
		return
	for(var/I=0,I<rand(1,3), I++) //Generate some random kill objectives. They have to listen to the marker above all though.
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = marker_minion
		kill_objective.find_target()
		marker_minion.objectives += kill_objective
//	marker_minion.current?.psychosis_immune = TRUE //PENDING PSYCHOSIS MERGE.
	var/datum/objective/unitologist/unitologist_objective = new
	marker_minion.objectives += unitologist_objective
	GLOB.unitologists_list += marker_minion.current
	to_chat(marker_minion.current, "<span class='warning'>You can feel an alien presence altering your mind...</span>")
	addtimer(CALLBACK(src, .proc/give_collaborators, marker_minion.current), 2 SECONDS) //Let the other unitologists spawn before iterating through them.
	return

/datum/antagonist/unitologist/proc/give_collaborators(mob/living/our_owner)
	our_owner.verbs += /mob/proc/message_unitologists
	to_chat(our_owner, "<span class='warning'>The marker has established a psychic link between you and your fellow unitologists.</span>")
	to_chat(our_owner, "<span class='warning'><i>Your mind is flooded with several names, these people must also share a connection to the marker...</i></span>")
	for(var/mob/living/minion in GLOB.unitologists_list)
		if(minion && minion != our_owner)
			to_chat(our_owner, "Fellow unitologist: [minion.real_name]")
			our_owner.mind.store_memory("<b>Fellow unitologist</b>: [minion.real_name]")

/*
/datum/antagonist/rogue_ai/build_candidate_list()
	..()
	for(var/datum/mind/player in candidates)
		if(player.assigned_role && player.assigned_role != "AI")
			candidates -= player
	return candidates
*/ //Useful code that lets you force candidate selection. Use this for marker?