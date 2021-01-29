GLOBAL_DATUM_INIT(ert, /datum/antagonist/ert, new)
GLOBAL_DATUM_INIT(usm, /datum/antagonist/ert/usm, new)
GLOBAL_DATUM_INIT(kellion, /datum/antagonist/ert/kellion, new)
GLOBAL_DATUM_INIT(deliver, /datum/antagonist/ert/deliverance, new)

/datum/antagonist/ert
	id = MODE_ERT
	role_text = "ERT"
	role_text_plural = "ERT"
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the installation and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the ERT.</b>"
	leader_welcome_text = "As leader of the Emergency Response Team, you are part of the Earth Defence Force, and are there with the intention of restoring normal operation to the vessel or the safe evacuation of crew and passengers. You should, to this effect, aid the Commanding Officer or ranking officer aboard in their endeavours to achieve this."
	valid_species = list(SPECIES_HUMAN)
	antaghud_indicator = "hudloyalist"
	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	show_objectives_on_creation = 0

	var/list/members_types = list(list(0,1),list(0,1),list(0,1))
	var/list/equips = list(null, null, null, null, null)

/datum/antagonist/ert/equip(mob/living/carbon/human/player)
	if(!..())
		return FALSE

	var/decl/hierarchy/outfit/ertfit = outfit_by_type(equips[4])

	if(player.mind == leader)
		ertfit = outfit_by_type(equips[1])

	for(var/list/i in members_types)
		if(i[0]==i[1]) continue
		ertfit = outfit_by_type(equips[i+1])

	if(!ertfit)
		return FALSE
	dressup_human(player, ertfit)
	return TRUE

/datum/antagonist/ert/Initialize()
	..()
	welcome_text = "As member of the Emergency Response Team, you answer only to your leader and [GLOB.using_map.company_name] officials."

/datum/antagonist/ert/greet(datum/mind/player)
	if(!..()) return
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/ert/proc/update_members_type(k)
	if(members_types == list())	return

	for(var/list/i in members_types)
		i[1] = k

	GLOB.usm.members_types = members_types
	GLOB.kellion.members_types = members_types
	GLOB.deliver.members_types = members_types

// USM
/datum/antagonist/ert/usm
	role_text = "USM"
	role_text_plural = "USM"

/datum/antagonist/ert/kellion
	id = "Kellionteam"
	role_text = "Maintenance Response Team"
	role_text_plural = "Maintenance Response Team"
	leader_welcome_text = "As leader of the Emergency Response Team, you are part of the Kellion Response Team, and are there with the intention of restoring normal operation to the vessel or the safe evacuation of crew and passengers. You should, to this effect, aid the Commanding Officer or ranking officer aboard in their endeavours to achieve this."


/datum/antagonist/ert/deliverance
	id = "Unitologiststeam"
	role_text = "Unitologist"
	role_text_plural = "Unitologists"
	antag_text = "You are part of a new religion which worships strange alien artifacts, believing that only through them can humanity truly transcend. You have been blessed with a psychic connection created by the <b>marker</b>, one of these artifacts. Serve the marker's will at all costs by bringing it human sacrifices and remember that its objectives come before your own..."
	leader_welcome_text = "You are the leader of this response team. Work with the marker instead of against it."
	antaghud_indicator = "hudunitologist"
	antag_indicator = "hudunitologist"