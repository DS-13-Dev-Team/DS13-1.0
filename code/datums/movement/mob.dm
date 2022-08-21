/mob
	var/moving           = FALSE

/mob/proc/SelfMove(direction)
	///Mobs with slow turning take a move to turn in place.
	//We will attempt to turn towards the target if our movement is off cooldown
	if (slow_turning)
		if (check_move_cooldown() && facedir(direction))
			return TRUE
		else if (!(get_visual_dir() & direction))
			return FALSE

	//This is in movement/movement.dm, /atom/movable/proc/DoMove(
	if(DoMove(direction, src) & MOVEMENT_HANDLED)
		return TRUE // Doesn't necessarily mean the mob physically moved

/mob/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return TRUE

	if (mover.pass_flags & PASS_FLAG_NOMOB)
		return TRUE

	if(ismob(mover))
		var/mob/moving_mob = mover
		if ((other_mobs && moving_mob.other_mobs))
			return TRUE
		return (!mover.density || !density || (lying && !density_lying()))
	else
		return (!mover.density || !density || (lying && !density_lying()))


//Sets next move time to now, so a mob can move immediately
/mob/proc/reset_move_cooldown()
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		delay.ResetDelay()

/mob/proc/set_move_cooldown(var/timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		delay.SetDelay(timeout)

/mob/proc/extra_move_cooldown(var/timeout)
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		delay.AddDelay(timeout)

/mob/proc/check_move_cooldown()
	var/datum/movement_handler/mob/delay/delay = GetMovementHandler(/datum/movement_handler/mob/delay)
	if(delay)
		return (delay.MayMove(src) == MOVEMENT_PROCEED)

/client/proc/client_dir(input, direction=-1)
	return turn(input, direction*dir2angle(dir))

/client/Northeast()
	diagonal_action(NORTHEAST)
/client/Northwest()
	diagonal_action(NORTHWEST)
/client/Southeast()
	diagonal_action(SOUTHEAST)
/client/Southwest()
	diagonal_action(SOUTHWEST)

/client/proc/diagonal_action(direction)
	switch(client_dir(direction, 1))
		if(NORTHEAST)
			swap_hand()
			return
		if(SOUTHEAST)
			attack_self()
			return
		if(SOUTHWEST)
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				C.toggle_throw_mode()
			else
				to_chat(usr, "<span class='warning'>This mob type cannot throw items.</span>")
			return
		if(NORTHWEST)
			mob.hotkey_drop()

/mob/proc/hotkey_drop()
	to_chat(usr, "<span class='warning'>This mob type cannot drop items.</span>")

/mob/living/carbon/hotkey_drop()
	if(!get_active_hand())
		to_chat(usr, "<span class='warning'>You have nothing to drop in your hand.</span>")
	else
		unequip_item()



/client/verb/swap_hand()
	set hidden = 1
	if(istype(mob, /mob/living/carbon))
		mob.swap_hand()
	if(istype(mob,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = mob
		R.cycle_modules()
	return



/client/verb/attack_self()
	set hidden = 1
	if(mob)
		mob.mode()
	return


/client/verb/toggle_throw_mode()
	set hidden = 1
	if(!istype(mob, /mob/living/carbon))
		return
	if (!mob.stat && isturf(mob.loc) && !mob.restrained())
		mob.toggle_throw_mode()
	else
		return


/client/verb/drop_item()
	set hidden = 1
	if(!isrobot(mob) && mob.stat == CONSCIOUS && isturf(mob.loc))
		return mob.unequip_item()
	return




/client/Move(n, direction)
	if(!mob)
		return // Moved here to avoid nullrefs below
	return mob.SelfMove(direction)

// Checks whether this mob is allowed to move in space
// Return 1 for movement, 0 for none,
// -1 to allow movement but with a chance of slipping
/mob/proc/Allow_Spacemove(var/check_drift = 0)
	if(!Check_Dense_Object()) //Nothing to push off of so end here
		return 0

	if(restrained()) //Check to see if we can do things
		return 0

	return -1

//Checks if a mob has solid ground to stand on
//If there's no gravity then there's no up or down so naturally you can't stand on anything.
//For the same reason lattices in space don't count - those are things you grip, presumably.
/mob/proc/check_solid_ground()
	if(istype(loc, /turf/space))
		return 0

	if(!lastarea)
		lastarea = get_area(src)
	if(!lastarea || !lastarea.has_gravity)
		return 0

	return 1

/mob/proc/Check_Dense_Object() //checks for anything to push off or grip in the vicinity. also handles magboots on gravity-less floors tiles

	var/shoegrip = Check_Shoegrip()

	for(var/turf/simulated/T in trange(1,src)) //we only care for non-space turfs
		if(T.density)	//walls work
			return 1
		else
			var/area/A = T.loc
			if(A.has_gravity || shoegrip)
				return 1

	for(var/obj/O in orange(1, src))
		if(istype(O, /obj/structure/lattice))
			return 1
		if(O && O.density && O.anchored)
			return 1

	return 0

/mob/proc/Check_Shoegrip()
	return 0

//return 1 if slipped, 0 otherwise
/mob/proc/handle_spaceslipping()
	if(prob(skill_fail_chance(SKILL_EVA, slip_chance(10), SKILL_EXPERT)))
		to_chat(src, "<span class='warning'>You slipped!</span>")
		src.inertia_dir = src.last_move
		step(src, src.inertia_dir)
		return 1
	return 0

/mob/proc/slip_chance(var/prob_slip = 10)
	if(stat)
		return 0
	if(buckled)
		return 0
	if(Check_Shoegrip())
		return 0
	if(MOVING_DELIBERATELY(src))
		prob_slip *= 0.5
	return prob_slip

#define DO_MOVE(this_dir) var/final_dir = turn(this_dir, -dir2angle(dir)); Move(get_step(mob, final_dir), final_dir);

/mob/proc/check_slipmove()
	return

/client/verb/moveup()
	set name = ".moveup"
	set instant = 1
	DO_MOVE(NORTH)

/client/verb/movedown()
	set name = ".movedown"
	set instant = 1
	DO_MOVE(SOUTH)

/client/verb/moveright()
	set name = ".moveright"
	set instant = 1
	DO_MOVE(EAST)

/client/verb/moveleft()
	set name = ".moveleft"
	set instant = 1
	DO_MOVE(WEST)

#undef DO_MOVE

/mob/proc/set_next_usable_move_intent()
	var/checking_intent = (istype(move_intent) ? move_intent.type : move_intents[1])
	for(var/i = 1 to length(move_intents)) // One full iteration of the move set.
		checking_intent = next_in_list(checking_intent, move_intents)
		if(set_move_intent(decls_repository.get_decl(checking_intent)))
			return

/mob/proc/set_move_intent(var/decl/move_intent/next_intent)
	if(next_intent && move_intent != next_intent && next_intent.can_be_used_by(src))
		move_intent = next_intent
		if(hud_used)
			hud_used.move_intent.icon_state = move_intent.hud_icon_state
		return TRUE
	return FALSE

/mob/proc/get_movement_datum_by_flag(var/move_flag = MOVE_INTENT_DELIBERATE)
	for(var/m_intent in move_intents)
		var/decl/move_intent/check_move_intent = decls_repository.get_decl(m_intent)
		if(check_move_intent.flags & move_flag)
			return check_move_intent

/mob/proc/get_movement_datum_by_missing_flag(var/move_flag = MOVE_INTENT_DELIBERATE)
	for(var/m_intent in move_intents)
		var/decl/move_intent/check_move_intent = decls_repository.get_decl(m_intent)
		if(!(check_move_intent.flags & move_flag))
			return check_move_intent

/mob/proc/get_movement_datums_by_flag(var/move_flag = MOVE_INTENT_DELIBERATE)
	. = list()
	for(var/m_intent in move_intents)
		var/decl/move_intent/check_move_intent = decls_repository.get_decl(m_intent)
		if(check_move_intent.flags & move_flag)
			. += check_move_intent

/mob/proc/get_movement_datums_by_missing_flag(var/move_flag = MOVE_INTENT_DELIBERATE)
	. = list()
	for(var/m_intent in move_intents)
		var/decl/move_intent/check_move_intent = decls_repository.get_decl(m_intent)
		if(!(check_move_intent.flags & move_flag))
			. += check_move_intent

/mob/verb/SetDefaultWalk()
	set name = "Set Default Walk"
	set desc = "Select your default walking style."
	set category = "IC"
	var/choice = input(usr, "Select a default walk.", "Set Default Walk") as null|anything in get_movement_datums_by_missing_flag(MOVE_INTENT_QUICK)
	if(choice && (choice in get_movement_datums_by_missing_flag(MOVE_INTENT_QUICK)))
		default_walk_intent = choice
		to_chat(src, "You will now default to [default_walk_intent] when moving deliberately.")

/mob/verb/SetDefaultRun()
	set name = "Set Default Run"
	set desc = "Select your default running style."
	set category = "IC"
	var/choice = input(usr, "Select a default run.", "Set Default Run") as null|anything in get_movement_datums_by_flag(MOVE_INTENT_QUICK)
	if(choice && (choice in get_movement_datums_by_flag(MOVE_INTENT_QUICK)))
		default_run_intent = choice
		to_chat(src, "You will now default to [default_run_intent] when moving quickly.")

/client/verb/setmovingslowly()
	set hidden = 1
	if(mob)
		mob.set_moving_slowly()

/mob/proc/set_moving_slowly()
	if(!default_walk_intent)
		default_walk_intent = get_movement_datum_by_missing_flag(MOVE_INTENT_QUICK)
	if(default_walk_intent && move_intent != default_walk_intent)
		set_move_intent(default_walk_intent)

/client/verb/setmovingquickly()
	set hidden = 1
	if(mob)
		mob.set_moving_quickly()

/mob/proc/set_moving_quickly()
	if(!default_run_intent)
		default_run_intent = get_movement_datum_by_flag(MOVE_INTENT_QUICK)
	if(default_run_intent && move_intent != default_run_intent)
		set_move_intent(default_run_intent)

/mob/proc/can_sprint()
	return FALSE

/mob/proc/adjust_stamina(var/amt)
	return

/mob/proc/get_stamina()
	return 100

/* Movement relayed to self handling
Note: Removed from mobs because it is not currently used, nothing in the codebase ever adds an allowed mover
If this is needed in future, add new datum procs for adding allowed movers, and add/remove the handler only when it actually has an allowed mover to relay to
*/
/datum/movement_handler/mob/relayed_movement
	var/prevent_host_move = FALSE
	var/list/allowed_movers

/datum/movement_handler/mob/relayed_movement/MayMove(var/mob/mover, var/is_external)
	if(is_external)
		return MOVEMENT_PROCEED
	if(mover == mob && !(prevent_host_move && LAZYLEN(allowed_movers) && !LAZYISIN(allowed_movers, mover)))
		return MOVEMENT_PROCEED
	if(LAZYISIN(allowed_movers, mover))
		return MOVEMENT_PROCEED

	return MOVEMENT_STOP

/datum/movement_handler/mob/relayed_movement/proc/AddAllowedMover(var/mover)
	LAZYOR(allowed_movers, mover)

/datum/movement_handler/mob/relayed_movement/proc/RemoveAllowedMover(var/mover)
	LAZYREMOVE(allowed_movers, mover)

// Admin object possession
/datum/movement_handler/mob/admin_possess/DoMove(var/direction)
	if(QDELETED(mob.control_object))
		return MOVEMENT_REMOVE

	. = MOVEMENT_HANDLED

	var/atom/movable/control_object = mob.control_object
	step(control_object, direction)
	if(QDELETED(control_object))
		. |= MOVEMENT_REMOVE
	else
		control_object.set_dir(direction)

// Death handling
/datum/movement_handler/mob/death/DoMove()
	if(mob.stat != DEAD)
		return MOVEMENT_REMOVE
	. = MOVEMENT_HANDLED
	if(!mob.client)
		return
	mob.ghostize()

// Incorporeal/Ghost movement
/datum/movement_handler/mob/incorporeal/DoMove(var/direction)
	. = MOVEMENT_HANDLED
	direction = mob.AdjustMovementDirection(direction)

	var/turf/T = get_step(mob, direction)
	if(!mob.MayEnterTurf(T))
		return

	if(!mob.forceMove(T))
		return


	mob.set_dir(direction)
	mob.PostIncorporealMovement()

//Variation of incorporeal movement for signal eyes. Uses eyemove instead of forcemove
/datum/movement_handler/mob/incorporeal/eye/DoMove(var/direction)
	. = MOVEMENT_HANDLED
	direction = mob.AdjustMovementDirection(direction)

	var/turf/T = get_step(mob, direction)
	if(!mob.MayEnterTurf(T))
		return

	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)

	mob.set_dir(direction)
	mob.PostIncorporealMovement()



/mob/proc/PostIncorporealMovement()
	return

// Eye movement
/datum/movement_handler/mob/eye/DoMove(var/direction, var/mob/mover)
	if(IS_NOT_SELF(mover)) // We only care about direct movement
		return
	if(!mob.eyeobj)
		return
	mob.eyeobj.EyeMove(direction)
	return MOVEMENT_HANDLED

/datum/movement_handler/mob/eye/MayMove(var/mob/mover, var/is_external)
	if(IS_NOT_SELF(mover))
		return MOVEMENT_PROCEED
	if(is_external)
		return MOVEMENT_PROCEED
	if(!mob.eyeobj)
		return MOVEMENT_REMOVE
	return (MOVEMENT_PROCEED|MOVEMENT_HANDLED)

// Space movement
/datum/movement_handler/mob/zero_gravity/DoMove(var/direction, var/mob/mover)
	if(!mob.check_solid_ground())
		var/allowmove = mob.Allow_Spacemove(0)
		if(!allowmove)
			return MOVEMENT_HANDLED
		else if(allowmove == -1 && mob.handle_spaceslipping()) //Check to see if we slipped
			return MOVEMENT_HANDLED
		else
			mob.inertia_dir = 0 //If not then we can reset inertia and move

/datum/movement_handler/mob/zero_gravity/MayMove(var/mob/mover, var/is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED

	if(!mob.check_solid_ground())
		if(!mob.Allow_Spacemove(0))
			return MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Buckle movement
/datum/movement_handler/mob/buckle_relay/DoMove(var/direction, var/mover)
	if (!mob.buckled)
		return MOVEMENT_REMOVE

	// TODO: Datumlize buckle-handling
	if(istype(mob.buckled, /obj/vehicle))
		//drunk driving
		if(mob.confused && prob(20)) //vehicles tend to keep moving in the same direction
			direction = turn(direction, pick(90, -90))
		mob.buckled.relaymove(mob, direction)
		return MOVEMENT_HANDLED

	if(mob.pulledby || mob.buckled) // Wheelchair driving!
		if(istype(mob.loc, /turf/space))
			return // No wheelchair driving in space
		if(istype(mob.pulledby, /obj/structure/bed/chair/wheelchair))
			. = MOVEMENT_HANDLED
			mob.pulledby.DoMove(direction, mob)
		else if(istype(mob.buckled, /obj/structure/bed/chair/wheelchair))
			. = MOVEMENT_HANDLED
			if(ishuman(mob))
				var/mob/living/carbon/human/driver = mob
				var/obj/item/organ/external/l_hand = driver.get_organ(BP_L_HAND)
				var/obj/item/organ/external/r_hand = driver.get_organ(BP_R_HAND)
				if((!l_hand || l_hand.is_stump()) && (!r_hand || r_hand.is_stump()))
					return // No hands to drive your chair? Tough luck!
			//drunk wheelchair driving
			direction = mob.AdjustMovementDirection(direction)
			mob.buckled.DoMove(direction, mob)

/datum/movement_handler/mob/buckle_relay/MayMove(var/mover)
	if(mob.buckled)
		return mob.buckled.MayMove(mover, FALSE) ? (MOVEMENT_PROCEED|MOVEMENT_HANDLED) : MOVEMENT_STOP
	return MOVEMENT_PROCEED

// Movement delay
/datum/movement_handler/mob/delay
	var/next_move
	var/overflow = 0

/datum/movement_handler/mob/delay/DoMove(var/direction, var/mover, var/is_external)
	if(is_external)
		return
	next_move = world.time + (mob.movement_delay()-overflow)

/datum/movement_handler/mob/delay/MayMove(var/mover, var/is_external)
	if(IS_NOT_SELF(mover) && is_external)
		return MOVEMENT_PROCEED
	if ((mover && mover != mob) ||  world.time >= next_move)
		var/extra = world.time - next_move
		if (extra > 0  && extra < 1)
			overflow = extra
		return MOVEMENT_PROCEED

	else
		return MOVEMENT_STOP

/datum/movement_handler/mob/delay/proc/SetDelay(var/delay)
	next_move = max(next_move, world.time + delay)

/datum/movement_handler/mob/delay/proc/AddDelay(var/delay)
	next_move += max(0, delay)

/datum/movement_handler/mob/delay/proc/ResetDelay()
	next_move = world.time - 1



// Transformation
/datum/movement_handler/mob/transformation/MayMove()
	return MOVEMENT_STOP

/* Consciousness - Is the entity trying to conduct the move conscious?
	Disabled as it is currently not useful, we have no entities which can remotely control a mob and themselves fall unconscious
	If this is re-enabled in future, add it only when such an entity is controlling
*/
/datum/movement_handler/mob/conscious/MayMove(var/mob/mover)
	return (mover ? mover.stat == CONSCIOUS : mob.stat == CONSCIOUS) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Along with more physical checks
/datum/movement_handler/mob/physically_capable/MayMove(var/mob/mover)
	// We only check physical capability if the host mob tried to do the moving
	return ((mover && mover != mob) || !mob.incapacitated(INCAPACITATION_DISABLED & ~INCAPACITATION_FORCELYING)) ? MOVEMENT_PROCEED : MOVEMENT_STOP

// Is anything physically preventing movement?
/datum/movement_handler/mob/physically_restrained/MayMove(var/mob/mover)
	if(mob.anchored)
		if(mover == mob)
			to_chat(mob, "<span class='notice'>You're anchored down!</span>")
		return MOVEMENT_STOP

	if(istype(mob.buckled) && !mob.buckled.buckle_movable)
		if(mover == mob)
			to_chat(mob, "<span class='notice'>You're buckled to \the [mob.buckled]!</span>")
		return MOVEMENT_STOP

	if(LAZYLEN(mob.pinned))
		if(mover == mob)
			to_chat(mob, "<span class='notice'>You're pinned down by \a [mob.pinned[1]]!</span>")
		return MOVEMENT_STOP

	for(var/obj/item/grab/G in mob.grabbed_by)
		if(G.stop_move())
			if(mover == mob)
				to_chat(mob, "<span class='notice'>You're stuck in a grab!</span>")
			mob.ProcessGrabs()
			return MOVEMENT_STOP

	if(mob.restrained())
		for(var/mob/M in range(mob, 1))
			if(M.pulling == mob)
				if(!M.incapacitated() && mob.Adjacent(M))
					if(mover == mob)
						to_chat(mob, "<span class='notice'>You're restrained! You can't move!</span>")
					return MOVEMENT_STOP
				else
					M.stop_pulling()

	return MOVEMENT_PROCEED


/mob/living/ProcessGrabs()
	//if we are being grabbed
	if(grabbed_by.len)
		resist() //shortcut for resisting grabs

/mob/proc/ProcessGrabs()
	return


// Finally.. the last of the mob movement junk
/datum/movement_handler/mob/movement/DoMove(var/direction, var/mob/mover)
	. = MOVEMENT_HANDLED
	if(mob.moving)

		return

	if(!mob.lastarea)
		mob.lastarea = get_area(mob.loc)

	if(mob.check_slipmove())

		return

	//We are now going to move
	mob.moving = 1

	direction = mob.AdjustMovementDirection(direction)
	var/turf/old_turf = get_turf(mob)

	step(mob, direction)


	// Something with pulling things
	var/extra_delay = HandleGrabs(direction, old_turf)
	mob.extra_move_cooldown(extra_delay)

	for (var/obj/item/grab/G in mob)
		if (G.assailant_reverse_facing())
			mob.set_dir(GLOB.reverse_dir[direction])
		G.assailant_moved()
	for (var/obj/item/grab/G in mob.grabbed_by)
		G.adjust_position()

	//Moving with objects stuck in you can cause bad times.
	if(get_turf(mob) != old_turf)
		if(MOVING_QUICKLY(mob))
			mob.last_quick_move_time = world.time
			mob.adjust_stamina(-(mob.get_stamina_used_per_step() * (1+mob.encumbrance())))

	mob.moving = 0

/datum/movement_handler/mob/movement/MayMove(var/mob/mover)
	return IS_SELF(mover) &&  mob.moving ? MOVEMENT_STOP : MOVEMENT_PROCEED

/mob/proc/get_stamina_used_per_step()
	return 1

/mob/living/carbon/human/get_stamina_used_per_step()
	var/mod = (1-((get_skill_value(SKILL_ATHLETICS) - SKILL_MIN)/(SKILL_MAX - SKILL_MIN)))
	if(species && (species.species_flags & SPECIES_FLAG_LOW_GRAV_ADAPTED))
		if(has_gravity(src))
			mod *= 1.2
		else
			mod *= 0.8

	return MINIMUM_SPRINT_COST + (SKILL_SPRINT_COST_RANGE * mod)

/datum/movement_handler/mob/movement/proc/HandleGrabs(var/direction, var/old_turf)
	. = 0
	// TODO: Look into making grabs use movement events instead, this is a mess.
	for (var/obj/item/grab/G in mob)
		if(G.assailant == G.affecting)
			return
		. = max(., G.grab_slowdown())
		var/list/L = mob.ret_grab()
		if(istype(L, /list))
			if(L.len == 2)
				L -= mob
				var/mob/M = L[1]
				if(M)
					if (get_dist(old_turf, M) <= 1)
						if (isturf(M.loc) && isturf(mob.loc))
							if (mob.loc != old_turf && M.loc != mob.loc)
								step(M, get_dir(M.loc, old_turf))
			else
				for(var/mob/M in L)
					M.other_mobs = 1
					if(mob != M)
						M.animate_movement = 3
				for(var/mob/M in L)
					spawn( 0 )
						step(M, direction)
						return
					spawn( 1 )
						M.other_mobs = null
						M.animate_movement = 2
						return
			G.adjust_position()

// Misc. helpers
/mob/proc/MayEnterTurf(var/turf/T)
	return T && !((mob_flags & MOB_FLAG_HOLY_BAD) && check_is_holy_turf(T))

/mob/proc/AdjustMovementDirection(var/direction)
	. = direction
	if(!confused)
		return

	var/stability = MOVING_DELIBERATELY(src) ? 75 : 25
	if(prob(stability))
		return

	return prob(50) ? GLOB.cw_dir[.] : GLOB.ccw_dir[.]