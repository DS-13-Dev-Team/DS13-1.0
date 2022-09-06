

/mob/verb/down()
	set name = "Move Down"
	set category = "IC"

	move_down()

/mob/verb/up()
	set name = "Move Upwards"
	set category = "IC"

	move_up()

//----------------------
/mob/proc/move_down()
	SelfMove(DOWN)

/mob/living/move_down()
	AddMovementHandler(/datum/movement_handler/mob/multiz, /datum/movement_handler/mob/movement)
	.=..()

/mob/proc/move_up()

	SelfMove(UP)

/mob/living/move_up()
	AddMovementHandler(/datum/movement_handler/mob/multiz, /datum/movement_handler/mob/movement)
	.=..()

/mob/living/carbon/human/move_up()
	var/turf/old_loc = loc
	..()
	if(loc != old_loc)
		return

	var/turf/simulated/open/O = GetAbove(src)
	var/atom/climb_target
	if(istype(O))
		for(var/turf/T in RANGE_TURFS(O, 1))
			if(T.is_hole && T.is_floor())
				climb_target = T
			else
				for(var/obj/I in T)
					if(I.obj_flags & OBJ_FLAG_NOFALL)
						climb_target = I
						break
			if(climb_target)
				break

	if(climb_target)
		climb_up(climb_target)

/mob/proc/zPull(direction)
	//checks and handles pulled items across z levels
	if(!pulling)
		return FALSE

	var/turf/start = pulling.loc
	var/turf/destination = (direction == UP) ? GetAbove(pulling) : GetBelow(pulling)

	if(!start.CanZPass(pulling, direction))
		to_chat(src, "<span class='warning'>\The [start] blocked your pulled object!</span>")
		stop_pulling()
		return FALSE

	if(!destination.CanZPass(pulling, direction))
		to_chat(src, "<span class='warning'>The [pulling] you were pulling bumps up against \the [destination].</span>")
		stop_pulling()
		return FALSE

	for(var/atom/A in destination)
		if(!A.CanMoveOnto(pulling, start, 1.5, direction))
			to_chat(src, "<span class='warning'>\The [A] blocks the [pulling] you were pulling.</span>")
			stop_pulling()
			return FALSE

	pulling.forceMove(destination)
	return TRUE

/atom/proc/CanMoveOnto(atom/movable/mover, turf/target, height=1.5, direction = 0)
	//Purpose: Determines if the object can move through this
	//Uses regular limitations plus whatever we think is an exception for the purpose of
	//moving up and down z levles
	return CanPass(mover, target, height, 0) || (direction == DOWN && (atom_flags & ATOM_FLAG_CLIMBABLE))

/mob/proc/can_overcome_gravity()
	return FALSE

/mob/living/carbon/human/can_overcome_gravity()
	//First do species check
	if(species?.can_overcome_gravity(src) || is_mounted())
		return TRUE
	else
		for(var/atom/a in src.loc)
			if(a.atom_flags & ATOM_FLAG_CLIMBABLE)
				return TRUE

		//Last check, list of items that could plausibly be used to climb but aren't climbable themselves
		var/list/objects_to_stand_on = list(
				/obj/structure/bed
			)
		for(var/type in objects_to_stand_on)
			if(locate(type) in src.loc)
				return TRUE
	return FALSE

/mob/proc/can_ztravel()
	return FALSE

/mob/living/carbon/human/can_ztravel()
	if(Allow_Spacemove())
		return TRUE

	if(Check_Shoegrip())	//scaling hull with magboots
		for(var/turf/simulated/T in RANGE_TURFS(src, 1))
			if(T.density)
				return TRUE

/mob/living/silicon/robot/can_ztravel()
	if(Allow_Spacemove()) //Checks for active jetpack
		return TRUE

	for(var/turf/simulated/T in RANGE_TURFS(src, 1)) //Robots get "magboots"
		if(T.density)
			return TRUE

//FALLING STUFF

