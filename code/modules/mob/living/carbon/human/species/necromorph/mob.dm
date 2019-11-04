/*
	Code for the necromorph mob.
	Most of this is a temporary hack because we don't have proper icons for parts.

`	I am well aware this is not how human mobs and species are supposed to be used
*/
/mob/living/carbon/human/necromorph

/mob/living/carbon/human/necromorph/slasher/New(var/new_loc, var/new_species = SPECIES_NECROMORPH_SLASHER)
	..(new_loc, new_species)

/mob/living/carbon/human/necromorph/slasher/enhanced/New(var/new_loc, var/new_species = SPECIES_NECROMORPH_SLASHER_ENHANCED)
	..(new_loc, new_species)

/mob/living/carbon/human/necromorph/update_icons()
	.=..()
	update_body(FALSE)

#define DEBUG
//Override all that complicated limb-displaying stuff, with singular icons
/mob/living/carbon/human/necromorph/update_body(var/update_icons=1)
	var/datum/species/necromorph/N = species
	if (!istype(N))
		return

	stand_icon = N.icon_template
	icon = stand_icon

	if (stat == DEAD)
		icon_state = N.icon_dead

	else if (lying)
		icon_state = N.icon_lying
	else
		icon_state = N.icon_normal