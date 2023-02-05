//DEFINITIONS FOR ASSET DATUMS START HERE.

/datum/asset/simple/nanoui
	keep_local_name = TRUE

	var/list/asset_dirs = list(
		"nano/css/",
		"nano/images/",
		"nano/images/modular_computers/",
		"nano/templates/",
		"nano/js/"
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

/datum/asset/simple/nanomaps
	keep_local_name = TRUE
	assets = list(
		"ishimura-2.png"		= 'nano/images/ishimura/ishimura-2.png',
		"ishimura-3.png"		= 'nano/images/ishimura/ishimura-3.png',
		"ishimura-4.png"		= 'nano/images/ishimura/ishimura-4.png',
		"ishimura-5.png"		= 'nano/images/ishimura/ishimura-5.png',
		"ishimura-6.png"		= 'nano/images/ishimura/ishimura-6.png',
		"ishimura-7.png"		= 'nano/images/ishimura/ishimura-7.png',
		"colony-2.png"			= 'nano/images/colony/colony-2.png',
		"colony-3.png"			= 'nano/images/colony/colony-3.png',
		"colony-4.png"			= 'nano/images/colony/colony-4.png',
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
	var/obj/item/storage/pill_bottle/PB = new()
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

/datum/asset/spritesheet/research_designs
	name = "rnd_designs"

/datum/asset/spritesheet/research_designs/register()
	for(var/datum/design/D as anything in SSresearch.designs_by_id)
		D = SSresearch.designs_by_id[D]
		var/icon/I = icon(getFlatTypeIcon(D.build_path))
		I.Scale(I.Width()*3, I.Height()*3)
		Insert(D.id, I)
	.=..()

/datum/asset/spritesheet/research_technologies
	name = "rdtech"

/datum/asset/spritesheet/research_technologies/register()
	for(var/datum/technology/T as anything in SSresearch.all_technologies)
		T = SSresearch.all_technologies[T]
		var/icon/icon = T.generate_icon()
		icon.Scale(icon.Width()*3, icon.Height()*3)
		Insert(T.id, icon)
	.=..()

/datum/asset/spritesheet/chat
	name = "chat"

/datum/asset/spritesheet/chat/register()
	InsertAll("tags", 'icons/chattags.dmi')
	return ..()

/datum/asset/spritesheet/simple/jobs
	name = "jobs"

/datum/asset/spritesheet/simple/jobs/register()
	var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin("#job_icon")
	mannequin.dir = SOUTH
	for(var/datum/job/job as anything in job_master.occupations_map)
		job.dress_mannequin(mannequin)
		var/icon/preview_icon = getFlatIcon(mannequin)
		preview_icon.Scale(preview_icon.Width() * 3, preview_icon.Height() * 3) // Scaling here to prevent blurring in the browser.
		assets[ckey(job.title)] = preview_icon
	return ..()

/datum/asset/spritesheet/simple/jobs/generate_css()
	.=..()
	. += "\n.job_icon{float:left;}"

