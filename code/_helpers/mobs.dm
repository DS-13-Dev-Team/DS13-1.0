/atom/movable/proc/get_mob()
	return

/obj/mecha/get_mob()
	return occupant

/obj/vehicle/train/get_mob()
	return buckled_mob

/mob/get_mob()
	return src

/mob/living/bot/mulebot/get_mob()
	if(load && istype(load, /mob/living))
		return list(src, load)
	return src

//helper for inverting armor blocked values into a multiplier
#define blocked_mult(blocked) max(1 - (blocked/100), 0)

/proc/mobs_in_view(var/range, var/source)
	var/list/mobs = list()
	for(var/atom/movable/AM in view(range, source))
		var/M = AM.get_mob()
		if(M)
			mobs += M

	return mobs

proc/random_hair_style(gender, species = SPECIES_HUMAN)
	var/h_style = "Bald"

	var/datum/species/mob_species = all_species[species]
	var/list/valid_hairstyles = mob_species.get_hair_styles()
	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style

proc/random_target_zone()
	return pickweight(list(BP_EYES, BP_MOUTH, BP_HEAD, BP_CHEST = 2, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_GROIN, BP_L_LEG, BP_R_LEG, BP_R_ARM, BP_L_ARM))

proc/random_facial_hair_style(gender, var/species = SPECIES_HUMAN)
	var/f_style = "Shaved"

	var/datum/species/mob_species = all_species[species]
	var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(gender)
	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)

		return f_style

proc/sanitize_name(name, species = SPECIES_HUMAN)
	var/datum/species/current_species
	if(species)
		current_species = all_species[species]

	return current_species ? current_species.sanitize_name(name) : sanitizeName(name)

proc/random_name(gender, species = SPECIES_HUMAN)

	var/datum/species/current_species
	if(species)
		current_species = all_species[species]

	if(!current_species)
		if(gender==FEMALE)
			return capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))
		else
			return capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
	else
		return current_species.get_random_name(gender)

proc/random_skin_tone(var/datum/species/current_species)
	var/species_tone = current_species ? 35 - current_species.max_skin_tone() : -185
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(species_tone,34)

	return min(max(. + rand(-25, 25), species_tone), 34)

proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

/proc/RoundHealth(health)
	var/list/icon_states = icon_states('icons/mob/hud_med.dmi')
	for(var/icon_state in icon_states)
		if(health >= text2num(icon_state))
			return icon_state
	return icon_states[icon_states.len] // If we had no match, return the last element

//checks whether this item is a module of the robot it is located in.
/proc/is_robot_module(var/obj/item/thing)
	if (!thing || !istype(thing.loc, /mob/living/silicon/robot))
		return 0
	var/mob/living/silicon/robot/R = thing.loc
	return (thing in R.module.modules)

/proc/get_exposed_defense_zone(var/atom/movable/target)
	return pick(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG, BP_CHEST, BP_GROIN)



/*
	Do after is used to let a mob do things over time, with a failure if they move, or become incapacitated.
	Vars:
		User: Who is doing the thing
		Delay: How long the thing takes to do, in total
		target: What we are doing the thing to. Optional. should be a nonmob atom.
			Use do_mob instead if you want to have a mob target
		needhand: If true, they must not change the contents of their active hand
		progress: Whether to display a graphical progress meter above the target. Shown above user if no target
		incapacitation_flags: which incap flags will trigger a failure state.
		same_direction: If true, user must maintain their starting facing direction
		can_move: If false, user must maintain their location
		proc_to_call: A callback. While the operation is ongoing, periodically call this
		proc_interval: how often to call the above, in deciseconds
*/

//This is used to interrupt these procs from outside
/datum/extension/interrupt_doafter

