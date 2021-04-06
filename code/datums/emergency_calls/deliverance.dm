/*
	Emergency Call
*/
/datum/emergency_call/deliverance
	name = "Unitologist"
	pref_name = "Unitologist Missionary"
	weight = 1
	landmark_tag = "unitologiststeam"
	antag_id = ERT_UNITOLOGY

/*
	Antagonist
*/

/datum/antagonist/ert/unitologists
	id = ERT_UNITOLOGY
	role_text = "Unitologist Pilgrim"
	role_text_plural = "Unitologist Pilgrims"
	antag_text = "You are part of a new religion which worships strange alien artifacts, believing that only through them can humanity truly transcend. You have been blessed with a psychic connection created by the <b>marker</b>, one of these artifacts. Serve the marker's will at all costs by bringing it human sacrifices and remember that its objectives come before your own..."
	leader_welcome_text = "You are the leader of the Holy Ship Deliverance. You answer only to the call of the marker. You are here to ensure that everyone aboard Ishimura becomes a glorious sacrifice"
	welcome_text = "You are a disciple aboard the Holy Ship Deliverance. You answer only to the call of the marker, and your comrades. You are here to ensure that everyone aboard Ishimura becomes a glorious sacrifice"

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






///////////////////
////OUTFITS////////
///////////////////

/decl/hierarchy/outfit/faithful
	name = "UNI Faithful"
	uniform = /obj/item/clothing/under/rigunder
	suit = /obj/item/clothing/suit/space/unitologist
	l_ear = null
	mask = /obj/item/clothing/mask/breath
	head = /obj/item/clothing/head/helmet/space/unitologist
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = null
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/combat
	backpack_contents = list(/obj/item/weapon/material/knife/unitologist = 1)
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/unitologist
	id_desc = "A holographic ID belonging to an unregistered civilian vessel. It bears unitologist iconography."

/decl/hierarchy/outfit/healer
	name = "UNI Medic"
	uniform = /obj/item/clothing/under/rigunder
	suit = /obj/item/clothing/suit/space/unitologist/healer
	l_ear = null
	glasses = /obj/item/clothing/glasses/hud/health
	mask = /obj/item/clothing/mask/breath
	head = /obj/item/clothing/head/helmet/space/unitologist/healer
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = null
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/combat
	backpack_contents = list(/obj/item/weapon/material/knife/unitologist = 1)
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/healer
	id_desc = "A holographic ID belonging to an unregistered civilian vessel. It bears unitologist iconography."

/decl/hierarchy/outfit/mechanic
	name = "UNI Mechanic"
	uniform = /obj/item/clothing/under/rigunder
	suit = /obj/item/clothing/suit/space/unitologist/mechanic
	l_ear = null
	glasses = /obj/item/clothing/glasses/welding
	mask = /obj/item/clothing/mask/breath
	head = /obj/item/clothing/head/helmet/space/unitologist/mechanic
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = null
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/combat
	backpack_contents = list(/obj/item/weapon/material/knife/unitologist = 1)
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/mechanic
	id_desc = "A holographic ID belonging to an unregistered civilian vessel. It bears unitologist iconography."

/decl/hierarchy/outfit/berserker
	name = "UNI Berserker"
	uniform = /obj/item/clothing/under/rigunder
	suit = /obj/item/clothing/suit/space/unitologist/berserker
	l_ear = null
	mask = /obj/item/clothing/mask/breath
	head = /obj/item/clothing/head/helmet/space/unitologist/berserker
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = null
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/combat
	backpack_contents = list(/obj/item/weapon/material/knife/unitologist = 1)
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/berserker
	id_desc = "A holographic ID belonging to an unregistered civilian vessel. It bears unitologist iconography."

/decl/hierarchy/outfit/deacon
	name = "UNI Deacon"
	uniform = /obj/item/clothing/under/rigunder
	suit = /obj/item/clothing/suit/space/unitologist/deacon
	l_ear = null
	mask = /obj/item/clothing/mask/breath
	head = /obj/item/clothing/head/helmet/space/unitologist/deacon
	belt = /obj/item/weapon/storage/belt/holster/security/tactical
	back = null
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/combat
	backpack_contents = list(/obj/item/weapon/material/knife/unitologist = 1)
	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/deacon
	id_desc = "A holographic ID belonging to an unregistered civilian vessel. It bears unitologist iconography."
