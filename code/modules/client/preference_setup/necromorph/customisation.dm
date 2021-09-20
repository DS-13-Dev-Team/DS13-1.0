#define NECROCUSTOM_UI_SCALE	2.5

GLOBAL_LIST_EMPTY(default_necro_custom)

/datum/preferences
	var/list/necro_custom

/datum/category_item/player_setup_item/necromorph/customisation
	name = "customisation"
	sort_order = 8
	var/selected = SIGNAL

/datum/category_item/player_setup_item/necromorph/customisation/load_character(var/savefile/S)
	READ_FILE(S["necro_custom"],     pref.necro_custom)

/datum/category_item/player_setup_item/necromorph/customisation/save_character(var/savefile/S)
	WRITE_FILE(S["necro_custom"],     pref.necro_custom)


/datum/category_item/player_setup_item/necromorph/customisation/sanitize_character()


/datum/category_item/player_setup_item/necromorph/customisation/content(var/mob/user)
	. = list()

	//This is a patron only feature!
	if (!pref.is_patron())
		var/datum/codex_entry/entry = SScodex.get_entry_by_string("patron")
		. += entry.get_text(user)

	else
		if (!pref.necro_custom)
			pref.initialize_necrocustom_prefs()

		. += "<table><tr><td style='vertical-align:top;'>"
		/*
			First of all, the sidebar
		*/
		. += "<b>Signals:</b><br>"
		. += "<table style='width:100%'>"
		. += "<tr><td>"
		if(selected == SIGNAL)
			. += "<span class='linkOn'>Signal</span>"
		else

			. += "<a href='?src=\ref[src];select=[SIGNAL]'>Signal</a>"
		. += "</td></tr> </table>"
		. += "<br>"



		//Necromorphs
		. += "<b>Necromorphs:</b><br>"
		. += "<table>"
		for(var/nname in GLOB.all_necromorph_species)
			var/datum/species/necromorph/N = GLOB.all_necromorph_species[nname]
			if (!N.has_customisation())
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


			var/list/enabled_sprites = pref.necro_custom[SIGNAL][SIGNAL_DEFAULT]

			for (var/iconstate in GLOB.signal_sprites)
				var/icon/I = new ('icons/mob/eye.dmi',iconstate,SOUTH)
				var/is_enabled = (iconstate in enabled_sprites)
				. += image_check_panel(text = iconstate, I = I, ticked = is_enabled, user = user, command = is_enabled ? "disable" : "enable", source = src, category = SIGNAL, subcategory = SIGNAL_DEFAULT)


		else
			//What we have selected is a necromorph
			var/datum/species/necromorph/N = GLOB.all_necromorph_species[selected]
			.+= N.get_customisation_content(pref, user, src)	//This is in necromorph_species.dm
		. += "</td></tr></table>"

	. = jointext(.,null)



/datum/category_item/player_setup_item/necromorph/customisation/OnTopic(var/href,var/list/href_list, var/mob/user)
	.= TOPIC_REFRESH
	if(href_list["select"])
		selected = href_list["select"]
		return TOPIC_REFRESH

	if(href_list["enable"] || href_list["disable"])
		//These are necessary
		if (!href_list["category"] || !href_list["subcategory"])
			return

		//Lets make sure the necessary lists are in place to recieve the data

		//First up the main category. This will be signal, slasher, brute, etc. What thing is being customised
		if (!islist(pref.necro_custom[href_list["category"]]))
			pref.necro_custom[href_list["category"]] = list()

		//Second the subcategory. Species variant, outfit, or bodypart. In the case of signals, what type they might be
		if (!islist(pref.necro_custom[href_list["category"]][href_list["subcategory"]]))
			pref.necro_custom[href_list["category"]][href_list["subcategory"]] = list()

		//Alright we are ready to work with the data. Now...

		//If we are enabling, insert it into the list exclusively
		if(href_list["enable"])
			pref.necro_custom[href_list["category"]][href_list["subcategory"]] |= href_list["enable"]
		//If disabling, remove
		else if (href_list["disable"])
			//However, we only allow removing if there are two or more items remaining. Dont allow removing the last thing or we'd be left with no fallbacks
			var/numentries = length(pref.necro_custom[href_list["category"]][href_list["subcategory"]])
			if (numentries <= 1)
				to_chat(user, SPAN_DANGER("You can't remove the last item in a category!"))
				return

			pref.necro_custom[href_list["category"]][href_list["subcategory"]] -= href_list["disable"]

		return
		//Do stuff here
	return ..()

