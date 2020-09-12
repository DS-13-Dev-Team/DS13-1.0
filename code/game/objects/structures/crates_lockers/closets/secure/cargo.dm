/obj/structure/closet/secure_closet/cargoservice
	name = "cargo serviceman's locker"
	req_access = list(access_cargo)
	icon_state = "securecargo1"
	icon_closed = "securecargo"
	icon_locked = "securecargo1"
	icon_opened = "securecargoopen"
	icon_off = "securecargooff"

/obj/structure/closet/secure_closet/cargoservice/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack = 75,  /obj/item/weapon/storage/backpack/satchel/grey = 25)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag, 25),
		/obj/item/clothing/under/cargo_deadspace,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/thick,
		/obj/item/weapon/storage/belt/general
	)

/obj/structure/closet/secure_closet/SO
	name = "supply officer's locker"
	req_access = list(access_cargo)
	icon_state = "secureqm1"
	icon_closed = "secureqm"
	icon_locked = "secureqm1"
	icon_opened = "secureqmopen"
	icon_off = "secureqmoff"

/obj/structure/closet/secure_closet/SO/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack = 75,  /obj/item/weapon/storage/backpack/satchel/grey = 25)),
		new/datum/atom_creator/simple(/obj/item/weapon/storage/backpack/dufflebag, 25),
		/obj/item/clothing/under/cargo_deadspace,
		/obj/item/clothing/suit/storage/toggle/cargo_jacket,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/weapon/tank/emergency/oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/head/soft
	)
