/*
	Special areas mark places necromorphs can spawn for events
*/
/area/necrospawn
	var/active = FALSE	//Has this already been opened for spawning?
	var/obj/structure/corruption_node/nest/event_spawn/spawner
	var/datum/crew_objective/event

/area/necrospawn/Entered(atom/movable/Obj,atom/OldLoc)
	if (isliving(Obj))
		set_extension(Obj, /datum/extension/spawn_buff)
	.=..()


/area/necrospawn/Exited(atom/movable/Obj,atom/OldLoc)
	.=..()
	if(isliving(Obj))
		remove_extension(Obj, /datum/extension/spawn_buff)

/area/necrospawn/proc/open_spawner()
	if (spawner)
		return

	var/turf/T = get_clear_turf()
	spawner = new /obj/structure/corruption_node/nest/event_spawn(T, event = src.event)
	active = TRUE


/area/necrospawn/proc/close_spawner()
	if (spawner)
		QDEL_NULL(spawner)
	for(var/mob/living/L in contents)
		qdel(L)
/*
	While standing inside the spawn area, necromorphs get buffs to vision and movespeed, plus xray vision, so they can position themselves for ambush
*/
/datum/extension/spawn_buff
	flags = EXTENSION_FLAG_IMMEDIATE
	expected_type = /mob/living
	statmods = list(STATMOD_VIEW_RANGE = 3, STATMOD_MOVESPEED_MULTIPLICATIVE = 3)

/datum/extension/spawn_buff/New(var/atom/holder)
	.=..()
	var/mob/living/L = holder
	L.mutations += XRAY
	L.update_living_sight()


/datum/extension/spawn_buff/Destroy()
	var/mob/living/L = holder
	L.mutations -= XRAY
	L.update_living_sight()
	.=..()




