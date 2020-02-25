/decl/hierarchy/outfit/job/science
	hierarchy_type = /decl/hierarchy/outfit/job/science
	shoes = /obj/item/clothing/shoes/black

/decl/hierarchy/outfit/job/science/New()
	..()
	BACKPACK_OVERRIDE_RESEARCH

/decl/hierarchy/outfit/job/science/cscio
	name = OUTFIT_JOB_NAME("Chief Science Officer")
	uniform = /obj/item/clothing/under/chief_science_officer
	l_ear = /obj/item/device/radio/headset/heads/rd
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/holo/science/cscio
	pda_type = /obj/item/modular_computer/pda/heads/rd

/decl/hierarchy/outfit/job/science/ra
	name = OUTFIT_JOB_NAME("Research Assistant")
	uniform = /obj/item/clothing/under/research_assistant
	l_ear = /obj/item/device/radio/headset/headset_medsci
	id_type = /obj/item/weapon/card/id/holo/science
	pda_type = /obj/item/modular_computer/pda/science