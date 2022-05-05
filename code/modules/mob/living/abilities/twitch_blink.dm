/*
	This is a permanant extension used by the necromorph twitcher. It is added to a twitcher on spawning and stays there forever. It handles a few things:

		-Periodic idle twitching animations
		-Shortrange blinks from charging and reactive
		-Actively used shortrange blink

	Its purposes are highly specialised for the twitcher and it shouldn't be used on anyone else
*/

/datum/extension/twitch
	name = "Twitch"
	expected_type = /mob/living/carbon/human
	flags = EXTENSION_FLAG_IMMEDIATE
	var/mob/living/carbon/human/user

	//Small chance to randomly displace each step taken. This does not trigger the defensive cooldown
	var/movement_displace_chance = 4

	//Twitchers will blink to an adjacent tile when damaged, this effect has a cooldown
	var/defensive_displace_cooldown = 3 SECONDS


	//Runtime data
	var/last_defensive_displace = 0
	var/idle_twitch_timer

/datum/extension/twitch/New(var/mob/living/carbon/human/_user)
	..()
	user = _user
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/moved)

/datum/extension/twitch/proc/moved(var/atom/mover, var/oldloc, var/newloc)
	SIGNAL_HANDLER
	//Sometimes blink around while walking
	if(prob(movement_displace_chance))
		displace(FALSE)

/datum/extension/twitch/proc/move_to(var/atom/target, var/speed = 10)
	if (!turf_clear(get_turf(target)))
		return FALSE

	animate_movement(user, target, speed, client_lag = 0.4)
	return TRUE


/datum/extension/twitch/proc/displace(var/defensive = FALSE)
	if (defensive)
		if (last_defensive_displace + (defensive_displace_cooldown / user.get_attack_speed_factor()) >= world.time)
			return FALSE //Too soon since last one


	var/list/possible = list()
	for (var/turf/simulated/floor/F in orange(user, 1))
		if (turf_clear(F))
			possible.Add(F)

	if (possible.len)
		if (defensive)
			last_defensive_displace = world.time
		move_to(pick(possible), speed = 8)
		return TRUE

	return FALSE