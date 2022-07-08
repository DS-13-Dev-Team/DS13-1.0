//////////////////////////////
//Contents: Ladders, Stairs.//
//////////////////////////////

/obj/structure/ladder
	name = "ladder"
	desc = "A ladder. You can climb it up and down."
	icon_state = "ladder01"
	icon = 'icons/obj/structures.dmi'
	density = FALSE
	opacity = 0
	anchored = TRUE
	obj_flags = OBJ_FLAG_NOFALL

	/*
		Planned future todo: Allow stairs and ladders to be damaged and enter a broken state,  which makes them much slower and harder to climb
		And from which they can be repaired with materials or tools to return to normalcy

		For now though, just making them indestructible because deleting stairs is no fun
	*/
	atom_flags = ATOM_FLAG_INDESTRUCTIBLE

	var/allowed_directions = DOWN
	var/obj/structure/ladder/target_up
	var/obj/structure/ladder/target_down

	var/const/climb_time = 2 SECONDS
	var/static/list/climbsounds = list('sound/effects/ladder.ogg','sound/effects/ladder2.ogg','sound/effects/ladder3.ogg','sound/effects/ladder4.ogg')

/obj/structure/ladder/Initialize()
	. = ..()

	// the upper will connect to the lower
	if(allowed_directions & DOWN) //we only want to do the top one, as it will initialize the ones before it.
		for(var/obj/structure/ladder/L in GetBelow(src))
			if(L.allowed_directions & UP)
				target_down = L
				L.target_up = src
				var/turf/T = get_turf(src)
				T.ReplaceWithLattice()
				break


	update_icon()

	var/turf/T = get_turf(src)
	if (T)
		LAZYSET(T.zstructures, src, 2)



/obj/structure/ladder/Destroy()
	if(target_down)
		target_down.target_up = null
		target_down = null
	if(target_up)
		target_up.target_down = null
		target_up = null

	var/turf/T = get_turf(src)
	if (T)
		LAZYREMOVE(T.zstructures, src)
	return ..()

/obj/structure/ladder/attackby(obj/item/I, mob/user)
	climb(user, I)

/turf/hitby(atom/movable/AM)
	if(isobj(AM))
		var/obj/structure/ladder/L = locate() in contents
		if(L)
			L.hitby(AM)
			return
	..()

/obj/structure/ladder/hitby(obj/item/I)
	if (istype(src, /obj/structure/ladder/up))
		return
	var/area/room = get_area(src)
	if(!room.has_gravity())
		return
	var/atom/blocker
	var/turf/landing = get_turf(target_down)
	for(var/atom/A in landing)
		if(!A.CanPass(I, I.loc, 1.5, 0))
			blocker = A
			break
	if(blocker)
		visible_message(SPAN_WARNING("\The [I] fails to go down \the [src], blocked by the [blocker]!"))
	else
		visible_message(SPAN_WARNING("\The [I] goes down \the [src]!"))
		I.forceMove(landing)
		landing.visible_message(SPAN_WARNING("\The [I] falls from the top of \the [target_down]!"))

/obj/structure/ladder/attack_hand(mob/M)
	climb(M)

/obj/structure/ladder/attack_ai(mob/M)
	var/mob/living/silicon/ai/ai = M
	if(!istype(ai))
		return
	var/mob/dead/observer/eye/AIeye = ai.eyeobj
	if(istype(AIeye))
		instant_climb(AIeye)

/obj/structure/ladder/attack_robot(mob/M)
	climb(M)

/obj/structure/ladder/proc/instant_climb(mob/M)
	var/atom/target_ladder = getTargetLadder(M)
	if(target_ladder)
		M.dropInto(target_ladder.loc)

/obj/structure/ladder/proc/climb(mob/M, obj/item/I = null)
	if(!M.may_climb_ladders(src))
		return

	add_fingerprint(M)
	var/obj/structure/ladder/target_ladder = getTargetLadder(M)
	if(!target_ladder)
		return
	if(!M.Move(get_turf(src)))
		to_chat(M, "<span class='notice'>You fail to reach \the [src].</span>")
		return

	for (var/obj/item/grab/G in M)
		G.adjust_position()

	var/direction = target_ladder == target_up ? "up" : "down"

	M.visible_message("<span class='notice'>\The [M] begins climbing [direction] \the [src]!</span>",
	"You begin climbing [direction] \the [src]!",
	"You hear the grunting and clanging of a metal ladder being used.")

	target_ladder.audible_message("<span class='notice'>You hear something coming [direction] \the [src]</span>")

	if(do_after(M, climb_time, src))
		climbLadder(M, target_ladder, I)
		for (var/obj/item/grab/G in M)
			G.adjust_position(force = 1)

/obj/structure/ladder/attack_ghost(mob/M)
	instant_climb(M)

/obj/structure/ladder/proc/getTargetLadder(mob/M)
	if((!target_up && !target_down) || (target_up && !istype(target_up.loc, /turf/simulated/open) || (target_down && !istype(target_down.loc, /turf))))
		to_chat(M, "<span class='notice'>\The [src] is incomplete and can't be climbed.</span>")
		return
	if(target_down && target_up)
		var/direction = tgui_alert(M,"Do you want to go up or down?", "Ladder", list("Up", "Down", "Cancel"))

		if(direction == "Cancel"||!direction)
			return

		if(!M.may_climb_ladders(src))
			return

		switch(direction)
			if("Up")
				return target_up
			if("Down")
				return target_down
	else
		return target_down || target_up

