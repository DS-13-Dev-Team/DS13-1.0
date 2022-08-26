/*
	This file contains preferences and UI handling for the loadout menu
*/
/hook/startup/proc/populate_gear_list()

	//create a list of gear datums to sort
	for(var/geartype in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = geartype
		if(initial(G.base_type) == geartype)
			continue
		G = new geartype()
		register_gear(G)

	sort_loadout_categories()

	GLOB.loadout_datums_loaded = TRUE
	if (LOADOUT_LOADED)
		handle_pending_loadouts()

	return TRUE


/proc/register_gear(var/datum/gear/G)

	var/use_name = G.display_name
	var/use_category = G.sort_category

	if(!GLOB.loadout_categories[use_category])
		GLOB.loadout_categories[use_category] = new /datum/loadout_category(use_category)
	var/datum/loadout_category/LC = GLOB.loadout_categories[use_category]
	GLOB.gear_datums[use_name] = G
	LC.gear[use_name] = GLOB.gear_datums[use_name]

/proc/sort_loadout_categories()
	GLOB.loadout_categories = sortAssoc(GLOB.loadout_categories)
	for(var/loadout_category in GLOB.loadout_categories)
		var/datum/loadout_category/LC = GLOB.loadout_categories[loadout_category]
		sortTim(LC.gear, /proc/cmp_gear_subcategory, TRUE)	//Sort the loadout menu by subcategory






/datum/category_item/player_setup_item/loadout
	name = "Loadout"
	sort_order = 1
	var/current_tab = "General"
	var/hide_unavailable_gear = 0

/datum/category_item/player_setup_item/loadout/load_character(var/savefile/S)
	READ_FILE(S["gear_list"], pref.gear_list)
	READ_FILE(S["gear_slot"], pref.gear_slot)
	if (!pref.gear_slot)
		pref.gear_slot = 1
	//Rebuild the loadout
	if (pref.loadout)
		pref.loadout.set_prefs(pref)

/datum/category_item/player_setup_item/loadout/save_character(var/savefile/S)
	WRITE_FILE(S["gear_list"], pref.gear_list)
	WRITE_FILE(S["gear_slot"], pref.gear_slot)

/datum/category_item/player_setup_item/loadout/proc/valid_gear_choices(var/max_cost)
	. = list()
	var/mob/preference_mob = preference_mob()
	for(var/gear_name in GLOB.gear_datums)
		var/datum/gear/G = GLOB.gear_datums[gear_name]
		var/okay = TRUE
		if(G.species_whitelist && preference_mob)
			for(var/species in G.species_whitelist)
				if(!is_species_whitelist(preference_mob, species))
					okay = FALSE
					break

		if (G.key_whitelist)
			if (!(preference_mob.ckey in G.key_whitelist))
				okay = FALSE

		if(!okay)
			continue
		if(max_cost && G.cost > max_cost)
			continue
		. += gear_name

/datum/category_item/player_setup_item/loadout/sanitize_character()


	pref.gear_slot = sanitize_integer(pref.gear_slot, 1, LOADOUT_SLOTS, initial(pref.gear_slot))
	if(!islist(pref.gear_list))
		pref.reset_gear_list()

	if(pref.gear_list.len < LOADOUT_SLOTS)
		pref.gear_list.len = LOADOUT_SLOTS

	//Loadout only sanitizes the current slot
	LOADOUT_CHECK
	pref.loadout.sanitize()


/datum/category_item/player_setup_item/loadout/content()
	. = list()
	LOADOUT_CHECK

	var/fcolor =  "#3366cc"
	if(pref.loadout.points > 0)
		fcolor = "#e67300"
	. += "<table align = 'center' width = 100% style = 'border-collapse: collapse;'>"
	. += "<tr><td colspan=3><center>"
	. += "<a href='?src=\ref[src];prev_slot=1'>\<\<</a><b><font color = '[fcolor]'>\[[pref.gear_slot]\]</font> </b><a href='?src=\ref[src];next_slot=1'>\>\></a>"

	if(CONFIG_GET(number/max_gear_cost) < INFINITY)
		. += "<b><font color = '[fcolor]'>[pref.loadout.max_points - pref.loadout.points]/[pref.loadout.max_points]</font> loadout points spent.</b>"

	. += "<a href='?src=\ref[src];clear_loadout=1'>Clear Loadout</a>"
	. += "<a href='?src=\ref[src];toggle_hiding=1'>[hide_unavailable_gear ? "Show all" : "Hide unavailable"]</a></center></td></tr>"

	. += "<tr><td colspan=3><center><b>"
	var/firstcat = 1

	//Maybe this should be cached earlier than this proc
	var/list/valid_gear = valid_gear_choices()

	for(var/category in GLOB.loadout_categories)

		if(firstcat)
			firstcat = 0
		else
			. += " |"

		var/datum/loadout_category/LC = GLOB.loadout_categories[category]
		var/category_cost = 0
		for(var/gear in LC.gear)
			if(gear in pref.gear_list[pref.gear_slot])
				var/datum/gear/G = LC.gear[gear]
				category_cost += G.cost

		if(category == current_tab)
			. += " <span class='linkOn'>[category] - [category_cost]</span> "
		else
			if(category_cost)
				. += " <a href='?src=\ref[src];select_category=[category]'><font color = '#e67300'>[category] - [category_cost]</font></a> "
			else
				. += " <a href='?src=\ref[src];select_category=[category]'>[category] - 0</a> "

	. += "</b></center></td></tr>"

	var/datum/loadout_category/LC = GLOB.loadout_categories[current_tab]
	. += "<tr><td colspan=3><hr></td></tr>"
	. += "<tr><td colspan=3><b><center>[LC.category]</center></b></td></tr>"
	. += "<tr><td colspan=3><hr></td></tr>"
	var/jobs = list()
	if(job_master)
		for(var/job_title in (pref.job_medium|pref.job_low|pref.job_high))
			var/datum/job/J = job_master.GetJob(job_title)
			if(J)
				dd_insertObjectList(jobs, J)

	//TODO: Fetch this from player datum
	var/datum/player/P = get_player_from_key(pref.client_ckey)
	var/is_patron = (P ? P.patron	: FALSE)
	var/current_subcategory


	for(var/gear_name in LC.gear)

		if(!(gear_name in valid_gear))
			continue
		var/list/entry = list()
		var/datum/gear/G = LC.gear[gear_name]
		var/ticked = (G.display_name in pref.gear_list[pref.gear_slot])
		if (G.subcategory && (G.subcategory != current_subcategory))
			current_subcategory = G.subcategory

			entry += "</table>"
			entry += "<h1>[current_subcategory]</h1>"
			entry += "<table align = 'center' width = 100% style = 'border-collapse: collapse;'>"
		entry += "<tr style='[G.patron_only ? " border-style: outset; border-color: [COLOR_GOLD];":"border-top:1pt solid black;"]'>"
		var/button_info = "<td width=25%>"

		//If this is a patron item and the player isn't a patron, then the button goes to a codex page
		if (G.patron_only && !is_patron)
			button_info += "<a style='white-space:normal;' href='?src=\ref[SScodex];show_examined_info=\ref[SScodex.get_entry_by_string("patron")];show_to=\ref[pref.client]'>[G.display_name]</a></td>"
		else
			button_info += "<a style='white-space:normal;' [ticked ? "class='linkOn' " : ""]href='?src=\ref[src];toggle_gear=[html_encode(G.display_name)]'>[G.display_name]</a></td>"
		entry += button_info

		entry += "<td width = 10% style='vertical-align:top'>[G.cost]</td>"
		entry += "<td><font size=2>[G.get_description(get_gear_metadata(G,1))]</font>"
		var/allowed = 1
		if(allowed && G.allowed_roles)
			var/good_job = 0
			var/bad_job = 0
			entry += "<br><i>"
			var/ind = 0
			for(var/datum/job/J in jobs)
				++ind
				if(ind > 1)
					entry += ", "
				if(J.type in G.allowed_roles)
					entry += "<font color=55cc55>[J.title]</font>"
					good_job = 1
				else
					entry += "<font color=cc5555>[J.title]</font>"
					bad_job = 1
			allowed = good_job || !bad_job
			entry += "</i>"
		entry += "</td></tr>"
		if(ticked)
			entry += "<tr><td colspan=3>"
			for(var/datum/gear_tweak/tweak in G.gear_tweaks)
				if(!tweak.show_in_ui)
					continue
				entry += " <a href='?src=\ref[src];gear=[G.display_name];tweak=\ref[tweak]'>[tweak.get_contents(get_tweak_metadata(G, tweak))]</a>"
			entry += "</td></tr>"
		if(!hide_unavailable_gear || allowed || ticked)
			. += entry
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/loadout/proc/get_gear_metadata(var/datum/gear/G, var/readonly)
	var/list/gear = pref.gear_list[pref.gear_slot]
	if(gear)
		. = gear[G.display_name]
	if(!.)
		. = list()
		if(!readonly)
			gear[G.display_name] = .

/datum/category_item/player_setup_item/loadout/proc/get_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak)
	var/list/metadata = get_gear_metadata(G)
	. = metadata["[tweak]"]
	if(!.)
		. = tweak.get_default()
		metadata["[tweak]"] = .

