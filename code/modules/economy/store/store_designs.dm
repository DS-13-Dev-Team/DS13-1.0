/*
	The store uses research design datums for its items
*/

//This list holds all the designs, sorted into sublists tagged by category
GLOBAL_LIST_EMPTY(store_designs)
/obj/machinery/store


/proc/load_store_database()
	/*
		This is all for debug

		TODO Future: Load designs from a persistent database
	*/

	//For now we will just load every possible design

	var/list/temp_list = SSresearch.design_ids.Copy()

	for (var/id in temp_list)

		var/datum/design/D = temp_list[id]
		//Its gotta be printable in the store
		if (!(D.build_type & STORE))
			continue


		LAZYADD(GLOB.store_designs[D.category], list(D.ui_data))