/datum/signal_ability/placement
	energy_cost = 300
	targeting_method	=	TARGET_PLACEMENT


	placement_snap = TRUE
	require_corruption = TRUE

/datum/signal_ability/placement/on_cast(var/atom/target, var/mob/user, var/list/data)
	var/atom/movable/A = new placement_atom(target)
	if (LAZYACCESS(data, "direction"))
		A.set_dir(data["direction"])


/datum/signal_ability/placement/growth
	name = "Growth"
	id = "Growth"
	placement_atom = /obj/structure/corruption_node/growth