/decl/hierarchy/outfit/job/medical
	hierarchy_type = /decl/hierarchy/outfit/job/medical
	l_ear = /obj/item/device/radio/headset/headset_med
	shoes = /obj/item/clothing/shoes/white
	pda_type = /obj/item/modular_computer/pda/medical

/decl/hierarchy/outfit/job/medical/New()
	..()
	BACKPACK_OVERRIDE_MEDICAL


/decl/hierarchy/outfit/job/medical/smo
	name = OUTFIT_JOB_NAME("Senior Medical Officer")
	l_ear = /obj/item/device/radio/headset/heads/smo
	uniform = /obj/item/clothing/under/senior_medical_officer
	id_type = /obj/item/weapon/card/id/holo/medical/smo
	pda_type = /obj/item/modular_computer/pda/heads/cmo

/decl/hierarchy/outfit/job/medical/md
	name = OUTFIT_JOB_NAME("Medical Doctor")
	uniform = /obj/item/clothing/under/medical_doctor
	id_type = /obj/item/weapon/card/id/holo/medical

/decl/hierarchy/outfit/job/medical/surg
	name = OUTFIT_JOB_NAME("Surgeon")
	uniform = /obj/item/clothing/under/surgeon
	glasses = /obj/item/clothing/glasses/hud/health
	id_type = /obj/item/weapon/card/id/holo/medical/surgeon