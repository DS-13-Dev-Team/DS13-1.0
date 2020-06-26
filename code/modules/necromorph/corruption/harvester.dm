/*
*/

#define HARVESTER_HARVEST_RANGE	10
/obj/structure/corruption_node/harvester
	name = "Harvester"
	desc = "It will take its due"
	max_health = 300
	resistance = 30	//Extremely tough, basically immune to small arms fire
	icon_state = "growth"
	density = TRUE

	biomass = 30
	biomass_reclamation = 0.0
	placement_type = /datum/click_handler/placement/necromorph/harvester

	var/list/passive_sources = list()
	var/list/active_sources = list()
	var/list/all_sources = list()

	var/datum/biomass_source/passive_datum
	var/datum/biomass_source/active_datum

	var/refresh_timer

/obj/structure/corruption_node/harvester/Initialize()
	.=..()
	register_sources()

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
	passive_sources = stuff[1]
	active_sources = stuff[2]
	all_sources = passive_sources + active_sources

	//Ok now lets do individual stuff for them
	for (var/atom/A as anything in all_sources)
		GLOB.moved_event.register(A, src, /obj/structure/corruption_node/harvester/proc/source_moved)
		GLOB.destroyed_event.register(A, src, /obj/structure/corruption_node/harvester/proc/source_deleted)

/obj/structure/corruption_node/harvester/proc/unregister_sources()
	for (var/atom/A as anything in all_sources)
		GLOB.moved_event.unregister(A, src, /obj/structure/corruption_node/harvester/proc/source_moved)
		GLOB.destroyed_event.unregister(A, src, /obj/structure/corruption_node/harvester/proc/source_deleted)

	passive_sources = list()
	active_sources = list()
	all_sources = list()

//When a source moves, we update, but with a delay for batching
/obj/structure/corruption_node/harvester/proc/source_moved()
	if (refresh_timer)
		return
	refresh_timer = addtimer(CALLBACK(src, /obj/structure/corruption_node/harvester/proc/refresh_sources), 3 SECONDS, timer_stoppable)

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
		-Biomass Storage tank<br>\"

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
		else if (result == MASS_READY_ACTIVE)
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
	MASS_READY_ACTIVE if its a limited quantity source

*/
/datum/proc/can_harvest_biomass()
	return MASS_FAIL