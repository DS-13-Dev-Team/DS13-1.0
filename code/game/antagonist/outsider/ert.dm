/*To add a new ert.
1. Ask for help if you do not understand.
2. Init the global datum for the ert.
3. Create the datum for the ert make sure to inherit from /datum/antagonist/ert
4. Add it to the ert options list. (Not in this file but code\game\response_team.dm)
5. Add it to the switch statement to pick the ert for admins.
*/

GLOBAL_DATUM_INIT(ert, /datum/antagonist/ert, new)
GLOBAL_DATUM_INIT(uni_ert, /datum/antagonist/ert/unitologists, new)
GLOBAL_DATUM_INIT(kellion, /datum/antagonist/ert/kellion, new)

/datum/antagonist/ert
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
	show_objectives_on_creation = 0 //we are not antagonists, we do not need the antagonist shpiel/objectives

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
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)


/datum/antagonist/ert/Initialize()
	..()
	welcome_text = "As member of the Emergency Response Team, you answer only to your leader and [GLOB.using_map.company_name] officials."

/datum/antagonist/ert/greet(var/datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/ert/add_antagonist(var/datum/mind/player, var/ignore_role, var/do_not_equip, var/move_to_spawn, var/do_not_announce, var/preserve_appearance)
	index++
	.=..()


/datum/antagonist/ert/reset_antag_selection()
	.=..()
	index = 0	//Reset this so any extra teams can have the proper composition

/*
/datum/antagonist/ert/proc/add_candidate(var/mob/source)
	candidates += source

/datum/antagonist/ert/proc/pick_candidates()


	for(var/i = 0; i <= outfits.len; i++)
		if(candidates.len == 0)
			break
		var/candidate = pick(candidates)
		create_default(candidate)
		candidates -= candidate
	candidates = list()
*/

/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)
	if(!..())
		return 0
	var/decl/hierarchy/outfit/ert_outfit

	//If we're within the number of ordered team members, grab the corresponding entry from the outfits list
	if (index <= outfits.len)
		ert_outfit = outfit_by_type(outfits[index])
	else
		//If we're past the preset outfits, pick one at random from the fallbacks
		ert_outfit = outfit_by_type(pickweight(fallback_outfits))

	ert_outfit = outfit_by_type(outfits_temp[1])
	if(!ert_outfit)
		return 0
	dressup_human(player, ert_outfit)
	return 1

/datum/antagonist/ert/kellion
	id = "Kellionteam"
	role_text = "Maintenance Response Team"
	role_text_plural = "Maintenance Response Team"
	leader_welcome_text = "As leader of the Emergency Response Team, you are part of the Kellion Response Team, and are there with the intention of restoring normal operation to the vessel or the safe evacuation of crew and passengers. You should, to this effect, aid the Commanding Officer or ranking officer aboard in their endeavours to achieve this."
	landmark_id = "kellionteam"
	initial_spawn_req = 1	//Isaac can come alone
	outfits = list(
		/decl/hierarchy/outfit/isaac,
		/decl/hierarchy/outfit/kendra,
		/decl/hierarchy/outfit/kellion_sec_leader
		)

	fallback_outfits = list(/decl/hierarchy/outfit/kellion_sec)

/datum/antagonist/ert/unitologists
	id = "Unitologiststeam"
	role_text = "Unitologist"
	role_text_plural = "Unitologists"
	antag_text = "You are part of a new religion which worships strange alien artifacts, believing that only through them can humanity truly transcend. You have been blessed with a psychic connection created by the <b>marker</b>, one of these artifacts. Serve the marker's will at all costs by bringing it human sacrifices and remember that its objectives come before your own..."
	leader_welcome_text = "You are the leader of this response team. Work with the marker instead of against it."
	landmark_id = "unitologiststeam"
	antaghud_indicator = "hudunitologist" // Used by the ghost antagHUD.
	antag_indicator = "hudunitologist"// icon_state for icons/mob/mob.dm visual indicator.
	outfits = list(
		/decl/hierarchy/outfit/faithful,
		/decl/hierarchy/outfit/healer,
		/decl/hierarchy/outfit/mechanic,
		/decl/hierarchy/outfit/berserker,
		/decl/hierarchy/outfit/deacon)


	//Unitology gets completely random outfits once the team is filled
	fallback_outfits = list(
		/decl/hierarchy/outfit/faithful,
		/decl/hierarchy/outfit/healer,
		/decl/hierarchy/outfit/mechanic,
		/decl/hierarchy/outfit/berserker,
		/decl/hierarchy/outfit/deacon)