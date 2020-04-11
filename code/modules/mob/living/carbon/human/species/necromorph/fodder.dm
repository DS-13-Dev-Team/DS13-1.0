/datum/species/necromorph/fodder
	name = SPECIES_NECROMORPH_FODDER
	name_plural =  "Fodders"
	mob_type = /mob/living/carbon/human/necromorph/fodder
	blurb = "A master of disguise, fodders look completely human. Often wearing the suit they died in, fodders are hardly distinguishable from real survivors other than the glow emenating from their eyes. \n\
	To remain looking human, they sacrifice the usual benefitial arm-blades like slashers. Less biomass is removed from the body overall, and their clothes help protect the fodder from damage. \n\
	In order to make up for the lack of blades, they retain enough primitive intelligence to pick up weapons and bludgeon survivors. Unlike humans, their nervous system doesn't restrain their strength."
	total_health = 140
	biomass = 80
	mass = 70

	biomass_reclamation_time	=	7.5 MINUTES

	icon_template = 'icons/mob/necromorph/fodder.dmi'
	icon_lying = "_lying"
	single_icon = FALSE
	evasion = 0	//No natural evasion

	slowdown = 3.2

	inherent_verbs = list(/atom/movable/proc/slasher_charge, /mob/living/proc/slasher_dodge)
	modifier_verbs = list(KEY_CTRLALT = list(/atom/movable/proc/slasher_charge),
	KEY_ALT = list(/mob/living/proc/slasher_dodge))

	lying_rotation = 90 //trying to  see if this works.

	can_pickup = TRUE

	locomotion_limbs = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)

	has_limbs = list(
	BP_CHEST =  list("path" = /obj/item/organ/external/chest/simple),
	BP_HEAD =   list("path" = /obj/item/organ/external/head/simple),
	BP_L_ARM =  list("path" = /obj/item/organ/external/arm/fodder),
	BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/fodder),
	BP_L_HAND =  list("path" = /obj/item/organ/external/hand/fodder),
	BP_R_HAND =  list("path" = /obj/item/organ/external/hand/right/fodder),
	BP_L_LEG =  list("path" = /obj/item/organ/external/leg/fodder),
	BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/fodder),
	BP_L_FOOT =  list("path" = /obj/item/organ/external/foot/fodder),
	BP_R_FOOT =  list("path" = /obj/item/organ/external/foot/right/fodder),
	BP_GROIN =	list("path" = /obj/item/organ/external/groin/fodder)
	)
