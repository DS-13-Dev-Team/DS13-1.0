/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(access_service)
	icon_state = "secure1"
	icon_closed = "secure"
	icon_locked = "secure1"
	icon_opened = "secureopen"
	icon_off = "secureoff"

/obj/structure/closet/secure_closet/hydroponics/WillContain()
	return list(
		/obj/item/storage/plants,
		/obj/item/clothing/under/deadspace/hydroponics,
		/obj/item/analyzer/plant_analyzer,
		/obj/item/radio/headset/headset_service,
		/obj/item/material/minihoe,
		/obj/item/material/hatchet,
		/obj/item/tool/wirecutters/clippers,
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/clothing/gloves/thick/botany
	)
