#define DESTRUCTIVE 3

#define IMPRINTER_TAB 1
#define PROTOLATHE_TAB 2
#define RESEARCH_TAB 3
#define MAIN_TAB 4

/obj/machinery/computer/rdconsole/attack_hand(mob/user as mob)
	if(..())
		return TRUE
	tgui_interact(user)

/obj/machinery/computer/rdconsole/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/rdconsole/attack_ghost(mob/ghost)
	tgui_interact(ghost)

/obj/machinery/computer/rdconsole/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/research_designs),
		get_asset_datum(/datum/asset/spritesheet/research_technologies)
	)

/obj/machinery/computer/rdconsole/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RDConsole", "Research & Development Console")
		ui.open()

/obj/machinery/computer/rdconsole/ui_data(mob/user)
	var/list/data = list()
	data["sync"] = sync
	data["locked"] = locked
	data["has_imprinter"] = linked_imprinter ? TRUE : FALSE
	data["has_protolathe"] = linked_lathe ? TRUE : FALSE
	data["has_destroy"] = linked_destroy ? TRUE : FALSE

	return data

/obj/machinery/computer/rdconsole/ui_static_data(mob/user)
	var/list/data = list()

	data["can_research"] = can_research

	data["research_points"] = files.research_points

	data["access"] = req_access

	data["console_tab"] = cats[4]

	if(linked_lathe && cats[4] == PROTOLATHE_TAB)
		data["lathe_data"] = get_protolathe_data()

		data["lathe_queue_data"] = list()
		data["lathe_can_restart_queue"] = (linked_lathe.queue.len && !linked_lathe.busy)
		for(var/RNDD in linked_lathe.queue)
			data["lathe_queue_data"] += list(list("item" = RNDD, "name" = linked_lathe.queue[RNDD]["name"]))

		data["lathe_possible_designs"] = get_possible_designs_data(PROTOLATHE)
		data["lathe_all_cats"] = files.design_categories_protolathe
		data["lathe_cat"] = cats[PROTOLATHE_TAB]

	if(linked_imprinter && cats[4] == IMPRINTER_TAB)
		data["imprinter_data"] = get_imprinter_data()

		data["imprinter_queue_data"] = list()
		data["imprinter_can_restart_queue"] = (linked_imprinter.queue.len && !linked_imprinter.busy)
		for(var/RNDD in linked_imprinter.queue)
			data["imprinter_queue_data"] += list("item" = RNDD, "name" = linked_imprinter.queue[RNDD]["name"])

		data["imprinter_possible_designs"] = get_possible_designs_data(IMPRINTER)
		data["imprinter_all_cats"] = files.design_categories_imprinter
		data["imprinter_cat"] = cats[IMPRINTER_TAB]

	if(cats[4] == MAIN_TAB)
		var/list/tech_tree_list = list()
		for(var/tech_tree_id in files.tech_trees_shown)
			var/datum/tech/Tech_Tree = SSresearch.tech_trees[tech_tree_id]
			var/list/tech_tree_data = list(
				"name" =		capitalize(Tech_Tree.name),
				"shortname" =	capitalize(Tech_Tree.shortname),
				"level" =		files.tech_trees_shown[tech_tree_id],
				"maxlevel" =	Tech_Tree.maxlevel,
			)
			tech_tree_list += list(tech_tree_data)

		data["tech_trees"] = tech_tree_list

		if(linked_destroy)
			var/list/destroy_list = list(
				"has_item" = FALSE,
				"is_processing" = FALSE,
				"loading_item" = linked_destroy.loading
			)
			if(linked_destroy.loaded_item)
				var/list/tech_names = list(TECH_MATERIAL = "Materials", TECH_ENGINEERING = "Engineering", TECH_PHORON = "Phoron", TECH_POWER = "Power", TECH_BLUESPACE = "Blue-space", TECH_BIO = "Biotech", TECH_COMBAT = "Combat", TECH_MAGNET = "Electromagnetic", TECH_DATA = "Programming", TECH_ILLEGAL = "Illegal", TECH_NECRO = "Marker", TECH_ROBOT = "Roboticist")

				var/list/temp_tech = linked_destroy.loaded_item.origin_tech
				var/list/item_data = list()

				for(var/T in temp_tech)
					var/tech_name = tech_names[T]
					if(!tech_name)
						tech_name = T

					item_data += list(list(
						"id" =		T,
						"name" =	tech_name,
						"level" =	temp_tech[T],
					))

				// This calculates how much research points we missed because we already researched items with such orig_tech levels
				var/tech_points_mod = files.experiments.get_object_research_value(linked_destroy.loaded_item) / files.experiments.get_object_research_value(linked_destroy.loaded_item, ignoreRepeat = TRUE)

				destroy_list = list(
					"has_item" =			TRUE,
					"item_name" =			capitalize(linked_destroy.loaded_item.name),
					"item_desc" =			linked_destroy.loaded_item.desc,
					"icon_path" =			sanitizeFileName("[linked_destroy.loaded_item.type]"),
					"item_tech_points" =	files.experiments.get_object_research_value(linked_destroy.loaded_item),
					"item_tech_mod" = 		round(tech_points_mod*100),
					"is_processing" =		linked_destroy.busy,
					"loading_item" = 		linked_destroy.loading,
					"tech_data" = 			item_data
				)

			data["destroy_data"] = destroy_list

	if(cats[4] == RESEARCH_TAB)
		var/list/line_list = list()
		var/list/tech_list = list()
		var/list/tech_tree_list = list()

		for(var/tech_tree_id in files.tech_trees_shown)
			var/datum/tech/Tech_Tree = SSresearch.tech_trees[tech_tree_id]
			var/list/tech_tree_data = list(
				"id" =			Tech_Tree.id,
				"shortname" =	capitalize(Tech_Tree.shortname),
			)
			tech_tree_list += list(tech_tree_data)
		data["tech_trees"] = tech_tree_list
		data["tech_cat"] = cats[3]

		var/columns = 0
		var/rows = 0

		for(var/tech_id in files.all_technologies)
			var/datum/technology/Tech = SSresearch.all_technologies[tech_id]
			if(Tech.tech_type != cats[3])
				continue
			var/unlocks = list()
			var/req_techs_lock = list()
			var/req_techs_unlock = list()
			for(var/A in Tech.unlocks_designs)
				var/datum/design/temp = SSresearch.designs_by_id[A]
				unlocks |= capitalize(temp.name)
			for(var/A in Tech.required_technologies)
				var/datum/technology/temp = SSresearch.all_technologies[A]
				if(files.IsResearched(temp))
					req_techs_unlock |= capitalize(temp.name)
				else
					req_techs_lock |= capitalize(temp.name)
			if(columns < Tech.x)
				columns = Tech.x
			if(rows < Tech.y)
				rows = Tech.y
			var/list/tech_data = list(
				"id" =			Tech.id,
				"name" =		capitalize(Tech.name),
				"desc" =		Tech.desc,
				"tech_type" =	Tech.tech_type,
				"x" =			round(Tech.x),
				"y" =			round(Tech.y),
				"cost" =		Tech.cost,
				"isresearched" =files.IsResearched(Tech),
				"canresearch" = files.CanResearch(Tech))
			tech_list += list(tech_data)

			for(var/req_tech_id in Tech.required_technologies)
				if(req_tech_id in files.all_technologies)
					var/datum/technology/OTech = SSresearch.all_technologies[req_tech_id]
					if(OTech.tech_type == Tech.tech_type && !Tech.no_lines)
						var/first_height
						var/second_height
						var/first_width
						var/second_width
						var/top = FALSE
						var/bottom = FALSE
						var/left = FALSE
						var/right = FALSE
						if(OTech.y == Tech.y)
							bottom = TRUE
							first_height = OTech.y
							second_height = 0
							if(OTech.x < Tech.x)
								first_width = OTech.x + 1
								second_width = Tech.x - OTech.x
							else
								first_width = Tech.x + 1
								second_width = OTech.x - Tech.x

						else if(OTech.y < Tech.y)
							first_height = OTech.y + 1
							second_height = Tech.y - OTech.y
							if(OTech.x == Tech.x)
								right = TRUE
								first_width = OTech.x
								second_width = 0
							else if(OTech.x < Tech.x)
								right = TRUE
								top = TRUE
								first_width = OTech.x
								second_width = Tech.x - OTech.x + 1
							else
								left = TRUE
								top = TRUE
								first_width = Tech.x + 1
								second_width = OTech.x - Tech.x

						else
							first_height = Tech.y + 1
							second_height = OTech.y - Tech.y
							if(OTech.x == Tech.x)
								right = TRUE
								first_width = OTech.x
								second_width = 0
							else if(OTech.x < Tech.x)
								bottom = TRUE
								right = TRUE
								first_width = OTech.x + 1
								second_width = Tech.x - OTech.x
							else
								bottom = TRUE
								left = TRUE
								first_width = Tech.x + 1
								second_width = OTech.x - Tech.x

						var/list/line_data = list(
							"category" =	OTech.tech_type,
							"width_1" =		round(first_height),
							"height_1" =	round(first_width),
							"width_2" =		round(second_height),
							"height_2" =	round(second_width),
							"top" =			top,
							"bottom" =		bottom,
							"right" =		right,
							"left" =		left)
						line_list += list(line_data)

		data["columns"] = columns
		data["rows"] = rows
		data["techs"] = tech_list
		data["lines"] = line_list

		if(cats[5])
			var/datum/technology/Tech = SSresearch.all_technologies[cats[5]]
			var/unlocks = list()
			var/req_techs_lock = list()
			var/req_techs_unlock = list()

			for(var/A in Tech.unlocks_designs)
				var/datum/design/temp = SSresearch.designs_by_id[A]
				unlocks |= capitalize(temp.name)

			for(var/A in Tech.required_technologies)
				var/datum/technology/temp = SSresearch.all_technologies[A]
				if(files.IsResearched(temp))
					req_techs_unlock |= capitalize(temp.name)
				else
					req_techs_lock |= capitalize(temp.name)

			var/list/tech_data = list(
			"id" =				Tech.id,
			"name" =			capitalize(Tech.name),
			"desc" =			Tech.desc,
			"cost" =			Tech.cost,
			"isresearched" =	files.IsResearched(Tech),
			"canresearch" = 	files.CanResearch(Tech),
			"req_techs_lock" =	req_techs_lock,
			"req_techs_unlock" =req_techs_unlock,
			"unlocks_design" =	unlocks)

			data["selected_tech"] = tech_data

	return data

