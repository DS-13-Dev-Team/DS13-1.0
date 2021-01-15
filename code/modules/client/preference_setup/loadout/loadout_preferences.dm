

/datum/preferences/proc/Gear()
	//Not initialized?
	if (!gear_list)
		reset_gear_list()

	.= LAZYACCESS(gear_list, gear_slot)
	if (!.)
		return list()

/datum/loadout_category
	var/category = ""
	var/list/gear = list()

/datum/loadout_category/New(cat)
	category = cat
	..()