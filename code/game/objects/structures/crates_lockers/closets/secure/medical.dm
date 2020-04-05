#define RANDOM_SCRUBS new/datum/atom_creator/weighted(list( \
				list(/obj/item/clothing/head/surgery), \
				list(/obj/item/clothing/head/surgery/blue), \
				list(/obj/item/clothing/head/surgery/green), \
				list(/obj/item/clothing/head/surgery/purple), \
				list(/obj/item/clothing/head/surgery/black), \
				list(/obj/item/clothing/head/surgery/lilac), \
				list(/obj/item/clothing/head/surgery/teal), \
				list(/obj/item/clothing/head/surgery/heliodor), \
				list(/obj/item/clothing/head/surgery/navyblue)\
			) \
		)

/obj/structure/closet/secure_closet/medical1
	name = "medical equipment closet"
	desc = "Filled with medical junk."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_off = "medicaloff"
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/medical1/WillContain()
	return list(
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/random/firstaid = 3
	)

/obj/structure/closet/secure_closet/medical2
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_off = "medicaloff"
	req_access = list(access_surgery)

/obj/structure/closet/secure_closet/medical2/WillContain()
	return list(
		/obj/item/weapon/tank/anesthetic = 3,
		/obj/item/clothing/mask/breath/medical = 3
	)

/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_medical)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_off = "securemedoff"

/obj/structure/closet/secure_closet/medical3/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/medic, /obj/item/weapon/storage/backpack/satchel_med)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag/med, 50),
		/obj/item/clothing/under/medical_doctor,
		/obj/item/clothing/shoes/white,
		/obj/item/device/flashlight,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/taperoll/medical,
		/obj/item/weapon/storage/belt/medical,
		/obj/item/clothing/glasses/hud/health
	)

/obj/structure/closet/secure_closet/SMO
	name = "senior medical officer's locker"
	req_access = list(access_smo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_off = "cmosecureoff"

/obj/structure/closet/secure_closet/SMO/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/medic, /obj/item/weapon/storage/backpack/satchel_med)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag/med, 50),
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/shoes/brown,
		/obj/item/device/radio/headset/heads/cmo,
		/obj/item/device/flash,
		/obj/item/weapon/reagent_containers/hypospray/vial,
		RANDOM_SCRUBS
	)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "medical1"
	icon_closed = "medical"
	icon_locked = "medical1"
	icon_opened = "medicalopen"
	icon_off = "medicaloff"
	req_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chemical/WillContain()
	return list(
		/obj/item/weapon/storage/box/pillbottles = 2,
		/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone,
		/obj/random/medical = 12
	)

/obj/structure/closet/secure_closet/medical_wall
	name = "first aid closet"
	desc = "It's a secure wall-mounted storage unit for first aid supplies."
	icon_state = "medical_wall_locked"
	icon_closed = "medical_wall_unlocked"
	icon_locked = "medical_wall_locked"
	icon_opened = "medical_wall_open"
	icon_broken = "medical_wall_sparks"
	icon_off = "medical_wall_off"
	anchored = 1
	density = 0
	wall_mounted = 1
	storage_types = CLOSET_STORAGE_ITEMS
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/counselor
	name = "counselor's locker"
	req_access = list(access_medical)
	icon_state = "chaplainsecure1"
	icon_closed = "chaplainsecure"
	icon_locked = "chaplainsecure1"
	icon_opened = "chaplainsecureopen"
	icon_off = "chaplainsecureoff"

/obj/structure/closet/secure_closet/counselor/WillContain()
	return list(
		/obj/item/clothing/under/rank/psych,
		/obj/item/clothing/under/rank/psych/turtleneck,
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/chaplain_hoodie,
		/obj/item/weapon/storage/fancy/candle_box = 2,
		/obj/item/weapon/deck/tarot,
		/obj/item/weapon/reagent_containers/food/drinks/bottle/holywater,
		/obj/item/weapon/nullrod,
		/obj/item/weapon/storage/bible,
		/obj/item/clothing/suit/straight_jacket,
		/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/storage/pill_bottle/citalopram,
		/obj/item/weapon/reagent_containers/pill/methylphenidate,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder/white,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/toy/therapy_blue,
		/obj/item/weapon/storage/belt/general
	)

/obj/structure/closet/secure_closet/virology
	name = "virologist's locker"
	icon_state = "secureviro1"
	icon_closed = "secureviro"
	icon_locked = "secureviro1"
	icon_opened = "secureviroopen"
	icon_off = "securevirooff"
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/virology/WillContain()
	return list(
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/weapon/storage/box/syringes,
		/obj/item/weapon/reagent_containers/dropper = 2,
		/obj/item/weapon/reagent_containers/glass/beaker = 2,
		/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/weapon/storage/pill_bottle/spaceacillin,
		/obj/item/weapon/reagent_containers/syringe/antiviral,
		/obj/item/weapon/reagent_containers/glass/bottle/antitoxin,
		/obj/item/weapon/storage/box/masks,
		/obj/item/weapon/storage/box/gloves,
		/obj/item/clothing/under/rank/virologist,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/suit/storage/toggle/labcoat/virologist,
		/obj/item/clothing/mask/surgical,
		/obj/item/device/healthanalyzer,
		/obj/item/clothing/glasses/hud/health
	)

/obj/structure/closet/secure_closet/psychiatry
	name = "Psychiatrist's locker"
	desc = "Everything you need to keep the lunatics at bay."
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_off = "securemedoff"
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/psychiatry/WillContain()
	return list(
		/obj/item/clothing/suit/straight_jacket,
		/obj/item/weapon/reagent_containers/glass/bottle/stoxin,
		/obj/item/weapon/reagent_containers/syringe,
		/obj/item/weapon/storage/pill_bottle/citalopram,
		/obj/item/weapon/storage/pill_bottle/methylphenidate,
		/obj/item/weapon/storage/pill_bottle/paroxetine,
		/obj/item/clothing/under/rank/psych/turtleneck,
		/obj/item/clothing/under/rank/psych
	)