/obj/machinery/computer/rdconsole/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return
	if(!locked)
		switch(action)
			if("change_tab")
				if(params["machine"] && params["tab"])
					if(cats[text2num(params["machine"])] != params["tab"])
						switch(text2num(params["tab"]))
							if(IMPRINTER_TAB)
								if(linked_imprinter)
									cats[text2num(params["machine"])] = params["tab"]
									playsound(src, get_sfx("keyboard"), VOLUME_HIGH)
							if(PROTOLATHE_TAB)
								if(linked_lathe)
									cats[text2num(params["machine"])] = params["tab"]
									playsound(src, get_sfx("keyboard"), VOLUME_HIGH)
							else
								cats[text2num(params["machine"])] = params["tab"]
								playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

			if("set_selected_tech")
				if(cats[5] != params["tech_id"])
					cats[5] = params["tech_id"]
					playsound(src, get_sfx("keyboard"), VOLUME_HIGH)
				else
					return

			if("change_design_cat_arrow")
				if(params["dir"] == "right")
					if(text2num(params["machine"]) == PROTOLATHE)
						var/cat = files.design_categories_protolathe.Find(cats[PROTOLATHE_TAB])
						if(cat < files.design_categories_protolathe.len)
							cats[PROTOLATHE_TAB] = files.design_categories_protolathe[cat+1]
						else
							cats[PROTOLATHE_TAB] = files.design_categories_protolathe[1]
						playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

					else if(text2num(params["machine"]) == IMPRINTER)
						var/cat = files.design_categories_imprinter.Find(cats[IMPRINTER_TAB])
						if(cat < files.design_categories_imprinter.len)
							cats[IMPRINTER_TAB] = files.design_categories_imprinter[cat+1]
						else
							cats[IMPRINTER_TAB] = files.design_categories_imprinter[1]
						playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

					else if(text2num(params["machine"]) == RESEARCH_TAB)
						var/cat = files.tech_trees_shown.Find(cats[3])
						if(cat < files.tech_trees_shown.len)
							cats[3] = files.tech_trees_shown[cat+1]
						else
							cats[3] = files.tech_trees_shown[1]
						playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

				else
					if(text2num(params["machine"]) == PROTOLATHE)
						var/cat = files.design_categories_protolathe.Find(cats[PROTOLATHE_TAB])
						if(cat > 1)
							cats[PROTOLATHE_TAB] = files.design_categories_protolathe[cat-1]
						else
							cats[PROTOLATHE_TAB] = files.design_categories_protolathe[files.design_categories_protolathe.len]
						playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

					else if(text2num(params["machine"]) == IMPRINTER)
						var/cat = files.design_categories_imprinter.Find(cats[IMPRINTER_TAB])
						if(cat > 1)
							cats[IMPRINTER_TAB] = files.design_categories_imprinter[cat-1]
						else
							cats[IMPRINTER_TAB] = files.design_categories_imprinter[files.design_categories_imprinter.len]
						playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

					else if(text2num(params["machine"]) == RESEARCH_TAB)
						var/cat = files.tech_trees_shown.Find(cats[3])
						if(cat > 1)
							cats[3] = files.tech_trees_shown[cat-1]
						else
							cats[3] = files.tech_trees_shown[files.tech_trees_shown.len]
						playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

			if("eject")
				var/amount = text2num(params["amount"])
				if(!amount)
					to_chat(usr, "<span class=\"alert\">[src] only accepts a numerical amount!</span>")
					return

				if(text2num(params["machine"]) == PROTOLATHE)
					linked_lathe?.eject_sheet(params["id"], round(amount))

				else if(text2num(params["machine"]) == IMPRINTER)
					linked_imprinter?.eject_sheet(params["id"], round(amount))

				playsound(src, get_sfx("keystroke"), VOLUME_HIGH)

			if("build")
				var/amount=text2num(params["amount"])
				if(params["id"] in files.known_designs)
					var/datum/design/being_built = SSresearch.designs_by_id[params["id"]]
					if(amount)
						switch(text2num(params["machine"]))
							if(PROTOLATHE)
								linked_lathe?.queue_design(being_built, amount)
							if(IMPRINTER)
								linked_imprinter?.queue_design(being_built, amount)
				else
					log_and_message_admins("Possible hacker detected. User tried to print research design that wasn't yet researched. Design id: [params["id"]]", usr, usr.loc)

				playsound(src, get_sfx("keystroke"), VOLUME_HIGH)

			if("research_tech")
				if((params["tech_id"] in files.all_technologies) && can_research)
					var/datum/technology/T = SSresearch.all_technologies[params["tech_id"]]
					if(files.UnlockTechology(T))
						playsound(src, get_sfx("keystroke"), VOLUME_HIGH)

			if("clear_queue")
				switch(text2num(params["machine"]))
					if(PROTOLATHE)
						linked_lathe?.clear_queue()
					if(IMPRINTER)
						linked_imprinter?.clear_queue()

			if("restart_queue")
				switch(text2num(params["machine"]))
					if(PROTOLATHE)
						linked_lathe?.restart_queue()
					if(IMPRINTER)
						linked_imprinter?.restart_queue()

			if("remove_from_queue")
				switch(text2num(params["machine"]))
					if(PROTOLATHE)
						linked_lathe?.queue -= params["queue_item"]
					if(IMPRINTER)
						linked_imprinter?.queue -= params["queue_item"]

			if("resync_machines")
				SyncRDevices()
				playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

			if("togglesync")
				sync = !sync
				playsound(src, get_sfx("keyboard"), VOLUME_HIGH)
				return TRUE // We dont need to send static data again

			if("sync")
				sync_tech()
				playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

			if("lock")
				playsound(src, get_sfx("keyboard"), VOLUME_HIGH)
				if(allowed(usr) || emagged)
					locked = !locked
					return TRUE // We dont need to send static data again
				else
					to_chat(usr, SPAN_WARNING("Unauthorized Access."))
					return

			if("disconnect")
				switch(text2num(params["machine"]))
					if(IMPRINTER)
						linked_imprinter.linked_console = null
						linked_imprinter = null
						if(cats[4] == IMPRINTER_TAB)
							cats[3] = 1

					if(PROTOLATHE)
						linked_lathe.linked_console = null
						linked_lathe = null
						if(cats[4] == PROTOLATHE_TAB)
							cats[4] = 1

					if(DESTRUCTIVE)
						linked_destroy.linked_console = null
						linked_destroy = null

				playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

			if("purge")
				var/amount = text2num(params["volume"])
				if(!amount)
					to_chat(usr, "<span class=\"alert\">[src] only accepts a numerical volume!</span>")
					return

				switch(params["machine"])
					if(PROTOLATHE)
						linked_lathe?.reagents.remove_reagents_of_type(text2path(params["type"]), round(amount))
					if(IMPRINTER)
						linked_imprinter?.reagents.remove_reagents_of_type(text2path(params["type"]), round(amount))

				playsound(src, get_sfx("keystroke"), VOLUME_HIGH)

			if("deconstruct")
				linked_destroy?.deconstruct_item()
				playsound(src, get_sfx("keystroke"), VOLUME_HIGH)

			if("eject_decon")
				linked_destroy?.eject_item(usr)
				playsound(src, get_sfx("keyboard"), VOLUME_HIGH)

		SStgui.update_uis(src, TRUE)

	else
		if(action == "lock")
			playsound(src, get_sfx("keyboard"), VOLUME_HIGH)
			if(allowed(usr) || emagged)
				locked = !locked
				return TRUE // We dont need to send static data again
			else
				to_chat(usr, SPAN_WARNING("Unauthorized Access."))

