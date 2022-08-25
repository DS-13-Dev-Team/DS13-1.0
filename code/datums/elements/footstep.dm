///Footstep element. Plays footsteps at parents location when it is appropriate.
/datum/element/footstep
	element_flags = ELEMENT_DETACH|ELEMENT_BESPOKE
	id_arg_index = 2
	///A list containing living mobs and the number of steps they have taken since the last time their footsteps were played.
	var/list/steps_for_living = list()
	///volume determines the extra volume of the footstep. This is multiplied by the base volume, should there be one.
	var/volume
	///e_range stands for extra range - aka how far the sound can be heard. This is added to the base value and ignored if there isn't a base value.
	var/e_range
	///footstep_type is a define which determines what kind of sounds should get chosen.
	var/footstep_type
	///This can be a list OR a soundfile OR null. Determines whatever sound gets played.
	var/footstep_sounds
	///Whether or not to add variation to the sounds played
	var/sound_vary = FALSE

/datum/element/footstep/Attach(datum/target, footstep_type = FOOTSTEP_MOB_BAREFOOT, volume = 0.5, e_range = 0, sound_vary = FALSE)
	. = ..()
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	src.volume = volume
	src.e_range = e_range
	src.footstep_type = footstep_type
	src.sound_vary = sound_vary
	switch(footstep_type)
		if(FOOTSTEP_MOB_HUMAN)
			if(!ishuman(target))
				return ELEMENT_INCOMPATIBLE
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/play_humanstep)
			steps_for_living[target] = 0
			return
		if(FOOTSTEP_MOB_CLAW)
			footstep_sounds = GLOB.clawfootstep
		if(FOOTSTEP_MOB_BAREFOOT)
			footstep_sounds = GLOB.barefootstep
		if(FOOTSTEP_MOB_HEAVY)
			footstep_sounds = GLOB.heavyfootstep
		if(FOOTSTEP_MOB_SHOE)
			footstep_sounds = GLOB.footstep
		if(FOOTSTEP_MOB_SLIME)
			footstep_sounds = 'sound/effects/footstep/slime1.ogg'
		if(FOOTSTEP_OBJ_MACHINE)
			footstep_sounds = 'sound/effects/bang.ogg'
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/play_simplestep_machine)
			return
		if(FOOTSTEP_OBJ_ROBOT)
			footstep_sounds = 'sound/effects/tank_treads.ogg'
			RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/play_simplestep_machine)
			return
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/play_simplestep)
	steps_for_living[target] = 0

/datum/element/footstep/Detach(atom/movable/source)
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	steps_for_living -= source
	return ..()

///Prepares a footstep for living mobs. Determines if it should get played. Returns the turf it should get played on.
/datum/element/footstep/proc/prepare_step(mob/living/source)
	var/turf/turf = get_turf(source)
	if(!istype(turf))
		return

	if(source.buckled || source.HasMovementHandler(/datum/movement_handler/mob/admin_possess) || source.HasMovementHandler(/datum/movement_handler/mob/eye) || source.HasMovementHandler(/datum/movement_handler/mob/incorporeal))
		return

	if(source.lying) //play crawling sound if we're lying
		playsound(turf, 'sound/effects/footstep/crawl1.ogg', 15 * volume, sound_vary)
		return

	if(iscarbon(source))
		var/mob/living/carbon/carbon_source = source
		if(!length(carbon_source.get_locomotion_limbs()))
			return
		if(MOVING_SILENT(carbon_source) || carbon_source.species.silent_steps)
			return// stealth
	steps_for_living[source] += 1
	var/steps = steps_for_living[source]

	if(steps >= 6)
		steps_for_living[source] = 0
		steps = 0

	if(steps % 2)
		return

	if(steps != 0 && !source.has_gravity()) // don't need to step as often when you hop around
		return
	return turf

