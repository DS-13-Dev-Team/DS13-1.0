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
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"
	req_access = list(access_medical)

/obj/structure/closet/secure_closet/medical1/WillContain()
	return list(
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/random/firstaid = 3
	)

/obj/structure/closet/secure_closet/medical2
	name = "anesthetics closet"
	desc = "Used to knock people out."
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"
	req_access = list(access_surgery)

/obj/structure/closet/secure_closet/medical2/WillContain()
	return list(
		/obj/item/tank/anesthetic = 3,
		/obj/item/clothing/mask/breath/medical = 3,
		/obj/item/rig_remover = 2
	)

/obj/structure/closet/secure_closet/medical3
	name = "medical doctor's locker"
	req_access = list(access_medical)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/medical3/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel_med)),
		new/datum/atom_creator/weighted(list(/obj/item/clothing/suit/storage/toggle/labcoat, /obj/item/clothing/suit/storage/toggle/labcoat/blue)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/med, 50),
		/obj/item/rig/medical,
		/obj/item/clothing/under/deadspace/doctor,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/flashlight,
		/obj/item/flashlight/pen,
		/obj/item/radio/headset/headset_med,
		/obj/item/healthanalyzer,
		/obj/item/taperoll/medical,
		/obj/item/storage/belt/medical,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/rig_remover
	)

/obj/structure/closet/secure_closet/medical4
	name = "surgeon's locker"
	req_access = list(access_medical)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/medical4/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel_med)),
		new/datum/atom_creator/weighted(list(/obj/item/clothing/suit/storage/toggle/labcoat, /obj/item/clothing/suit/storage/toggle/labcoat/blue)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/med, 50),
		/obj/item/rig/medical,
		/obj/item/clothing/under/deadspace/surgeon,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/flashlight,
		/obj/item/flashlight/pen,
		/obj/item/radio/headset/headset_med,
		/obj/item/healthanalyzer,
		/obj/item/taperoll/medical,
		/obj/item/storage/belt/medical,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/rig_remover
	)

/obj/structure/closet/secure_closet/SMO
	name = "senior medical officer's locker"
	req_access = list(access_smo)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/SMO/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel_med)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/med, 50),
		/obj/item/rig/medical/equipped,
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/under/rank/chief_medical_officer,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/radio/headset/heads/smo,
		/obj/item/taperoll/medical,
//		/obj/item/flash,
		/obj/item/flashlight,
		/obj/item/flashlight/pen,
		/obj/item/adv_health_analyzer,
		/obj/item/storage/belt/medical,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/reagent_containers/hypospray/vial,
		/obj/item/rig_remover
	)

/obj/structure/closet/secure_closet/chemical
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"
	req_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chemical/WillContain()
	return list(
		/obj/item/storage/box/pillbottles = 2,
		/obj/item/reagent_containers/glass/beaker/cryoxadone,
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
		/obj/item/clothing/under/rank/psych/sweater,
		/obj/item/clothing/under/rank/chaplain,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/suit/chaplain_hoodie,
		/obj/item/storage/fancy/candle_box = 2,
		/obj/item/deck/tarot,
		/obj/item/reagent_containers/food/drinks/bottle/holywater,
		/obj/item/nullrod,
		/obj/item/storage/bible,
		/obj/item/clothing/suit/straight_jacket,
		/obj/item/reagent_containers/glass/bottle/stoxin,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/pill_bottle/citalopram,
		/obj/item/reagent_containers/pill/methylphenidate,
		/obj/item/clipboard,
		/obj/item/folder/white,
		/obj/item/taperecorder,
		/obj/item/tape/random = 3,
		/obj/item/camera,
		/obj/item/toy/therapy_blue,
		/obj/item/storage/belt/general
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
		/obj/item/storage/box/autoinjectors,
		/obj/item/storage/box/syringes,
		/obj/item/reagent_containers/dropper = 2,
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/reagent_containers/glass/bottle/inaprovaline,
		/obj/item/storage/pill_bottle/spaceacillin,
		/obj/item/reagent_containers/syringe/antiviral,
		/obj/item/reagent_containers/glass/bottle/antitoxin,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/gloves,
		/obj/item/clothing/under/rank/virologist,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/mask/surgical,
		/obj/item/healthanalyzer,
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
		/obj/item/reagent_containers/glass/bottle/stoxin,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/pill_bottle/citalopram,
		/obj/item/storage/pill_bottle/methylphenidate,
		/obj/item/storage/pill_bottle/paroxetine,
		/obj/item/clothing/under/rank/psych/sweater,
		/obj/item/clothing/under/rank/psych
	)
