/obj/structure/closet/secure_closet/captains
	name = "captain's locker"
	req_access = list(access_captain)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/captains/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/captain, /obj/item/storage/backpack/satchel_cap)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/captain, 50),
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/heads/captain,
		/obj/item/clothing/gloves/captain,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/suit/armor/captain,
		/obj/item/telebaton,
		/obj/item/clothing/head/caphat,
		/obj/item/clothing/under/captainformal,
		/obj/item/rig/vintage,
		/obj/random/tool = 3
	)

/obj/structure/closet/secure_closet/hop
	name = "head of personnel's locker"
	req_access = list(access_fl)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_off = "hopsecureoff"

/obj/structure/closet/secure_closet/hop/WillContain()
	return list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/head/helmet,
		/obj/item/radio/headset/heads/fl,
		/obj/item/storage/box/ids = 2,
		/obj/item/gun/projectile/sec/flash,
		/obj/item/flash
	)

/obj/structure/closet/secure_closet/hop2
	name = "head of personnel's attire"
	req_access = list(access_fl)
	icon_state = "hopsecure1"
	icon_closed = "hopsecure"
	icon_locked = "hopsecure1"
	icon_opened = "hopsecureopen"
	icon_off = "hopsecureoff"

/obj/structure/closet/secure_closet/hop2/WillContain()
	return list(
		/obj/item/clothing/under/lawyer/female,
		/obj/item/clothing/under/lawyer/black,
		/obj/item/clothing/under/lawyer/oldman,
		/obj/item/clothing/shoes/brown,
		/obj/item/clothing/shoes/black,
		/obj/item/clothing/shoes/leather,
		/obj/item/clothing/shoes/white
	)

/obj/structure/closet/secure_closet/CSECO
	name = "chief security officer's locker"
	req_access = list(access_cseco)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/CSECO/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/security, /obj/item/storage/backpack/satchel_sec)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/sec, 50),
		/obj/item/rig/cseco,
		/obj/item/clothing/under/deadspace/security/cseco,
		/obj/item/clothing/suit/armor/pcsi,
		/obj/item/clothing/head/helmet/pcsi,
		/obj/item/clothing/shoes/pcsi,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/gloves/combat/pcsi,
		/obj/item/clothing/accessory/storage/webbing/security,
		/obj/item/radio/headset/heads/cseco,
		/obj/item/storage/belt/holster/security,
		/obj/item/gun/projectile/divet,
		/obj/item/ammo_magazine/divet = 2,
		/obj/item/ammo_magazine/divet/rb = 2,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/storage/box/holobadge,
		/obj/item/baton/loaded,
		/obj/item/taperoll/police,
		/obj/item/hailer,
		/obj/item/flash,
		/obj/item/holowarrant,
		/obj/item/flashlight/maglight
	)

/obj/structure/closet/secure_closet/SSO
	name = "senior security officer's locker"
	req_access = list(access_security)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/SSO/WillContain()
	return list(
		pick(list(/obj/item/storage/backpack/security, /obj/item/storage/backpack/satchel_sec)),
		pick(list(/obj/item/storage/backpack/dufflebag/sec, /obj/item/storage/backpack/messenger/sec)),
		/obj/item/clothing/under/deadspace/security,
		/obj/item/clothing/suit/armor/pcsi,
		/obj/item/clothing/head/helmet/pcsi,
		/obj/item/clothing/shoes/pcsi,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/clothing/accessory/storage/webbing/security,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/gloves/combat/pcsi,
		/obj/item/clothing/gloves/forensic,
		/obj/item/radio/headset/headset_sec,
		/obj/item/storage/belt/holster/forensic,
		/obj/item/storage/belt/holster/security,
		/obj/item/gun/projectile/divet,
		/obj/item/ammo_magazine/divet = 2,
		/obj/item/ammo_magazine/divet/rb = 2,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/baton/loaded,
		/obj/item/taperoll/police,
		/obj/item/hailer,
		/obj/item/flash,
		/obj/item/holowarrant,
		/obj/item/flashlight/maglight,
		/obj/item/rig/marksman
	)

