


/*
	Corruption Source Datum
*/
/datum/extension/corruption_source
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE
	var/range = 12
	var/growth_speed = 1	//Multiplier on growth speed
	var/growth_distance_falloff = 0.15	//15% added to growth time for each tile of distance from the source
	var/support_limit = null
	var/atom/source
	var/obj/machinery/portable_atmospherics/hydroponics/soil/invisible/plant
	var/list/corruption_vines = list()	//A list of all the vines we're currently supporting

	//What tiles are revealed to the visualnet by our corruption vines?
	var/list/visualnet_tiles = list()
	var/needs_update = TRUE	//A dirty bit. Set true when our list of vines changes
	//If its true when visualnets update, we'll re-fetch all the tiles from the corruption

	//Is this source currently active?
	var/enabled = TRUE

/datum/extension/corruption_source/New(var/atom/holder, var/range, var/speed, var/falloff, var/limit)
	source = holder
	GLOB.corruption_sources |= src
	plant = new (get_turf(source), GLOB.corruption_seed)
	GLOB.moved_event.register(source, src, /datum/extension/corruption_source/proc/source_moved)
	GLOB.destroyed_event.register(source, src, /datum/extension/corruption_source/proc/source_deleted)
	if (range)
		src.range = range
	if (speed)
		growth_speed = speed
	if (falloff)
		growth_distance_falloff = falloff
	if (limit)
		support_limit = limit

	new /obj/effect/vine/corruption(get_turf(source),GLOB.corruption_seed, start_matured = 1, newsource = src)

	//Corruption tiles add vision
	source.visualnet_range = range
	GLOB.necrovision.add_source(source)

/datum/extension/corruption_source/Destroy()
	GLOB.corruption_sources -= src
	QDEL_NULL(plant)
	update_vines()
	corruption_vines = list()
	source = null
	.=..()



/datum/extension/corruption_source/proc/register(var/obj/effect/vine/corruption/applicant)
	if (!can_support(applicant))
		return FALSE

	//If its switching sources, remove from the old one first
	if (applicant.source)
		applicant.source.unregister(applicant)

	corruption_vines |= applicant
	applicant.plant = plant
	applicant.source = src

	//When we gain or lose a vine, our visualnet has changed
	needs_update = TRUE
	applicant.update_chunks()	//Lets also update the chunk(s) the vine is in/next to

/datum/extension/corruption_source/proc/unregister(var/obj/effect/vine/corruption/applicant)
	corruption_vines -= applicant
	if (applicant.source == src)
		applicant.source = null
		applicant.plant = null

	//When we gain or lose a vine, our visualnet has changed
	needs_update = TRUE
	applicant.update_chunks()	//Lets also update the chunk(s) the vine is in/next to


//Is this source able to provide support to a specified turf or corruption vine?
/datum/extension/corruption_source/proc/can_support(var/atom/A)
	//If we're turned off we cant support anyone
	if (!enabled)
		return FALSE

	//Hard numerical limits
	if (support_limit)
		if (corruption_vines.len >= support_limit)
			return FALSE

	var/turf/T = get_turf(A)
	var/distance = get_dist_3D(get_turf(source), T)
	//We check distance fist, it's quick and efficient
	if (distance > range)
		return FALSE


	//TODO Future:
		//View restricting


	return TRUE


/datum/extension/corruption_source/proc/source_moved(var/atom/movable/mover, var/old_loc, var/new_loc)
	plant.forceMove(get_turf(new_loc))
	update_vines()

/datum/extension/corruption_source/proc/source_deleted()
	qdel(src)


//Called when a source moves, gets deleted, changes its radius or other parameters.
//Tells all the associated vines to update various things, and/or find a new parent to support them now that we're gone
//If we are being deleted, plant will be nulled out before calling this
/datum/extension/corruption_source/proc/update_vines()
	for (var/obj/effect/vine/corruption/C as anything in corruption_vines)
		C.wake_up(FALSE)




/* Visualnet Handling */
//-------------------

//A corruption source caches the visual data from all the turfs under its banner
/datum/extension/corruption_source/get_visualnet_tiles(var/datum/visualnet/network)

	if (needs_update)
		update_visualnet()


	return visualnet_tiles

//This proc reads and stores the visualnet tiles from all of our vines. It is only called when potentially necessary
/datum/extension/corruption_source/proc/update_visualnet()
	visualnet_tiles = list()
	for (var/obj/effect/vine/corruption/C in corruption_vines)
		visualnet_tiles += C.get_visualnet_tiles(GLOB.necrovision)
	needs_update = FALSE