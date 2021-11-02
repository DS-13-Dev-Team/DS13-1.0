//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/nanoui
	keep_local_name = TRUE

	var/list/asset_dirs = list(
		"nano/images/",
		"nano/images/modular_computers/",
		"nano/templates/"
	)

/datum/asset/simple/nanoui/register()
	var/list/filenames = null
	for (var/path in asset_dirs)
		filenames = flist(path)
		for(var/filename in filenames)
			if(copytext(filename, length(filename)) == "/") // filenames which end in "/" are actually directories, which we want to ignore
				continue
			if(fexists(path + filename))
				assets[filename] = file(path + filename)
	. = ..()

/datum/asset/simple/tgui
	keep_local_name = TRUE
	assets = list(
		"tgui.bundle.js" = file("tgui/public/tgui.bundle.js"),
		"tgui.bundle.css" = file("tgui/public/tgui.bundle.css"),
	)

/datum/asset/simple/tgui_panel
	keep_local_name = TRUE
	assets = list(
		"tgui-panel.bundle.js" = file("tgui/public/tgui-panel.bundle.js"),
		"tgui-panel.bundle.css" = file("tgui/public/tgui-panel.bundle.css"),
	)


/datum/asset/spritesheet/craft
	name = "craft"

/datum/asset/spritesheet/craft/register()
	for(var/i in GLOB.craftitems)
		var/list/craftitem = GLOB.craftitems[i]

		if (!sprites[sanitizeFileName(craftitem["name"])])
			var/icon_file = craftitem["icon"]
			var/icon_state = craftitem["icon_state"]
			var/icon/I = icon(icon_file, icon_state, SOUTH)
			Insert(sanitizeFileName(craftitem["name"]), I, icon_state)
		craftitem = list("name" = craftitem["name"])
	return ..()

proc/get_craft_item(path)
	if(GLOB.craftitems[path])
		return GLOB.craftitems[path]
	else
		var/obj/A = new path()
		GLOB.craftitems[path] = list("icon" = A.icon, "icon_state" = A.icon_state, "name" = A.name)
		qdel(A)
		return GLOB.craftitems[path]

/datum/asset/simple/research_designs
	keep_local_name = TRUE

/datum/asset/simple/research_designs/register()
	for(var/R in subtypesof(/datum/design))
		var/datum/design/design = new R

		register_design(design)

	SSresearch.generate_integrated_circuit_designs()

	for(var/D in SSresearch.design_ids)
		var/datum/design/design = SSresearch.design_ids[D]
		var/datum/computer_file/binary/design/design_file = new
		design_file.design = design
		design_file.on_design_set()
		design.file = design_file

	SSresearch.designs_initialized = TRUE

	// Initialize design files that were created before
	for(var/file in SSresearch.design_files_to_init)
		SSresearch.initialize_design_file(file)
	SSresearch.design_files_to_init = list()


	SSdatabase.update_store_designs()

	. = ..()

/proc/register_research_design(var/datum/design/design)
	var/datum/asset/simple/research_designs/RD = GLOB.asset_datums[/datum/asset/simple/research_designs]
	RD.register_design(design)

/datum/asset/simple/research_designs/proc/register_design(var/datum/design/design)
	design.AssembleDesignInfo()

	if(!design.build_path)
		return

	//Cache the icons
	var/filename = sanitizeFileName("[design.build_path].png")
	var/icon/I = getFlatTypeIcon(design.build_path)
	assets[filename] = I

	design.ui_data["icon"] = filename
	design.ui_data["icon_width"] = I.Width()
	design.ui_data["icon_height"] = I.Height()

	SSresearch.all_designs += design

	// Design ID is string
	SSresearch.design_ids["[design.id]"] = design


/datum/asset/simple/jquery
	legacy = TRUE
	assets = list(
		"jquery.min.js" = 'html/jquery.min.js',
	)

/datum/asset/simple/namespaced/fontawesome
	assets = list(
		"fa-regular-400.eot"  = 'html/font-awesome/webfonts/fa-regular-400.eot',
		"fa-regular-400.woff" = 'html/font-awesome/webfonts/fa-regular-400.woff',
		"fa-solid-900.eot"    = 'html/font-awesome/webfonts/fa-solid-900.eot',
		"fa-solid-900.woff"   = 'html/font-awesome/webfonts/fa-solid-900.woff',
		"v4shim.css"          = 'html/font-awesome/css/v4-shims.min.css',
	)
	parents = list(
		"font-awesome.css" = 'html/font-awesome/css/all.min.css',
	)