/obj/machinery/computer/rdconsole/proc/get_protolathe_data()
	var/list/protolathe_list = list(
		"machine_id" =				PROTOLATHE,
		"max_material_storage" =	linked_lathe.max_material_storage,
		"total_materials" =			linked_lathe.TotalMaterials(),
		"total_volume" =			linked_lathe.reagents.total_volume,
		"maximum_volume" =			linked_lathe.reagents.maximum_volume,
	)
	var/list/protolathe_reagent_list = list()
	for(var/datum/reagent/R in linked_lathe.reagents.reagent_list)
		protolathe_reagent_list += list(list(
			"name" =	R.name,
			"volume" =	R.volume,
			"type" =	R.type
		))
	protolathe_list["reagents"] = protolathe_reagent_list
	var/list/material_list = list()
	for(var/M in linked_lathe.materials)
		if(linked_lathe.materials[M]["amount"])
			material_list += list(list(
				"id" =		M,
				"name" =	linked_lathe.materials[M]["name"],
				"amount" =	linked_lathe.materials[M]["amount"],
			))
	protolathe_list["materials"] = material_list
	return protolathe_list

/obj/machinery/computer/rdconsole/proc/get_imprinter_data()
	var/list/imprinter_list = list(
		"machine_id" =				IMPRINTER,
		"max_material_storage" =	linked_imprinter.max_material_storage,
		"total_materials" =			linked_imprinter.TotalMaterials(),
		"total_volume" =			linked_imprinter.reagents.total_volume,
		"maximum_volume" =			linked_imprinter.reagents.maximum_volume,
	)
	var/list/printer_reagent_list = list()
	for(var/datum/reagent/R in linked_imprinter.reagents.reagent_list)
		printer_reagent_list += list(list(
			"name" =	R.name,
			"volume" =	R.volume,
			"type" =	R.type,
		))
	imprinter_list["reagents"] = printer_reagent_list
	var/list/material_list = list()
	for(var/M in linked_imprinter.materials)
		if(linked_imprinter.materials[M]["amount"])
			material_list += list(list(
				"id" =		M,
				"name" =	linked_imprinter.materials[M]["name"],
				"amount" =	linked_imprinter.materials[M]["amount"],
			))
	imprinter_list["materials"] = material_list
	return imprinter_list

