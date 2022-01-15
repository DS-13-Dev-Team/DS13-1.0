/*
	Vent Eye: Used to allow mobs lurking inside a vent to see out of it

	This eye cannot be moved, but the mob controlling it can move instead
*/
/mob/dead/observer/eye/vent
	var/obj/machinery/atmospherics/unary/vent/associated_vent

/mob/dead/observer/eye/vent/Destroy()
	if (associated_vent)
		LAZYREMOVE(associated_vent.eyes,src)
	GLOB.moved_event.unregister(owner, src, /mob/dead/observer/eye/vent/proc/owner_moved)

	//Put the darkness overlay back on if they're still in the pipes
	if (owner && istype(owner.loc, /obj/machinery/atmospherics))
		owner.set_fullscreen(TRUE, "vent", /atom/movable/screen/fullscreen/ventcrawl)
	.=..()

/mob/dead/observer/eye/vent/Move(n, direct)
	var/old_turf = get_turf(owner)
	.=owner.Move(n,direct)
	if (get_turf(owner) != old_turf)
		qdel(src)

/mob/dead/observer/eye/vent/EyeMove(direct)
	if (owner.loc == associated_vent)
		associated_vent.relaymove(owner, direct)
	else
		//The owner's location may be set wrong after they exit a vent
		var/obj/machinery/atmospherics/A = owner.loc
		if (istype(A))
			A.relaymove(owner, direct)
		//We're done now
		if (!QDELETED(src))
			qdel(src)


	
/mob/dead/observer/eye/vent/possess(var/mob/user)
	.=..()
	GLOB.moved_event.register(owner, src, /mob/dead/observer/eye/vent/proc/owner_moved)

/mob/dead/observer/eye/vent/proc/owner_moved()
	if (owner.loc != associated_vent)
		to_chat(world, "Owner left the vent, deleting eye")
		qdel(src)