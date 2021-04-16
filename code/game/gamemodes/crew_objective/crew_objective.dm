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
		This should be a list of necromorph species tag = weight
		When a wave of necromorphs spawns, we will first try to create one of each thing in the list
		Then we will pickweight from the list until nothing is left affordable
	*/
	var/list/necromorphs

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

	//What was the value of current progress the last time we checked
	var/last_progress = 0

	//How likely this is
	var/weight = 1

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
	link_necromorphs_to("Crew objective [name] at LINK has been compelted. Nearby spawnpoints will soon close down and any unused free necros will be lost. Spawn them now!", get_epicentre())


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
			if (sublist_types[area_type])	//Copy over the value from associative lists
				sublist_datums[A] = sublist_types[area_type]
		areas[area_sublist] = sublist_datums
		sublist_types = null		//We're done with this

	//TODO: Prepare the areas, seal them in indestructible walls

	//Lets create an event for us
	setup_event()

/*
	Triggering and Warmup
*/

//Called when inactive, by the event
/datum/crew_objective/proc/trigger()
	status	=	CO_STATUS_WARMUP
	announce_trigger()
	open_spawns()
	//TODO: Select the first wave of objective necros
	addtimer(CALLBACK(src, /datum/crew_objective/proc/activate), warmup_time, TIMER_STOPPABLE)




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
		var/threshold = spawn_areas[A]
		if (last_progress >= threshold)
			A.open_spawner()
			opened++
		else
			not_opened++

	if (opened)
		message_necromorphs("[opened] new necro spawnpoints have opened near the objective location")

	if (!not_opened)
		all_spawns_opened = TRUE	//All the spawnpoints are active, we can skip this in future



/*
	Activate
*/
/datum/crew_objective/proc/activate()
	status	=	CO_STATUS_ACTIVE
	announce_activate()

	//TODO: Start the passive effect from the system being broken
	//TODO: Start regular progress checks
	//TODO: Fade when a progress check returns 1
	START_PROCESSING(SSslowprocess, src)
	on_activate()



/datum/crew_objective/Process()
	check_progress()

	//The status will change if progress hit a threshold
	if (status != CO_STATUS_ACTIVE)
		return PROCESS_KILL

/*
	Called periodically while in active state
	This ends the event if the current progress value hits 1.
	It also triggers the release of more objective necros when it reaches milestones
*/
/datum/crew_objective/proc/check_progress()
	var/current_progress = get_progress()
	var/changed = (current_progress != last_progress)
	last_progress = current_progress
	if (changed)
		//This will open any new spawns that might have hit threshold
		open_spawns()
		//TODO: Release more biomass at appropriate milestones

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
	Fade
*/
/datum/crew_objective/proc/fade()
	status	=	CO_STATUS_FADING
	if (is_processing)
		STOP_PROCESSING(SSslowprocess, src)
	announce_fade()
	//TODO: Warn necromorphs for last call
	on_fade()
	addtimer(CALLBACK(src, /datum/crew_objective/proc/end), fade_time, TIMER_STOPPABLE)



/*
	Fade
*/
/datum/crew_objective/proc/end()
	status	=	CO_STATUS_DONE
	//TODO: Delete spawning nests
	//TODO: Remove any unused spawns
	//TODO: Unregister ourself
