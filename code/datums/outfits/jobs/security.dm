/decl/hierarchy/outfit/job/security
	hierarchy_type = /decl/hierarchy/outfit/job/security
	uniform = /obj/item/clothing/under/deadspace/security
	head = /obj/item/clothing/head/soft/pcsi
	l_ear = /obj/item/device/radio/headset/headset_sec
	glasses = /obj/item/clothing/glasses/sunglasses/sechud
	shoes = /obj/item/clothing/shoes/pcsi
	backpack_contents = list(/obj/item/weapon/handcuffs = 1)

/decl/hierarchy/outfit/job/security/New()
	..()
	BACKPACK_OVERRIDE_SECURITY

/decl/hierarchy/outfit/job/security/cseco
	name = OUTFIT_JOB_NAME("Chief Security Officer")
	suit = /obj/item/clothing/suit/storage/toggle/cseco
	head = /obj/item/clothing/under/deadspace/security/cseco
	l_ear = /obj/item/device/radio/headset/heads/cseco
	glasses = /obj/item/clothing/glasses/sunglasses/csecohud
	id_type = /obj/item/weapon/card/id/holo/security/cseco
	pda_type = /obj/item/modular_computer/pda/heads/hos

/decl/hierarchy/outfit/job/security/sso
	name = OUTFIT_JOB_NAME("Senior Security Officer")
	id_type = /obj/item/weapon/card/id/holo/security/sso
	pda_type = /obj/item/modular_computer/pda/security

/decl/hierarchy/outfit/job/security/officer
	name = OUTFIT_JOB_NAME("Security Officer")
	id_type = /obj/item/weapon/card/id/holo/security
	pda_type = /obj/item/modular_computer/pda/security