/mob/proc/may_climb_ladders(ladder)
	if(!Adjacent(ladder))
		to_chat(src, "<span class='warning'>You need to be next to \the [ladder] to start climbing.</span>")
		return FALSE
	if(incapacitated())
		to_chat(src, "<span class='warning'>You are physically unable to climb \the [ladder].</span>")
		return FALSE

	var/carry_count = 0
	for(var/obj/item/grab/G in src)
		if(!G.ladder_carry())
			to_chat(src, "<span class='warning'>You can't carry [G.affecting] up \the [ladder].</span>")
			return FALSE
		else
			carry_count++
	if(carry_count > 1)
		to_chat(src, "<span class='warning'>You can't carry more than one person up \the [ladder].</span>")
		return FALSE

	return TRUE

/mob/dead/observer/ghost/may_climb_ladders(ladder)
	return TRUE

/obj/structure/ladder/proc/climbLadder(mob/user, target_ladder, obj/item/I = null)
	var/turf/T = get_turf(target_ladder)
	for(var/atom/A in T)
		if(!A.CanPass(user, user.loc, 1.5, 0))
			to_chat(user, "<span class='notice'>\The [A] is blocking \the [src].</span>")

			//We cannot use the ladder, but we probably can remove the obstruction
			var/atom/movable/M = A
			if(istype(M) && M.movable_flags & MOVABLE_FLAG_Z_INTERACT)
				if(isnull(I))
					M.attack_hand(user)
				else
					M.attackby(I, user)

			return FALSE

	playsound(src, pick(climbsounds), 50)
	playsound(target_ladder, pick(climbsounds), 50)
	return user.Move(T)

/obj/structure/ladder/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

/obj/structure/ladder/update_icon()
	icon_state = "ladder[!!(allowed_directions & UP)][!!(allowed_directions & DOWN)]"

/obj/structure/ladder/up
	allowed_directions = UP
	icon_state = "ladder10"

/obj/structure/ladder/updown
	allowed_directions = UP|DOWN
	icon_state = "ladder11"

/obj/structure/stairs
	name = "stairs"
	desc = "Stairs leading to another deck.  Not too useful if the gravity goes out."
	icon = 'icons/obj/stairs.dmi'
	breakable = TRUE
	density = FALSE
	opacity = FALSE
	anchored = TRUE
	layer = RUNE_LAYER

	/*
		Planned future todo: Allow stairs and ladders to be damaged and enter a broken state,  which makes them much slower and harder to climb
		And from which they can be repaired with materials or tools to return to normalcy

		For now though, just making them indestructible because deleting stairs is no fun
	*/
	atom_flags = ATOM_FLAG_INDESTRUCTIBLE
/obj/structure/stairs/Destroy()
	var/turf/T = get_turf(src)
	if (T)
		LAZYREMOVE(T.zstructures, src)

	var/turf/above = GetAbove(src)
	if (above && istype(above, /turf/simulated/open))
		LAZYREMOVE(above.zstructures, src)

	.=..()

/obj/structure/stairs/Initialize()
	for(var/turf/turf in locs)
		var/turf/simulated/open/above = GetAbove(turf)
		if(!above)
			warning("Stair created without level above: ([loc.x], [loc.y], [loc.z])")
			return INITIALIZE_HINT_QDEL
		if(!istype(above))
			above.ChangeTurf(/turf/simulated/open)

		LAZYSET(above.zstructures, src, 2)

	. = ..()

	var/turf/T = get_turf(src)
	if (T)
		LAZYSET(T.zstructures, src, 2)




/obj/structure/stairs/CheckExit(atom/movable/mover as mob|obj, turf/target as turf)
	if(get_dir(loc, target) == dir && upperStep(mover.loc))
		return FALSE
	return ..()

/obj/structure/stairs/Bumped(atom/movable/A)
	var/turf/above = GetAbove(A)
	if (above)
		var/turf/target = get_step(above, dir)
		var/turf/source = A.loc
		if(above.CanZPass(source, UP) && target.Enter(A, src))
			A.forceMove(target)
			if(isliving(A))
				var/mob/living/L = A
				if(L.pulling)
					L.pulling.forceMove(target, null, L.glide_size)
			if(ishuman(A))
				var/mob/living/carbon/human/H = A
				if(H.species.silent_steps || H.buckled || H.lying || H.throwing)
					return

				playsound(source, 'sound/effects/stairs_step.ogg', 50)
				playsound(target, 'sound/effects/stairs_step.ogg', 50)
		else
			to_chat(A, "<span class='warning'>Something blocks the path.</span>")
	else
		to_chat(A, SPAN_NOTICE("There is nothing of interest in this direction."))

/obj/structure/stairs/proc/upperStep(turf/T)
	return (T == loc)

/obj/structure/stairs/CanPass(obj/mover, turf/source, height, airflow)
	return airflow || !density

// type paths to make mapping easier.
/obj/structure/stairs/north
	dir = NORTH
	bound_height = 64
	bound_y = -32
	pixel_y = -32

/obj/structure/stairs/south
	dir = SOUTH
	bound_height = 64

/obj/structure/stairs/east
	dir = EAST
	bound_width = 64
	bound_x = -32
	pixel_x = -32

/obj/structure/stairs/west
	dir = WEST
	bound_width = 64

/obj/structure/stairs_short
	icon = 'icons/obj/stairs_persp.dmi'
	icon_state = "p_stair_full"
	anchored = TRUE

/obj/structure/stairs_short/north
	dir = NORTH

/obj/structure/stairs_short/south
	dir = SOUTH

/obj/structure/stairs_short/east
	dir = EAST

/obj/structure/stairs_short/west
	dir = WEST
