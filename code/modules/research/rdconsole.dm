/*
Research and Development (R&D) Console
This is the main work horse of the R&D system. It contains the menus/controls for the Destructive Analyzer, Protolathe, and Circuit
imprinter. It also contains the /datum/research holder with all the known/possible technology paths and device designs.
Basic use: When it first is created, it will attempt to link up to related devices within 3 squares. It'll only link up if they
aren't already linked to another console. Any consoles it cannot link up with (either because all of a certain type are already
linked or there aren't any in range), you'll just not have access to that menu. In the settings menu, there are menu options that
allow a player to attempt to re-sync with nearby consoles. You can also force it to disconnect from a specific console.
The imprinting and construction menus do NOT require toxins access to access but all the other menus do. However, if you leave it
on a menu, nothing is to stop the person from using the options on that menu (although they won't be able to change to a different
one). You can also lock the console on the settings menu if you're feeling paranoid and you don't want anyone messing with it who
doesn't have toxins access.
When a R&D console is destroyed or even partially disassembled, you lose all research data on it. However, there is a way around
this dire fate:
- Go to the settings menu and select "Sync Database with Network." That causes it to upload (but not download)
it's data to every other device in the game. Each console has a "disconnect from network" option that'll will cause data base sync
operations to skip that console. This is useful if you want to make a "public" R&D console or, for example, give the engineers
a circuit imprinter with certain designs on it and don't want it accidentally updating. The downside of this method is that you have
to have physical access to the other console to send data back. Note: An R&D console is on CentCom so if a random griffan happens to
cause a ton of data to be lost, an admin can go send it back.
*/

/obj/machinery/computer/rdconsole
	name = "fabrication control console"
	desc = "Console controlling the various fabrication devices. Uses self-learning matrix to hold and optimize blueprints. Prone to corrupting said matrix, so back up often."
	icon_keyboard = "rd_key"
	icon_screen = "rdcomp"
	light_color = "#a97faa"
	circuit = /obj/item/weapon/circuitboard/rdconsole
	var/datum/research/files							//Stores all the collected research data.

	var/obj/machinery/r_n_d/destructive_analyzer/linked_destroy = null	//Linked Destructive Analyzer
	var/obj/machinery/r_n_d/protolathe/linked_lathe = null				//Linked Protolathe
	var/obj/machinery/r_n_d/circuit_imprinter/linked_imprinter = null	//Linked Circuit Imprinter

	var/screen = "main"       //Which screen is currently showing.
	var/id = 0                //ID of the computer (for server restrictions).
	var/sync = TRUE           //If sync = 0, it doesn't show up on Server Control Console
	var/can_research = TRUE   //Is this console capable of researching

	var/selected_tech_tree
	var/selected_technology
	var/show_settings = FALSE
	var/show_link_menu = FALSE
	var/selected_protolathe_category
	var/selected_imprinter_category
	var/search_text

	req_access = list(access_research)	//Data and setting manipulation requires scientist access.

/obj/machinery/computer/rdconsole/proc/CallReagentName(var/reagent_type)
	var/datum/reagent/R = reagent_type
	return ispath(reagent_type, /datum/reagent) ? initial(R.name) : "Unknown"

/obj/machinery/computer/rdconsole/proc/SyncRDevices() //Makes sure it is properly sync'ed up with the devices attached to it (if any).
	for(var/obj/machinery/r_n_d/D in range(4, src))
		if(D.linked_console != null || D.panel_open)
			continue
		if(istype(D, /obj/machinery/r_n_d/destructive_analyzer))
			if(linked_destroy == null)
				linked_destroy = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/protolathe))
			if(linked_lathe == null)
				linked_lathe = D
				D.linked_console = src
		else if(istype(D, /obj/machinery/r_n_d/circuit_imprinter))
			if(linked_imprinter == null)
				linked_imprinter = D
				D.linked_console = src
	return

/obj/machinery/computer/rdconsole/Initialize()
	.=..()
	files = new /datum/research(src) //Setup the research data holder
	SyncRDevices()
	sync_tech()

