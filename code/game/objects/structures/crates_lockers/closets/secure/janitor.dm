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
	return list(/obj/item/reagent_containers/glass/bucket,
				/obj/item/mop,
				/obj/item/caution = 4,
				/obj/item/storage/bag/trash,
				/obj/item/lightreplacer,
				/obj/item/clothing/shoes/galoshes,
				/obj/item/reagent_containers/spray/cleaner,
				/obj/item/reagent_containers/glass/rag,
				/obj/item/grenade/chem_grenade/cleaner = 3,
				/obj/structure/mopbucket)