/datum/asset/simple/namespaced/tgfont
	assets = list(
		"tgfont.eot" = file("tgui/packages/tgfont/dist/tgfont.eot"),
		"tgfont.woff2" = file("tgui/packages/tgfont/dist/tgfont.woff2"),
	)
	parents = list(
		"tgfont.css" = file("tgui/packages/tgfont/dist/tgfont.css"),
	)

/datum/asset/spritesheet/simple/paper
	name = "paper"
	assets = list(
		"stamp-clown" = 'icons/stamp_icons/large_stamp-clown.png',
		"stamp-deny" = 'icons/stamp_icons/large_stamp-deny.png',
		"stamp-ok" = 'icons/stamp_icons/large_stamp-ok.png',
		"stamp-hop" = 'icons/stamp_icons/large_stamp-hop.png',
		"stamp-smo" = 'icons/stamp_icons/large_stamp-cmo.png',
		"stamp-ce" = 'icons/stamp_icons/large_stamp-ce.png',
		"stamp-cseco" = 'icons/stamp_icons/large_stamp-hos.png',
		"stamp-sci" = 'icons/stamp_icons/large_stamp-rd.png',
		"stamp-cap" = 'icons/stamp_icons/large_stamp-cap.png',
		"stamp-cargo" = 'icons/stamp_icons/large_stamp-qm.png',
		"stamp-law" = 'icons/stamp_icons/large_stamp-law.png',
		"stamp-chap" = 'icons/stamp_icons/large_stamp-chap.png',
		"stamp-mime" = 'icons/stamp_icons/large_stamp-mime.png',
		"stamp-cent" = 'icons/stamp_icons/large_stamp-centcom.png',
		"stamp-syndicate" = 'icons/stamp_icons/large_stamp-syndicate.png'
	)




/datum/asset/simple/patron_content/register()
	log_debug("Registering patron content")
	var/total = 0
	for (var/typepath in subtypesof(/datum/patron_item))
		log_debug("Registering [typepath]")
		total++
		var/datum/patron_item/PI = new typepath()

		GLOB.patron_items += PI

	log_debug("Done Registering patron content. Total: [total]")
	log_debug("---------------------------------")

	//Now we load and assign the whitelists
	load_patron_item_whitelists()

	//These procs update and sort various other things after the patron items have added themselves to them
	sort_loadout_categories()
	SSdatabase.update_store_designs()

	GLOB.custom_items_loaded = TRUE
	if (LOADOUT_LOADED)
		handle_pending_loadouts()

	.=..()

/datum/asset/simple/chem_master
	keep_local_name = TRUE
	assets = list("pillA.png" = icon('icons/obj/chemical.dmi', "pillA"))

/datum/asset/simple/chem_master/register()
	for(var/i = 1 to 25)
		assets["pill[i].png"] = icon('icons/obj/chemical.dmi', "pill[i]")
	for(var/i = 1 to 4)
		assets["bottle-[i].png"] = icon('icons/obj/chemical.dmi', "bottle-[i]")
	.=..()

/datum/asset/spritesheet/simple/pill_bottles
	name = "pill_bottles"

/datum/asset/spritesheet/simple/pill_bottles/register()
	var/list/pill_bottle_wrappers = list(
		COLOR_RED = "Red",
		COLOR_GREEN = "Green",
		COLOR_PALE_BTL_GREEN = "Pale_Green",
		COLOR_BLUE = "Blue",
		COLOR_CYAN_BLUE = "Light_Blue",
		COLOR_TEAL = "Teal",
		COLOR_YELLOW = "Yellow",
		COLOR_ORANGE = "Orange",
		COLOR_PINK = "Pink",
		COLOR_MAROON = "Brown"
	)
	var/obj/item/weapon/storage/pill_bottle/PB = new()
	var/icon/I = getFlatIcon(PB)
	I.Scale(96, 96)
	assets = list("Default_pill_bottle" = I)
	for(var/A in pill_bottle_wrappers)
		PB.wrapper_color = A
		PB.update_icon()
		I = getFlatIcon(PB)
		I.Scale(96, 96)
		assets["[pill_bottle_wrappers[A]]_pill_bottle"] = I
	qdel(PB)
	.=..()
