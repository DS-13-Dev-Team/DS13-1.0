/obj/structure/closet/secure_closet/DOM
	name = "director of mining's closet"
	req_access = list(access_dom)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/DOM/WillContain()
	return list(
		/obj/item/device/radio/headset/heads/dom,
		/obj/item/clothing/under/suit_jacket/dom,
		/obj/item/clothing/shoes/dress,
		/obj/item/clothing/accessory/black,
		/obj/item/weapon/storage/briefcase,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/staff/gentcane,
		/obj/item/device/flashlight/maglight
)

/obj/structure/closet/secure_closet/foreman
	name = "mining foreman's closet"
	req_access = list(access_mf)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/foreman/WillContain()
		return list(
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/clothing/under/foreman,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/gloves/thick,
		/obj/item/weapon/mining_scanner,
		/obj/item/weapon/storage/ore,
		/obj/item/weapon/tool/shovel,
		/obj/item/weapon/tool/saw/plasma,
		/obj/item/weapon/gun/energy/cutter,
		/obj/item/weapon/cell/plasmacutter = 2,
		/obj/item/device/flashlight/maglight,
		/obj/item/weapon/rig/vintage
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
		/obj/item/clothing/under/deadspace/planet_cracker,
		/obj/item/clothing/shoes/dutyboots,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/gloves/thick,
		/obj/item/weapon/mining_scanner,
		/obj/item/weapon/storage/ore,
		/obj/item/weapon/tool/shovel,
		/obj/item/weapon/tool/saw/plasma,
		/obj/item/weapon/tool/pickaxe/laser,
		/obj/item/weapon/rig/mining,
		/obj/item/device/flashlight/maglight
	)


/obj/structure/closet/secure_closet/planet_cracker/New(var/atom/location)
	if (prob(30))	//Not all planet crackers get a cutter
		new /obj/item/weapon/gun/energy/cutter(src)

	.=..()