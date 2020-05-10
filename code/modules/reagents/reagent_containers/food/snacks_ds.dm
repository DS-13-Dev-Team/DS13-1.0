/obj/item/weapon/reagent_containers/food/snacks/lobster
	name = "raw lobster"
	desc = "a shifty lobster. You can try eating it, but its shell is extremely tough."
	icon_state = "lobster_raw"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/lobster/Initialize()
	..()
	bitesize = 0.1

/obj/item/weapon/reagent_containers/food/snacks/lobstercooked
	name = "cooked lobster"
	desc = "a luxurious plate of cooked lobster, its taste accentuated by lemon juice. Reinvigorating!"
	icon_state = "lobster_cooked"
	trash = /obj/item/trash/plate
	nutriment_amt = 20
	nutriment_desc = list("lemon" = 2, "lobster" = 5, "salad" = 2)

/obj/item/weapon/reagent_containers/food/snacks/lobstercooked/Initialize()
	..()
	bitesize = 5
	reagents.add_reagent(/datum/reagent/nutriment/protein, 20)

/obj/item/weapon/reagent_containers/food/snacks/cuttlefish
	name = "raw cuttlefish"
	desc = "it's an adorable squid! you can't possible be thinking about eating this right?"
	icon_state = "cuttlefish_raw"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/cuttlefish/Initialize()
	..()
	bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked
	name = "cooked cuttlefish"
	desc = "it's a roasted cuttlefish. rubbery, squishy, an acquired taste."
	icon_state = "cuttlefish_cooked"
	nutriment_amt = 20
	nutriment_desc = list("cuttlefish" = 5, "rubber" = 5, "grease" = 1)

/obj/item/weapon/reagent_containers/food/snacks/cuttlefishcooked/Initialize()
	..()
	bitesize = 5
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfish
	name = "extra large monkfish"
	desc = "it's a huge monkfish. better clean it first, you can't possibly eat it like this."
	icon_state = "monkfish_raw"
	nutriment_amt = 30
	w_class = ITEM_SIZE_HUGE //Is that a monkfish in your pocket, or are you just happy to see me?
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	slices_num = 6
	trash = /obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfish/Initialize()
	..()
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet
	name = "monkfish fillet"
	desc = "it's a fillet sliced from a monkfish."
	icon_state = "monkfish_fillet"
	nutriment_amt = 5

/obj/item/weapon/reagent_containers/food/snacks/monkfishfillet/Initialize()
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

/obj/item/weapon/reagent_containers/food/snacks/monkfishcooked/Initialize()
	..()
	bitesize = 4
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains
	name = "monkfish remains"
	icon_state = "monkfish_remains"
	desc = "the work of a madman."
	w_class = ITEM_SIZE_LARGE
	nutriment_amt = 10
	slice_path = /obj/item/clothing/head/fish
	slices_num = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/monkfishremains/Initialize()
	..()
	bitesize = 0.01 //impossible to eat
	reagents.add_reagent(/datum/reagent/carbon, 5)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/shark
	name = "a measelshark"
	desc = "this beast used to terrorize the sea with its pathogens, incredibly tasty seeing humans can't catch sea-measels."
	icon_state = "sharkmeat_chunk"
	icon = 'icons/obj/food_shark.dmi'
	nutriment_amt = 5
	w_class = ITEM_SIZE_HUGE
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sliceable/sharkchunk
	slices_num = 6

/obj/item/weapon/reagent_containers/food/snacks/sliceable/shark/Initialize()
	..()
	bitesize = 0.01

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sharkchunk
	name = "chunk of shark meat"
	desc = "still rough, needs to be cut into even smaller chunks."
	icon_state = "sharkmeat_chunk"
	nutriment_amt = 15
	w_class = ITEM_SIZE_LARGE
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	slices_num = 5

/obj/item/weapon/reagent_containers/food/snacks/sliceable/sharkchunk/Initialize()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/nutriment/protein, 20)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeat
	name = "a slice of sharkmeat"
	desc = "now it's small enough to cook with."
	icon_state = "sharkmeat"
	nutriment_amt = 2

