/*
	Areas
*/
/area/proc/has_gravity()
	return has_gravity

/area/space/has_gravity()
	return 0



/area/proc/gravity_changed(var/gravitystate = 0)
	has_gravity = gravitystate

	for (var/mob/M in contents)
		M.gravity_changed()



/*
	Mobs
*/

/mob/proc/has_gravity()
	if (Check_Shoegrip())
		return TRUE
	var/area/A = get_area(src)
	return A.has_gravity

/mob/proc/gravity_changed(var/new_gravity)


/mob/living/gravity_changed(var/new_gravity)
	if (!has_gravity())
		AddMovementHandler(/datum/movement_handler/mob/zero_gravity, /datum/movement_handler/mob/movement)
		set_extension(src, /datum/extension/zero_gravity_effects)
	else
		RemoveMovementHandler(/datum/movement_handler/mob/zero_gravity, /datum/movement_handler/mob/movement)
		remove_extension(src, /datum/extension/zero_gravity_effects)

	if(new_gravity && !MOVING_DELIBERATELY(src)) // Being ready when you change areas allows you to avoid falling.
		gravity_shock()

	update_floating()
	update_encumbrance()




/*
	Extension
*/
/datum/extension/zero_gravity_effects
	name = "Zero G"
	flags = EXTENSION_FLAG_IMMEDIATE
	auto_register_statmods = FALSE
	expected_type = /mob/living
	auto_register_statmods = FALSE
	statmods = list()

/datum/extension/zero_gravity_effects/New(datum/holder)
	. = ..()
	var/mob/living/L = holder
	L.update_encumbrance()

	var/skill = L.get_skill_value(SKILL_EVA)-1	//This returns a value in the range 1-5, reduced to 0-4
	statmods[STATMOD_MOVESPEED_MULTIPLICATIVE] = 1.1 + (0.06 * skill)
	statmods[STATMOD_EVASION]	=	4 * skill
	statmods[STATMOD_ATTACK_SPEED] = -(0.4 - (0.05 * skill))	//Takes longer to recover from swings
	register_statmods()

/*
	Falling to the floor with a sudden change in gravity
*/
/mob/proc/gravity_shock()

/mob/living/gravity_shock()
	if(istype(get_turf(src), /turf/space)) // Can't fall onto nothing.
		return

	if(src.Check_Shoegrip())
		return

	if(istype(src,/mob/living/carbon/human/))
		var/mob/living/carbon/human/H = src
		if(prob(H.skill_fail_chance(SKILL_EVA, 100, SKILL_PROF)))
			if(!MOVING_DELIBERATELY(H))
				H.AdjustStunned(6)
				H.AdjustWeakened(6)
			else
				H.AdjustStunned(3)
				H.AdjustWeakened(3)
			to_chat(src, "<span class='notice'>The sudden appearance of gravity makes you fall to the floor!</span>")