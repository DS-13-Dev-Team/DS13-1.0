/*
	Return true if this species has any customisation options at all
*/
/datum/species/necromorph/proc/has_customisation()

	//This is how we mark variant subtypes
	if (preference_settable == FALSE)
		return FALSE

	if (variants)
		return TRUE

	return FALSE

/*
	This produces all the content for the customisation menu main panel, when this species is selected
*/
/datum/species/necromorph/proc/get_customisation_content(var/datum/preferences/prefs, var/mob/living/user, var/datum/topic_reciever)
	. += "<table>"
	var/list/custom = prefs.get_necro_custom_list()
	var/list/data = custom[name]	//This gets the list containing all saved customisation data for this necromorph category
	if (!data)
		data = list()

	if (variants)
		.+= "<tr><td>"
		.+= "<h1>Variants</h1>"

		//This gets the sublist containing all saved customisation data for this subcategory
		var/list/variants_data = LAZYACCESS(data, VARIANT)
		if (!variants_data)	variants_data = list()

		for (var/species_name in variants)
			var/datum/species/necromorph/S = GLOB.all_necromorph_species[species_name]
			var/is_enabled = (species_name in variants_data)
			. += image_check_panel(text = species_name, I = S.get_default_icon(), ticked = is_enabled, user = user, command = is_enabled ? "disable" : "enable", source = topic_reciever, category = src.name, subcategory = VARIANT)
		. += "</td></tr>"


	if (outfits)
		.+= "<tr><td>"
		.+= "<h1>Outfits</h1>"

		//This gets the sublist containing all saved customisation data for this subcategory
		var/list/outfits_data = LAZYACCESS(data, OUTFIT)
		if (!outfits_data)
			outfits_data = list()

		for (var/outfit_type in outfits)

			var/decl/hierarchy/outfit/O = outfit_by_type(outfit_type)

			var/string_outfit_type = "[outfit_type]"

			var/is_enabled = (string_outfit_type in outfits_data)
			. += image_check_panel(text = O.name, I = O.get_default_species_icon(src.name), ticked = is_enabled, user = user, command = is_enabled ? "disable" : "enable", source = topic_reciever, category = src.name, subcategory = OUTFIT, command_data = string_outfit_type)
		. += "</td></tr>"

/*
	this can be overridden in case of interesting special things, but always call parent
*/
/datum/species/necromorph/proc/prefill_customisation_prefs(var/list/necro_custom)
	if (!necro_custom)
		necro_custom = list()
	necro_custom[name] = list()
	if (variants)
		var/list/public_variants = list()
		for (var/vname in variants)
			var/list/params = variants[vname]

			//Premium variant, not in the default list
			if (params[PATRON])
				continue

			public_variants[vname] = (params[WEIGHT] ? params[WEIGHT] : 1)
		necro_custom[name][VARIANT]	= public_variants

	if (outfits)
		var/list/public_outfits = list()
		for (var/outfit_type in outfits)
			//var/decl/hierarchy/outfit/O = outfit_by_type(outfit_type)
			var/string_outfit_type = "[outfit_type]"	//We convert it to a string from here on out
			var/list/params = outfits[outfit_type]

			//Premium outfit, not in the default list
			if (params[PATRON])
				continue

			public_outfits[string_outfit_type] = (params[WEIGHT] ? params[WEIGHT] : 1)
		necro_custom[name][OUTFIT]	= public_outfits
	return necro_custom

/datum/species/necromorph/proc/get_default_icon()
	if (!default_icon)
		var/mob/living/carbon/human/H = new mob_type(locate(1,1,1), src.name)	//Create a new human of our species
		default_icon = getFlatIcon(H)
		H.adjust_biomass(-INFINITY)	//Not worth biomass
		QDEL_NULL(H)

	return default_icon