/datum/element/footstep/proc/play_simplestep(mob/living/source)
	SIGNAL_HANDLER

	var/turf/source_loc = prepare_step(source)
	if(!source_loc)
		return
	if(isfile(footstep_sounds) || istext(footstep_sounds))
		playsound(source_loc, footstep_sounds, volume, sound_vary)
		return
	var/turf_footstep
	switch(footstep_type)
		if(FOOTSTEP_MOB_CLAW)
			turf_footstep = source_loc.clawfootstep
			if(isfloor(source_loc))
				var/turf/simulated/floor/floor = source_loc
				if(floor.flooring?.clawfootstep)
					turf_footstep = floor.flooring?.clawfootstep
		if(FOOTSTEP_MOB_BAREFOOT)
			turf_footstep = source_loc.barefootstep
			if(isfloor(source_loc))
				var/turf/simulated/floor/floor = source_loc
				if(floor.flooring?.barefootstep)
					turf_footstep = floor.flooring?.barefootstep
		if(FOOTSTEP_MOB_HEAVY)
			turf_footstep = source_loc.heavyfootstep
			if(isfloor(source_loc))
				var/turf/simulated/floor/floor = source_loc
				if(floor.flooring?.heavyfootstep)
					turf_footstep = floor.flooring?.heavyfootstep
		if(FOOTSTEP_MOB_SHOE)
			turf_footstep = source_loc.footstep
			if(isfloor(source_loc))
				var/turf/simulated/floor/floor = source_loc
				if(floor.flooring?.footstep)
					turf_footstep = floor.flooring?.footstep
	if(source_loc.is_plating())
		turf_footstep = FOOTSTEP_PLATING
	else if(locate(/obj/structure/catwalk) in source_loc)
		turf_footstep = FOOTSTEP_CATWALK
	if(!turf_footstep)
		return
	playsound(source_loc, pick(footstep_sounds[turf_footstep][1]), footstep_sounds[turf_footstep][2] * volume, sound_vary, footstep_sounds[turf_footstep][3] + e_range)

/datum/element/footstep/proc/play_humanstep(mob/living/carbon/human/source, atom/oldloc, direction, list/old_locs)
	SIGNAL_HANDLER

	var/volume_multiplier = 1
	var/range_adjustment = 0

	if(MOVING_DELIBERATELY(source))
		volume_multiplier = 0.8
		range_adjustment = -1

	var/turf/source_loc = prepare_step(source)
	if(!source_loc)
		return

	var/turf_footstep = source_loc.footstep
	if(isfloor(source_loc))
		var/turf/simulated/floor/floor = source_loc
		if(floor.flooring?.footstep)
			turf_footstep = floor.flooring?.footstep
	if(locate(/obj/structure/catwalk) in source_loc)
		turf_footstep = FOOTSTEP_CATWALK
	else if(source_loc.is_plating())
		turf_footstep = FOOTSTEP_PLATING

	//cache for sanic speed (lists are references anyways)
	var/static/list/footstep_sounds = GLOB.footstep
	///list returned by playsound() filled by client mobs who heard the footstep. given to play_fov_effect()
	var/list/heard_clients

	if((source.wear_suit?.body_parts_covered | source.w_uniform?.body_parts_covered | source.shoes?.body_parts_covered) & FEET)
		// we are wearing shoes

		heard_clients = playsound(source_loc, pick(footstep_sounds[turf_footstep][1]),
			footstep_sounds[turf_footstep][2] * volume * volume_multiplier,
			sound_vary,
			footstep_sounds[turf_footstep][3] + e_range + range_adjustment)
	else
		if(source.species.special_step_sounds)
			heard_clients = playsound(source_loc, pick(source.species.special_step_sounds), 50, sound_vary)
		else if(!source.species.play_bare_footsteps)
			heard_clients = playsound(source_loc, pick(footstep_sounds[turf_footstep][1]),
				footstep_sounds[turf_footstep][2] * volume * volume_multiplier,
				sound_vary,
				footstep_sounds[turf_footstep][3] + e_range + range_adjustment)
		else
			var/static/list/bare_footstep_sounds = GLOB.barefootstep
			var/footstep = source_loc.barefootstep
			if(isfloor(source_loc))
				var/turf/simulated/floor/floor = source_loc
				if(floor.flooring?.barefootstep)
					footstep = floor.flooring?.barefootstep
			if(!footstep)
				return

			heard_clients = playsound(source_loc, pick(bare_footstep_sounds[footstep][1]),
				bare_footstep_sounds[footstep][2] * volume * volume_multiplier,
				sound_vary,
				bare_footstep_sounds[footstep][3] + e_range + range_adjustment)

	if(length(heard_clients))
		play_fov_effect(source, 5, "footstep", direction, ignore_self = TRUE, override_list = heard_clients)


///Prepares a footstep for machine walking
/datum/element/footstep/proc/play_simplestep_machine(atom/movable/source)
	SIGNAL_HANDLER

	var/turf/source_loc = get_turf(source)
	if(!istype(source_loc))
		return
	playsound(source_loc, footstep_sounds, 50, sound_vary)
