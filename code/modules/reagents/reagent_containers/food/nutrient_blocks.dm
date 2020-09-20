/obj/item/weapon/reagent_containers/food/snacks/cube
	name = "protein cube"
	desc = "A compressed, dessicated block of nutrients, needs water to expand. It's a lot heavier than it looks!"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	icon = 'icons/obj/food/foodblocks.dmi'
	icon_state = "proteincube"
	bitesize = 12
	filling_color = "#adac7f"
	center_of_mass = "x=16;y=14"

	w_class = ITEM_SIZE_NORMAL

	var/growing = 0
	var/content_reagent = /datum/reagent/toxin/meatcolony
	var/grown_type = /obj/item/weapon/reagent_containers/food/snacks/block

/obj/item/weapon/reagent_containers/food/snacks/cube/get_biomass()
	return 0	//Worth no biomass until expanded

/obj/item/weapon/reagent_containers/food/snacks/cube/veg
	name = "nutrient cube"
	icon_state = "nutrimentcube"
	content_reagent = /datum/reagent/toxin/plantcolony
	grown_type = /obj/item/weapon/reagent_containers/food/snacks/block/veg

/obj/item/weapon/reagent_containers/food/snacks/cube/New()
	..()
	reagents.add_reagent(content_reagent, 10)


/obj/item/weapon/reagent_containers/food/snacks/cube/proc/Expand()
	if(!growing)
		growing = 1
		src.visible_message("<span class='notice'>\The [src] expands!</span>")
		var/atom/movable/block = new grown_type
		block.dropInto(src.loc)
		qdel(src)


/obj/item/weapon/reagent_containers/food/snacks/cube/on_reagent_change()
	if(reagents.has_reagent(/datum/reagent/water))
		Expand()



/*
	Expanded form
*/
/obj/item/weapon/reagent_containers/food/snacks/block
	desc = "A broad slab of nutrients, weighing 1 kg"
	icon = 'icons/obj/food/foodblocks.dmi'
	icon_state = "proteinslab"
	var/reagent_type = /datum/reagent/nutriment/protein

	w_class = ITEM_SIZE_LARGE

/obj/item/weapon/reagent_containers/food/snacks/block/veg
	icon_state = "nutrimentslab"
	reagent_type = /datum/reagent/nutriment

/obj/item/weapon/reagent_containers/food/snacks/block/New()
	..()
	reagents.add_reagent(reagent_type, 100)



/*
	Storage Tray
*/
/obj/item/weapon/storage/fancy/nutricube_tray
	name = "Nutricube Storage Tray"
	desc = "A tray full of nutrient cubes, this is much heavier than it looks."
	icon = 'icons/obj/food/foodblocks.dmi'
	icon_state = "tray0"
	item_state = "nutrient cube tray" //placeholder, many of these don't have inhands
	key_type = /obj/item/weapon/reagent_containers/food/snacks/cube//path of the key item that this "fancy" container is meant to store

	storage_slots = 8
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_HUGE
	opened = TRUE


/obj/item/weapon/storage/fancy/nutricube_tray/filled
	name = "Nutricube Storage Tray"
	desc = "A tray full of nutrient cubes, this is much heavier than it looks."
	icon_state = "tray8"
	startswith = list(/obj/item/weapon/reagent_containers/food/snacks/cube = 4, /obj/item/weapon/reagent_containers/food/snacks/cube/veg = 4)