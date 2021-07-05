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
SUBSYSTEM_DEF(database)
	name = "Database"
	init_order = SS_INIT_MISC_LATE
	wait = 1 MINUTE

	//A list of mind datums whose credit amounts have changed recently, and are queued for updates
	//These are batched into one per mind per minute, as needed, to reduce database load.
	//So we're not sending a flurry of requests if someone is shuffling around chips in their inventory
	var/list/credits_to_update = list()




/datum/controller/subsystem/database/Initialize()



/datum/controller/subsystem/database/fire(resumed = 0)
	for (var/datum/mind/M as anything in credits_to_update)
		update_lastround_credits(M)

	credits_to_update = list()










/*
	Credit Handling
*/
/datum/controller/subsystem/database/proc/credits_changed(var/datum/mind/M)
	credits_to_update |= M

//Mob level helper
/mob/proc/credits_changed()
	world << "[src] credits changed"
	if (mind)
		SSdatabase.credits_changed(mind)

//Item helper
/obj/item/proc/credits_changed()
	var/mob/M = get_holding_mob()
	if(M)
		M.credits_changed()