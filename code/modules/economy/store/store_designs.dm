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
	GLOB.public_store_designs = list()

	var/list/temp_list = SSstore.known_designs.Copy()

	for (var/id in temp_list)

		var/datum/design/D = SSresearch.design_ids[id]

		//Its gotta be printable in the store
		if (!(D.build_type & STORE))
			continue


		LAZYADD(GLOB.public_store_designs[D.category], list(D.ui_data()))

	//Add this lot to the list
	for (var/datum/design/D in GLOB.unlimited_store_designs)
		LAZYADD(GLOB.public_store_designs[D.category], list(D.ui_data()))