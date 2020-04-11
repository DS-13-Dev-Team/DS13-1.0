/datum/species/necromorph/fodder
	name = SPECIES_NECROMORPH_FODDER
	name_plural =  "Fodders"
	mob_type = /mob/living/carbon/human/necromorph/fodder
	blurb = "A master of disguise, fodders look completely human. Often wearing the suit they died in, fodders are hardly distinguishable from real survivors other than the glow emenating from their eyes. \n\
	To remain looking human, they sacrifice the usual benefitial arm-blades like slashers. Less biomass is removed from the body overall, and their clothes help protect the fodder from damage. \n\
	In order to make up for the lack of blades, they retain enough primitive intelligence to pick up weapons and bludgeon survivors."
	total_health = 70
	biomass = 80
	mass = 70

	biomass_reclamation_time	=	7.5 MINUTES

	icon_template = 'icons/mob/necromorph/fodder.dmi'
	single_icon = FALSE
	evasion = 0	//No natural evasion

	slowdown = 3.2

	inherent_verbs = list(/atom/movable/proc/slasher_charge, /mob/living/proc/slasher_dodge)
	modifier_verbs = list(KEY_CTRLALT = list(/atom/movable/proc/slasher_charge),
	KEY_ALT = list(/mob/living/proc/slasher_dodge))