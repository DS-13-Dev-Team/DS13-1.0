/mob/living/proc/handle_death_check()
	if (stat != DEAD)
		death()

/mob/living/death()
	if(hiding)
		hiding = FALSE
	. = ..()