/proc/do_after(mob/user, delay, atom/target = null, needhand = 1, progress = 1, var/incapacitation_flags = INCAPACITATION_DEFAULT, var/same_direction = 0, var/can_move = 0,
var/datum/callback/proc_to_call, var/proc_interval = 10)

	if(!user)
		return 0
	var/atom/target_loc = null
	var/target_type = null

	var/original_dir = user.dir

	if(target)
		target_loc = target.loc
		target_type = target.type

	var/atom/original_loc = user.loc

	var/holding = user.get_active_hand()

	var/datum/progressbar/progbar
	if (progress)
		//Where will the progress bar appear?
		//Usually over the target object. But if its not on turf, we'll put the bar on that turf anyway
		//If no target supplied, the bar goes on the user
		var/atom/progtarget = target
		if (!progtarget)
			progtarget = user
		else if (!isturf(progtarget.loc))
			progtarget = get_turf(progtarget)

		progbar = new(user, delay, progtarget)

	var/endtime = world.time + delay
	var/starttime = world.time

	//We'll use this to time when to call the proc
	var/proc_ticker = proc_interval

	. = 1
	remove_extension(user, /datum/extension/interrupt_doafter)
	while (world.time < endtime)
		sleep(1)
		if (progress)
			progbar.update(world.time - starttime)

		if(!user || user.incapacitated(incapacitation_flags) || (user.loc != original_loc && !can_move) || (same_direction && user.dir != original_dir))
			. = 0
			break

		if(target_loc && (!target || QDELETED(target) || target_loc != target.loc || target_type != target.type))
			. = 0
			break

		if(needhand)
			if(user.get_active_hand() != holding)
				. = 0
				break

		if (doafter_blocked(user))
			. = 0
			break

		if (proc_to_call)
			//Deplete this SSticker
			proc_ticker -= 1

			//If it goes below zero, we ADD not set the proc interval, so that any overflow isn't lost
			if (proc_ticker <= 0)
				proc_ticker += proc_interval

				//And we call the proc
				//We will pass: User, Interval
				proc_to_call.Invoke(user, target, proc_interval)


	if (progbar)
		qdel(progbar)


/proc/doafter_blocked(user)
	.=FALSE
	if (has_extension(user, /datum/extension/interrupt_doafter))
		var/datum/extension/interrupt_doafter/D = get_extension(user, /datum/extension/interrupt_doafter)
		if (D.end_time >= world.time)
			.=TRUE
		D.remove_self()


/datum/extension/interrupt_doafter
	var/end_time
/datum/extension/interrupt_doafter/New(var/datum/holder, var/_end_time)
	.=..()
	end_time = _end_time
/*
	do_mob is a variant of do_after. The key difference being it requires both the user and target to be mobs, and fails if either moves away
	Needhand can be: 0, irrelevant
	1: Must continue holding same thing
	2. must have a free hand
	proc_to_call: A callback. While the operation is ongoing, periodically call this
		proc_interval: how often to call the above, in deciseconds
*/
/proc/do_mob(mob/user , mob/target, time = 30, target_zone = 0, uninterruptible = 0, progress = 1, var/incapacitation_flags = INCAPACITATION_DEFAULT, var/needhand = 1,
var/datum/callback/proc_to_call, var/proc_interval = 10)
	if(!user || !target)
		return 0
	var/user_loc = user.loc
	var/target_loc = target.loc

	var/holding = user.get_active_hand()
	var/datum/progressbar/progbar
	if (progress)
		progbar = new(user, time, target)

	var/endtime = world.time+time
	var/starttime = world.time
	//We'll use this to time when to call the proc
	var/proc_ticker = proc_interval
	. = 1
	while (world.time < endtime)
		sleep(1)
		if (progress)
			progbar.update(world.time - starttime)
		if(!user || !target)
			. = 0
			break
		if(uninterruptible)
			continue

		if (doafter_blocked(user))
			. = 0
			break

		if(!user || user.incapacitated(incapacitation_flags) || user.loc != user_loc)
			. = 0
			break

		if(target.loc != target_loc)
			. = 0
			break

		if (needhand)
			if(needhand == 1 && user.get_active_hand() != holding)
				. = 0
				break
			else if (needhand == 2 && !user.has_free_hand())
				. = 0
				break

		if (proc_to_call)
			//Deplete this SSticker
			proc_ticker -= 1

			//If it goes below zero, we ADD not set the proc interval, so that any overflow isn't lost
			if (proc_ticker <= 0)
				proc_ticker += proc_interval

				//And we call the proc
				//We will pass: User, Interval
				proc_to_call.Invoke(user, target, proc_interval)

		if(target_zone && get_zone_sel(user) != target_zone)
			. = 0
			break

	if (progbar)
		qdel(progbar)




