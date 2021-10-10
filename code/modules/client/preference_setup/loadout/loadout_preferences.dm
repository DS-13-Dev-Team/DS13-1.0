

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