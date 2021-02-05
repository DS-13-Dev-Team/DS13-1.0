/obj/structure/closet/secure_closet/freezer
	name = "refrigerator"
	icon_state = "securenew1"
	icon_closed = "securenew"
	icon_locked = "securenew1"
	icon_opened = "secureopen"
	icon_off = "securenewoff"
	req_access = list(access_service)

/obj/structure/closet/secure_closet/freezer/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/condiment/salt = 2,
		/obj/item/weapon/reagent_containers/food/condiment/flour = 4,
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
		/obj/item/weapon/reagent_containers/food/snacks/meat/beef = 6,
		/obj/item/weapon/reagent_containers/food/snacks/meat/chicken = 4,
		/obj/item/weapon/reagent_containers/food/snacks/fish = 4
	)
/obj/structure/closet/secure_closet/freezer/chicken
	name = "meat fridge"

/obj/structure/closet/secure_closet/freezer/chicken/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/snacks/meat/chicken = 6
	)

/obj/structure/closet/secure_closet/freezer/cheese
	name = "cheese fridge"

/obj/structure/closet/secure_closet/freezer/cheese/WillContain()
	return list(
		/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel = 5
	)