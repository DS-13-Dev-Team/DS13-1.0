
/mob/proc/apply_customisation(var/datum/preferences/prefs)


/*
	Humans applying customisation is complicated
*/
/mob/living/carbon/human/apply_customisation(var/datum/preferences/prefs)

	/*
		Don't do this if we're in nullspace. Used for dummies that are spawned for preference menus
	*/
	if (!loc)
		return

	//This extension makes sure it only happens once
	if (has_extension(src, /datum/extension/customisation_applied))
		return

	//Only for necromorphs
	var/datum/species/necromorph/N = species
	if (!istype(N) || !N.has_customisation())
		return

	//Here's the cutoff point for the once only, UNLESS
	//If this is called with blank prefs, we don't apply the lockout. That is only done on initial spawning
	if (prefs)
		set_extension(src, /datum/extension/customisation_applied)


	//Now cache some data. This may change after variant so we need the original
	var/species_tag = N.name
	var/list/custom
	if (prefs)
		custom = prefs.get_necro_custom_list()
	else
		//With blank prefs, we use the global default
		custom = get_default_necro_custom()

	var/list/our_data = custom[species_tag]

	//First up, species variant, since this involves changing species, we cant let the species do this itself, we manage it here
	if (our_data[VARIANT])
		var/list/possible_variants = our_data[VARIANT]
		var/selected = pickweight(possible_variants)
		set_species(selected)


	//Now outfits
	if (our_data[OUTFIT])
		var/list/possible_outfits = our_data[OUTFIT]
		var/selected_type = pickweight(possible_outfits)
		//Selected type is a string so we convert it to a path in this process
		var/decl/hierarchy/outfit/O = outfit_by_type(text2path(selected_type))
		O.equip(src, equip_adjustments = OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR)
