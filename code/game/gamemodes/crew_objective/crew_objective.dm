/*
	Crew objectives are global singletons in a datum ref list
	triggered through the major event pool.

	Generally they create some ongoing crisis that has broad negative effects, including delaying the evac and end of round,
	until the problem is resolved

	They mostly consist of a machine or system breaking down, and require a team to be sent to fix it.

	Necromorphs will attempt to ambush people who come to repair it


	To Add a new objective:
		1. Make a new file with a subtype of /datum/crew_objective
		2. Add it to the crew_objectives list in ishimura.dm
*/

/*
	Sublist keys. These just categorise the areas list
*/
#define AREA_COMBAT	"combat"	//Areas where necros and humans meet
#define AREA_SPAWNING	"spawn"	//Areas where necros spawn, and have a special buff until they leave. No humans allowed
#define AREA_REST	"rest"	//Safe places for humans to resupply, necros maybe not allowed

/*
	Status flags for the objective
*/
#define CO_STATUS_INACTIVE	1	//Nothing has happened with this event, its not been selected
#define CO_STATUS_WARMUP	2	//Its been selected and necromorphs have been unlocked. No effects have started yet, it will start soon
#define CO_STATUS_ACTIVE	3	//We are now in full swing, the humans have been notified, all ongoing effects are active
#define CO_STATUS_FADING	4	//Crew repaired the thing, the event is over. The last of the free necros can still be spawned, passive effects are gone
#define CO_STATUS_DONE		5	//This event is concluded and cannot trigger again this round. Necrospawns are disabled, remaining free necros are lost.

#define SET_PROGRESS(A)	. = A;	min_progress = max(A, min_progress);

/datum/crew_objective

	var/name = "Crew Objective"
	/*
		This list contains all the areas associated with this objective. It is made of several keyed sublists
		At authortime it is populated with sublist_key = list(typepaths...)
		At runtime the typepaths are converted to actual area references
			The Spawning sublist has special behaviour. It can use a format of typepath = threshold, where threshold is a value in the range 0..1
			If this is used, that area will become available for spawning only when the progress is >= threshold
	*/
	var/list/areas


	/*
		This should be a list of necromorph species name = weight
		When a wave of necromorphs spawns, we will first try to create one of each thing in the list
		Then we will pickweight from the list until nothing is left affordable
	*/
	var/list/necromorphs

	//When all biomass has been released and used, the leftover biomass will be consumed to create one of these
	var/fallback_necromorph = SPECIES_NECROMORPH_SLASHER

	/*
		A list of lists, each sublist is in the format
		list("quantity" = value, "threshold" = value, "released" = FALSE)
	*/
	var/list/biomass_payouts

	var/biomass = 0

	var/all_spawns_opened = FALSE	//have all possible spawnpoints been opened?
	//This can remain false after triggering, as some spawnpoints may be locked until a certain progress threshold


	//If false, this can occur more than once per round. no current use case
	var/oneshot = TRUE

	//Must be one of the CO_STATUS flags above
	var/status	=	CO_STATUS_INACTIVE

	//How much advance notice the necromorphs get before we enter active state
	var/warmup_time = 5 MINUTES

	//Once the objective is complete, the necromorphs get this much time to spawn any leftover necros.
	//After it expires, the nests are deleted and any unspawned necros are lost
	var/fade_time = 3 MINUTES


	//The event which triggered us and runs in the background. We will end it when we do.
	//If admins end it, it will end us too
	var/datum/event/event


	//These cached values are used to track progress
	//Current is updated at the start of check_progress
	//Last is updated at the end
	var/current_progress = 0
	var/last_progress = null

	//Used to mark a point we can't backslide from, return value from get_progress will always be at least this
	var/min_progress = 0

	//How likely this is
	var/weight = 1

	//Set true after init
	var/initialized = FALSE

	//Holds an event meta that our event is assigned to. Just a useful reference for helper procs
	var/datum/event_meta/crew_objective/EM

	var/sabotaged = FALSE

	/*
		This is used in the necrospawn UI
	*/
	var/color = "#ff9600"

	//How many extra points this adds to global evacuation point requirement
	var/evac_cost = 30

