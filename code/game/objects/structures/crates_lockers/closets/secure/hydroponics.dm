/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_service)
	icon_state = "hydrosecure1"
	icon_closed = "hydrosecure"
	icon_locked = "hydrosecure1"
	icon_opened = "hydrosecureopen"
	icon_off = "hydrosecureoff"

/obj/structure/closet/secure_closet/hydroponics/WillContain()
	return list(
		/obj/item/weapon/storage/plants,
		/obj/item/clothing/under/deadspace/hydroponics,
		/obj/item/device/analyzer/plant_analyzer,
		/obj/item/device/radio/headset/headset_service,
		/obj/item/weapon/material/minihoe,
		/obj/item/weapon/material/hatchet,
		/obj/item/weapon/tool/wirecutters/clippers,
		/obj/item/weapon/reagent_containers/spray/plantbgone,
		/obj/item/clothing/gloves/thick/botany
	)
