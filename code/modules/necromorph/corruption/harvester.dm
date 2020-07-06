/*
	List of things we can absorb:
	Infinite:
		/obj/machinery/growth_tank, code/game/machinery/ds13/bpl/growth_tank.dm
		/obj/structure/morgue, code/game/object/strucures/morgue.dm
		/obj/machinery/portable_atmospherics/hydroponics, code/modules/hydroponics/trays/tray.dm
		/obj/machinery/cryopod, code/game/machinery/cryopod.dm

	Limited:
		/obj/structure/reagent_dispensers/biomass, code/game/machinery/ds13/bpl/biomass_storage.dm
		/obj/machinery/vending, code/game/machinery/vending.dm (only certain subtypes which contain biological matter)
*/

#define HARVESTER_HARVEST_RANGE	10
/obj/structure/corruption_node/harvester
	name = "Harvester"
	desc = "It will take its due"
	max_health = 300
	resistance = 30	//Extremely tough, basically immune to small arms fire
	icon = 'icons/effects/corruption96x96.dmi'
	icon_state = "harvester"
	density = TRUE

	appearance_flags = PIXEL_SCALE

	biomass = 30
	biomass_reclamation = 0.0
	placement_type = /datum/click_handler/placement/necromorph/harvester
	default_scale = 1
	random_rotation = FALSE

	var/list/passive_sources = list()
	var/list/active_sources = list()
	var/list/all_sources = list()

	var/datum/biomass_source/passive_datum
	var/datum/biomass_source/active_datum

	var/refresh_timer

	//Harvester dies fast without corruption support
	degen = 5

	var/deployed = TRUE

/obj/structure/corruption_node/harvester/update_icon()
	set waitfor = FALSE

	.=..()

	underlays.Cut()
	overlays.Cut()

	if (deployed)
		overlays += image(icon, src, "beak")
		underlays += image(icon, src, "tentacle_1")
		sleep(1)
		underlays += image(icon, src, "tentacle_2")
		sleep(1)
		underlays += image(icon, src, "tentacle_3")
		sleep(1)
		underlays += image(icon, src, "tentacle_4")


/obj/structure/corruption_node/harvester/Initialize()
	.=..()
	register_sources()
	update_icon()

/obj/structure/corruption_node/harvester/Destroy()
	unregister_sources()
	.=..()


//Registration and listeners
//----------------------------

/obj/structure/corruption_node/harvester/proc/refresh_sources()
	deltimer(refresh_timer)
	refresh_timer = null
	unregister_sources()
	register_sources()

/obj/structure/corruption_node/harvester/proc/register_sources()
	var/list/stuff = get_harvestable_biomass_sources(src, FALSE)
	if (stuff.len == 2)
		passive_sources = stuff[1]
		active_sources = stuff[2]
	all_sources = passive_sources + active_sources

	//Ok now lets do individual stuff for them
	for (var/atom/A as anything in all_sources)
		GLOB.moved_event.register(A, src, /obj/structure/corruption_node/harvester/proc/source_moved)
		GLOB.destroyed_event.register(A, src, /obj/structure/corruption_node/harvester/proc/source_deleted)

	//Alright lets create the biomass sources on the marker
	var/obj/machinery/marker/M = get_marker()
	if (LAZYLEN(passive_sources))
		passive_datum = M.add_biomass_source(src, INFINITY, INFINITY, /datum/biomass_source/harvest)
		var/passive_biomass = 0
		for (var/datum/D as anything in passive_sources)
			passive_biomass += D.harvest_biomass(1)
		//This is how much the passive biomass sources will give in total each tick
		passive_datum.last_absorb = passive_biomass

	if (LAZYLEN(active_sources))
		active_datum = M.add_biomass_source(src, INFINITY, INFINITY, /datum/biomass_source/harvest/active)

	//We add an outline visual effect to each thing we're absorbing from
	for (var/atom/A in all_sources)
		var/newfilter = filter(type="outline", size=1, color=COLOR_MARKER_RED)
		A.filters.Add(newfilter)
		all_sources[A] = newfilter//We store the reference to that filter in the all_sources list, so we can cleanly remove it later if needed




/obj/structure/corruption_node/harvester/proc/unregister_sources()
	for (var/atom/A as anything in all_sources)
		if (!QDELETED(A))
			GLOB.moved_event.unregister(A, src, /obj/structure/corruption_node/harvester/proc/source_moved)
			GLOB.destroyed_event.unregister(A, src, /obj/structure/corruption_node/harvester/proc/source_deleted)
			A.filters.Remove(all_sources[A])	//Remove the visual filter we created earlier by using its stored reference

	passive_sources = list()
	active_sources = list()
	all_sources = list()

	//These biomass source datums do their own cleanup in destroy, we can just delete them and everything works magically
	QDEL_NULL(passive_datum)
	QDEL_NULL(active_datum)

