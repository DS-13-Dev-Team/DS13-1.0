/*
	Crew objectives are triggered through the major event pool.

	Generally they create some ongoing crisis that has broad negative effects, including delaying the evac and end of round,
	until the problem is resolved

	They mostly consist of a machine or system breaking down, and require a team to be sent to fix it.

	Necromorphs will attempt to ambush people who come to repair it
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
#define STATUS_INACTIVE	1	//Nothing has happened with this event, its not been selected
#define STATUS_WARMUP	2	//Its been selected and necromorphs have been unlocked. No effects have started yet, it will start soon
#define STATUS_ACTIVE	3	//We are now in full swing, the humans have been notified, all ongoing effects are active
#define STATUS_FADING	4	//Crew repaired the thing, the event is over. The last of the free necros can still be spawned, passive effects are gone
#define STATUS_DONE		5	//This event is concluded and cannot trigger again this round. Necrospawns are disabled, remaining free necros are lost.


/datum/crew_objective
	/*
		This list contains all the areas associated with this objective. It is made of several keyed sublists
		At authortime it is populated with sublist_key = list(typepaths...)
		At runtime the typepaths are converted to actual area references
	*/
	var/list/areas


	/*
		This should be a list of necromorph species tag = weight
		When a wave of necromorphs spawns, we will first try to create one of each thing in the list
		Then we will pickweight from the list until nothing is left affordable
	*/
	var/list/necromorphs


	//If false, this can occur more than once per round. no current use case
	var/oneshot = TRUE

	var/status