// Returns true if M was not already in the dead mob list
/mob/proc/switch_from_living_to_dead_mob_list()
	remove_from_living_mob_list()
	. = add_to_dead_mob_list()

// Returns true if M was not already in the living mob list
/mob/proc/switch_from_dead_to_living_mob_list()
	remove_from_dead_mob_list()
	. = add_to_living_mob_list()

// Returns true if the mob was in neither the dead or living list
/mob/proc/add_to_living_mob_list()
	return FALSE
/mob/living/add_to_living_mob_list()
	if((src in GLOB.living_mob_list) || (src in GLOB.dead_mob_list))
		return FALSE
	GLOB.living_mob_list += src
	return TRUE

// Returns true if the mob was removed from the living list
/mob/proc/remove_from_living_mob_list()
	return GLOB.living_mob_list.Remove(src)

// Returns true if the mob was in neither the dead or living list
/mob/proc/add_to_dead_mob_list()
	return FALSE
/mob/living/add_to_dead_mob_list()
	if((src in GLOB.living_mob_list) || (src in GLOB.dead_mob_list))
		return FALSE
	GLOB.dead_mob_list += src
	return TRUE

// Returns true if the mob was removed form the dead list
/mob/proc/remove_from_dead_mob_list()
	return GLOB.dead_mob_list.Remove(src)

//Find a dead mob with a brain and client.
/proc/find_dead_player(var/find_key, var/include_observers = 0)
	if(isnull(find_key))
		return

	var/mob/selected = null

	if(include_observers)
		for(var/mob/M in GLOB.player_list)
			if((M.stat != DEAD) || (!M.client))
				continue
			if(M.ckey == find_key)
				selected = M
				break
	else
		for(var/mob/living/M in GLOB.player_list)
			//Dead people only thanks!
			if((M.stat != DEAD) || (!M.client))
				continue
			//They need a brain!
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.should_have_organ(BP_BRAIN) && !H.has_brain())
					continue
			if(M.ckey == find_key)
				selected = M
				break
	return selected


//Returns true if the two passed mobs are on the same "team".
//For the purposes of DS13, this is only true if both are necromorphs
/atom/proc/is_allied(var/atom/B)
	if (is_necromorph() && B.is_necromorph())
		return TRUE
	return FALSE



//This somewhat complex proc attempts to find a valid enemy target nearby.
//Vars:	All except origin are optional
//Origin:		Where do we search around?
//Searchrange:	How far around origin do we search?
//User:			Who is doing the searching? This is used for is_allied. If not passed, all mobs will be considered?
//Reach:		Target must be within Reach tiles of the user
/proc/autotarget_enemy_mob(var/atom/origin, var/searchrange = 1, var/mob/living/user = null, var/reach = 0)
	var/list/search_tiles = trange(searchrange, origin)
	var/list/prime_targets = list()	//Main targets, we pick one
	var/list/secondary_targets	=	list()	//Used only if there are no prime targets
	for (var/t in search_tiles)
		var/turf/T = t
		for (var/mob/living/L in T)

			if (L.stat == DEAD)
				continue	//Never target a dead mob

			if (user && user.is_allied(L))
				continue	//Don't target our allies

			if (reach && (get_dist(user, L) > reach))
				continue	//Got to be near the user

			//Alright all safety checks passed, we have a valid target. But how valid?
			if (L.lying)
				//Lying targets are low priority
				secondary_targets.Add(L)

			else
				prime_targets.Add(L)

	if (prime_targets.len)
		return pick(prime_targets)

	else if (secondary_targets.len)
		return pick(secondary_targets)

	else
		return origin



//Adds verb path to our verbs if condition is true, removes it if false
/mob/proc/update_verb(verb_path, condition)
	if (condition)
		add_verb(src, verb_path)
	else
		remove_verb(src, verb_path)


/mob/proc/enemy_in_view(var/require_standing = FALSE)
	for (var/mob/living/carbon/human/H in atoms_in_view())
		//People who are downed don't count
		if (require_standing && (H.lying || H.stat))
			continue



		//Other necros don't count
		if (is_allied(H))
			continue

		return TRUE
	return FALSE