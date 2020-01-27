/obj/structure/corruption_node
	anchored = TRUE
	icon = 'icons/effects/corruption.dmi'
	var/marker_spawnable = TRUE	//When true, this automatically shows in the necroshop
	var/biomass = 10
	var/biomass_reclamation = 0.9
	var/reclamation_time = 10 MINUTES
	var/requires_corruption = TRUE


	//TEMPORARY. Replace this once i rebase to unified structure damage
	var/max_health = 200


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
	name = "Growth"
	desc = "Corruption spreads out in all directions from this horrible mass."

/obj/structure/corruption_node/growth/Initialize()
	.=..()
	var/datum/seed/seed = new /datum/seed/corruption()
	new /obj/effect/vine/corruption(get_turf(src),seed, start_matured = 1)

/obj/structure/corruption_node/growth/get_blurb()
	. = "This node acts as a heart for corruption spread, allowing it to extend out up to 7 tiles in all directions from the node. It must be placed on existing corruption from another growth node, or from the marker."