/datum/category_item/player_setup_item/loadout/proc/set_tweak_metadata(var/datum/gear/G, var/datum/gear_tweak/tweak, var/new_metadata)
	var/list/metadata = get_gear_metadata(G)
	metadata["[tweak]"] = new_metadata

/datum/category_item/player_setup_item/loadout/OnTopic(href, href_list, user)
	if(href_list["toggle_gear"])
		toggle_gear(href_list["toggle_gear"], user)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["gear"] && href_list["tweak"])
		var/datum/gear/gear = GLOB.gear_datums[href_list["gear"]]
		var/datum/gear_tweak/tweak = locate(href_list["tweak"])
		if(!tweak || !istype(gear) || !(tweak in gear.gear_tweaks))
			return TOPIC_NOACTION
		var/metadata = tweak.get_metadata(user, get_tweak_metadata(gear, tweak))
		if(!metadata || !CanUseTopic(user))
			return TOPIC_NOACTION
		set_tweak_metadata(gear, tweak, metadata)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["next_slot"])
		change_slot(pref.gear_slot+1)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["prev_slot"])
		change_slot(pref.gear_slot-1)
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["select_category"])
		current_tab = href_list["select_category"]
		return TOPIC_REFRESH
	if(href_list["clear_loadout"])
		var/list/gear = pref.gear_list[pref.gear_slot]
		gear.Cut()
		pref.loadout.clear_data()
		return TOPIC_REFRESH_UPDATE_PREVIEW
	if(href_list["toggle_hiding"])
		hide_unavailable_gear = !hide_unavailable_gear
		return TOPIC_REFRESH
	return ..()












