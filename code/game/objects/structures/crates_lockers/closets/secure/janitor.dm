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
	return list(/obj/item/weapon/reagent_containers/glass/bucket,
				/obj/item/weapon/mop,
				/obj/item/weapon/caution = 4,
				/obj/item/weapon/storage/bag/trash,
				/obj/item/device/lightreplacer,
				/obj/item/weapon/reagent_containers/spray/cleaner,
				/obj/item/weapon/reagent_containers/glass/rag,
				/obj/item/weapon/grenade/chem_grenade/cleaner = 3,
				/obj/structure/mopbucket)