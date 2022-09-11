/obj/structure/closet/secure_closet/janitor
	name = "janitor's closet"
	req_access = list(access_service)
	icon_state = "secureeng1"
	icon_closed = "secureeng"
	icon_locked = "secureeng1"
	icon_opened = "secureengopen"
	icon_broken = "secureengoff"
	icon_off = "secureengoff"

/obj/structure/closet/secure_closet/janitor/WillContain()
	return list(
		/obj/item/clothing/under/rank/janitor,
		/obj/item/radio/headset/headset_service,
		/obj/item/clothing/gloves/thick,
		/obj/item/flashlight,
		/obj/item/caution = 4,
		/obj/item/lightreplacer,
		/obj/item/storage/bag/trash,
		/obj/item/clothing/shoes/galoshes,
		/obj/item/clothing/accessory/solgov/specialty/janitor,
		/obj/item/reagent_containers/glass/rag,
		/obj/item/soap,
		/obj/item/mop,
		/obj/item/reagent_containers/glass/bucket,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/grenade/chem_grenade/cleaner,
		/obj/item/reagent_containers/spray/cleaner,
		/obj/item/rig_module/grenade_launcher/cleaner,
		/obj/item/rig_module/fabricator/wf_sign,
		/obj/random/tool)