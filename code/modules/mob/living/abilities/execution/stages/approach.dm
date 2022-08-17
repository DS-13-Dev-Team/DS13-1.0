/*
	Approach

	Moves the user towards the host.victim.
*/
/datum/execution_stage/approach
	duration = 10 SECONDS	//If the duration expires before we reach the target location, it fails
	var/atom/victim_last_loc
	var/turf/target_turf
	var/speed = 1 //Its a deliberate, suspenseful walking pace
	range = 7	//This can be active a long way, but you'd better be within 1 tile by the end


/datum/execution_stage/approach/enter()
	get_target_turf()

	if (!target_turf)
		to_chat(host.user, SPAN_DANGER("Unable to reach target, they may be too close to obstacles"))
		return FALSE	//This will cause an interrupt and fail the execution

	RegisterSignal(host.user, COMSIG_MOVABLE_MOVED, .proc/user_moved)
	walk_to(host.user, target_turf, 0, SPEED_TO_DELAY(speed))
	host.user.visible_message(SPAN_EXECUTION("[host.user] [speed  < 3 ? "slowly ":""]approaches [host.victim]"))
	return ..()

/datum/execution_stage/approach/exit()
	spawn(1)
		host.user.face_atom(host.victim, TRUE)
	walk(host.user, 0)

	UnregisterSignal(host.user, COMSIG_MOVABLE_MOVED)

/datum/execution_stage/approach/interrupt()
	walk(host.user, 0)

	UnregisterSignal(host.user, COMSIG_MOVABLE_MOVED)

/datum/execution_stage/approach/proc/get_target_turf()
	victim_last_loc = get_turf(host.victim)
	target_turf = null
	if (host.victim.lying)
		if (turf_clear(victim_last_loc))
			target_turf = victim_last_loc
		else
			for (var/direction in GLOB.cardinal)
				var/turf/T = get_step(victim_last_loc, direction)
				if (turf_clear(T))
					target_turf = T
		return

	//Get the turf infront of where the host.victim is facing
	var/turf/T = get_step(host.victim, host.victim.dir)
	if (turf_clear(T))
		target_turf = T

//We will recalculate the position after each step, in case the host.victim is trying to escape us
/datum/execution_stage/approach/proc/user_moved(atom/movable/mover, atom/oldloc, dir)
	SIGNAL_HANDLER
	if (host.victim.loc != victim_last_loc)
		get_target_turf()
		walk_to(host.user, target_turf, 0, SPEED_TO_DELAY(speed))


	if (mover.loc == target_turf)
		advance()



/datum/execution_stage/approach/can_advance()
	//We have not reached the target, keep trying
	if (host.user.loc != target_turf)
		return EXECUTION_RETRY

	.=..()