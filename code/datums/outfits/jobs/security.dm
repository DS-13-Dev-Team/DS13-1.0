/decl/hierarchy/outfit/job/security
	hierarchy_type = /decl/hierarchy/outfit/job/security
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	l_ear = /obj/item/device/radio/headset/headset_sec
	uniform = /obj/item/clothing/under/deadspace/security
	gloves = /obj/item/clothing/gloves/combat
	shoes = /obj/item/clothing/shoes/ds_securityboots
	backpack_contents = list(/obj/item/weapon/handcuffs = 1)

/decl/hierarchy/outfit/job/security/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/security/cseco
	name = OUTFIT_JOB_NAME("Chief Security Officer")
	suit = /obj/item/clothing/suit/armor/vest/ds_jacket
	l_ear = /obj/item/device/radio/headset/heads/cseco
	belt = /obj/item/weapon/storage/belt/holster/security
	id_type = /obj/item/weapon/card/id/holo/security/cseco
	pda_type = /obj/item/modular_computer/pda/heads/hos

/decl/hierarchy/outfit/job/security/sso
	name = OUTFIT_JOB_NAME("Senior Security Officer")
	belt = /obj/item/weapon/storage/belt/holster/security
	id_type = /obj/item/weapon/card/id/holo/security/sso
	pda_type = /obj/item/modular_computer/pda/security

/decl/hierarchy/outfit/job/security/officer
	name = OUTFIT_JOB_NAME("Security Officer")
	belt = /obj/item/weapon/storage/belt/holster/security
	id_type = /obj/item/weapon/card/id/holo/security
	pda_type = /obj/item/modular_computer/pda/security