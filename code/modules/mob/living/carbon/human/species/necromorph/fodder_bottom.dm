/datum/species/necromorph/fodder_bottom
	name = SPECIES_NECROMORPH_FODDERBOTTOM
	name_plural =  "Bottom Fodders"
	mob_type = /mob/living/carbon/human/necromorph/fodderbottom
	blurb = "A master of disguise, fodders look completely human. Often wearing the suit they died in, fodders are hardly distinguishable from real survivors other than the glow emenating from their eyes. \n\
	To remain looking human, they sacrifice the usual benefitial arm-blades like slashers. Less biomass is removed from the body overall, and their clothes help protect the fodder from damage. \n\
	In order to make up for the lack of blades, they retain enough primitive intelligence to pick up weapons and bludgeon survivors. Unlike humans, their nervous system doesn't restrain their strength."
	total_health = 60
	biomass = null
	mass = 50
	marker_spawnable = FALSE

	icon_template = 'icons/mob/necromorph/fodder_bottom.dmi'
	icon_lying = "_lying"
	single_icon = FALSE

	slowdown = 3.6 //faster due to lost mass!

	inherent_verbs = list(/atom/movable/proc/slasher_charge, /mob/living/proc/slasher_dodge)
	modifier_verbs = list(KEY_CTRLALT = list(/atom/movable/proc/slasher_charge),
	KEY_ALT = list(/mob/living/proc/slasher_dodge))

	override_limb_types = list(
	BP_L_ARM =  /obj/item/organ/external/arm/blade,
	BP_R_ARM =  /obj/item/organ/external/arm/blade/right,
	)

	lying_rotation = 90