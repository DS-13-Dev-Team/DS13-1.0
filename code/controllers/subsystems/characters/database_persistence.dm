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
SUBSYSTEM_DEF(database_persistence)
	name = "Database Persistence"
	init_order = SS_INIT_MISC_LATE


/datum/controller/subsystem/database_persistence/Initialize()



