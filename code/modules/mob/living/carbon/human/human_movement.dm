/mob/living/carbon/human
	move_intents = list(/decl/move_intent/walk)

/mob/living/carbon/human/movement_delay()
	var/tally = ..()

	if(species.slowdown)
		tally += species.slowdown


	tally += species.handle_movement_delay_special(src)

	if(legcuffed)
		tally += legcuffed.get_onmob_delay()


	if(CE_SLOWDOWN in chem_effects)
		tally += chem_effects[CE_SLOWDOWN]

	if(can_feel_pain())
		if(get_shock() >= 10) tally += (get_shock() / 10) //pain shouldn't slow you down if you can't even feel it


	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.splinted)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	if(shock_stage >= 10 || src.stamina <= 0)
		tally += 3

	if(is_asystole()) tally += 10  //heart attacks are kinda distracting

	if(aiming && aiming.aiming_at) tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(FAT in src.mutations)
		tally += 1.5
	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75


	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow


	if(mRun in mutations)
		tally = 0

	tally += CONFIG_GET(number/human_delay)


	tally /= get_move_speed_factor()
	if(lying) //Crawling, it's slower
		tally /= species.lying_speed_factor


	set_glide_size(DELAY2GLIDESIZE(tally))

	return tally

/mob/living/carbon/human/size_strength_mod()
	. = ..()
	. += species.strength

/mob/living/carbon/human/Allow_Spacemove(var/check_drift = 0)
	. = ..()
	if(.)
		return

	// This is horrible but short of spawning a jetpack inside the organ than locating
	// it, I don't really see another viable approach short of a total jetpack refactor.
	for(var/obj/item/organ/internal/powered/jets/jet in internal_organs)
		if(!jet.is_broken() && jet.active)
			inertia_dir = 0
			return 1
	// End 'eugh'

	//Do we have a working jetpack?
	var/obj/item/weapon/tank/jetpack/thrust
	if(back)
		if(istype(back,/obj/item/weapon/tank/jetpack))
			thrust = back
		else if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/rig = back
			for(var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				thrust = module.jets
				break

	if(thrust && thrust.on)
		if(prob(skill_fail_chance(SKILL_EVA, 10, SKILL_ADEPT)))
			to_chat(src, "<span class='warning'>You fumble with [thrust] controls!</span>")
			inertia_dir = pick(GLOB.cardinal)
			return 0

		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1

/mob/living/carbon/human/slip_chance(var/prob_slip = 5)
	if(!..())
		return 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= ITEM_SIZE_SMALL)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= ITEM_SIZE_SMALL)	prob_slip -= 1

	return prob_slip

/mob/living/carbon/human/Check_Shoegrip()
	if(species.species_flags & SPECIES_FLAG_NO_SLIP)
		return 1
	if(shoes && (shoes.item_flags & ITEM_FLAG_NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	return 0

/mob/living/carbon/human/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	. = ..()
	if(.) //We moved
		handle_exertion()

/mob/living/carbon/human/proc/handle_exertion()
	if(isSynthetic())
		return

	if(LAZYLEN(implants) || (stomach_contents && stomach_contents.len))
		handle_embedded_and_stomach_objects() //Moving with objects stuck in you can cause bad times.

	var/lac_chance =  10 * encumbrance()
	if(lac_chance && prob(skill_fail_chance(SKILL_HAULING, lac_chance)))
		make_reagent(1, /datum/reagent/lactate)
		switch(rand(1,20))
			if(1)
				visible_message("<span class='notice'>\The [src] is sweating heavily!</span>", "<span class='notice'>You are sweating heavily!</span>")
			if(2)
				visible_message("<span class='notice'>\The [src] looks out of breath!</span>", "<span class='notice'>You are out of breath!</span>")

//Returns what percentage of the limbs we use for movement, are still attached
/mob/living/carbon/human/proc/get_locomotive_limb_percent()

	var/current = length(get_locomotion_limbs(FALSE))
	var/max = LAZYLEN(species.locomotion_limbs)

	if (max > 0)
		return current / max

	return 1

/mob/living/carbon/human/can_sprint()
	return (stamina > 0)