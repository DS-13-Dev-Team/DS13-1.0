//TO DO: replacing system

var/global/datum/global_init/init = new ()

/datum/global_init/New()
	callHook("global_init")
	initialize_chemical_reactions()

	qdel(src)

/datum/global_init/Destroy(force = FALSE)
	if(!force)
		return 2

	return ..()
