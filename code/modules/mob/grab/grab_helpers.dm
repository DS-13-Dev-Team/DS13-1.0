/*
	Returns true if src has an active, valid grab with target as the victim
	If no target is passed, returns true when grabbing anyone
*/
/mob/living/proc/is_grabbing(var/mob/living/target)
	for (var/obj/item/grab/G in get_held_items())
		if (!target && G.affecting)
			return TRUE
		else if (G.affecting == target)
			return TRUE

	return FALSE

/*
	With no target, drops all grabs
	With a target, drops only grabs affecting that target
*/

/mob/living/proc/stop_grabbing(var/mob/living/target)
	for (var/obj/item/grab/G in get_held_items())
		if (!target)
			G.force_drop()
		else if (G.affecting == target)
			G.force_drop()
