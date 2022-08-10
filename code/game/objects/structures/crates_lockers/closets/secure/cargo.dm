/obj/structure/closet/secure_closet/cargoservice
	name = "cargo serviceman's locker"
	req_access = list(access_cargo)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/cargoservice/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack = 75,  /obj/item/storage/backpack/satchel/grey = 25)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag, 25),
		/obj/item/clothing/under/deadspace/cargo,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/thick,
		/obj/item/storage/belt/general
	)

/obj/structure/closet/secure_closet/SO
	name = "supply officer's locker"
	req_access = list(access_cargo)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/SO/WillContain()
	return list(
		new/datum/atom_creator/weighted(list(/obj/item/storage/backpack = 75,  /obj/item/storage/backpack/satchel/grey = 25)),
		new/datum/atom_creator/simple(/obj/item/storage/backpack/dufflebag, 25),
		/obj/item/clothing/under/deadspace/cargo,
		/obj/item/clothing/suit/storage/toggle/cargo_jacket,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/radio/headset/headset_cargo,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/suit/fire,
		/obj/item/tank/emergency/oxygen,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/head/soft
	)