/*
	Override procs.
	Override these in a subclass, generally no others
*/
/datum/crew_objective/proc/on_trigger()

/datum/crew_objective/proc/on_activate()

/datum/crew_objective/proc/on_fade()

/datum/crew_objective/proc/on_end()

/datum/crew_objective/proc/announce_trigger()
	link_necromorphs_to("CREW OBJECTIVE [name] ACTIVATING SOON AT LINK. Nearby spawnpoints are now open, prepare to ambush incoming repair crew", get_epicentre())

/datum/crew_objective/proc/announce_activate()

/datum/crew_objective/proc/announce_fade()
	link_necromorphs_to("Crew objective [name] at LINK has been completed. Nearby spawnpoints will soon close down and any unused free necros will be lost. Spawn them now!", get_epicentre())


//This should return an atom which represents where the event is happening
/datum/crew_objective/proc/get_epicentre()


/datum/crew_objective/proc/Initialize()
	//Lets grab the areas
	for (var/area_sublist in areas)
		var/list/sublist_types = areas[area_sublist]	//This is a sublist of typepaths
		var/list/sublist_datums = list()	//We'll replace the above with this list of datums we create
		for (var/area_type in sublist_types)
			var/area/A = locate(area_type)
			if (A)
				sublist_datums += A
				if (istype(A, /area/necrospawn))
					var/area/necrospawn/AB = A
					AB.event = src
				A.seal()
			if (sublist_types[area_type])	//Copy over the value from associative lists
				sublist_datums[A] = sublist_types[area_type]
		areas[area_sublist] = sublist_datums
		sublist_types = null		//We're done with this


	//Lets grab the necromorph datums too
	var/list/n_datums = list()
	for (var/species_tag in necromorphs)
		var/datum/species/S = all_species[species_tag]
		n_datums[S] = necromorphs[species_tag]//Copy the weight
	necromorphs = n_datums


	//Lets create an event for us
	setup_event()

	initialized = TRUE

/*
	Triggering and Warmup
*/

//Called when inactive, by the event
/datum/crew_objective/proc/trigger()
	status	=	CO_STATUS_WARMUP
	min_progress = 0 //Reset this in the case of more than one ocurrence in a round
	announce_trigger()
	open_spawns()
	handle_biomass_and_necromorphs()

	//For the currently impossible but plausible-in-future edge case where we were sabotaged, triggered, and might trigger again in this round
	//Reset the extra weighting caused by sabotage
	if (sabotaged)
		EM.weight = src.weight

	addtimer(CALLBACK(src, /datum/crew_objective/proc/activate), warmup_time, TIMER_STOPPABLE)



/*
	Activate
*/
/datum/crew_objective/proc/activate()
	status	=	CO_STATUS_ACTIVE
	announce_activate()

	START_PROCESSING(SSslowprocess, src)
	on_activate()




/datum/crew_objective/Process()
	check_progress()

	//The status will change if progress hit a threshold
	if (status != CO_STATUS_ACTIVE)
		return PROCESS_KILL

	process_active()


/datum/crew_objective/proc/process_active()
	//Called periodically while active



/*
	Called periodically while in active state
	This ends the event if the current progress value hits 1.
	It also triggers the release of more objective necros when it reaches milestones
*/
/datum/crew_objective/proc/check_progress()
	current_progress = get_progress()
	var/changed = (current_progress != last_progress)

	if (changed)
		//This will open any new spawns that might have hit threshold
		open_spawns()
		handle_biomass_and_necromorphs()

	last_progress = current_progress

	if (current_progress >= 1)
		//Progress hit one, we are done
		fade()



/*
	Called periodically while in active state
	Override with each objective
	This should return a value in the range 0..1 representing how much of the repair work the crew has done.
	A value of 1 indicates that repairs are complete and will immediately switch us to fading status
*/
/datum/crew_objective/proc/get_progress()
	return 0


