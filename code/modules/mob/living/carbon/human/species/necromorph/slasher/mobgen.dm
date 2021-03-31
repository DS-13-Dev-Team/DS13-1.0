#define SLASHER_NAKED_CHANCE	50

/*
	Slasher Mob setup
*/
/mob/living/carbon/human/necromorph/slasher/New(var/new_loc, var/new_species = SPECIES_NECROMORPH_SLASHER)
	..(new_loc, new_species)

/mob/living/carbon/human/necromorph/slasher_enhanced/New(var/new_loc, var/new_species = SPECIES_NECROMORPH_SLASHER_ENHANCED)
	..(new_loc, new_species)

//A dummy version of slasher for target practise
/mob/living/carbon/human/necromorph/slasher/dummy
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

/mob/living/carbon/human/necromorph/slasher/dummy/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)


/mob/living/carbon/human/necromorph/slasher/Initialize()
	.=..()
	//Slashers don't always get clothes
	if (prob(SLASHER_NAKED_CHANCE))
		return

	var/list/possible_outfits = list(/decl/hierarchy/outfit/necromorph/planet_cracker = 1,
	/decl/hierarchy/outfit/necromorph/security = 0.5)
	var/outfit_type = pickweight(possible_outfits)

	var/decl/hierarchy/outfit/O = outfit_by_type(outfit_type)
	O.equip(src, equip_adjustments = OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR)