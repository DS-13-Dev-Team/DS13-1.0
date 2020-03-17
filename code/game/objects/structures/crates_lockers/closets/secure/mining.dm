/obj/structure/closet/secure_closet/DOM
	name = "director of mining's closet"
	req_access = list(access_mining)
	icon_state = "cabinetdetective_locked"
	icon_closed = "cabinetdetective"
	icon_locked = "cabinetdetective_locked"
	icon_opened = "cabinetdetective_open"
	icon_broken = "cabinetdetective_sparks"
	icon_off = "cabinetdetective_broken"

/obj/structure/closet/secure_closet/DOM/WillContain()
	return list(
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/under/suit_jacket/dom,
		/obj/item/clothing/shoes/dress,
		/obj/item/weapon/storage/secure/briefcase/money,
		/obj/item/weapon/storage/briefcase,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/staff/gentcane,
		/obj/item/device/flashlight/maglight
)

/obj/structure/closet/secure_closet/foreman
	name = "mining foreman's closet"
	req_access = list(access_mining)
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_off = "miningsecoff"

/obj/structure/closet/secure_closet/foreman/WillContain()
		return list(
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/under/foreman,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/clothing/gloves/thick,
		/obj/item/weapon/storage/ore,
		/obj/item/weapon/shovel,
		/obj/item/weapon/tool/saw/plasma,
		/obj/item/device/flashlight/maglight,
		/obj/item/weapon/gun/energy/cutter
)

/obj/structure/closet/secure_closet/planet_cracker
	name = "planet cracker's equipment"
	req_access = list(access_mining)
	icon_state = "miningsec1"
	icon_closed = "miningsec"
	icon_locked = "miningsec1"
	icon_opened = "miningsecopen"
	icon_off = "miningsecoff"

/obj/structure/closet/secure_closet/planet_cracker/WillContain()
		return list(
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/under/miner/deadspace,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/clothing/gloves/thick,
		/obj/item/weapon/storage/ore,
		/obj/item/weapon/shovel,
		/obj/item/weapon/tool/saw/plasma,
		/obj/item/device/flashlight/maglight
	)


/obj/structure/closet/secure_closet/planet_cracker/New(var/atom/location)
	if (prob(20))	//Not all planet crackers get a cutter
		new /obj/item/weapon/gun/energy/cutter(src)

	.=..()