/*
	Loadout Interface Procs
*/

//Adds or removes a specified gear item from the user
/datum/category_item/player_setup_item/loadout/proc/toggle_gear(var/gearname, var/mob/user)
	var/datum/gear/TG = GLOB.gear_datums[gearname]

	LOADOUT_CHECK

	//Quick safety check
	if (!islist(pref.gear_list[pref.gear_slot]))
		pref.gear_list[pref.gear_slot] = list()


	//If the gear is enabled, disable it
	if((TG.display_name in pref.gear_list[pref.gear_slot]) && pref.loadout.remove_gear(TG))
		pref.gear_list[pref.gear_slot] -= TG.display_name
	else if (pref.loadout.add_gear(TG))
		pref.gear_list[pref.gear_slot] += list(TG.display_name)



/datum/category_item/player_setup_item/loadout/proc/change_slot(var/newslot)
	newslot = clamp(newslot, 1, LOADOUT_SLOTS)
	if(pref.gear_slot != newslot)
		pref.gear_slot = newslot
		pref.loadout.set_prefs(pref)	//Remake the loadout datum



/datum/category_item/player_setup_item/loadout/update_setup(var/savefile/preferences, var/savefile/character)
	if(preferences["version"] < 14)
		var/list/old_gear = character["gear"]
		if(istype(old_gear)) // During updates data isn't sanitized yet, we have to do manual checks
			if(!istype(pref.gear_list))
				pref.reset_gear_list()
			pref.gear_list[1] = old_gear
		return TRUE

	if(preferences["version"] < 15)
		if(istype(pref.gear_list))
			// Checks if the key of the pref.gear_list is a list.
			// If not the key is replaced with the corresponding value.
			// This will convert the loadout slot data to a reasonable and (more importantly) compatible format.
			// I.e. list("1" = loadout_data1, "2" = loadout_data2, "3" = loadout_data3) becomes list(loadout_data1, loadout_data2, loadaout_data3)
			for(var/index = 1 to pref.gear_list.len)
				var/key = pref.gear_list[index]
				if(islist(key))
					continue
				var/value = pref.gear_list[key]
				pref.gear_list[index] = value
		return TRUE