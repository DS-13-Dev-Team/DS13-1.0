/*
	This file handles meta-things related to patron status and patron perks
*/



/hook/startup/proc/loadpatrons()
	load_patrons()
	return 1

//load text from file
/proc/load_patrons()
	var/list/Lines = file2list("config/patrons.txt")

	for(var/line in Lines)
		if(!length(line))
			continue
		if(copytext(line,1,2) == "#")
			continue

		var/list/line_list = splittext(line, "	")
		if(!line_list.len)
			continue

		log_world("Line list is [english_list(line_list)]")

		//We now have a list containing two things:
			//1. Ckey of a patron player
			//2. The date up to which their patron status lasts

		if (is_past_date(line_list[2]))
			//Their patron status has expired!
			continue

		//patron status is still valid!
		GLOB.patron_keys[lowertext(line_list[1])] = line_list[2]


/proc/update_patrons()
	for (var/datum/player/P as anything in GLOB.player_list)
		P.update_patron()
/*
	Patron UI
*/

/*
	Necrohelp just opens a window containing text extracted from the necromorph species the player is playing
*/
/datum/extension/interactive/patrons
	name = "Help"
	base_type = /datum/extension/interactive/necrohelp
	expected_type = /mob
	flags = EXTENSION_FLAG_IMMEDIATE
	template = "necrohelp.tmpl"
	dimensions = new /vector2(800, 500)

/datum/extension/interactive/patrons/generate_content_data()
	content_data = list()
	if (ishuman(holder))
		var/mob/living/carbon/human/H = holder
		var/datum/species/necromorph/N = H.get_species_datum()
		content_data["name"] = N.name
		content_data["desc"] = N.get_long_description()
		title = N.name

	var/list/patrons = list()
	for (var/ckey in GLOB.patron_keys)
		var/list/patron = list()
		patron["key"] = ckey
		patron["date"] = GLOB.patron_keys[ckey]
		if (GLOB.patron_keys[ckey] == FOREVER)
			patron["delta"] = "Never"
		else
			var/days = days_between_dates(current_date(), GLOB.patron_keys[ckey])

			patron["delta"] = "In [days] days."

		patrons += list(patron)


	content_data["patrons"] = patrons


/client/proc/patrons()
	set name = "Patron Management"
	set category = "Admin"
	set desc = "Allows managing patron status of users"

	if (!check_rights(R_HOST, 0, src))
		to_chat(src, "Only Hosts can use this verb.")
		return

	var/datum/extension/interactive/patrons/NH = get_or_create_extension(src, /datum/extension/interactive/patrons)
	NH.ui_interact(src)