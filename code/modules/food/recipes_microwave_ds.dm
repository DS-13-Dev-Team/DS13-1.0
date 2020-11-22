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
		/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	)
	result = /obj/item/weapon/reagent_containers/food/snacks/necrojelly

/*
/datum/recipe/microwave/foodcubes
	reagents = list(/datum/reagent/enzyme = 20, /datum/reagent/nutriment/virus_food = 5, /datum/reagent/nutriment = 15, /datum/reagent/nutriment/protein = 15) // labor intensive
	items = list()
	result = /obj/item/weapon/storage/box/tray
*/