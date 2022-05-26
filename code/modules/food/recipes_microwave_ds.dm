/datum/recipe/microwave/bacon
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/rawbacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/bacon

/datum/recipe/microwave/baconcheeseburger
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheeseburger,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/baconcheeseburger

/datum/recipe/microwave/baconcheeseburger
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/baconcheeseburger

/datum/recipe/microwave/deluxebaconcheeseburger
	fruit = list("cabbage" = 1, "tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/baconcheeseburger,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/deluxebaconcheeseburger

/datum/recipe/microwave/deluxebaconcheeseburger
	fruit = list("cabbage" = 1, "tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheeseburger,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/deluxebaconcheeseburger

/datum/recipe/microwave/deluxebaconcheeseburger
	fruit = list("cabbage" = 1, "tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bun,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cutlet,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/deluxebaconcheeseburger

/datum/recipe/microwave/baconandeggs
	reagents = list(/datum/reagent/blackpepper = 1, /datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/egg,
		/obj/item/weapon/reagent_containers/food/snacks/egg
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/baconandeggs

/datum/recipe/microwave/blt
	fruit = list("cabbage" = 1, "tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/blt

/datum/recipe/microwave/xlclubsandwich
	fruit = list("cabbage" = 1, "tomato" = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/slice/bread,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/meat/chicken,
		/obj/item/weapon/reagent_containers/food/snacks/bacon,
		/obj/item/weapon/reagent_containers/food/snacks/bacon
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/xlclubsandwich

/datum/recipe/microwave/lobster
	fruit = list()
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/lobster
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/lobstercooked

/datum/recipe/microwave/cuttlefish
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cuttlefish
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked

/datum/recipe/microwave/monkfish
	fruit = list()
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/monkfishcooked

/datum/recipe/microwave/sharksteak
	reagents = list(/datum/reagent/blackpepper = 1, /datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked

/datum/recipe/microwave/sharkdip
	reagents = list(/datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sharkmeatdip

/datum/recipe/microwave/sharkcubes
	reagents = list(/datum/reagent/nutriment/soysauce = 5, /datum/reagent/sodiumchloride = 1)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sharkmeatcubes

/datum/recipe/microwave/necrojelly
	reagents = list(/datum/reagent/sugar = 5)
	items = list(
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge,
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/sliceable/jellycube

/*
/datum/recipe/microwave/foodcubes
	reagents = list(/datum/reagent/enzyme = 20, /datum/reagent/nutriment/virus_food = 5, /datum/reagent/nutriment = 15, /datum/reagent/nutriment/protein = 15) // labor intensive
	items = list()
	result = /obj/item/weapon/storage/box/tray
*/