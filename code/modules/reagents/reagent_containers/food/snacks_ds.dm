/obj/item/weapon/reagent_containers/food/snacks/lobster
	name = "raw lobster"
	desc = "A shifty lobster. You can try eating it, but its shell is extremely tough."
	icon_state = "lobster_raw"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/lobster/New()
	..()
	bitesize = 0.1

/obj/item/weapon/reagent_containers/food/snacks/lobstercooked
	name = "cooked lobster"
	desc = "A luxurious plate of cooked lobster, its taste accentuated by lemon juice. Reinvigorating!"
	icon_state = "lobster_cooked"
	trash = /obj/item/trash/plate
	nutriment_amt = 20
	nutriment_desc = list("lemon" = 2, "lobster" = 5, "salad" = 2)

/obj/item/weapon/reagent_containers/food/snacks/lobstercooked/New()
	..()
	bitesize = 5
	reagents.add_reagent(/datum/reagent/nutriment/protein, 20)

/obj/item/weapon/reagent_containers/food/snacks/cuttlefish
	name = "raw cuttlefish"
	desc = "It's an adorable squid! you can't possible be thinking about eating this right?"
	icon_state = "cuttlefish_raw"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/cuttlefish/New()
	..()
	bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked
	name = "cooked cuttlefish"
	desc = "It's a roasted cuttlefish. rubbery, squishy, an acquired taste."
	icon_state = "cuttlefish_cooked"
	nutriment_amt = 20
	nutriment_desc = list("cuttlefish" = 5, "rubber" = 5, "grease" = 1)

/obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked/New()
	..()
	bitesize = 5
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfish
	name = "extra large monkfish"
	desc = "It's a huge monkfish. better clean it first, you can't possibly eat it like this."
	icon = 'icons/obj/food48x48.dmi'
	icon_state = "monkfish_raw"
	nutriment_amt = 30
	w_class = ITEM_SIZE_HUGE //Is that a monkfish in your pocket, or are you just happy to see me?
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	slices_num = 6
	trash = /obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfish/New()
	..()
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	name = "monkfish fillet"
	desc = "It's a fillet sliced from a monkfish."
	icon_state = "monkfish_fillet"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet/New()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/nutriment/protein, 1)

/obj/item/weapon/reagent_containers/food/snacks/monkfishcooked
	name = "seasoned monkfish"
	desc = "a delicious slice of monkfish prepared with sweet chili and spring onion."
	icon_state = "monkfish_cooked"
	nutriment_amt = 10
	nutriment_desc = list("fish" = 3, "oil" = 1, "sweet chili" = 3, "spring onion" = 2)
	trash = /obj/item/trash/fancyplate

/obj/item/weapon/reagent_containers/food/snacks/monkfishcooked/New()
	..()
	bitesize = 4
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains
	name = "monkfish remains"
	icon_state = "monkfish_remains"
	desc = "The work of a madman."
	w_class = ITEM_SIZE_LARGE
	nutriment_amt = 10
	slice_path = /obj/item/clothing/head/fish
	slices_num = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains/New()
	..()
	bitesize = 0.01 //impossible to eat
	reagents.add_reagent(/datum/reagent/carbon, 5)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/shark
	name = "a measelshark"
	desc = "This beast used to terrorize the sea with its pathogens, incredibly tasty seeing humans can't catch sea-measels."
	icon_state = "measelshark"
	icon = 'icons/obj/food_shark.dmi'
	nutriment_amt = 5
	w_class = ITEM_SIZE_HUGE
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/sharkchunk
	slices_num = 6

/obj/item/weapon/reagent_containers/food/snacks/sliceable/shark/New()
	..()
	bitesize = 0.01

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sharkchunk
	name = "chunk of shark meat"
	desc = "Still rough, needs to be cut into even smaller chunks."
	icon_state = "sharkmeat_chunk"
	nutriment_amt = 15
	w_class = ITEM_SIZE_LARGE
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	slices_num = 5

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sharkchunk/New()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/nutriment/protein, 20)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	name = "a slice of sharkmeat"
	desc = "A raw cut of shark meat."
	icon_state = "sharkmeat"
	nutriment_amt = 2

/obj/item/weapon/reagent_containers/food/snacks/sharkmeat/New()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked
	name = "shark steak"
	desc = "Finally, some food for real men."
	icon_state = "sharkmeat_cooked"
	nutriment_amt = 5
	trash = /obj/item/trash/plate
	nutriment_desc = list("manliness" = 1, "fish oil" = 2, "shark" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked/New()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatdip
	name = "hot shark shank"
	desc = "A shank of shark meat dipped in hot sauce."
	icon_state = "sharkmeat_dip"
	nutriment_amt = 5
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("salt" = 1, "fish oil" = 2, "spicy shark" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatdip/New()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/capsaicin, 4)
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcubes
	name = "shark cubes"
	desc = "Foul-scented, fermented shark cubes. It's said to make men fly . . . or just really fat."
	icon_state = "sharkmeat_cubes"
	nutriment_amt = 8
	trash = /obj/item/trash/plate
	nutriment_desc = list("viking spirit" = 1, "rot" = 2, "fermented sauce" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcubes/New()
	..()
	bitesize = 10
	reagents.add_reagent(/datum/reagent/drink/juice/potato, 30) // for people who want to get fat, FAST.

/obj/item/weapon/reagent_containers/food/snacks/necrojelly
	name = "suspicious jello"
	desc = "The chef's creativity appears to be oddly menacing."
	icon_state = "necrojelly"
	nutriment_amt = 10
	nutriment_desc = list("Evil" = 10)

/obj/item/weapon/reagent_containers/food/snacks/necrojelly/New()
	..()
	bitesize = 2
	reagents.add_reagent(/datum/reagent/drink/milk = 5)
