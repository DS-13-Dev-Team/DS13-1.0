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
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/captain, /obj/item/weapon/storage/backpack/satchel_cap)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag/captain, 50),
		/obj/item/clothing/head/helmet,
		/obj/item/clothing/shoes/brown,
		/obj/item/device/radio/headset/heads/captain,
		/obj/item/clothing/gloves/captain,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/suit/armor/captain,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/head/caphat,
		/obj/item/clothing/under/captainformal,
		/obj/item/weapon/rig/vintage,
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
		/obj/item/device/radio/headset/heads/fl,
		/obj/item/weapon/storage/box/ids = 2,
		/obj/item/weapon/gun/projectile/sec/flash,
		/obj/item/device/flash
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
	req_access = list(access_armory)
	icon_state = "sec1"
	icon_closed = "sec"
	icon_locked = "sec1"
	icon_opened = "secopen"
	icon_off = "secoff"

/obj/structure/closet/secure_closet/CSECO/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/security, /obj/item/weapon/storage/backpack/satchel_sec)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag/sec, 50),
		/obj/item/clothing/under/deadspace/security/cseco,
		/obj/item/clothing/suit/armor/pcsi,
		/obj/item/clothing/head/helmet/pcsi,
		/obj/item/clothing/shoes/pcsi,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/gloves/combat/pcsi,
		/obj/item/clothing/accessory/storage/webbing/security,
		/obj/item/device/radio/headset/heads/cseco,
		/obj/item/weapon/storage/belt/holster/security,
		/obj/item/weapon/gun/projectile/divet,
		/obj/item/ammo_magazine/divet = 2,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/storage/box/holobadge,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/device/flash,
		/obj/item/device/holowarrant,
		/obj/item/device/flashlight/maglight
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
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/security, /obj/item/weapon/storage/backpack/satchel_sec)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/sec, /obj/item/weapon/storage/backpack/messenger/sec)),
		/obj/item/clothing/under/deadspace/security,
		/obj/item/clothing/suit/armor/pcsi,
		/obj/item/clothing/head/helmet/pcsi,
		/obj/item/clothing/shoes/pcsi,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/clothing/accessory/storage/webbing/security,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/gloves/combat/pcsi,
		/obj/item/clothing/gloves/forensic,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/weapon/storage/belt/holster/forensic,
		/obj/item/weapon/storage/belt/holster/security,
		/obj/item/weapon/gun/projectile/divet,
		/obj/item/ammo_magazine/divet = 2,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/device/flash,
		/obj/item/device/holowarrant,
		/obj/item/device/flashlight/maglight
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
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/security, /obj/item/weapon/storage/backpack/satchel_sec)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag/sec, 50),
		/obj/item/clothing/under/deadspace/security,
		/obj/item/clothing/suit/armor/pcsi,
		/obj/item/clothing/head/helmet/pcsi,
		/obj/item/clothing/shoes/pcsi,
		/obj/item/clothing/glasses/hud/security,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/gloves/combat/pcsi,
		/obj/item/clothing/accessory/storage/webbing/security,
		/obj/item/device/radio/headset/headset_sec,
		/obj/item/weapon/storage/belt/holster/security,
		/obj/item/weapon/gun/projectile/divet,
		/obj/item/ammo_magazine/divet = 2,
		/obj/item/weapon/reagent_containers/spray/pepper,
		/obj/item/weapon/melee/baton/loaded,
		/obj/item/taperoll/police,
		/obj/item/device/hailer,
		/obj/item/device/flash,
		/obj/item/device/holowarrant,
		/obj/item/device/flashlight/maglight
	)

/obj/structure/closet/secure_closet/security/cargo/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
		/obj/item/clothing/accessory/armband/cargo,
		/obj/item/device/encryptionkey/headset_cargo
	))

/obj/structure/closet/secure_closet/security/engine/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
			/obj/item/clothing/accessory/armband/engine,
			/obj/item/device/encryptionkey/headset_eng
		))

/obj/structure/closet/secure_closet/security/science/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(/obj/item/device/encryptionkey/headset_sci))

/obj/structure/closet/secure_closet/security/med/WillContain()
	return MERGE_ASSOCS_WITH_NUM_VALUES(..(), list(
			/obj/item/clothing/accessory/armband/medgreen,
			/obj/item/device/encryptionkey/headset_med
		))

/obj/structure/closet/secure_closet/injection
	name = "lethal injections locker"
	req_access = list(access_captain)

/obj/structure/closet/secure_closet/injection/WillContain()
	return list(/obj/item/weapon/reagent_containers/syringe/ld50_syringe/choral = 2)

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

/obj/structure/closet/secure_closet/courtroom
	name = "courtroom locker"
	req_access = list(access_security)

/obj/structure/closet/secure_closet/courtroom/WillContain()
	return list(
		/obj/item/clothing/shoes/brown,
		/obj/item/weapon/paper/Court = 3,
		/obj/item/weapon/pen,
		/obj/item/clothing/suit/judgerobe,
		/obj/item/weapon/storage/briefcase
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
		/obj/item/device/flash = 2,
		/obj/item/device/camera = 2,
		/obj/item/device/camera_film = 2,
		/obj/item/device/taperecorder = 2,
		/obj/item/weapon/storage/secure/briefcase = 2,
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
		/obj/item/device/radio/headset/heads/captain,
		/obj/item/clothing/gloves/captain,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/suit/armor/captain,
		/obj/item/weapon/melee/telebaton,
		/obj/item/clothing/head/caphat,
		/obj/item/clothing/under/captainformal,
		/obj/random/tool = 3
	)