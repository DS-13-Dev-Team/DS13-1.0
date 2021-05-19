/turf/var/list/zstructures	//A list of structures that may allow or interfere with ztransitions

/atom/proc/CanZPass(atom/A, direction)
	return TRUE

/turf/CanZPass(atom/A, direction)
	if(z == A.z) //moving FROM this turf
		.= direction == UP //can't go below
	else
		if(direction == UP) //on a turf below, trying to enter
			.=FALSE
		if(direction == DOWN) //on a turf above, trying to enter
			.= !density

	if (LAZYLEN(zstructures))
		var/highest_priority = 0
		for (var/atom/B in zstructures)
			if (zstructures[B] > highest_priority)
				var/result=B.CanZPass(A, direction)
				if (result != ZTRANSITION_MAYBE)
					highest_priority = zstructures[B]
					.=result

/turf/simulated/open/CanZPass(atom/A, direction)
	.=TRUE
	if (LAZYLEN(zstructures))
		var/highest_priority = 0
		for (var/atom/B in zstructures)
			if (zstructures[B] > highest_priority)
				var/result=B.CanZPass(A, direction)
				if (result != ZTRANSITION_MAYBE)
					highest_priority = zstructures[B]
					.=result


/turf/space/CanZPass(atom/A, direction)
	.=TRUE
	if (LAZYLEN(zstructures))
		var/highest_priority = 0
		for (var/atom/B in zstructures)
			if (zstructures[B] > highest_priority)
				var/result=B.CanZPass(A, direction)
				if (result != ZTRANSITION_MAYBE)
					highest_priority = zstructures[B]
					.=result

/turf/simulated/open
	name = "open space"
	icon = 'icons/turf/space.dmi'
	icon_state = ""
	density = 0
	pathweight = 100000 //Seriously, don't try and path over this one numbnuts

  z_flags = ZM_MIMIC_DEFAULTS | ZM_MIMIC_OVERWRITE | ZM_MIMIC_NO_AO | ZM_ALLOW_ATMOS

	is_hole = TRUE

/turf/simulated/open/update_dirt()
	return 0

/turf/simulated/open/Entered(var/atom/movable/mover)
	..()
	mover.fall()

// Called when thrown object lands on this turf.
/turf/simulated/open/hitby(var/atom/movable/AM, var/speed)
	. = ..()
	AM.fall()


// override to make sure nothing is hidden
/turf/simulated/open/levelupdate()
	for(var/obj/O in src)
		O.hide(0)



/turf/simulated/open/examine(mob/user, distance, infix, suffix)
	if(..(user, 2))
		var/depth = 1
		for(var/T = GetBelow(src); isopenspace(T); T = GetBelow(T))
			depth += 1
		to_chat(user, "It is about [depth] level\s deep.")



/turf/simulated/open/Click()
	if(istype(usr,/mob/observer))
		usr.forceMove(GetBelow(src))


/turf/simulated/open/attackby(obj/item/C as obj, mob/user as mob)
	if (istype(C, /obj/item/stack/rods))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			return L.attackby(C, user)
		var/obj/item/stack/rods/R = C
		if (R.use(1))
			to_chat(user, "<span class='notice'>You lay down the support lattice.</span>")
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			new /obj/structure/lattice(locate(src.x, src.y, src.z))
		return

	if (istype(C, /obj/item/stack/tile))
		var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
		if(L)
			var/obj/item/stack/tile/floor/S = C
			if (S.get_amount() < 1)
				return
			qdel(L)
			playsound(src, 'sound/weapons/Genhit.ogg', 50, 1)
			S.use(1)
			ChangeTurf(/turf/simulated/floor/airless)
			return
		else
			to_chat(user, "<span class='warning'>The plating is going to need some support.</span>")

	//To lay cable.
	if(isCoil(C))
		var/obj/item/stack/cable_coil/coil = C
		coil.turf_place(src, user)
		return
	return

//Most things use is_plating to test if there is a cover tile on top (like regular floors)
/turf/simulated/open/is_plating()
	return TRUE