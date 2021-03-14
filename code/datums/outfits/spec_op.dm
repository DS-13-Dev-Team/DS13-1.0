///////////////////////////////////////////////////
///////////////DEFAULT OUTFITS BELOW///////////////
///////////////////////////////////////////////////
/decl/hierarchy/outfit/spec_op_officer
	name = "Spec Ops - Officer"
	uniform = /obj/item/clothing/under/syndicate/combat
	suit = /obj/item/clothing/suit/armor/swat
	l_ear = /obj/item/device/radio/headset/ert
	glasses = /obj/item/clothing/glasses/thermal/plain/eyepatch
	mask = /obj/item/clothing/mask/smokable/cigarette/cigar/havana
	back = /obj/item/weapon/storage/backpack/satchel
	shoes = /obj/item/clothing/shoes/combat
	gloves = /obj/item/clothing/gloves/thick/combat

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT
	id_desc = "Special operations ID."
	id_pda_assignment = "Special Operations Officer"

/decl/hierarchy/outfit/spec_op_officer/space
	name = "Spec Ops - Officer in space"
	suit = /obj/item/clothing/suit/space/void/swat
	back = /obj/item/weapon/tank/jetpack/oxygen
	mask = /obj/item/clothing/mask/gas

	flags = OUTFIT_HAS_JETPACK|OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/ert
	name = "Spec Ops - Emergency response team"
	uniform = /obj/item/clothing/under/ert
	shoes = /obj/item/clothing/shoes/dutyboots
	gloves = /obj/item/clothing/gloves/thick/swat
	l_ear = /obj/item/device/radio/headset/ert
	belt = /obj/item/weapon/gun/energy/gun
	glasses = /obj/item/clothing/glasses/sunglasses
	back = /obj/item/weapon/storage/backpack/satchel

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/centcom/ERT
/*
/decl/hierarchy/outfit/death_command
	name = "Spec Ops - Death commando"

/decl/hierarchy/outfit/death_command/equip(var/mob/living/carbon/human/H)
	GLOB.deathsquad.equip(H)
	return 1
*/
/decl/hierarchy/outfit/syndicate_command
	name = "Spec Ops - Syndicate commando"


/decl/hierarchy/outfit/mercenary
	name = "Spec Ops - Mercenary"
	uniform = /obj/item/clothing/under/syndicate
	shoes = /obj/item/clothing/shoes/combat
	l_ear = /obj/item/device/radio/headset/syndicate
	belt = /obj/item/weapon/storage/belt/holster/security
	glasses = /obj/item/clothing/glasses/sunglasses
	gloves = /obj/item/clothing/gloves/thick/swat

	l_pocket = /obj/item/weapon/reagent_containers/pill/cyanide

	id_slot = slot_wear_id
	id_type = /obj/item/weapon/card/id/syndicate
	id_pda_assignment = "Mercenary"

	flags = OUTFIT_HAS_BACKPACK|OUTFIT_RESET_EQUIPMENT

/decl/hierarchy/outfit/mercenary/syndicate
	name = "Spec Ops - Syndicate"
	suit = /obj/item/clothing/suit/armor/vest
	mask = /obj/item/clothing/mask/gas
	shoes = /obj/item/clothing/shoes/dutyboots
	id_desc = "Syndicate Operative"

/decl/hierarchy/outfit/mercenary/syndicate/commando
	name = "Spec Ops - Syndicate Commando"
	suit = /obj/item/clothing/suit/space/void/merc
	head = /obj/item/clothing/head/helmet/space/void/merc
	back = /obj/item/weapon/tank/jetpack/oxygen
	l_pocket = /obj/item/weapon/tank/emergency/oxygen
