
/mob/proc/apply_customisation(var/datum/preferences/prefs)


/*
	Humans applying customisation is complicated
*/
/mob/living/carbon/human/apply_customisation(var/datum/preferences/prefs)

	//This extension makes sure it only happens once
	if (has_extension(src, /datum/extension/customisation_applied))
		return

	//Only for necromorphs
	var/datum/species/necromorph/N = species
	if (!istype(N) || !N.has_customisation())
		return

	//Here's the cutoff point for the once only
	set_extension(src, /datum/extension/customisation_applied)


	//Now cache some data. This may change after variant so we need the original
	var/species_tag = N.name
	var/list/custom = prefs.get_necro_custom_list()
	var/list/our_data = custom[species_tag]

	//First up, species variant, since this involves changing species, we cant let the species do this itself, we manage it here
	if (our_data[VARIANT])
		var/list/possible_variants = our_data[VARIANT]
		var/selected = pickweight(possible_variants)
		set_species(selected)
		//refresh_lighting_overlays()