/obj/structure/closet/secure_closet/security
	name = "security officer's locker"
	req_access = list(access_security)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/security/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack/security, /obj/item/storage/backpack/satchel_sec)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag/sec, 50),
		/obj/item/clothing/under/deadspace/security,
		/obj/item/clothing/suit/armor/pcsi,
		/obj/item/clothing/head/helmet/pcsi,
		/obj/item/clothing/shoes/pcsi,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/gloves/combat/pcsi,
		/obj/item/clothing/accessory/storage/webbing/security,
		/obj/item/radio/headset/headset_sec,
		/obj/item/storage/belt/holster/security,
		/obj/item/gun/projectile/divet,
		/obj/item/ammo_magazine/divet = 2,
		/obj/item/ammo_magazine/divet/rb = 2,
		/obj/item/reagent_containers/spray/pepper,
		/obj/item/baton/loaded,
		/obj/item/taperoll/police,
		/obj/item/hailer,
		/obj/item/flash,
		/obj/item/holowarrant,
		/obj/item/flashlight/maglight
	)

/obj/structure/closet/secure_closet/security/cargo/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
		/obj/item/clothing/accessory/armband/cargo,
		/obj/item/encryptionkey/headset_cargo
	))

/obj/structure/closet/secure_closet/security/engine/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
			/obj/item/clothing/accessory/armband/engine,
			/obj/item/encryptionkey/headset_eng
		))

/obj/structure/closet/secure_closet/security/science/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(/obj/item/encryptionkey/headset_sci))

/obj/structure/closet/secure_closet/security/med/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
			/obj/item/clothing/accessory/armband/medgreen,
			/obj/item/encryptionkey/headset_med
		))

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/injection/WillContain()
	return list(/obj/item/reagent_containers/syringe/ld50_syringe/choral = 2)

/obj/structure/closet/secure_closet/brig
	name = "brig locker"
	req_access = list(access_security)
	anchored = 1
	var/id = null

/obj/structure/closet/secure_closet/brig/WillContain()
	return list(
		/obj/item/clothing/under/color/orange,
		/obj/item/clothing/shoes/orange
	)

/obj/structure/closet/secure_closet/brig/evidence
	name = "evidence locker"

/obj/structure/closet/secure_closet/brig/evidence/WillContain()
	return null

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_security)

/obj/structure/closet/secure_closet/courtroom/WillContain()
	return list(
		/obj/item/clothing/shoes/brown,
		/obj/item/paper/Court = 3,
		/obj/item/pen,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/storage/briefcase
	)

/obj/structure/closet/secure_closet/wall
	name = "wall locker"
	req_access = list(access_security)
	icon_state = "wall-locker1"
	density = 1
	icon_closed = "wall-locker"
	icon_locked = "wall-locker1"
	icon_opened = "wall-lockeropen"
	icon_broken = "wall-lockerbroken"
	icon_off = "wall-lockeroff"

	//too small to put a man in
	large = 0

/obj/structure/closet/secure_closet/lawyer
	name = "internal affairs secure closet"
	req_access = list(access_security)

/obj/structure/closet/secure_closet/lawyer/WillContain()
	return list(
		/obj/item/flash = 2,
		/obj/item/camera = 2,
		/obj/item/camera_film = 2,
		/obj/item/taperecorder = 2,
		/obj/item/storage/secure/briefcase = 2,
	)

/obj/structure/closet/secure_closet/military
	name = "military personnel's locker"
	req_access = list(access_captain)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/military/WillContain()
	return list(
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/shoes/brown,
		/obj/item/radio/headset/heads/captain,
		/obj/item/clothing/gloves/captain,
		/obj/item/gun/energy/gun,
		/obj/item/clothing/suit/armor/captain,
		/obj/item/telebaton,
		/obj/item/clothing/head/caphat,
		/obj/item/clothing/under/captainformal,
		/obj/random/tool = 3
	)