/*
	This opens up spawnpoints which currently meet the threshold
*/
/datum/crew_objective/proc/open_spawns()
	if (all_spawns_opened)
		return

	var/list/spawn_areas = areas[AREA_SPAWNING]
	var/opened = 0
	var/not_opened = 0
	for (var/area/necrospawn/A in spawn_areas)
		if (A.active)
			continue
		var/threshold = (spawn_areas[A] ? spawn_areas[A] : 0)
		if (last_progress >= threshold)
			A.open_spawner()
			opened++
		else
			not_opened++

	if (opened)
		message_necromorphs("[opened] new necro spawnpoints have opened near the objective location")

	if (!not_opened)
		all_spawns_opened = TRUE	//All the spawnpoints are active, we can skip this in future

/datum/crew_objective/proc/close_spawns()
	var/list/spawn_areas = areas[AREA_SPAWNING]
	for (var/area/necrospawn/A in spawn_areas)
		A.close_spawner()

	message_necromorphs("All event spawnpoints for [src] have been closed and are no longer useable.")



/*
	This releases extra biomass and then allocates necromorphs from it
*/
/datum/crew_objective/proc/handle_biomass_and_necromorphs()

	for (var/list/sublist in biomass_payouts)
		var/released = sublist["released"]
		if (released)
			continue

		var/threshold = sublist["threshold"]

		//Lets check whether we just passed this threshold
		if (current_progress >= threshold)
			release_biomass(sublist["quantity"])


/datum/crew_objective/proc/release_biomass(var/quantity)

	biomass += quantity
	allocate_necromorphs()

/datum/crew_objective/proc/allocate_necromorphs(var/last_call = FALSE)
	var/list/shortlist = necromorphs.Copy()
	while (shortlist.len && biomass > 0)
		var/datum/species/necromorph/N = pickweight(shortlist)
		if (N.biomass <= src.biomass)
			release_necromorph(N)
		else
			shortlist -= N

	if (last_call)
		var/datum/species/necromorph/N =  all_species[fallback_necromorph]
		release_necromorph(N)



/datum/crew_objective/proc/release_necromorph(var/datum/species/necromorph/N)
	var/obj/machinery/marker/marker = get_marker()
	biomass -= N.biomass
	if (biomass < 0)
		biomass = 0	//Dont let this be negative
	var/datum/necroshop/shop = marker.shop
	var/datum/necroshop_item/NI = shop.get_listing(N.name)
	if (!NI.event_spawns)
		NI.event_spawns = list()
	var/existing = NI.event_spawns[src] ? NI.event_spawns[src] : 0
	NI.event_spawns[src] = existing+1
	shop.generate_content_data()




//This removes any unused free necros
/datum/crew_objective/proc/remove_necromorphs()
	var/obj/machinery/marker/marker = get_marker()
	var/datum/necroshop/shop = marker.shop
	for (var/species_tag in shop.spawnable_necromorphs)
		var/datum/necroshop_item/I = shop.spawnable_necromorphs[species_tag]
		I.event_spawns -= src
	shop.generate_content_data()








/*
	Fade
*/
/datum/crew_objective/proc/fade()
	status	=	CO_STATUS_FADING
	STOP_PROCESSING(SSslowprocess, src)
	announce_fade()
	allocate_necromorphs(last_call = TRUE)
	on_fade()
	addtimer(CALLBACK(src, /datum/crew_objective/proc/end), fade_time, TIMER_STOPPABLE)












/*
	End
*/
/datum/crew_objective/proc/end()
	status	=	CO_STATUS_DONE
	close_spawns()
	remove_necromorphs()
	biomass = 0



/*
	Sabotage
*/
/datum/crew_objective/proc/can_sabotage()
	return ((sabotaged == FALSE) && (status	==	CO_STATUS_INACTIVE))

//When an objective is sabotaged, its weight increases massively, and the global timer to next event is decreased
/datum/crew_objective/proc/sabotage()
	sabotaged = TRUE
	EM.weight *= 10

	var/datum/event_container/EC = SSevent.event_containers[EVENT_LEVEL_MAJOR]
	EC.next_event_time -= OBJECTIVE_SABOTAGE_TIME_REDUCTION

