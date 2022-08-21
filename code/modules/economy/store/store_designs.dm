//This list holds all the designs that are publicly available, sorted into sublists tagged by category. These are unlocked by schematics
GLOBAL_LIST_EMPTY(public_store_designs)

//This list holds designs which come from custom items, but do NOT require any special status, and are available to everyone
//These do not require schematics
GLOBAL_LIST_EMPTY(unlimited_store_designs)

//Holds designs that are patron only or require a whitelist. These do not require schematics
GLOBAL_LIST_EMPTY(limited_store_designs)

/proc/load_store_database()
	for(var/id in SSresearch.designs_by_id.Copy())
		var/datum/design/D = SSresearch.designs_by_id[id]

		if(D.PI && D.PI.store_access != ACCESS_PUBLIC)
			LAZYADD(GLOB.limited_store_designs, id)

		else if(D.build_type & STORE_ROUNDSTART || (D.PI && D.PI.store_access == ACCESS_PUBLIC))
			LAZYADD(GLOB.unlimited_store_designs, id)

		else if(D.build_type & STORE_SCHEMATICS)
			LAZYADD(GLOB.public_store_designs, id)