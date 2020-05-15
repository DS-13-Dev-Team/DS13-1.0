/obj/structure/closet/secure_closet/freezer
	name = "refrigerator"
	icon_state = "fridge1"
	icon_closed = "fridge"
	icon_locked = "fridge1"
	icon_opened = "fridgeopen"
	icon_off = "fridgebroken"
	req_access = list(access_service)

/obj/structure/closet/secure_closet/freezer/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/condiment/salt = 2,
		/obj/item/weapon/reagent_containers/food/condiment/flour = 10,
		/obj/item/weapon/reagent_containers/food/condiment/sugar = 4,
		/obj/item/weapon/reagent_containers/food/drinks/milk = 6,
		/obj/item/weapon/reagent_containers/food/drinks/soymilk = 4,
		/obj/item/weapon/reagent_containers/food/condiment/enzyme = 2,
		/obj/item/weapon/storage/fancy/egg_box = 6
	)

/obj/structure/closet/secure_closet/freezer/meat
	name = "meat fridge"

/obj/structure/closet/secure_closet/freezer/meat/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/beef = 12
	)

/obj/structure/closet/secure_closet/freezer/chicken
	name = "meat fridge"

/obj/structure/closet/secure_closet/freezer/chicken/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/chicken = 10,
		/obj/item/weapon/reagent_containers/food/snacks/carpmeat/safe = 10
	)

/obj/structure/closet/secure_closet/freezer/cheese
	name = "cheese fridge"

/obj/structure/closet/secure_closet/freezer/cheese/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel = 10
	)