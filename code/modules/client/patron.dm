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

/*
	Writes to the patrons.txt file

*/
/proc/save_patrons()
	update_patrons()

	var/list/Lines = file2list("config/patrons.txt")

	//We will preserve the block of commented text at the top of the file
	var/list/text = list()

	for(var/line in Lines)
		if(!length(line))
			text += line
			continue
		if(copytext(line,1,2) == "#")
			text += line
			continue

		//Header is over, everything below this point is overwritten
		break

	//Delete the file, we will remake it
	fdel("config/patrons.txt")

	for (var/ckey in GLOB.patron_keys)
		text += "[ckey]	[GLOB.patron_keys[ckey]]"

	list2file(text, "config/patrons.txt")

/proc/update_patrons()
	for (var/key in GLOB.players)
		var/datum/player/P = GLOB.players[key]
		P.update_patron()
/*
	Patron UI
*/

/*
	Necrohelp just opens a window containing text extracted from the necromorph species the player is playing
*/
/datum/extension/interactive/patrons
	name = "Patron Management"
	title = "Patron Management"
	base_type = /datum/extension/interactive/patrons
	expected_type = /mob
	flags = EXTENSION_FLAG_IMMEDIATE
	template = "patron.tmpl"
	dimensions = new /vector2(800, 500)

/datum/extension/interactive/patrons/generate_content_data()
	content_data = list()

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
		world << dump_list(patron)
		patrons += list(patron)


	content_data["patrons"] = patrons

/datum/extension/interactive/patrons/Topic(href, href_list)
	world << "Patron menu topic [href]"
	if(..())
		world << "Parent returned true, cancelling"
		return
	if (href_list["extend"])
		world << "Got extend"
		var/ckey = href_list["extend"]
		var/extradays = input(usr, "How many extra days would you like to add to [ckey]'s Patron status?", "A Promise of Days", 0) as num | null
		if (extradays && (ckey in GLOB.patron_keys))
			GLOB.patron_keys[ckey] = add_time_to_date(GLOB.patron_keys[ckey], extradays DAYS)
			to_chat(usr, "Success, [ckey] expiry date is now [GLOB.patron_keys[ckey]]")
			save_patrons()
			generate_content_data()


	if (href_list["date"])
		var/ckey = href_list["date"]
		var/newdate = input(usr, "Input a new expiry date in the format YYYY-MM-DD", "A Gift of Years", 0) as text
		newdate = sanitize_date(newdate)
		if (newdate)
			GLOB.patron_keys[ckey] = newdate
			to_chat(usr, "Success, [ckey] expiry date is now [GLOB.patron_keys[ckey]]")
			save_patrons()
			generate_content_data()

	if (href_list["revoke"])
		var/ckey = href_list["revoke"]
		var/confirm = alert(usr,"Are you sure you wish to revoke patron status for [ckey]? They will immediately lose access to patronage privilages" , "Cast into the abyss","Revoke","Cancel")
		if (confirm == "Revoke")
			GLOB.patron_keys -= ckey
			to_chat(usr, "Success, [ckey] expiry date is no longer a patron.")
			save_patrons()
			generate_content_data()

	if (href_list["register"])
		var/newkey = input(usr, "Please enter the ckey of the player you wish to register as a patron. This is not case sensitive, but please make sure the spelling is accurate.", "A New Patron", 0) as text
		if (newkey)
			GLOB.patron_keys[newkey] = add_time_to_date(current_date(), 30 DAYS)
			to_chat(usr, "Success, [newkey] Added as patron, an initial 30 day duration has been set, it can be farther edited")
			save_patrons()
			generate_content_data()
	SSnano.update_uis(src)



/client/proc/patrons()
	set name = "Patron Management"
	set category = "Admin"
	set desc = "Allows managing patron status of users"

	if (!check_rights(R_HOST, 0, src))
		to_chat(src, "Only Hosts can use this verb.")
		return

	if (istype(mob, /mob/new_player))
		to_chat(src, "This cannot be used from the lobby, please observe first.")
		return

	var/datum/extension/interactive/patrons/NH = get_or_create_extension(mob, /datum/extension/interactive/patrons)
	NH.ui_interact(mob)