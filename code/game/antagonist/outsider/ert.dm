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
	id = MODE_EDF
	role_text = "EDF Responder"
	role_text_plural = "EDF Responders"
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the installation and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the ERT.</b>"
	welcome_text = "Placeholder"
	leader_welcome_text = "As leader of the Emergency Response Team, you are part of the Earth Defence Force, and are there with the intention of restoring normal operation to the vessel or the safe evacuation of crew and passengers. You should, to this effect, aid the Commanding Officer or ranking officer aboard in their endeavours to achieve this."
	landmark_id = "EDF Team"
	id_type = /obj/item/weapon/card/id/centcom/ERT
	valid_species = list(SPECIES_HUMAN)
	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"
	hard_cap = 99
	hard_cap_round = 99
	initial_spawn_req = 99
	initial_spawn_target = 99
	show_objectives_on_creation = 0 //we are not antagonists, we do not need the antagonist shpiel/objectives

	var/list/outfits = list(
		/decl/hierarchy/outfit/edf_grunt,
		/decl/hierarchy/outfit/edf_grunt, // Twice because we want 2 in the team
		/decl/hierarchy/outfit/edf_commander,
		/decl/hierarchy/outfit/edf_medic,
		/decl/hierarchy/outfit/edf_engie)

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

/datum/antagonist/ert/proc/add_candidate(var/mob/source)
	candidates += source

/datum/antagonist/ert/proc/pick_candidates()

	if(!outfits || outfits.len > candidates.len)
		message_admins("Ert aborted. Not enough candidates.", 1)
		log_admin("Ert aborted. Not enough candidates.")
		return 0

	for(var/i = 0; i < outfits.len; i++)
		if(candidates.len == 0)
			break
		var/candidate = pick(candidates)
		create_default(candidate)
		candidates -= candidate
	candidates = list()


/datum/antagonist/ert/equip(var/mob/living/carbon/human/player)	
	if(!..())
		return 0
	if(!outfits.len)
		return 0
	var/list/outfits_temp = outfits
	var/decl/hierarchy/outfit/ert_outfit = outfit_by_type(outfits_temp[1])
	if(!ert_outfit)
		return 0
	dressup_human(player, ert_outfit)
	outfits_temp -= outfits_temp[1]
	return 1

/datum/antagonist/ert/kellion
	id = MODE_MRT
	role_text = "Maintenance Response Team"
	role_text_plural = "Maintenance Response Team"
	antag_text = "Placeholder"
	leader_welcome_text = "Placeholder"
	landmark_id = "Kellion Team"
	outfits = list(
		/decl/hierarchy/outfit/isaac,
		/decl/hierarchy/outfit/kellion_sec,
		/decl/hierarchy/outfit/kellion_sec,
		/decl/hierarchy/outfit/kellion_sec_leader,
		/decl/hierarchy/outfit/kendra)

/datum/antagonist/ert/unitologists
	id = MODE_UNI_ERT
	role_text = "Unitologist"
	role_text_plural = "Unitologists"
	antag_text = "Placeholder"
	leader_welcome_text = "Placeholder"
	landmark_id = "Unitologists Team"
	antaghud_indicator = "hudunitologist" // Used by the ghost antagHUD.
	antag_indicator = "hudunitologist"// icon_state for icons/mob/mob.dm visual indicator.
	outfits = list(
		/decl/hierarchy/outfit/faithful,
		/decl/hierarchy/outfit/healer,
		/decl/hierarchy/outfit/mechanic,
		/decl/hierarchy/outfit/berserker,
		/decl/hierarchy/outfit/deacon)