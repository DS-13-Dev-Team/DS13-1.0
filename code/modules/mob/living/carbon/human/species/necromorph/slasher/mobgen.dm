#define SLASHER_NAKED_CHANCE	1//50

/mob/living/carbon/human/necromorph/slasher/New(var/new_loc, var/new_species = SPECIES_NECROMORPH_SLASHER)
	new_species = pickweight(list(SPECIES_NECROMORPH_SLASHER = 80, \
	SPECIES_NECROMORPH_SLASHER_DESICCATED = 20))
	..(new_loc, new_species)


/mob/living/carbon/human/necromorph/slasher/Initialize()
	.=..()
	//Slashers don't always get clothes
	if (prob(SLASHER_NAKED_CHANCE))
		world << "Naked slasher"
		return

	var/list/possible_outfits = list(/decl/hierarchy/outfit/necromorph/planet_cracker = 1,
	/decl/hierarchy/outfit/necromorph/security = 0.5)
	world << "There are [possible_outfits.len] possible outfits"
	var/outfit_type = pickweight(possible_outfits)
	world << "Picked outfit type [outfit_type]"

	var/decl/hierarchy/outfit/O = outfit_by_type(outfit_type)
	O.equip(src, equip_adjustments = OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR)