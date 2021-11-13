#define WORLD_ICON_SIZE 32

//This file is just for the necessary /world definition
//Try looking in game/world.dm

/**
 * # World
 *
 * Two possibilities exist: either we are alone in the Universe or we are not. Both are equally terrifying. ~ Arthur C. Clarke
 *
 * The byond world object stores some basic byond level config, and has a few hub specific procs for managing hub visiblity
 *
 * The world /New() is the root of where a round itself begins
 */

/world
	mob = /mob/dead/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 7
	hub = "Exadv1.spacestation13"
	icon_size = WORLD_ICON_SIZE
	fps = 20
#ifdef GC_FAILURE_HARD_LOOKUP
	loop_checks = FALSE
#endif