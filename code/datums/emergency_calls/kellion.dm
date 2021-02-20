/*
	Emergency Call
*/
/datum/emergency_call/kellionteam
	name = "Kellionteam"
	pref_name = "CEC Repair Crew"
	weight = 1
	landmark_tag = "kellionteam"
	antag_id = ERT_CEC_REPAIR

/*
	Antagonist
*/


/datum/antagonist/ert/kellion
	id = ERT_CEC_REPAIR
	role_text = "CEC Repair Crew"
	role_text_plural = "CEC Repair Crew"
	leader_welcome_text = "As leader of the CEC Repair Crew, you are there with the intention of restoring normal operation to the vessel or the safe evacuation of crew and passengers. You should first of all make contact with the local command staff, and follow all orders from them."
	landmark_id = "kellionteam"
	initial_spawn_req = 1	//Isaac can come alone
	outfits = list(
		/decl/hierarchy/outfit/isaac,
		/decl/hierarchy/outfit/kendra,
		/decl/hierarchy/outfit/kellion_sec_leader
		)

	fallback_outfits = list(/decl/hierarchy/outfit/kellion_sec)








///////////////////
////OUTFITS////////
///////////////////
/decl/hierarchy/outfit/isaac
	name = "Kellion Engineer"
	uniform = /obj/item/clothing/under/rigunder
	suit = null
	l_ear = /obj/item/device/radio/headset/ert
	mask = /obj/item/clothing/mask/breath
	head = null
	belt = /obj/item/weapon/storage/belt/utility/full
	back = null
	shoes = /obj/item/clothing/shoes/workboots
	gloves = /obj/item/clothing/gloves/insulated

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/isaac
	id_desc = "Kellion Engineer"

/decl/hierarchy/outfit/kellion_sec
	name = "Kellion Security"
	uniform = /obj/item/clothing/under/deadspace/ert/kellion
	suit = /obj/item/clothing/suit/armor/vest/kellion
	l_ear = /obj/item/device/radio/headset/ert
	mask = null
	head = null
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = null
	shoes = /obj/item/clothing/shoes/kellion
	gloves = /obj/item/clothing/gloves/kellion

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/kellion_sec
	id_desc = "Kellion Security"

/decl/hierarchy/outfit/kellion_sec_leader
	name = "Kellion Security Leader"
	uniform = /obj/item/clothing/under/deadspace/ert/kellion/leader
	suit = null
	l_ear = /obj/item/device/radio/headset/ert
	mask = null
	head = null
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = null
	shoes = /obj/item/clothing/shoes/kellion/lead
	gloves = /obj/item/clothing/gloves/kellion

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/kellion_sec_leader
	id_desc = "Kellion Security Team Leader"

/decl/hierarchy/outfit/kendra
	name = "Kellion Technician"
	uniform = /obj/item/clothing/under/deadspace/ert/kellion/tech
	suit = /obj/item/clothing/suit/storage/toggle/kellion_jacket
	l_ear = /obj/item/device/radio/headset/ert
	mask = null
	head = null
	belt = null
	back = null
	shoes = /obj/item/clothing/shoes/dress
	gloves = null

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/kendra
	id_desc = "Kellion Technician"
