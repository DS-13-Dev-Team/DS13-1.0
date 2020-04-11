/obj/structure/corruption_node/growth
	name = "Propagator"
	desc = "Corruption spreads out in all directions from this horrible mass."
	max_health = 200	//Takes a while to kill
	resistance = 8
	icon_state = "growth"
	density = FALSE

	var/range = 12
	var/speed = 1
	var/falloff = 0.15


/obj/structure/corruption_node/growth/Initialize()
	.=..()
	if (!dummy)	//Don't do this stuff if its a dummy for placement preview

		set_extension(src, /datum/extension/corruption_source, range, speed, falloff)
		//new /obj/effect/vine/corruption(get_turf(src),GLOB.corruption_seed, start_matured = 1)

/obj/structure/corruption_node/growth/get_blurb()
	. = "This node acts as a heart for corruption spread, allowing it to extend out up to [range] tiles in all directions from the node. It must be placed on existing corruption from another propagator node, or from the marker."


/*
	Smaller version for signals
*/
/obj/structure/corruption_node/growth/branch
	name = "Branch"
	desc = "This is just a tribute"
	max_health = 60//Takes a while to kill
	resistance = 6
	icon_state = "minigrowth"
	density = FALSE
	biomass = 5

	range = 6
	speed = 0.9
	falloff = 0.2


/obj/structure/corruption_node/growth/get_blurb()
	. = "This node acts as a smaller source for corruption spread, allowing it to extend out up to [range] tiles in all directions from the node. It must be placed on existing corruption from another propagator node, or from the marker."


/datum/signal_ability/placement/corruption/branch
	name = "Branch"
	id = "branch"
	desc = ""
	energy_cost = 200
	placement_atom = /obj/structure/corruption_node/growth/branch


