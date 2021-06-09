///////////////////
////OUTFITS////////
///////////////////

/*	Outfit Template:

	name = "Job"
	uniform = null
	suit = null
	l_ear = null
	mask = null
	head = null
	belt = null
	back = null
	shoes = null
	gloves = null

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo
	id_desc = "Job Desc Here"*/


/decl/hierarchy/outfit/isaac
	name = "Kellion Engineer"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/device/radio/headset/ert
	back = /obj/item/weapon/rig/engineering
	shoes = /obj/item/clothing/shoes/workboots

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/isaac
	id_desc = "Kellion Engineer"

/decl/hierarchy/outfit/kellion_sec
	name = "Kellion Security"
	uniform = /obj/item/clothing/under/deadspace/ert/kellion
	suit =	/obj/item/clothing/suit/armor/vest/kellion
	l_ear = /obj/item/device/radio/headset/ert
	shoes = /obj/item/clothing/shoes/kellion
	gloves = 	/obj/item/clothing/gloves/combat/kellion

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/kellion_sec
	id_desc = "Kellion Security"

/decl/hierarchy/outfit/kellion_sec_leader
	name = "Kellion Security Leader"
	uniform = /obj/item/clothing/under/deadspace/ert/kellion/leader
	l_ear = /obj/item/device/radio/headset/ert
	shoes = /obj/item/clothing/shoes/kellion/lead
	gloves = 	/obj/item/clothing/gloves/combat/kellion

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/kellion_sec_leader
	id_desc = "Kellion Security Team Leader"

/decl/hierarchy/outfit/kendra
	name = "Kellion Technician"
	uniform = /obj/item/clothing/under/deadspace/ert/kellion/tech
	suit = /obj/item/clothing/suit/storage/toggle/kellion_jacket
	l_ear = /obj/item/device/radio/headset/ert
	shoes = /obj/item/clothing/shoes/dress

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/holo/kendra
	id_desc = "Kellion Technician"