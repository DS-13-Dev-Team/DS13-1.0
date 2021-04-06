/*
	Emergency Call
*/
/datum/emergency_call/usm
	name = "USM Valor Marine"
	pref_name = "EDF Marine"
	weight = 2
	landmark_tag = "edfteam"
	antag_id = ERT_EDF_MARINES









/*
	Antagonist
*/

/datum/antagonist/ert/edf_marines
	id = ERT_EDF_MARINES
	role_text = "EDF Marine"
	role_text_plural = "EDF Responders"
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the installation and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the ERT.</b>"
	leader_welcome_text = "You are the leader EDF Marine force, responding to a distress call from a mining vessel illegally located in this sector. You are here to secure the ship and possibly to fulfil additional objectives. You answer to Earthgov, You do not take orders from the Ishimura command staff. and are not obligated to cooperate with them."
	welcome_text = "You are part of an EDF Marine force, responding to a distress call from a mining vessel illegally located in this sector. You answer to your squad leader or specialists, and to any representatives of EDF or Earthgov. You do not take orders from the Ishimura command staff."
	landmark_id = "edfteam"
	antaghud_indicator = "hudloyalist"

	outfits = list(
		/decl/hierarchy/outfit/edf_commander,
		/decl/hierarchy/outfit/edf_grunt,
		/decl/hierarchy/outfit/edf_grunt, // Twice because we want 2 in the team
		/decl/hierarchy/outfit/edf_engie,
		/decl/hierarchy/outfit/edf_medic)


	fallback_outfits = list(/decl/hierarchy/outfit/edf_grunt)


/datum/antagonist/ert/edf_marines/create_global_objectives(var/override=0)
	.=..()
	if (!.)
		return
	/*
		Regardless of their other objectives, the marines always have a secondary task to extract all earthgov VIPs onsite. One objective for each of them
		If an agent happens to be already dead before the marines arrive, they still get an objective for their records, and it is autofailed
	*/
	var/list/earthgov_agents = list()
	find_targets_by_role(ROLETEXT_EARTHGOV_AGENT, 1)
	for (var/datum/mind/M in earthgov_agents)
		var/datum/objective/extract/O = new /datum/objective/extract()
		O.role_type = TRUE
		O.set_target(M, TRUE)//Pass true to make the target setting silent so we dont spam the players with objective notifications
		global_objectives += O

///////////////////
////OUTFITS////////
///////////////////

/decl/hierarchy/outfit/edf_commander
	name = "EDF CO"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/device/radio/headset/ert
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = /obj/item/weapon/rig/marine/specialist
	shoes = /obj/item/clothing/shoes/dutyboots

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/edf/commander
	id_desc = "EDF Commander"

/decl/hierarchy/outfit/edf_medic
	name = "EDF Medic"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/device/radio/headset/ert
	l_hand = /obj/item/weapon/storage/firstaid/ds_healkitcombat
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = /obj/item/weapon/rig/marine/specialist
	shoes = /obj/item/clothing/shoes/dutyboots

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/edf/medic
	id_desc = "EDF Medic"

/decl/hierarchy/outfit/edf_engie
	name = "EDF Engineer"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/device/radio/headset/ert
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = /obj/item/weapon/rig/marine/specialist
	shoes = /obj/item/clothing/shoes/dutyboots

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/edf/engineer
	id_desc = "EDF Engineer"

/decl/hierarchy/outfit/edf_grunt
	name = "EDF Marine"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/device/radio/headset/ert
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	shoes = /obj/item/clothing/shoes/dutyboots
	back = /obj/item/weapon/rig/marine

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/edf
	id_desc = "EDF Marine"
