/*
	This system handles persistent content and player vars which are stored in an external database
	It loads them as soon as possible when the server boots
	It also saves things back to the database, generally at a minimum interval of once a minute, but it can do it on demand

	Currently used for:
		Characters, generally
		Persistent credits
		Store schematics

	Planned future uses:
		Skills?
*/

//TODO: Fix depositing credits from chip to rig
SUBSYSTEM_DEF(database)
	name = "Database"
	wait = 1 MINUTE
	init_order = SS_INIT_DATABASE	//Initializes before atoms



	//Design caches
	var/list/known_designs
	var/list/unknown_designs


	var/list/pending_schematics = list()

	//A list of mind datums whose credit amounts have changed recently, and are queued for updates
	//These are batched into one per mind per minute, as needed, to reduce database load.
	//So we're not sending a flurry of requests if someone is shuffling around chips in their inventory
	var/list/credits_to_update = list()

	var/free_schematics	=	20	//The first X are considered free and won't be counted when determining how many to remove
	var/schematic_loss	=	0.05

/datum/controller/subsystem/database/stat_entry(msg)
	return "Click to debug!"

/datum/controller/subsystem/database/Initialize()


	log_world("Database initializing")
	//update_store_designs()	//No point doing this here, its called from the asset system after designs are initialised



/datum/controller/subsystem/database/fire(resumed = 0)
	for (var/datum/mind/M as anything in credits_to_update)
		update_lastround_credits(M)

	credits_to_update = list()