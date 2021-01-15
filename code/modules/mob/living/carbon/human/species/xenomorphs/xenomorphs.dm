proc/create_new_xenomorph(alien_caste, target)

	target = get_turf(target)
	if(!target || !alien_caste) return

	var/mob/living/carbon/human/new_alien = new(target)
	new_alien.set_species("Xenophage [alien_caste]")
	return new_alien

/mob/living/carbon/human/xdrone/New(new_loc)
	h_style = "Bald"
	..(new_loc, "Xenophage Drone")

/mob/living/carbon/human/xsentinel/New(new_loc)
	h_style = "Bald"
	..(new_loc, "Xenophage Sentinel")

/mob/living/carbon/human/xhunter/New(new_loc)
	h_style = "Bald"
	..(new_loc, "Xenophage Hunter")

/mob/living/carbon/human/xqueen/New(new_loc)
	h_style = "Bald"
	..(new_loc, "Xenophage Queen")
