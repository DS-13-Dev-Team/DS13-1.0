/*To add a new ert.
1. Ask for help if you do not understand.
2. Init the global datum for the ert.
3. Create the datum for the ert make sure to inherit from /datum/antagonist/ert
4. Add it to the ert options list. (Not in this file but code\game\response_team.dm)
5. Add it to the switch statement to pick the ert for admins.
*/
/datum/antagonist/ert
	base_type = /datum/antagonist/ert
	id = MODE_ERT
	role_text = "EDF Responder"
	role_text_plural = "EDF Responders"
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the installation and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the ERT.</b>"
	leader_welcome_text = "As leader of the Emergency Response Team, you are part of the Earth Defence Force, and are there with the intention of restoring normal operation to the vessel or the safe evacuation of crew and passengers. You should, to this effect, aid the Commanding Officer or ranking officer aboard in their endeavours to achieve this."
	landmark_id = "edfteam"
	hard_cap = 8
	hard_cap_round = 8
	initial_spawn_req = 2
	initial_spawn_target = 6
	finalize_minimum_req = TRUE
	valid_species = list(SPECIES_HUMAN)
	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	preference_candidacy_toggle = TRUE	// Whether to show an option in preferences to toggle candidacy
	preference_candidacy_category = "Response Teams"

	//Which member of the team are we currently adding? This determines the selected outfit
	//If it goes over the end of the outfits list, we pick from fallback outfits
	var/index = 0

	var/list/outfits = list(
		/decl/hierarchy/outfit/edf_commander,
		/decl/hierarchy/outfit/edf_grunt,
		/decl/hierarchy/outfit/edf_grunt, // Twice because we want 2 in the team
		/decl/hierarchy/outfit/edf_engie,
		/decl/hierarchy/outfit/edf_medic)


	var/list/fallback_outfits = list(/decl/hierarchy/outfit/edf_grunt)

/datum/antagonist/ert/create_default(var/mob/source)
	.=..()
	var/mob/living/carbon/human/M = .
	if(istype(M)) M.age = rand(25,45)


/datum/antagonist/ert/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")



/datum/antagonist/ert/reset_antag_selection()
	.=..()
	index = 0	//Reset this so any extra teams can have the proper composition


/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)

	if(!..())
		return 0

	index++
	var/decl/hierarchy/outfit/ert_outfit

	//If we're within the number of ordered team members, grab the corresponding entry from the outfits list
	if (index <= outfits.len)
		ert_outfit = outfit_by_type(outfits[index])
	else
		//If we're past the preset outfits, pick one at random from the fallbacks
		ert_outfit = outfit_by_type(pickweight(fallback_outfits))

	if(!ert_outfit)
		return 0
	dressup_human(player, ert_outfit)
	return 1