/obj/machinery/computer/rdconsole/Destroy()
	sync_tech()
	QDEL_NULL(files)
	if(linked_destroy)
		linked_destroy.linked_console = null
		linked_destroy = null
	if(linked_lathe)
		linked_lathe.linked_console = null
		linked_destroy = null
	if(linked_imprinter)
		linked_imprinter.linked_console = null
		linked_destroy = null
	.=..()

/obj/machinery/computer/rdconsole/attackby(var/obj/item/weapon/D as obj, var/mob/user as mob)
	if(istype(D, /obj/item/weapon/disk/research_points))
		var/obj/item/weapon/disk/research_points/disk = D
		to_chat(user, "<span class='notice'>[name] received [disk.stored_points] research points from [disk.name]</span>")
		files.research_points += disk.stored_points
		user.remove_from_mob(disk)
		qdel(disk)

	else
		.=..()

	update_open_uis()

/obj/machinery/computer/rdconsole/attack_hand(mob/user as mob)
	if(..())
		return
	ui_interact(user)

/obj/machinery/computer/rdconsole/emp_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
		emagged = 1
		to_chat(user, "<span class='notice'>You you disable the security protocols.</span>")
		return 1

/obj/machinery/computer/rdconsole/Topic(href, href_list) // Oh boy here we go.
	if(..())
		return TRUE

	if(href_list["select_tech_tree"])
		var/new_select_tech_tree = href_list["select_tech_tree"]
		if(new_select_tech_tree in files.tech_trees_shown)
			selected_tech_tree = new_select_tech_tree
			selected_technology = null
	if(href_list["select_technology"])
		var/new_selected_technology = href_list["select_technology"]
		if(new_selected_technology in files.all_technologies)
			selected_technology = new_selected_technology
	if(href_list["unlock_technology"])
		var/unlock = href_list["unlock_technology"]
		files.UnlockTechology(SSresearch.all_technologies[unlock])
	if(href_list["go_screen"])
		var/where = href_list["go_screen"]
		if(href_list["need_access"])
			if(!allowed(usr) && !emagged)
				to_chat(usr, "<span class='warning'>Unauthorized Access.</span>")
				return
		screen = where
		if(screen == "protolathe" || screen == "circuit_imprinter")
			search_text = ""
	if(href_list["toggle_settings"])
		if(allowed(usr) || emagged)
			show_settings = !show_settings
		else
			to_chat(usr, "<span class='warning'>Unauthorized Access.</span>")
	if(href_list["toggle_link_menu"])
		if(allowed(usr) || emagged)
			show_link_menu = !show_link_menu
		else
			to_chat(usr, "<span class='warning'>Unauthorized Access.</span>")
	if(href_list["sync"]) //Sync the research holder with all the R&D consoles in the game that aren't sync protected.
		if(!sync)
			to_chat(usr, "<span class='warning'>You must connect to the network first!</span>")
		else
			screen = "working"
			addtimer(CALLBACK(src, .proc/sync_tech), 3 SECONDS)
			update_open_uis()
	if(href_list["togglesync"]) //Prevents the console from being synced by other consoles. Can still send data.
		sync = !sync
	if(href_list["build"] && screen == "protolathe" && linked_lathe) //Causes the Protolathe to build something.
		var/amount=text2num(href_list["amount"])
		var/datum/design/being_built = null
		if(SSresearch.designs_by_id[href_list["build"]])
			being_built = SSresearch.designs_by_id[href_list["build"]]
		if(being_built && amount)
			linked_lathe.queue_design(being_built, amount)
	if(href_list["build"] && screen == "circuit_imprinter" && linked_imprinter)
		var/datum/design/being_built = null
		if(SSresearch.designs_by_id[href_list["build"]])
			being_built = SSresearch.designs_by_id[href_list["build"]]
		if(being_built)
			linked_imprinter.queue_design(being_built)
	if(href_list["select_category"])
		var/what_cat = href_list["select_category"]
		if(screen == "protolathe")
			selected_protolathe_category = what_cat
		if(screen == "circuit_imprinter")
			selected_imprinter_category = what_cat
	if(href_list["search"])
		var/input = input(usr, "Enter text to search", "Searching") as null|text
		search_text = input
		if(screen == "protolathe")
			if(!search_text)
				selected_protolathe_category = null
			else
				selected_protolathe_category = "Search Results"
		if(screen == "circuit_imprinter")
			if(!search_text)
				selected_imprinter_category = null
			else
				selected_imprinter_category = "Search Results"
	if(href_list["clear_queue"])
		if(screen == "protolathe" && linked_lathe)
			linked_lathe.clear_queue()
		if(screen == "circuit_imprinter" && linked_imprinter)
			linked_imprinter.clear_queue()
	if(href_list["restart_queue"])
		if(screen == "protolathe" && linked_lathe)
			linked_lathe.restart_queue()
		if(screen == "circuit_imprinter" && linked_imprinter)
			linked_imprinter.restart_queue()
	if(href_list["deconstruct"])
		if(linked_destroy)
			linked_destroy.deconstruct_item()
	if(href_list["eject_item"])
		if(linked_destroy)
			linked_destroy.eject_item()
	if(href_list["protolathe_purgeall"] && linked_lathe)
		linked_lathe.reagents.clear_reagents()
	if(href_list["protolathe_purge"] && linked_lathe)
		linked_lathe.reagents.del_reagent(text2path(href_list["protolathe_purge"]))
	if(href_list["imprinter_purgeall"] && linked_imprinter)
		linked_imprinter.reagents.clear_reagents()
	if(href_list["imprinter_purge"] && linked_imprinter)
		linked_imprinter.reagents.del_reagent(text2path(href_list["imprinter_purge"]))
	if(href_list["lathe_ejectsheet"] && linked_lathe)
		var/desired_num_sheets = text2num(href_list["lathe_ejectsheet_amt"])
		linked_lathe.eject_sheet(href_list["lathe_ejectsheet"], desired_num_sheets)
	if(href_list["imprinter_ejectsheet"] && linked_imprinter)
		var/desired_num_sheets = text2num(href_list["imprinter_ejectsheet_amt"])
		linked_imprinter.eject_sheet(href_list["imprinter_ejectsheet"], desired_num_sheets)
	if(href_list["find_device"])
		screen = "working"
		addtimer(CALLBACK(src, .proc/find_devices), 2 SECONDS)
	if(href_list["disconnect"]) //The R&D console disconnects with a specific device.
		switch(href_list["disconnect"])
			if("destroy")
				linked_destroy.linked_console = null
				linked_destroy = null
			if("lathe")
				linked_lathe.linked_console = null
				linked_lathe = null
			if("imprinter")
				linked_imprinter.linked_console = null
				linked_imprinter = null
	if(href_list["lock"]) //Lock the console from use by anyone without tox access.
		if(allowed(usr) || emagged)
			screen = "locked"
		else
			to_chat(usr, "<span class='warning'>Unauthorized Access.</span>")
	if(href_list["unlock"])
		if(allowed(usr) || emagged)
			screen = "main"
		else
			to_chat(usr, "<span class='warning'>Unauthorized Access.</span>")

	return TRUE

