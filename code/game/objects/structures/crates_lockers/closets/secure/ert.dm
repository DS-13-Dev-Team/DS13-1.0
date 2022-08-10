///////////////////
////ERT Lockers////
///////////////////

// Kellion
/obj/structure/closet/secure_closet/kellion/leader
	name = "security leader's locker"
	req_one_access = list(access_klead)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/kellion/leader/WillContain()
	return list(
	/obj/item/clothing/gloves/combat/kellion,
	/obj/item/radio/headset/ert,
	/obj/item/storage/belt/holster/security/tactical,
	/obj/item/gun/projectile/automatic/pulse_rifle/empty,
	/obj/item/ammo_magazine/pulse = 3,
	/obj/item/gun/projectile/divet/empty,
	/obj/item/ammo_magazine/divet = 3,
	/obj/item/rig/civilian
	)


/obj/structure/closet/secure_closet/kellion/grunt
	name = "security grunt's locker"
	req_one_access = list(access_kgrunt)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/kellion/grunt/WillContain()
	return list(
	/obj/item/clothing/suit/armor/vest/kellion,
	/obj/item/clothing/gloves/combat/kellion,
	/obj/item/radio/headset/ert,
	/obj/item/storage/belt/holster/security/tactical,
	/obj/item/gun/projectile/automatic/pulse_rifle/empty,
	/obj/item/ammo_magazine/pulse = 3,
	/obj/item/gun/projectile/divet/empty,
	/obj/item/ammo_magazine/divet = 3,
	/obj/item/rig/civilian
	)


/obj/structure/closet/secure_closet/kellion/engineer
	name = "engineer's locker"
	req_one_access = list(access_kengineer)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/kellion/engineer/WillContain()
	return list(
	/obj/item/clothing/glasses/meson,
	/obj/item/clothing/gloves/insulated,
	/obj/item/storage/belt/utility/full
	)


/obj/structure/closet/secure_closet/kellion/technician
	name = "repair technician's locker"
	req_one_access = list(access_ktechnician)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/kellion/technician/WillContain()
	return list(
	/obj/item/storage/belt/holster,
	/obj/item/gun/projectile/divet/empty,
	/obj/item/ammo_magazine/divet = 3,
	/obj/item/rig/civilian
	)


//Deliverance
/obj/structure/closet/secure_closet/deliverance/deacon
	name = "deacon's locker"
	req_one_access = list(access_ulead)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/deliverance/deacon/WillContain()
	return list(
	/obj/item/storage/belt/holster/security/tactical,
	/obj/item/gun/projectile/automatic/bullpup,
	/obj/item/ammo_magazine/bullpup = 5,
	/obj/item/storage/bible/unitology
	)

/obj/structure/closet/secure_closet/deliverance/faithful
	name = "faithful's locker"
	req_one_access = list(access_ufaithful)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/deliverance/faithful/WillContain()
	return list(
	/obj/item/storage/belt/holster/security/tactical,
	/obj/item/gun/projectile/automatic/bullpup,
	/obj/item/ammo_magazine/bullpup = 5
	)

/obj/structure/closet/secure_closet/deliverance/berserker
	name = "berserker's locker"
	req_one_access = list(access_uberserker)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/deliverance/berserker/WillContain()
	return list(
	/obj/item/storage/belt/holster/security/tactical,
	/obj/item/gun/projectile/automatic/l6_saw,
	/obj/item/ammo_magazine/box/a556 = 3
	)


/obj/structure/closet/secure_closet/deliverance/healer
	name = "healer's locker"
	req_one_access = list(access_uhealer)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/deliverance/healer/WillContain()
	return list(
	/obj/item/clothing/glasses/hud/health,
	/obj/item/storage/belt/medical,
	/obj/item/gun/projectile/automatic/bullpup,
	/obj/item/ammo_magazine/bullpup = 5

	)


/obj/structure/closet/secure_closet/deliverance/mechanic
	name = "mechanic's locker"
	req_one_access = list(access_umechanic)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/deliverance/mechanic/WillContain()
	return list(
	/obj/item/storage/belt/utility/full,
	/obj/item/gun/projectile/automatic/bullpup,
	/obj/item/ammo_magazine/bullpup = 5,
	/obj/item/clothing/glasses/meson,
	/obj/item/clothing/glasses/welding,
	/obj/item/clothing/gloves/insulated
	)