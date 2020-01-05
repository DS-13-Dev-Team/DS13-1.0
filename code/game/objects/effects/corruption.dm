/obj/effect/corruption // placeholder with basic icon functionality
	name = "corruption"
	icon = 'icons/effects/corruption.dmi'
	icon_state = "corruption-1"

	anchored = 1.0
	var/random_icon = 1 //wether or not a tile is to pick a random icon.
	var/edge_icon = "corruption-edge" //making this a variable in case we want variants of corruption. Needs to be implemented

/obj/effect/corruption/Initialize()
	. = ..()
	if(random_icon)
		var/i = rand(1,3)
		icon_state  = "corruption-[i]"

obj/effect/corruption/node
	name = "corruption node"
	icon_state = "corruption-node"
	random_icon = 0