/obj/item/weapon/reagent_containers/food/snacks/sharkmeat/Initialize()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked
	name = "shark steak"
	desc = "finally, some food for real men."
	icon_state = "sharkmeat_cooked"
	nutriment_amt = 5
	trash = /obj/item/trash/plate
	nutriment_desc = list("manliness" = 1, "fish oil" = 2, "shark" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcooked/Initialize()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatdip
	name = "hot shark shank"
	desc = "a shank of shark meat dipped in hot sauce."
	icon_state = "sharkmeat_dip"
	nutriment_amt = 5
	trash = /obj/item/trash/snack_bowl
	nutriment_desc = list("salt" = 1, "fish oil" = 2, "spicy shark" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatdip/Initialize()
	..()
	bitesize = 3
	reagents.add_reagent(/datum/reagent/capsaicin, 4)
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcubes
	name = "shark cubes"
	desc = "foul scented fermented shark cubes, it's said to make men fly, or just make them really fat."
	icon_state = "sharkmeat_cubes"
	nutriment_amt = 8
	trash = /obj/item/trash/plate
	nutriment_desc = list("viking spirit" = 1, "rot" = 2, "fermented sauce" = 2)

/obj/item/weapon/reagent_containers/food/snacks/sharkmeatcubes/Initialize()
	..()
	bitesize = 10
	reagents.add_reagent(/datum/reagent/drink/juice/potato, 30) // for people who want to get fat, FAST.

/obj/item/weapon/reagent_containers/food/snacks/cube
	name = "protein cube"
	desc = "A colony of meat cells, Just add water!"
	icon_state = "proteincube"
	w_class = ITEM_SIZE_TINY
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	bitesize = 12
	filling_color = "#ADAC7F"
	center_of_mass = list("x"=16, "y"=14)

	var/food_type = "/obj/item/weapon/reagent_containers/food/snacks/proteinslab"

/obj/item/weapon/reagent_containers/food/snacks/cube/Initialize()
	. = ..()

/obj/item/weapon/reagent_containers/food/snacks/cube/proc/Expand()
	src.visible_message("<span class='notice'>\The [src] expands!</span>")
	new food_type(get_turf(src))
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/cube/on_reagent_change()
	if(reagents.has_reagent("water"))
		Expand()

/obj/item/weapon/reagent_containers/food/snacks/cube/protein

/obj/item/weapon/reagent_containers/food/snacks/cube/protein/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/meatcolony, 5)

/obj/item/weapon/reagent_containers/food/snacks/proteinslab
	name = "Protein slab"
	desc = "A slab of near pure protein, extremely artificial, and thoroughly disgusting."
	icon_state = "proteinslab"
	bitesize = 10
	nutriment_amt = 5
	nutriment_desc = list("bitter chyme" = 50)

/obj/item/weapon/reagent_containers/food/snacks/proteinslab/Initialize()
	..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 30)

/obj/item/weapon/reagent_containers/food/snacks/cube/nutriment
	name = "Nutriment cube"
	desc = "A colony of plant cells, Just add water!"
	icon_state = "nutrimentcube"
	food_type = "/obj/item/weapon/reagent_containers/food/snacks/nutrimentslab"

/obj/item/weapon/reagent_containers/food/snacks/cube/nutriment/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/toxin/plantcolony, 5)

/obj/item/weapon/reagent_containers/food/snacks/nutrimentslab
	name = "Nutriment slab"
	desc = "A slab of near pure plant-based nutrients, extremely artificial, and thoroughly disgusting."
	icon_state = "nutrimentslab"
	bitesize = 10
	nutriment_amt = 20
	nutriment_desc = list("compost" = 50)

/obj/item/weapon/storage/box/tray
	name = "ration cube tray"
	desc = "A tray of food cubes, the label warns not to consume before adding water or mixing with virusfood."
	icon = 'icons/obj/food.dmi'
	icon_state = "tray8"
	var/icon_base = "tray"
	startswith = 8
	w_class = ITEM_SIZE_SMALL
	startswith = list(
		/obj/item/weapon/reagent_containers/food/snacks/cube/protein = 4,
		/obj/item/weapon/reagent_containers/food/snacks/cube/nutriment = 4
	)
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/cube/protein,
					/obj/item/weapon/reagent_containers/food/snacks/cube/nutriment)
	foldable = null

/obj/item/weapon/storage/box/tray/Initialize()
	..()
	for(var/i=1 to startswith)
	update_icon()
	return

/obj/item/weapon/storage/box/tray/update_icon()
	var/i = 0
	for(var/obj/item/weapon/reagent_containers/food/snacks/W in contents)
		i++
	icon_state = "[icon_base][i]"