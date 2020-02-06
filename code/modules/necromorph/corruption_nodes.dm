/obj/structure/corruption_node
	anchored = TRUE
	layer = ABOVE_OBJ_LAYER	//Make sure nodes draw ontop of corruption
	icon = 'icons/effects/corruption.dmi'
	var/marker_spawnable = TRUE	//When true, this automatically shows in the necroshop
	var/biomass = 10
	var/biomass_reclamation = 0.9
	var/reclamation_time = 10 MINUTES
	var/requires_corruption = TRUE
	var/random_rotation = TRUE	//If true, set rotation randomly on spawn
	var/scale = 1

	var/dummy = FALSE


	//TEMPORARY. Replace this once i rebase to unified structure damage
	var/max_health = 200

/obj/structure/corruption_node/Initialize()
	.=..()
	if (!isturf(loc))
		dummy = TRUE
	update_icon()

/obj/structure/corruption_node/Destroy()
	if (!dummy && SSnecromorph.marker && biomass_reclamation)
		SSnecromorph.marker.add_biomass_source(src, biomass*biomass_reclamation, reclamation_time, /datum/biomass_source/reclaim)

	.=..()


/obj/structure/corruption_node/update_icon()
	.=..()
	var/matrix/M = matrix()
	M = M.Scale(scale)	//We scale up the sprite so it slightly overlaps neighboring corruption tiles
	var/rotation = 0
	if (random_rotation)
		rotation = pick(list(0,90,180,270))//Randomly rotate it
	transform = turn(M, rotation)

/obj/structure/corruption_node/proc/get_blurb()

/obj/structure/corruption_node/proc/get_long_description()
	.="<b>Health</b>: [max_health]<br>"
	.+="<b>Biomass</b>: [biomass]kg[biomass_reclamation ? " . If destroyed, reclaim [biomass_reclamation*100]% biomass over [reclamation_time/600] minutes" : ""]<br>"
	if (requires_corruption)
		.+= SPAN_WARNING("Must be placed on a corrupted tile <br>")
	.+= get_blurb()
	.+="<br><hr>"

/obj/structure/corruption_node/growth
	max_health = 200
	icon_state = "growth"
	density = FALSE
	name = "Propagator"
	desc = "Corruption spreads out in all directions from this horrible mass."
	var/corruption_plant

/obj/structure/corruption_node/growth/Destroy()
	QDEL_NULL(corruption_plant)
	.=..()

/obj/structure/corruption_node/growth/Initialize()
	.=..()
	if (!dummy)	//Don't do this stuff if its a dummy for placement preview
		new /obj/effect/vine/corruption(get_turf(src),GLOB.corruption_seed, start_matured = 1)

/obj/structure/corruption_node/growth/get_blurb()
	. = "This node acts as a heart for corruption spread, allowing it to extend out up to 7 tiles in all directions from the node. It must be placed on existing corruption from another propagator node, or from the marker."