//Holds fall checks that should not be overriden by children
/atom/movable/proc/fall(lastloc)
	if(!isturf(loc))
		return

	var/turf/below = GetBelow(src)
	if(!below)
		return

	var/turf/T = loc
	if(!T.CanZPass(src, DOWN) || !below.CanZPass(src, DOWN))
		return

	// No gravity in space, apparently.
	var/area/area = get_area(src)
	if(!area.has_gravity())
		return

	if(throwing)
		return

	if ((pass_flags & PASS_FLAG_FLYING))
		return

	if(can_fall())
		begin_falling(lastloc, below)

// We spawn(0) here to let the current move operation complete before we start falling. fall() is normally called from
// Entered() which is part of Move(), by spawn()ing we let that complete.  But we want to preserve if we were in client movement
// or normal movement so other move behavior can continue.
/atom/movable/proc/begin_falling(lastloc, below)
	INVOKE_ASYNC(src, .proc/fall_callback, below)

/atom/movable/proc/fall_callback(turf/below)
	var/mob/M = src
	var/is_client_moving = (ismob(M) && M.moving)
	if(is_client_moving)
		M.moving = 1
	handle_fall(below)
	if(is_client_moving)
		M.moving = 0

//For children to override
/atom/movable/proc/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	if(!simulated)
		return FALSE

	if(anchored && !anchor_bypass)
		return FALSE

	//Override will make checks from different location used for prediction
	if(location_override)
		for(var/obj/O in location_override)
			if(O.obj_flags & OBJ_FLAG_NOFALL)
				return FALSE

		var/turf/below = GetBelow(location_override)
		for(var/atom/A in below)
			if(!A.CanPass(src, location_override))
				return FALSE


	return TRUE

/obj/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	return ..(anchor_fall)

/obj/effect/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	return FALSE

/obj/effect/decal/cleanable/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	return TRUE

/obj/item/pipe/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	var/turf/simulated/open/below = loc
	below = GetBelow(below)

	. = ..()

	if(anchored)
		return FALSE

	if((locate(/obj/structure/disposalpipe/up) in below) || (locate(/obj/machinery/atmospherics/pipe/zpipe/up) in below))
		return FALSE

/mob/living/carbon/human/can_fall(anchor_bypass = FALSE, turf/location_override = loc)
	if(..())
		return species.can_fall(src)

/atom/movable/proc/handle_fall(turf/landing)
	forceMove(landing)
	if(locate(/obj/structure/stairs) in landing)
		return 1
	else
		handle_fall_effect(landing)

/atom/movable/proc/handle_fall_effect(turf/landing)
	if(istype(landing, /turf/simulated/open))
		visible_message("\The [src] falls through \the [landing]!", "You hear a whoosh of displaced air.")
	else
		visible_message("\The [src] slams into \the [landing]!", "You hear something slam into the deck.")
		if(fall_damage())
			for(var/mob/living/M in landing.contents)
				if(M == src)
					continue
				visible_message("\The [src] hits \the [M.name]!")
				M.take_overall_damage(fall_damage())

/atom/movable/proc/fall_damage()
	return 0

/obj/fall_damage()
	if(w_class == ITEM_SIZE_TINY)
		return 0
	if(w_class == ITEM_SIZE_NO_CONTAINER)
		return 100
	return BASE_STORAGE_COST(w_class)

