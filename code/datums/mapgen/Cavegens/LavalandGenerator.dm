/datum/map_generator/cave_generator/aegis
	name = "Aegis Generation"
	open_turf_types = list(
		/turf/simulated/floor/asteroid/outside_ds = 8,
		/turf/simulated/floor/asteroid/outside_ds/firm = 1,
		/turf/simulated/floor/asteroid/outside_ds/muddy = 1,
		/turf/simulated/floor/asteroid/outside_ds/cracked = 1,
		/turf/simulated/floor/asteroid/outside_ds/dry_soft = 1,
		/turf/simulated/floor/asteroid/outside_ds/dry_firm = 1,
		/turf/simulated/floor/asteroid/outside_ds/dry_muddy = 1,
		/turf/simulated/floor/asteroid/outside_ds/dry_cracked = 1,
		)
	closed_turf_types = list(
		/turf/simulated/mineral = 10,
		/turf/simulated/mineral/random = 3,
		/turf/simulated/mineral/random/high_chance = 1,
	)

	mob_spawn_list = list()
	flora_spawn_list = list()
	///Note that this spawn list is also in the icemoon generator
	feature_spawn_list = list()

	initial_closed_chance = 45
	smoothing_iterations = 50
	birth_limit = 4
	death_limit = 3

/area/aegis_gen
	name = "aegis generation area"
	base_lighting_alpha = 80
	area_flags = AREA_FLAG_CAVES_ALLOWED
	map_generator = /datum/map_generator/cave_generator/aegis

