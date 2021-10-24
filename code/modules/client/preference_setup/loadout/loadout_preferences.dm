//A two-part loading process, make sure these are both true before letting players mess with loadouts
GLOBAL_VAR_INIT(loadout_datums_loaded, FALSE)
GLOBAL_VAR_INIT(custom_items_loaded, FALSE)

GLOBAL_LIST_EMPTY(pending_loadouts)

/datum/preferences/proc/Gear()
	//Not initialized?
	if (!gear_list)
		reset_gear_list()

	.= LAZYACCESS(gear_list, gear_slot)
	if (!.)
		return list()




/*
	loadout_category is a datum created at runtime from this generic parent type to hold data about lists of gear datums
*/
/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(var/cat)
	category = cat
	..()



/proc/handle_pending_loadouts()
	for (var/datum/extension/loadout/L in GLOB.pending_loadouts)
		if (QDELETED(L))
			continue

		L.validate()

	GLOB.pending_loadouts = list()