/*
	The store uses research design datums for its items
*/

//This list holds all the designs, sorted into sublists tagged by category
GLOBAL_LIST_EMPTY(store_designs)
/obj/machinery/store


/proc/load_store_database()
	GLOB.store_designs = list()

	var/list/temp_list = SSdatabase.known_designs.Copy()

	for (var/id in temp_list)

		var/datum/design/D = SSresearch.design_ids[id]

		//Its gotta be printable in the store
		if (!(D.build_type & STORE))
			continue


		LAZYADD(GLOB.store_designs[D.category], list(D.ui_data))