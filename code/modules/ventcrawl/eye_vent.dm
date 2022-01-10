/*
	Vent Eye: Used to allow mobs lurking inside a vent to see out of it

	This eye cannot be moved, but the mob controlling it can move instead
*/
/mob/dead/observer/eye/vent
	var/obj/machinery/atmospherics/unary/vent/associated_vent

/mob/dead/observer/eye/vent/Destroy()
	if (associated_vent)
		LAZYREMOVE(associated_vent.eyes,src)
	.=..()

/mob/dead/observer/eye/vent/Move(n, direct)
	var/old_turf = get_turf(owner)
	.=owner.Move(n,direct)
	if (get_turf(owner) != old_turf)
		qdel(src)

/mob/dead/observer/eye/vent/EyeMove(direct)
	return 0