/obj/machinery/computer/rdconsole/proc/find_devices()
	SyncRDevices()
	screen = "main"
	update_open_uis()

/obj/machinery/computer/rdconsole/proc/sync_tech()
	for(var/obj/machinery/r_n_d/server/S in SSresearch.servers)
		var/server_processed = FALSE
		if(S.disabled)
			continue
		if((id in S.id_with_upload))
			S.files.download_from(files)
			server_processed = TRUE
		if(((id in S.id_with_download) || S.hacked))
			files.download_from(S.files)
			server_processed = TRUE
		if(server_processed)
			S.produce_heat(100)
	screen = "main"
	update_open_uis()

/obj/machinery/computer/rdconsole/proc/get_protolathe_data()
	var/list/protolathe_list = list(
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
		if(linked_lathe.materials[M].amount)
			material_list += list(list(
				"id" =             M,
				"name" =           linked_lathe.materials[M].name,
				"ammount" =        linked_lathe.materials[M].amount,
				"can_eject_one" =  linked_lathe.materials[M].amount >= linked_lathe.materials[M].sheet_size,
				"can_eject_five" = linked_lathe.materials[M].amount >= (linked_lathe.materials[M].sheet_size * 5),
			))
	protolathe_list["materials"] = material_list
	return protolathe_list

/obj/machinery/computer/rdconsole/proc/get_imprinter_data()
	var/list/imprinter_list = list(
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
		if(linked_imprinter.materials[M].amount)
			material_list += list(list(
				"id" =             M,
				"name" =           linked_imprinter.materials[M].name,
				"ammount" =        linked_imprinter.materials[M].amount,
				"can_eject_one" =  linked_imprinter.materials[M].amount >= linked_imprinter.materials[M].sheet_size,
				"can_eject_five" = linked_imprinter.materials[M].amount >= (linked_imprinter.materials[M].sheet_size * 5),
			))
	imprinter_list["materials"] = material_list
	return imprinter_list

/obj/machinery/computer/rdconsole/proc/get_possible_designs_data(build_type, category)
	var/coeff = 1
	if(build_type == PROTOLATHE)
		coeff = linked_lathe.efficiency_coeff
	if(build_type == IMPRINTER)
		coeff = linked_imprinter.efficiency_coeff

	var/list/designs_list = list()
	for(var/I in files.known_designs)
		var/datum/design/D = SSresearch.designs_by_id[I]
		if(D.build_type & build_type)
			var/cat = "Unspecified"
			if(D.category)
				cat = D.category
			if((category == cat) || (category == "Search Results" && findtext(D.name, search_text)))
				var/temp_material
				var/c = 50
				var/t
				for(var/M in D.materials)
					if(build_type == PROTOLATHE)
						t = linked_lathe.check_mat(D, M)
					if(build_type == IMPRINTER)
						t = linked_imprinter.check_mat(D, M)

					if(t < 1)
						temp_material += " <span style=\"color:red\">[D.materials[M]/coeff] [capitalize(M)]</span>"
					else
						temp_material += " [D.materials[M]/coeff] [capitalize(M)]"
					c = min(t,c)

				if(D.chemicals.len)
					for(var/R in D.chemicals)
						if(build_type == PROTOLATHE)
							t = linked_lathe.check_mat(D, R)
						if(build_type == IMPRINTER)
							t = linked_imprinter.check_mat(D, R)

						if(t < 1)
							temp_material += " <span style=\"color:red\">[D.chemicals[R]/coeff] [CallReagentName(R)]</span>"
						else
							temp_material += " [D.chemicals[R]/coeff] [CallReagentName(R)]"
						c = min(t,c)


				designs_list += list(list(
					"id" =             D.id,
					"name" =           D.name,
					"desc" =           D.desc,
					"can_create" =     c,
					"temp_material" =  temp_material,
				))
	return designs_list

/obj/machinery/computer/rdconsole/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null)
	if((screen == "protolathe" && !linked_lathe) || (screen == "circuit_imprinter" && !linked_imprinter))
		screen = "main" // Kick us from protolathe or imprinter screen if they were destroyed

	var/list/data = list()
	data["screen"] = screen
	data["sync"] = sync

	// Main screen needs info about tech levels
	if(!screen || screen == "main")
		data["show_settings"] = show_settings
		data["show_link_menu"] = show_link_menu
		data["has_dest_analyzer"] = !!linked_destroy
		data["has_protolathe"] = !!linked_lathe
		data["has_circuit_imprinter"] = !!linked_imprinter
		data["can_research"] = can_research

		var/list/tech_tree_list = list()
		for(var/tech_tree_id in files.tech_trees_shown)
			var/datum/tech/Tech_Tree = SSresearch.tech_trees[tech_tree_id]
			var/list/tech_tree_data = list(
				"id" =             Tech_Tree.id,
				"name" =           "[Tech_Tree.name]",
				"shortname" =      "[Tech_Tree.shortname]",
				"level" =          files.tech_trees_shown[tech_tree_id],
				"maxlevel" =       Tech_Tree.maxlevel,
			)
			tech_tree_list += list(tech_tree_data)
		data["tech_trees"] = tech_tree_list

		if(linked_lathe)
			data["protolathe_data"] = get_protolathe_data()

		if(linked_imprinter)
			data["imprinter_data"] = get_imprinter_data()

		if(linked_destroy)
			if(linked_destroy.loaded_item)
				var/list/tech_names = list(TECH_MATERIAL = "Materials", TECH_ENGINEERING = "Engineering", TECH_PHORON = "Phoron", TECH_POWER = "Power", TECH_BLUESPACE = "Blue-space", TECH_BIO = "Biotech", TECH_COMBAT = "Combat", TECH_MAGNET = "Electromagnetic", TECH_DATA = "Programming", TECH_ILLEGAL = "Illegal", TECH_NECRO = "Marker", TECH_ROBOT = "Roboticist")

				var/list/temp_tech = linked_destroy.loaded_item.origin_tech
				var/list/item_data = list()

				for(var/T in temp_tech)
					var/tech_name = tech_names[T]
					if(!tech_name)
						tech_name = T

					item_data += list(list(
						"id" =             T,
						"name" =           tech_name,
						"level" =          temp_tech[T],
					))

				// This calculates how much research points we missed because we already researched items with such orig_tech levels
				var/tech_points_mod = files.experiments.get_object_research_value(linked_destroy.loaded_item) / files.experiments.get_object_research_value(linked_destroy.loaded_item, ignoreRepeat = TRUE)

				var/list/destroy_list = list(
					"has_item" =              TRUE,
					"item_name" =             linked_destroy.loaded_item.name,
					"item_tech_points" =      files.experiments.get_object_research_value(linked_destroy.loaded_item),
					"item_tech_mod" =         round(tech_points_mod*100),
				)
				destroy_list["tech_data"] = item_data

				data["destroy_data"] = destroy_list
			else
				var/list/destroy_list = list(
					"has_item" =             FALSE,
				)
				data["destroy_data"] = destroy_list

	if(screen == "protolathe")
		if(linked_lathe)
			data["search_text"] = search_text
			data["protolathe_data"] = get_protolathe_data()
			data["all_categories"] = files.design_categories_protolathe
			if(search_text)
				data["all_categories"] = list("Search Results") + data["all_categories"]

			if((!selected_protolathe_category || !(selected_protolathe_category in data["all_categories"])) && files.design_categories_protolathe.len)
				selected_protolathe_category = files.design_categories_protolathe[1]

			if(selected_protolathe_category)
				data["selected_category"] = selected_protolathe_category
				data["possible_designs"] = get_possible_designs_data(PROTOLATHE, selected_protolathe_category)

			var/list/queue_list = list()
			queue_list["can_restart"] = (linked_lathe.queue.len && !linked_lathe.busy)
			queue_list["queue"] = list()
			for(var/datum/rnd_queue_design/RNDD in linked_lathe.queue)
				queue_list["queue"] += RNDD.name
			data["queue_data"] = queue_list

	if(screen == "circuit_imprinter")
		if(linked_imprinter)
			data["search_text"] = search_text
			data["imprinter_data"] = get_imprinter_data()
			data["all_categories"] = files.design_categories_imprinter
			if(search_text)
				data["all_categories"] = list("Search Results") + data["all_categories"]

			if((!selected_imprinter_category || !(selected_imprinter_category in data["all_categories"])) && files.design_categories_imprinter.len)
				selected_imprinter_category = files.design_categories_imprinter[1]

			if(selected_imprinter_category)
				data["selected_category"] = selected_imprinter_category
				data["possible_designs"] = get_possible_designs_data(IMPRINTER, selected_imprinter_category)

			var/list/queue_list = list()
			queue_list["can_restart"] = (linked_imprinter.queue.len && !linked_imprinter.busy)
			queue_list["queue"] = list()
			for(var/datum/rnd_queue_design/RNDD in linked_imprinter.queue)
				queue_list["queue"] += RNDD.name
			data["queue_data"] = queue_list

	// All the info needed for displaying tech trees
	if(screen == "tech_trees")
		var/list/line_list = list()

		var/list/tech_tree_list = list()
		for(var/tech_tree_id in files.tech_trees_shown)
			var/datum/tech/Tech_Tree = SSresearch.tech_trees[tech_tree_id]
			var/list/tech_tree_data = list(
				"id" =             Tech_Tree.id,
				"name" =           "[Tech_Tree.name]",
				"shortname" =      "[Tech_Tree.shortname]",
			)
			tech_tree_list += list(tech_tree_data)

		data["tech_trees"] = tech_tree_list

		if(!selected_tech_tree)
			selected_tech_tree = files.tech_trees_shown[1]

		var/list/tech_list = list()
		var/datum/tech/Tech_Tree = SSresearch.tech_trees[selected_tech_tree]
		data["tech_tree_name"] = Tech_Tree.name
		data["tech_tree_desc"] = Tech_Tree.desc
		data["tech_tree_level"] = Tech_Tree.level

		for(var/tech_id in files.all_technologies)
			var/datum/technology/Tech = SSresearch.all_technologies[tech_id]
			if(Tech.tech_type == selected_tech_tree)
				var/list/tech_data = list(
					"id" =             Tech.id,
					"name" =           "[Tech.name]",
					"x" =              round(Tech.x*100),
					"y" =              round(Tech.y*100),
					"icon" =           "[Tech.icon]",
					"isresearched" =   "[files.IsResearched(Tech)]",
					"canresearch" =    "[files.CanResearch(Tech)]",
				)
				tech_list += list(tech_data)

				for(var/req_tech_id in Tech.required_technologies)
					if(req_tech_id in files.all_technologies)
						var/datum/technology/OTech = SSresearch.all_technologies[req_tech_id]
						if(OTech.tech_type == Tech.tech_type && !Tech.no_lines)
							var/line_x = (min(round(OTech.x*100), round(Tech.x*100)))
							var/line_y = (min(round(OTech.y*100), round(Tech.y*100)))
							var/width = (abs(round(OTech.x*100) - round(Tech.x*100)))
							var/height = (abs(round(OTech.y*100) - round(Tech.y*100)))

							var/istop = FALSE
							if(OTech.y > Tech.y)
								istop = TRUE
							var/isright = FALSE
							if(OTech.x < Tech.x)
								isright = TRUE

							var/list/line_data = list(
								"line_x" =           line_x,
								"line_y" =           line_y,
								"width" =            width,
								"height" =           height,
								"istop" =            istop,
								"isright" =          isright,
							)
							line_list += list(line_data)

		data["techs"] = tech_list
		data["lines"] = line_list
		data["selected_tech_tree"] = selected_tech_tree
		data["research_points"] = files.research_points

		data["selected_technology_id"] = ""
		if(selected_technology)
			var/datum/technology/Tech = SSresearch.all_technologies[selected_technology]
			var/list/technology_data = list(
				"name" =           Tech.name,
				"desc" =           Tech.desc,
				"id" =             Tech.id,
				"tech_type" =      Tech.tech_type,
				"cost" =           Tech.cost,
				"isresearched" =   files.IsResearched(Tech),
			)
			data["selected_technology_id"] = Tech.id

			var/list/requirement_list = list()

			for(var/t in Tech.required_technologies)
				var/datum/technology/OTech = SSresearch.all_technologies[t]

				var/list/req_data = list(
					"text" =           "[OTech.name]",
					"isgood" =         files.IsResearched(OTech)
				)
				requirement_list += list(req_data)
			technology_data["requirements"] = requirement_list

			var/list/unlock_list = list()
			for(var/T in Tech.unlocks_designs)
				var/datum/design/D = SSresearch.designs_by_id[T]
				var/list/unlock_data = list(
					"text" =           "[D.name]",
				)
				unlock_list += list(unlock_data)
			technology_data["unlocks"] = unlock_list

			data["selected_technology"] = technology_data

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data)
	if (!ui)
		ui = new(user, src, ui_key, "rdconsole.tmpl", "R&D Console", 1000, 700)

		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/rdconsole/core
	name = "Core R&D Console"
	id = 1
	can_research = TRUE
