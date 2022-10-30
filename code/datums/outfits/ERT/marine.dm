///////////////////
////EDF OUTFITS////
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
	id_type = /obj/item/card/id/holo
	id_desc = "Job Desc Here"*/


/decl/hierarchy/outfit/edf_commander
	name = "EDF CO"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/radio/headset/ert
	belt = /obj/item/storage/belt/holster/security/tactical
	back = /obj/item/rig/advanced //has... everything
	shoes = /obj/item/clothing/shoes/dutyboots

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/holo/edf/commander
	id_desc = "EDF Commander"

/decl/hierarchy/outfit/edf_medic
	name = "EDF Medic"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/radio/headset/ert
	l_hand = /obj/item/storage/firstaid/ds_healkitcombat
	belt = /obj/item/storage/belt/holster/security/tactical
	back = /obj/item/rig/marine
	shoes = /obj/item/clothing/shoes/dutyboots

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/holo/edf/medic
	id_desc = "EDF Medic"

/decl/hierarchy/outfit/edf_engie
	name = "EDF Engineer"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/rig/marine/specialist //has advanced kinesis
	belt = /obj/item/storage/belt/holster/security/tactical
	back = /obj/item/rig/marine
	shoes = /obj/item/clothing/shoes/dutyboots

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/holo/edf/engineer
	id_desc = "EDF Engineer"

/decl/hierarchy/outfit/edf_grunt
	name = "EDF Marine"
	uniform = /obj/item/clothing/under/rigunder
	l_ear = /obj/item/radio/headset/ert
	belt = /obj/item/storage/belt/holster/security/tactical
	back = /obj/item/rig/marine
	shoes = /obj/item/clothing/shoes/dutyboots

	id_slot = slot_wear_id
	id_type = /obj/item/card/id/holo/edf
	id_desc = "EDF Marine"