/*
	If patron, fetch necrocustom data from prefs

	If not, fetch the global default
*/
/datum/preferences/proc/get_necro_custom_list()
	if (is_patron())
		if (!necro_custom)
			initialize_necrocustom_prefs()
		return necro_custom

	else
		if (!LAZYLEN(GLOB.default_necro_custom))
			GLOB.default_necro_custom = initialize_necrocustom_list(GLOB.default_necro_custom)
		return GLOB.default_necro_custom

/proc/get_default_necro_custom()
	if (!LAZYLEN(GLOB.default_necro_custom))
		GLOB.default_necro_custom = initialize_necrocustom_list(GLOB.default_necro_custom)
	return GLOB.default_necro_custom

/datum/preferences/proc/initialize_necrocustom_prefs()
	if (!necro_custom)
		necro_custom = list()
	necro_custom = initialize_necrocustom_list(necro_custom)

/proc/initialize_necrocustom_list(var/list/necro_custom)
	necro_custom = list()
	necro_custom[SIGNAL] = list()
	necro_custom[SIGNAL][SIGNAL_DEFAULT] = GLOB.signal_sprites.Copy()
	for(var/nname in GLOB.all_necromorph_species)
		var/datum/species/necromorph/N = GLOB.all_necromorph_species[nname]
		if (!N.has_customisation())
			continue

		//necro_custom =
		N.prefill_customisation_prefs(necro_custom)

	return necro_custom


/*
	This returns the HTML for a UI button used in the necromorph customisation menu.
	The button is square and mostly taken up by an image, but it also contains a title along the bottom,
	and a checkbox to indicate whether the button is selected

	Vars:
		Text: The text along the bottom of the button, aligned to the left. this is also used as the data passed to the command, unless otherwise specified
		Icon: An icon file to show on the button
		Ticked:	Boolean, should the checkbox be ticked or not?
		User: Who is viewing this button? Used to preload the image for them
		Command: What is this button for, generally enable or disable
		Source: The thing which recieves the topic calls, a preference setup
		Category: Signal or a necromorph
		Subcategory: Default, variant, outfits.
		command_data: If supplied, used instead of text as the content of the command returned in topic
*/

#define IMAGE_CHECK_PANEL_FOOTER_HEIGHT	10
#define IMAGE_CHECK_PANEL_PADDING	2
#define IMAGE_CHECK_PANEL_CHECKBOX_SIZE	10
/proc/image_check_panel(var/text, var/icon/I, var/ticked, var/mob/user, var/command, var/source, var/category, var/subcategory = "Default", var/command_data)

	var/filename = sanitizeFileName(text)

	if (user)
		user << browse_rsc(I, "[filename].png")

	var/subcategory_text = ""
	if (subcategory)
		subcategory_text = "subcategory=[subcategory]"
	var/html

	//Size of the icon in pixels
	var/iwidth = I.Width()*NECROCUSTOM_UI_SCALE
	var/total_width = iwidth + (2 * IMAGE_CHECK_PANEL_PADDING)
	var/iheight = I.Width()*NECROCUSTOM_UI_SCALE
	//We wrap everything in a link so the whole box is clickable
	html += {"<a class='linkActive noIcon' unselectable='on' style='display:inline-block; [!ticked ? "background-color: transparent;": ""]' onclick='document.location="?src=\ref[source];[command]=[command_data ? command_data : text];category=[category];[subcategory_text]"' >"}

	//A div inside represents the box, with width and height based on the image size
	html += "<div style='position:relative; width:[total_width]px; height:[iwidth + IMAGE_CHECK_PANEL_FOOTER_HEIGHT + (2 * IMAGE_CHECK_PANEL_PADDING)]px;'>"

	//The image of the thing
	html += "<img src=[filename].png width=[iwidth] height=[iheight] [!ticked ? "style='filter: grayscale(100%);'": ""]>"

	//This text appears in the lower right corner of the panel
	html += "<div style='font-size: 8px; position:absolute; bottom: 4px; right: 0; width: [total_width - (IMAGE_CHECK_PANEL_CHECKBOX_SIZE)]px; padding: [IMAGE_CHECK_PANEL_PADDING]px; text-align:right;line-height: 100%;'>[text]</div>"

	//Checkbox appears in the lower left corner of the panel
	html += "<div style='position:absolute; bottom: 0; left: 0;'><form><input type='checkbox' [ticked ? "checked" : ""]></form></div>"

	//Finally close everything and return it
	html += "</div></a>"
	return html

/datum/preferences/proc/can_customise()
	if (is_patron())
		return TRUE
	return FALSE




/datum/extension/customisation_applied
