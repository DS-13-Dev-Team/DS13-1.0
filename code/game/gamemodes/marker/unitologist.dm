GLOBAL_DATUM_INIT(unitologists, /datum/antagonist/unitologist, new)
GLOBAL_LIST_EMPTY(unitologists_list)
/*
/mob/proc/message_unitologists()
	set category = SPECIES_NECROMORPH
	set name = "Commune with the marker"
	set src = usr
	var/message = input("Say what?","Text") as null|text
	message = sanitize(message)
	message_necromorphs("<span class='cult'>[usr]: [message]</span>")
*/
/datum/antagonist/unitologist
	role_text = "Unitologist Zealot"
	role_text_plural = "Unitologist Zealots"
	welcome_text = "You are a zealot of Unitology willing to do anything in pursuit of your beliefs. You have been blessed with a psychic connection created by the <b>marker</b>, and must serve the marker's will at all costs by bringing it human sacrifices. Remember, its objectives come before your own..."
	id = MODE_UNITOLOGIST
	flags = ANTAG_SUSPICIOUS | ANTAG_RANDSPAWN | ANTAG_VOTABLE
	skill_setter = /datum/antag_skill_setter/station
	antaghud_indicator = "hudunitologist" // Used by the ghost antagHUD.
	antag_indicator = "hudunitologist"// icon_state for icons/mob/mob.dm visual indicator.
	preference_candidacy_toggle = TRUE

	// Spawn values (autotraitor and game mode)
	//Hard cap of 6 will only be reached at really high playercounts
	hard_cap = 6                        // Autotraitor var. Won't spawn more than this many antags.
	hard_cap_round = 6                  // As above but 'core' round antags ie. roundstart.
	initial_spawn_req = 0               // Gamemode using this template won't start without this # candidates.
	initial_spawn_target = 3            // Gamemode will attempt to spawn this many antags.

/datum/objective/unitologist
	explanation_text = "Serve the marker at all costs."

/datum/antagonist/unitologist/create_objectives(var/datum/mind/marker_minion)
	.=..()
	if(!.)
		return
//	marker_minion.current?.psychosis_immune = TRUE //PENDING PSYCHOSIS MERGE.
	var/datum/objective/unitologist/unitologist_objective = new
	marker_minion.objectives += unitologist_objective
	GLOB.unitologists_list += marker_minion.current
	to_chat(marker_minion.current, "<span class='warning'>You can feel an alien presence altering your mind...</span>")
	addtimer(CALLBACK(src, .proc/give_collaborators, marker_minion.current), 2 SECONDS) //Let the other unitologists spawn before iterating through them.
	return

/datum/antagonist/unitologist/proc/give_collaborators(mob/living/our_owner)
	//our_owner.verbs |= /mob/proc/message_unitologists
	to_chat(our_owner, "<span class='warning'>The marker has established a psychic link between you and your fellow zealots.</span>")
	to_chat(our_owner, "<span class='warning'><i>Your mind is flooded with several names, these people must also share a connection to the marker...</i></span>")
	for(var/mob/living/minion in GLOB.unitologists_list)
		if(minion && minion != our_owner)
			to_chat(our_owner, "Fellow zealot: [minion.real_name]")
			our_owner.mind.store_memory("<b>Fellow zealot</b>: [minion.real_name]")


GLOBAL_DATUM_INIT(shardbearers, /datum/antagonist/unitologist/shardbearer, new)
/*
	The Shardbearer
*/
/datum/antagonist/unitologist/shardbearer
	role_text = "Zealot Shardbearer"
	role_text_plural = "Shardbearers"
	preference_candidacy_toggle = TRUE
	id = MODE_UNITOLOGIST_SHARD
	flags = 0
	initial_spawn_req = 1
	welcome_text = "While on a planetary survey team on Aegis VII below, you uncovered the Holy Marker. It spoke to you, and you followed its directions, chipping off a piece and smuggling it aboard with you. <br>\
	The shard still speaks to you now. It tells you to hide it. Plant it somewhere in a dark, hidden corner of the Ishimura, where it will not be discovered"

/datum/antagonist/unitologist/shardbearer/equip(var/mob/living/carbon/human/H)
	.=..()
	H.equip_to_storage_or_drop(new /obj/item/marker_shard)




/datum/antagonist/unitologist/shardbearer/create_objectives(var/datum/mind/marker_minion)
	if(!..())
		return
	var/datum/objective/unitologist/shard/unitologist_objective = new
	marker_minion.objectives += unitologist_objective


/datum/objective/unitologist/shard
	explanation_text = "Plant the marker shard in a secret place and let it grow."
