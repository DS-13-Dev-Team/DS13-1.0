#define VENT_COVER_INTACT   0
#define VENT_COVER_BROKEN   1
#define VENT_COVER_SEALED   2
/obj/machinery/atmospherics/unary/vent
	var/cover_status = VENT_COVER_INTACT
	var/list/eyes

/obj/machinery/atmospherics/unary/vent/ventcrawl_enter(mob/living/user, atom/oldloc)
	//Did we just enter from within a vent network, or from without?
	var/external_entry = !(istype(oldloc, /obj/machinery/atmospherics))
	
	if (external_entry)
		break_cover(user)
	
	//If we entered from a pipe
	//OR if the mob entered through the cover without breaking it (tiny mobs only)
	//Then the mob will attempt to lurk inside this vent
	if (cover_status != VENT_COVER_BROKEN || !external_entry)
		lurk(user)


/obj/machinery/atmospherics/unary/vent/ventcrawl_exit(mob/living/user, atom/target_move)
	if (user && user.eyeobj && (LAZYISIN(user.eyeobj,eyes)))
		eyes -= user.eyeobj
		qdel(user.eyeobj)
	.=..()
	

/*
	Called when something enters from outside, or busts out of this vent
*/
/obj/machinery/atmospherics/unary/vent/proc/break_cover(mob/living/user)

	//Already broken
	if (cover_status == VENT_COVER_BROKEN)
		return

	//Especially tiny mobs don't break the cover, they can slip through the grating
	if (user && user.mob_size <= MOB_TINY)
		return

	//TODO: Sound 
	visible_message("The cover on the [src] breaks open")
	shake_animation()
	cover_status = VENT_COVER_BROKEN
	update_icon()


/* 
	The user will attempt to lurk inside this vent
	If there's no cover, this will fail and they'll get ejected instead
	If the cover isnt sealed, they will have vision around the vent

	Note that the mob is already physically present in the vent when this is called, so we don't have to move them in, here
*/
/obj/machinery/atmospherics/unary/vent/proc/lurk(mob/living/user)   
	//Woops, no cover, you fall out
	if (cover_status == VENT_COVER_BROKEN)
		return ventcrawl_exit(user, get_turf(src))

	//They can hide inside the vent but also look out
	else if (cover_status == VENT_COVER_INTACT)
		create_vent_eye(user)


//Create an eye mob that allows the mob to see things outside the vent
/obj/machinery/atmospherics/unary/vent/proc/create_vent_eye(mob/living/user)
	if (!user || user.eyeobj)
		return

	var/mob/dead/observer/eye/vent/EV = new /mob/dead/observer/eye/vent(loc)
	EV.associated_vent = src
	EV.possess(user)

	LAZYDISTINCTADD(eyes, EV)