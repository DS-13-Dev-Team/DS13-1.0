/*
	The store uses research design datums for its items
*/

//This list holds all the designs that are publicly available, sorted into sublists tagged by category. These are unlocked by schematics
GLOBAL_LIST_EMPTY(public_store_designs)

//This list holds designs which come from custom items, but do NOT require any special status, and are available to everyone
//These do not require schematics
GLOBAL_LIST_EMPTY(unlimited_store_designs)

//Holds designs that are patron only or require a whitelist. These do not require schematics
GLOBAL_LIST_EMPTY(limited_store_designs)

/obj/machinery/store

/datum/design
	//A patron item datum used to manage access
	var/datum/patron_item/PI


/proc/load_store_database()
	for(var/id in SSresearch.design_ids.Copy())
		var/datum/design/D = SSresearch.design_ids[id]

		if(D.build_type & STORE_ROUNDSTART)
			LAZYADD(GLOB.unlimited_store_designs[D.category], list(D.ui_data()))

		else if(D.build_type & STORE_SCHEMATICS)
			LAZYADD(GLOB.public_store_designs[D.category], list(D.ui_data()))