/obj/machinery/computer/rdconsole/proc/get_possible_designs_data(build_type)
	var/coeff = 1
	if(build_type == PROTOLATHE)
		coeff = linked_lathe.efficiency_coeff
	if(build_type == IMPRINTER)
		coeff = linked_imprinter.efficiency_coeff

	var/list/designs_list = list()
	for(var/I in files.known_designs)
		var/datum/design/D = SSresearch.designs_by_id[I]
		if(D.build_type & build_type && D.category == cats[build_type])
			var/list/design_data = D.ui_data.Copy()
			var/c = 50
			var/t
			for(var/M in D.materials)
				if(build_type == PROTOLATHE)
					t = linked_lathe.check_mat(D, M)
				if(build_type == IMPRINTER)
					t = linked_imprinter.check_mat(D, M)

				design_data["mats"] += list(list("name" = capitalize(M), "amount" = D.materials[M]/coeff, "can_make" = t >= 1 ? TRUE:FALSE))

				c = min(t,c)

			for(var/R as anything in D.chemicals)
				if(build_type == PROTOLATHE)
					t = linked_lathe.check_mat(D, R)
				if(build_type == IMPRINTER)
					t = linked_imprinter.check_mat(D, R)

				design_data["chems"] += list(list("name" = CallReagentName(R), "amount" = D.chemicals[R]/coeff, "can_make" = t >= 1 ? TRUE:FALSE))

				c = min(t,c)

			design_data["can_create"] = c
			designs_list += list(design_data)

	return designs_list

#undef DESTRUCTIVE

#undef IMPRINTER_TAB
#undef PROTOLATHE_TAB
#undef MAIN_TAB
#undef RESEARCH_TAB