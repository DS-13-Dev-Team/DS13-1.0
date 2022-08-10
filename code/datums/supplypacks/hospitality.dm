/decl/hierarchy/supply_pack/hospitality
	name = "Hospitality"

/decl/hierarchy/supply_pack/hospitality/party
	name = "Party equipment"
	contains = list(
			/obj/item/storage/box/mixedglasses = 2,
			/obj/item/storage/box/glasses/square,
			/obj/item/reagent_containers/food/drinks/shaker,
			/obj/item/reagent_containers/food/drinks/flask/barflask,
			/obj/item/reagent_containers/food/drinks/bottle/patron,
			/obj/item/reagent_containers/food/drinks/bottle/goldschlager,
			/obj/item/reagent_containers/food/drinks/bottle/specialwhiskey,
			/obj/item/storage/fancy/cigarettes/dromedaryco,
			/obj/item/reagent_containers/food/drinks/bottle/small/ale = 2,
			/obj/item/reagent_containers/food/drinks/bottle/small/beer = 4,
			/obj/item/storage/box/glowsticks = 2)
	cost = 20
	containername = "\improper Party equipment"

// TODO; Add more premium drinks at a later date. Could be useful for diplomatic events or fancy parties.
/decl/hierarchy/supply_pack/hospitality/premiumalcohol
	name = "Premium drinks crate"
	contains = list(/obj/item/reagent_containers/food/drinks/bottle/premiumwine = 1,
					/obj/item/reagent_containers/food/drinks/bottle/premiumvodka = 1)
	cost = 60
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Premium drinks"

/decl/hierarchy/supply_pack/hospitality/barsupplies
	name = "Bar supplies"
	contains = list(
			/obj/item/storage/box/glasses/cocktail,
			/obj/item/storage/box/glasses/rocks,
			/obj/item/storage/box/glasses/square,
			/obj/item/storage/box/glasses/pint,
			/obj/item/storage/box/glasses/wine,
			/obj/item/storage/box/glasses/shake,
			/obj/item/storage/box/glasses/shot,
			/obj/item/storage/box/glasses/mug,
			/obj/item/reagent_containers/food/drinks/shaker,
			/obj/item/storage/box/glass_extras/straws,
			/obj/item/storage/box/glass_extras/sticks
			)
	cost = 10
	containername = "crate of bar supplies"

/decl/hierarchy/supply_pack/hospitality/pizza
	num_contained = 5
	name = "Surprise pack of five pizzas"
	contains = list(/obj/item/pizzabox/margherita,
					/obj/item/pizzabox/mushroom,
					/obj/item/pizzabox/meat,
					/obj/item/pizzabox/vegetable)
	cost = 15
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Pizza crate"
	supply_method = /decl/supply_method/randomized


/decl/hierarchy/supply_pack/hospitality/bacon
	name = "Bacon crate"
	contains = list(/obj/item/reagent_containers/food/snacks/rawbacon = 20)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Bacon crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/beef
	name = "Beef crate"
	contains = list(/obj/item/reagent_containers/food/snacks/meat/beef = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Beef crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/goat
	name = "Goat meat crate"
	contains = list(/obj/item/reagent_containers/food/snacks/meat/goat = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Goat meat crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/chicken
	name = "Chicken meat crate"
	contains = list(/obj/item/reagent_containers/food/snacks/meat/chicken = 6)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Chicken meat crate"
	cost = 20

/decl/hierarchy/supply_pack/hospitality/eggs
	name = "Eggs crate"
	contains = list(/obj/item/storage/fancy/egg_box = 2)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Egg crate"
	cost = 15

/decl/hierarchy/supply_pack/hospitality/milk
	name = "Milk crate"
	contains = list(/obj/item/reagent_containers/food/drinks/milk = 3)
	containertype = /obj/structure/closet/crate/freezer
	containername = "\improper Milk crate"
	cost = 15

/decl/hierarchy/supply_pack/hydroponics/fish
	name = "Fish supply crate"
	contains = list(
			/obj/item/reagent_containers/food/snacks/lobster = 6,
			/obj/item/reagent_containers/food/snacks/cuttlefish = 8,
			/obj/item/reagent_containers/food/snacks/sliceable/monkfish = 1
			)
	cost = 20
	containertype = /obj/structure/closet/crate/freezer
	containername = "Fish crate"