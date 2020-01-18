/decl/hierarchy/outfit/job/cargo/dom
	name = OUTFIT_JOB_NAME("Director of Mining")
	uniform = /obj/item/clothing/under/suit_jacket
	shoes = /obj/item/clothing/shoes/dress
	glasses = /obj/item/clothing/glasses/sunglasses
	id_type = /obj/item/weapon/card/id/holoiddom

/decl/hierarchy/outfit/job/cargo/so
	name = OUTFIT_JOB_NAME("Supply Officer")
	uniform = /obj/item/clothing/under/miner/deadspace
	shoes = /obj/item/clothing/shoes/dutyboots
	glasses = /obj/item/clothing/glasses/sunglasses
	id_type = /obj/item/weapon/card/id/holoidso

/decl/hierarchy/outfit/job/cargo/serviceman
	name = OUTFIT_JOB_NAME("Cargo Serviceman")
	uniform = /obj/item/clothing/under/miner/deadspace
	shoes = /obj/item/clothing/shoes/dutyboots
	glasses = /obj/item/clothing/glasses/sunglasses
	id_type = /obj/item/weapon/card/id/holoidserviceman

/decl/hierarchy/outfit/job/cargo/planet_cracker
	name = OUTFIT_JOB_NAME("Planet Cracker")
	uniform = /obj/item/clothing/under/miner/deadspace
	shoes = /obj/item/clothing/shoes/dutyboots
	id_type = /obj/item/weapon/card/id/holoidplanetcracker

/decl/hierarchy/outfit/job/cargo/foreman
	name = OUTFIT_JOB_NAME("Mining Foreman")
	uniform = /obj/item/clothing/under/miner/deadspace
	shoes = /obj/item/clothing/shoes/dutyboots
	glasses = /obj/item/clothing/glasses/sunglasses
	id_type = /obj/item/weapon/card/id/holoidforeman



////////////////////////////////////////////////////////////////////////////////
///////////////////////////DEFAULT OUTFITS BELOW HERE///////////////////////////
////////////////////////////////////////////////////////////////////////////////



/decl/hierarchy/outfit/job/cargo
	l_ear = /obj/item/device/radio/headset/headset_cargo
	hierarchy_type = /decl/hierarchy/outfit/job/cargo

/decl/hierarchy/outfit/job/cargo/qm
	name = OUTFIT_JOB_NAME("Cargo")
	uniform = /obj/item/clothing/under/rank/cargo
	shoes = /obj/item/clothing/shoes/brown
	glasses = /obj/item/clothing/glasses/sunglasses
	l_hand = /obj/item/weapon/clipboard
	id_type = /obj/item/weapon/card/id/cargo/head
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/cargo/cargo_tech
	name = OUTFIT_JOB_NAME("Cargo technician")
	uniform = /obj/item/clothing/under/rank/cargotech
	id_type = /obj/item/weapon/card/id/cargo
	pda_type = /obj/item/modular_computer/pda/cargo

/decl/hierarchy/outfit/job/cargo/mining
	name = OUTFIT_JOB_NAME("Shaft miner")
	uniform = /obj/item/clothing/under/rank/miner
	id_type = /obj/item/weapon/card/id/cargo/mining
	pda_type = /obj/item/modular_computer/pda/science
	backpack_contents = list(/obj/item/weapon/tool/crowbar = 1, /obj/item/weapon/storage/ore = 1)
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

/decl/hierarchy/outfit/job/cargo/mining/New()
	..()
	BACKPACK_OVERRIDE_ENGINEERING

/decl/hierarchy/outfit/job/cargo/mining/void
	name = OUTFIT_JOB_NAME("Shaft miner - Voidsuit")
	head = /obj/item/clothing/head/helmet/space/void/mining
	mask = /obj/item/clothing/mask/breath
	suit = /obj/item/clothing/suit/space/void/mining
