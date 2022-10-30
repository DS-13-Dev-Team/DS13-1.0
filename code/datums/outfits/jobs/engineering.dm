/decl/hierarchy/outfit/job/engineering
	hierarchy_type = /decl/hierarchy/outfit/job/engineering
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/dutyboots
	pda_slot = slot_l_store
	backpack_contents = list(/obj/item/stack/power_node = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/engineering/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/engineering/ce
	name = OUTFIT_JOB_NAME("Chief Engineer")
	head = /obj/item/clothing/head/hardhat/white
	uniform = /obj/item/clothing/under/deadspace/engineer
	l_ear = /obj/item/radio/headset/heads/ce
	id_type = /obj/item/card/id/holo/engineering/chief_engineer
	pda_type = /obj/item/modular_computer/pda/heads/ce
	//back = /obj/item/rig/advanced //Future TODO: Allow rigs in outfits to be not-broken

/decl/hierarchy/outfit/job/engineering/tech_engineer
	name = OUTFIT_JOB_NAME("Technical Engineer")
	uniform = /obj/item/clothing/under/deadspace/engineer
	l_ear = /obj/item/radio/headset/headset_eng
	id_type = /obj/item/card/id/holo/engineering
	pda_type = /obj/item/modular_computer/pda/engineering