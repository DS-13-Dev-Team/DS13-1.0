//Fires once every 10 seconds, used for things with a high performance footprint such as traumatic events. If you encounter issues with lag caused by this SS, disable it.

PROCESSING_SUBSYSTEM_DEF(trauma)
	name = "Psychotic trauma"
	wait = 10 SECONDS
	var/list/trauma_components = list()

/datum/controller/subsystem/processing/trauma/proc/try_add_trauma(var/atom/target)
	for(var/datum/component/traumatic_sight/compare in trauma_components)
		if(compare.source == target)
			return FALSE //We already have this trauma component registered. Don't give it processing time.
	var/datum/component/traumatic_sight/new_trauma = new /datum/component/traumatic_sight
	new_trauma.source = target
	trauma_components += new_trauma
	return TRUE

/datum/controller/subsystem/processing/trauma/proc/try_remove_trauma(var/atom/target)
	for(var/datum/component/traumatic_sight/compare in trauma_components)
		if(compare.source == target)
			trauma_components -= compare
			qdel(compare)