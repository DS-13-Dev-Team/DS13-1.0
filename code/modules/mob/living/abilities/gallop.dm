/*
	Gallop is a sort of sprint mode for leapers, to get them into or out of combat quickly. It gives a burst of high speed,
	but also makes them vulnerable
	Any damaging hit, or bumping into a dense object, will knock them down and cause some damage
*/
/datum/extension/gallop
	name = "Gallop"
	base_type = /datum/extension/gallop
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	var/status
	var/mob/living/user
	var/power = 1
	var/cooldown = 1 SECOND
	var/duration = 1 SECOND

	var/started_at
	var/stopped_at
	var/ongoing_timer
	var/crashed = FALSE
	var/crash_limit = 2
	var/crash_count = 0

	statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 1)
/***********************
	Access Proc
************************/
/mob/living/proc/gallop_ability(var/_duration, var/_cooldown, var/_power)
	if (can_gallop())
		set_extension(src, /datum/extension/gallop, _duration,_cooldown,_power)
		return TRUE

/datum/extension/gallop/New(var/mob/living/_user, var/_duration, var/_cooldown, var/_power)
	statmods[STATMOD_MOVESPEED_MULTIPLICATIVE] = 1 + _power
	.=..()
	user = _user
	duration = _duration
	cooldown = _cooldown
	power = _power
	start()


/datum/extension/gallop/proc/start()
	if (!started_at)
		started_at = world.time
		user.can_pull_mobs = MOB_PULL_NONE
		user.can_pull_size = NONE
		ongoing_timer = addtimer(CALLBACK(src, /datum/extension/gallop/proc/stop), duration, TIMER_STOPPABLE)

		user.reset_move_cooldown()//Allow nextmove immediately
		RegisterSignal(user, COMSIG_MOB_DAMAGE_HIT, .proc/user_hit)
		RegisterSignal(user, COMSIG_MOVABLE_BUMP, .proc/user_bumped)
		RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/user_moved)

/datum/extension/gallop/Destroy()
	if (!stopped_at)
		stop()
	return ..()



/datum/extension/gallop/proc/stop()
	if (!stopped_at)
		deltimer(ongoing_timer)
		stopped_at = world.time
		ongoing_timer = addtimer(CALLBACK(src, /datum/extension/gallop/proc/finish_cooldown), cooldown, TIMER_STOPPABLE)
		UnregisterSignal(user, list(COMSIG_MOVABLE_MOVED, COMSIG_MOVABLE_BUMP, COMSIG_MOB_DAMAGE_HIT))
		user.can_pull_mobs = MOB_PULL_SAME
		user.can_pull_size = ITEM_SIZE_NO_CONTAINER
		user.visible_message(SPAN_NOTICE("[user] slows down"))
		for(var/modtype in statmods)
			unregister_statmod(modtype)

/datum/extension/gallop/proc/finish_cooldown()
	deltimer(ongoing_timer)
	remove_extension(holder, base_type)


/datum/extension/gallop/proc/get_cooldown_time()
	var/elapsed = world.time - stopped_at
	return cooldown - elapsed


/datum/extension/gallop/proc/user_hit(var/obj/item/organ/external/organ, brute, burn, damage_flags, used_weapon)
	SIGNAL_HANDLER
	if (crash_count < crash_limit)
		crash_count++
		return
	if (!crashed)
		user.visible_message(SPAN_DANGER("[user] crumples under the impact [istype(used_weapon, /obj) ? "of":"from"] [used_weapon]"))
		stop_crash(used_weapon)

/datum/extension/gallop/proc/user_bumped(var/mob/user, var/atom/obstacle)
	SIGNAL_HANDLER
	if (!crashed)
		user.visible_message(SPAN_DANGER("[user] crashes into [obstacle]"))
		stop_crash(obstacle)

//Play extra footstep sounds as the leaper clatters along the floor
/datum/extension/gallop/proc/user_moved(var/atom/obstacle)
	SIGNAL_HANDLER
	shake_camera(user, 3,0.5)
	user.play_species_audio(user, SOUND_FOOTSTEP, VOLUME_QUIET)

/datum/extension/gallop/proc/stop_crash(var/stopper)
	shake_camera(user, 20,4)
	crashed = TRUE
	user.Weaken(5)
	user.Stun(1)
	user.take_overall_damage(5, 0,0,0, stopper)
	stop()

/***********************
	Safety Checks
************************/
//Access Proc
/mob/living/proc/can_gallop(var/error_messages = TRUE)
	if (incapacitated())
		return FALSE

	var/datum/extension/gallop/gallop = get_extension(src, /datum/extension/gallop)
	if(gallop)
		if (error_messages)
			if (gallop.stopped_at)
				to_chat(src, SPAN_NOTICE("[gallop.name] is cooling down. You can use it again in [gallop.get_cooldown_time() /10] seconds."))
			else
				gallop.stop()
		return FALSE

	var/datum/extension/charge/charge = get_extension(src, /datum/extension/charge)
	if(charge && !charge.stopped_at)
		if (error_messages)
			to_chat(src, SPAN_NOTICE("You can't use use gallop while leaping!"))
		return FALSE

	return TRUE