//When a source moves, we update, but with a delay for batching
/obj/structure/corruption_node/harvester/proc/source_moved()
	if (refresh_timer)
		return
	refresh_timer = addtimer(CALLBACK(src, /obj/structure/corruption_node/harvester/proc/refresh_sources), 3 SECONDS, TIMER_STOPPABLE)

//If a source is deleted we refresh immediately
/obj/structure/corruption_node/harvester/proc/source_deleted()
	refresh_sources()



/obj/structure/corruption_node/harvester/get_blurb()
	return "The Harvester is a node for securiting territory and extracting biomass from certain objects. \
	It is dense and near-indestructible, mostly it can only be destroyed by cutting it off from corruption, at which point it will stop working, starve and die.<br>\
	<br>\
	The harvester can draw biomass slowly, but infinitely, from the following kinds of objects:<br>\
		-Cryostorage beds<br>\
		-Bioprosthetic Growth Tanks<br>\
		-Morgue Drawers<br>\
		-Hydroponics Trays<br>\
	<br>\
	In addition, the Harvester can draw biomass more rapidly - but in limited total quantities, from the following objects:<br>\
		-Food/Snack/Drink/fertilizer vending machiness<br>\
		-Biomass Storage tank"

/*
	Biomass Absorbing
*/
/obj/structure/corruption_node/harvester/proc/handle_active_absorb(var/ticks = 1)
	world << "Doing active absorb"
	//If anything returns MASS_FAIL, we will have to redo our sources
	var/failed = FALSE
	var/total = 0
	for (var/datum/D as anything in active_sources)
		var/result = D.can_harvest_biomass()
		world << "Result for [D] is [result]"
		//This thing is no longer viable
		if (result == MASS_FAIL)
			failed = TRUE
			continue

		//Its still viable but isn't giving us anything this tick, thats fine
		else if (result == MASS_PAUSE)
			continue

		else
			//Alright we can absorb!
			total += D.harvest_biomass(ticks)
			world << "Absorbing, total now [total]"

	.=total	//We'll return the total

	//If we failed, spawn off a refresh to get new sources
	if (failed)
		spawn()
			refresh_sources()

/*
	Click Handler
*/
/datum/click_handler/placement/necromorph/harvester

/datum/click_handler/placement/necromorph/harvester/placement_blocked(var/turf/candidate)
	.=..()
	if (!.)
		var/found_food = get_harvestable_biomass_sources(candidate, TRUE)
		if (!found_food)
			return "There are no objects within range of this location which contain harvestable biomass."

//Helper Proc
//This searched for nearby things that could be used by a harvester node.
//If single_check is set true, this proc simply returns TRUE if it finds any sources at all, and FALSE otherwise
//When single_check is disabled, this proc returns a list of two sublists, one for passive objects and one for active objects
/proc/get_harvestable_biomass_sources(var/atom/source, var/single_check = FALSE)
	var/list/passive_sources = list()
	var/list/active_sources = list()
	for (var/atom/O in view(HARVESTER_HARVEST_RANGE, source))
		var/result = O.can_harvest_biomass()
		if (result == MASS_FAIL)
			continue

		if (single_check)
			return TRUE	//We found anything, we're done

		if (result == MASS_READY)
			passive_sources += O
		else if (result == MASS_ACTIVE)
			active_sources += O

	//Alright at the end, lets see.
	if (single_check)
		return FALSE	//We didnt find anything

	return list(passive_sources, active_sources)







//Procs on objects

/*
	Called to see if we can harvest biomass from this thing.
	This should return MASS_FAIL if no
	MASS_READY if its an infinite source
	MASS_ACTIVE if its a limited quantity source

*/
/datum/proc/can_harvest_biomass()
	return MASS_FAIL


//This is called in two situations:
//1. For infinite sources, it's called once at the start - possibly only once ever - to find out how much biomass this source is worth per tick
//2. For limited sources, it's called each time biomass is absorbed, so the source can deplete itself appropriately.
	//Return zero to indicate we've run out of biomass, and force a re-considering of things
//In either case, this proc should return the quantity of biomass which was successfully harvested
//The ticks var contains the number of ticks (seconds) since the last time biomass was absorbed. This should be applied as a multiplier on the biomass taken and returned
/datum/proc/harvest_biomass(var/ticks = 1)
	return 0