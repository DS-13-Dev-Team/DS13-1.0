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
			world << "Checking if [species_name] is enabled: [is_enabled]"
			. += image_check_panel(text = species_name, I = S.get_default_icon(), ticked = is_enabled, user = user, command = is_enabled ? "disable" : "enable", source = topic_reciever, category = src.name, subcategory = VARIANT)
		. += "</td></tr>"


/datum/species/necromorph/proc/prefill_customisation_prefs(var/list/necro_custom = list())
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

	return necro_custom

/datum/species/necromorph/proc/get_default_icon()
	if (!default_icon)
		var/mob/living/carbon/human/H = new mob_type(locate(1,1,1), src.name)	//Create a new human of our species
		default_icon = getFlatIcon(H)

	return default_icon
