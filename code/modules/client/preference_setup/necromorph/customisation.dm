/datum/preferences
	var/list/signal_custom
	var/list/necro_custom

/datum/category_item/player_setup_item/necromorph/customisation
	name = "customisation"
	sort_order = 8
	var/selected = "Signal"

/datum/category_item/player_setup_item/necromorph/customisation/load_character(var/savefile/S)
	from_file(S["signal_custom"],           pref.signal_custom)
	from_file(S["necro_custom"],     pref.necro_custom)

/datum/category_item/player_setup_item/necromorph/customisation/save_character(var/savefile/S)
	from_file(S["signal_custom"],           pref.signal_custom)
	from_file(S["necro_custom"],     pref.necro_custom)


/datum/category_item/player_setup_item/necromorph/customisation/sanitize_character()


/datum/category_item/player_setup_item/necromorph/customisation/content(var/mob/user)
	. = list()

	. += "<table><tr><td>"
	/*
		First of all, the sidebar
	*/
	. += "<b>Signals:</b><br>"
	. += "<table>"
	. += "<tr><td>"
	if(selected == SIGNAL)
		. += "<a href='?src=\ref[src];select=[SIGNAL]'>Signal</a>"
	else
		. += "<span class='linkOn'>Signal</span>"
	. += "</td></tr> </table>"
	. += "<br>"



	//Necromorphs
	. += "<b>Necromorphs:</b><br>"
	. += "<table>"
	for(var/nname in GLOB.all_necromorph_species)
		var/datum/species/necromorph/N = GLOB.all_necromorph_species[nname]
		if (!N.has_customisation)
			continue
		. += "<tr><td>"
		if(selected == nname)
			. += "<span class='linkOn'>[nname]</span>"

		else
			. += "<a href='?src=\ref[src];select=[nname]'>[nname]</a>"
		. += "</td></tr>"
	. += "<br>"

	. += "</table>"

	//Next, the main window
	. += "</td><td>"
	if (selected == SIGNAL)
		//Initialize the list if it isnt already
		if (!pref.signal_custom)
			initialize_necrocustom_prefs()

		var/list/enabled_sprites = pref.signal_custom["signal_base"]

		for (var/iconstate in GLOB.signal_sprites)
			var/icon/I = new ('icons/mob/eye.dmi',iconstate,SOUTH)
			var/is_enabled = (iconstate in enabled_sprites)
			. += image_check_panel(text = iconstate, I = I, ticked = is_enabled, user = user, command = is_enabled ? "disable" : "enable", source = src)


	. += "</td></tr></table>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/necromorph/customisation/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["select"])
		selected = href_list["select"]
		return TOPIC_REFRESH

	if(href_list["enable"])
		//Do stuff here
	return ..()


/datum/category_item/player_setup_item/necromorph/customisation/proc/initialize_necrocustom_prefs()

	pref.signal_custom = list()
	pref.signal_custom["signal_base"] = GLOB.signal_sprites.Copy()
/*
	This returns the HTML for a UI button used in the necromorph customisation menu.
	The button is square and mostly taken up by an image, but it also contains a title along the bottom,
	and a checkbox to indicate whether the button is selected

	Vars:
		Text: The text along the bottom of the button, aligned to the left
		Image source: This can be one of two possible things:
			1. A list, containing icon and iconstate
			2. An atom, from which a flat icon will be generated

		Ticked:	Boolean, should the checkbox be ticked or not?
		User: Who is viewing this button? Used to preload the image for them
*/
/proc/image_check_panel(var/text, var/icon/I, var/ticked, var/mob/user, var/command, var/source, var/category, var/subcategory)

	var/filename = sanitizeFileName(text)

	if (user)
		user << browse_rsc(I, "[filename].png")

	var/subcategory_text = ""
	if (subcategory)
		subcategory_text = "subcategory=[subcategory]"
	var/html = {"<a class='linkActive noIcon' unselectable='on' style='display:inline-block;' onclick='document.location="?src=\ref[source];[command]=[text];category=[category];[subcategory_text]"' ></a><br>"}

	html += "<div><img src=[filename].png width=[I.Width()] height=[I.Height()]></center>"
	html += text
	html += "<div class='checkbox'><form><input type='checkbox' [ticked ? "checked" : ""]></form></div>"
	html += "</div>"
	return html

/datum/preferences/proc/can_customise()
	if (is_patron())
		return TRUE
	return FALSE

/mob/proc/apply_customisation(var/datum/preferences/prefs)