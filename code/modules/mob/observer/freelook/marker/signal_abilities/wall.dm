/datum/signal_ability/placement/corruption/wall
	name = "Hardened Growth"
	id = "wall"
	desc = "Creates an impassable object to block a tile"
	energy_cost = 70
	placement_atom = /obj/structure/corruption_node/wall


/*
	The actual atom
*/
/obj/structure/corruption_node/wall
	name = "Hardened Growth"
	desc = "...to the last I grapple with thee; from hell's heart I stab at thee;"
	anchored = TRUE
	density = TRUE
	opacity = TRUE
	layer = ABOVE_OBJ_LAYER	//Make sure nodes draw ontop of corruption
	icon = 'icons/effects/corruption32x48.dmi'
	icon_state = "wall"
	marker_spawnable = FALSE	//When true, this automatically shows in the necroshop
	biomass = 0
	requires_corruption = TRUE
	random_rotation = TRUE	//If true, set rotation randomly on spawn
	scale = 2.5
	pixel_y = 6

	max_health = 60
	resistance = 6

//Wall has a smaller random rotation range
/obj/structure/corruption_node/wall/set_rotation()
	var/matrix/M = matrix()
	var/rotation = rand_between(-25, 25)//Randomly rotate it

	transform = turn(M, rotation - cached_rotation)

	cached_rotation = rotation

/obj/structure/corruption_node/wall/update_icon()
	overlays.Cut()
	.=..()
	var/image/I = image(icon, src, icon_state)
	var/matrix/M = matrix()
	I.transform = turn(M, rand_between(-35, 35))
	I.pixel_x = -12
	overlays.Add(I)

	I = image(icon, icon_state)
	I.transform = turn(M, rand_between(-35, 35))
	I.pixel_x = 12
	overlays.Add(I)

/obj/structure/corruption_node/wall/get_blurb()
	. = "This node acts as a defensive wall, blocking movement and vision on the tile it's placed. The hardened growth can stall attackers for a few seconds, but it is not very durable, and easily overcome with hand tools.<br>\
	It does offer several creative possibilities. They can be placed to guard nothing in order to waste people's time, or hide cysts behind them that will fire as soon as they have a clear line of sight."