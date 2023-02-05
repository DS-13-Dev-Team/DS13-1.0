/datum/map_generator/cave_generator
	var/name = "Cave Generator"
	///Weighted list of the types that spawns if the turf is open
	var/open_turf_types = list(
		/turf/simulated/floor/asteroid/outside_ds = 8,
		/turf/simulated/floor/asteroid/outside_ds/firm = 1,
		/turf/simulated/floor/asteroid/outside_ds/muddy = 1,
		/turf/simulated/floor/asteroid/outside_ds/cracked = 1,
		/turf/simulated/floor/asteroid/outside_ds/dry_soft = 1,
		/turf/simulated/floor/asteroid/outside_ds/dry_firm = 1,
		/turf/simulated/floor/asteroid/outside_ds/dry_muddy = 1,
		/turf/simulated/floor/asteroid/outside_ds/dry_cracked = 1,
		)
	///Weighted list of the types that spawns if the turf is closed
	var/closed_turf_types = list(
		/turf/simulated/mineral = 10,
		/turf/simulated/mineral/random = 3,
		/turf/simulated/mineral/random/high_chance = 1,
	)

	///Weighted list of mobs that can spawn in the area.
	var/list/mob_spawn_list
	///Weighted list of flora that can spawn in the area.
	var/list/flora_spawn_list
	///Weighted list of extra features that can spawn in the area, such as geysers.
	var/list/feature_spawn_list


	///Base chance of spawning a mob
	var/mob_spawn_chance = 6
	///Base chance of spawning flora
	var/flora_spawn_chance = 2
	///Base chance of spawning features
	var/feature_spawn_chance = 0.1
	///Unique ID for this spawner
	var/string_gen

	///Chance of cells starting closed
	var/initial_closed_chance = 45
	///Amount of smoothing iterations
	var/smoothing_iterations = 20
	///How much neighbours does a dead cell need to become alive
	var/birth_limit = 4
	///How little neighbours does a alive cell need to die
	var/death_limit = 3

/datum/map_generator/cave_generator/New()
	. = ..()
	if(!mob_spawn_list)
		mob_spawn_list = list()
	if(!flora_spawn_list)
		flora_spawn_list = list()
	if(!feature_spawn_list)
		feature_spawn_list = list()

/datum/map_generator/cave_generator/generate_terrain(list/turfs)
	. = ..()
	var/start_time = REALTIMEOFDAY
	string_gen = rustg_cnoise_generate("[initial_closed_chance]", "[smoothing_iterations]", "[birth_limit]", "[death_limit]", "[world.maxx]", "[world.maxy]") //Generate the raw CA data

	for(var/i in turfs) //Go through all the turfs and generate them
		var/turf/gen_turf = i

		var/area/A = gen_turf.loc
		if(!(A.area_flags & AREA_FLAG_CAVES_ALLOWED))
			continue

		var/closed = text2num(string_gen[world.maxx * (gen_turf.y - 1) + gen_turf.x])

		var/stored_flags
		if(gen_turf.turf_flags & TURF_FLAG_NO_RUINS)
			stored_flags |= TURF_FLAG_NO_RUINS

		var/turf/simulated/new_turf = pickweight(closed ? closed_turf_types : open_turf_types)

		new_turf = gen_turf.ChangeTurf(new_turf, defer_change = TRUE)

		new_turf.turf_flags |= stored_flags

		if(!closed)//Open turfs have some special behavior related to spawning flora and mobs.

			var/turf/new_open_turf = new_turf

			///Spawning isn't done in procs to save on overhead on the 60k turfs we're going through.

			//FLORA SPAWNING HERE
			var/atom/spawned_flora
			if(flora_spawn_list && prob(flora_spawn_chance))
				var/can_spawn = TRUE

				if(!(A.area_flags & AREA_FLAG_FLORA_ALLOWED))
					can_spawn = FALSE
				if(can_spawn)
					spawned_flora = pickweight(flora_spawn_list)
					spawned_flora = new spawned_flora(new_open_turf)

			//FEATURE SPAWNING HERE
			var/atom/spawned_feature
			if(feature_spawn_list && prob(feature_spawn_chance))
				var/can_spawn = TRUE

				if(!(A.area_flags & AREA_FLAG_FLORA_ALLOWED)) //checks the same flag because lol dunno
					can_spawn = FALSE

				var/atom/picked_feature = pickweight(feature_spawn_list)

				for(var/obj/structure/F in range(7, new_open_turf))
					if(istype(F, picked_feature))
						can_spawn = FALSE

				if(can_spawn)
					spawned_feature = new picked_feature(new_open_turf)

			//MOB SPAWNING HERE

			if(mob_spawn_list && !spawned_flora && !spawned_feature && prob(mob_spawn_chance))
				var/can_spawn = TRUE

				if(!(A.area_flags & AREA_FLAG_MOB_SPAWN_ALLOWED))
					can_spawn = FALSE

				var/atom/picked_mob = pickweight(mob_spawn_list)

				for(var/thing in urange(12, new_open_turf)) //prevents mob clumps
					if(!istype(thing, /mob/living/simple_animal/hostile) && !istype(thing, /obj/structure/spawner))
						continue
					/*
					if(ispath(picked_mob, /mob/living/simple_animal/hostile/asteroid) || istype(thing, /mob/living/simple_animal/hostile/asteroid))
						can_spawn = FALSE //if the random is a standard mob, avoid spawning if there's another one within 12 tiles
						break
					if((ispath(picked_mob, /obj/structure/spawner/lavaland) || istype(thing, /obj/structure/spawner/lavaland)) && get_dist(new_open_turf, thing) <= 2)
						can_spawn = FALSE //prevents tendrils spawning in each other's collapse range
						break
					*/

				if(can_spawn)
					new picked_mob(new_open_turf)

		CHECK_TICK

	report_progress(SPAN_BOLDANNOUNCE("[name] finished in [(REALTIMEOFDAY - start_time)/10]s!"))