/mob/living/carbon/human/handle_fall_effect(turf/landing)
	if(species && species.handle_fall_special(src, landing))
		return

	..()
	var/min_damage = 5
	var/max_damage = 10
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_HEAD)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_CHEST)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_GROIN)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_LEG)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_LEG)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_FOOT)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_FOOT)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_L_ARM)
	apply_damage(rand(min_damage, max_damage), BRUTE, BP_R_ARM)
	weakened = max(weakened, 3)
	if(prob(skill_fail_chance(SKILL_HAULING, 40, SKILL_EXPERT, 2)))
		var/list/victims = list()
		for(var/tag in list(BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(tag)
			if(E && !E.is_stump() && !E.dislocated && !BP_IS_ROBOTIC(E))
				victims += E
		if(victims.len)
			var/obj/item/organ/external/victim = pick(victims)
			victim.dislocate()
			to_chat(src, "<span class='warning'>You feel a sickening pop as your [victim.joint] is wrenched out of the socket.</span>")
	updatehealth()


/mob/living/carbon/human/proc/climb_up(atom/A)
	var/turf/above = GetAbove(src)
	if(!isturf(loc) || !isopenspace(above) || is_physically_disabled())	// This destruction_timer check ideally wouldn't be required, but I'm not awake enough to refactor this to not need it.
		return FALSE

	var/turf/T = get_turf(A)
	if(above?.CanZPass(src, UP)) //Certain structures will block passage from below, others not
		var/area/location = get_area(loc)
		if(location.has_gravity && !can_overcome_gravity())
			return FALSE

		visible_message("<span class='notice'>[src] starts climbing onto \the [A]!</span>", "<span class='notice'>You start climbing onto \the [A]!</span>")
		if(do_after(src, 50, get_turf(src)))
			visible_message("<span class='notice'>[src] climbs onto \the [A]!</span>", "<span class='notice'>You climb onto \the [A]!</span>")
			src.Move(T)
		else
			visible_message("<span class='warning'>[src] gives up on trying to climb onto \the [A]!</span>", "<span class='warning'>You give up on trying to climb onto \the [A]!</span>")
		return TRUE

/mob/living/verb/lookup()
	set name = "Look Up"
	set desc = "If you want to know what's above."
	set category = "IC"

	if(client && !is_physically_disabled())
		if(z_eye)
			reset_view(null)
			qdel(z_eye)
			z_eye = null
			return
		var/turf/simulated/open/above = GetAbove(src)
		if(istype(above))
			z_eye = new /atom/movable/z_observer/z_up(src, src)
			to_chat(src, "<span class='notice'>You look up.</span>")
			reset_view(z_eye)
			return
		to_chat(src, "<span class='notice'>You can see \the [above ? above : "ceiling"].</span>")
	else
		to_chat(src, "<span class='notice'>You can't look up right now.</span>")

/mob/living/verb/lookdown()
	set name = "Look Down"
	set desc = "If you want to know what's below."
	set category = "IC"

	if(client && !is_physically_disabled())
		if(z_eye)
			reset_view(null)
			qdel(z_eye)
			z_eye = null
			return
		var/turf/simulated/open/T = get_turf(src)
		if(isopenspace(T) && HasBelow(T.z))
			z_eye = new /atom/movable/z_observer/z_down(src, src)
			to_chat(src, "<span class='notice'>You look down.</span>")
			reset_view(z_eye)
			return
		to_chat(src, "<span class='notice'>You can see \the [T ? T : "floor"].</span>")
	else
		to_chat(src, "<span class='notice'>You can't look below right now.</span>")

/mob/living
	var/atom/movable/z_observer/z_eye

/atom/movable/z_observer
	name = ""
	simulated = FALSE
	anchored = TRUE
	mouse_opacity = FALSE
	var/mob/living/owner

/atom/movable/z_observer/Initialize(mapload, var/mob/living/user)
	. = ..()
	owner = user
	follow()
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, .proc/follow)

/atom/movable/z_observer/proc/follow()
	SIGNAL_HANDLER

/atom/movable/z_observer/z_up/follow()
	forceMove(get_step(owner, UP))
	if(isturf(src.loc))
		var/turf/simulated/open/T = src.loc
		if(isopenspace(T))
			return
	owner.reset_view(null)
	owner.z_eye = null
	qdel(src)

/atom/movable/z_observer/z_down/follow()
	forceMove(get_step(owner, DOWN))
	var/turf/T = get_turf(owner)
	if(isopenspace(T))
		return
	owner.reset_view(null)
	owner.z_eye = null
	qdel(src)

/atom/movable/z_observer/Destroy()
	owner = null
	. = ..()

/atom/movable/z_observer/can_fall()
	return FALSE

/atom/movable/z_observer/ex_act()
	SHOULD_CALL_PARENT(FALSE)
	return

/atom/movable/z_observer/singularity_act()
	return

/atom/movable/z_observer/singularity_pull()
	return

/atom/movable/z_observer/singuloCanEat()
	return
