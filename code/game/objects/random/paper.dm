/obj/random/paper/cec
	name = "Random Paper - Low"
	desc = "This is a low chance random paper."
	icon = 'icons/misc/landmarks.dmi'
	icon_state = "radnomstuff-grey-low"
	spawn_nothing_percentage = RARELY
	max_amount = FEW

/obj/random/paper/cec/item_to_spawn()
	return pickweight(list(/obj/item/paper/ishimura/fcprotocol = 1))

/obj/random/paper/cec/low
	name = "Random Paper - Low"
	desc = "This is a low chance random paper."
	icon = 'icons/misc/landmarks.dmi'
	icon_state = "radnomstuff-grey-low"
	spawn_nothing_percentage = OFTEN
	max_amount = FEW

/obj/random/paper/cec/item_to_spawn()
	return pickweight(list(/obj/item/paper/ishimura/fcprotocol = 1))