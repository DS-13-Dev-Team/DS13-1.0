/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act

*/

/*-------------------------------
	Projectile accuracy handling
---------------------------------*/
//Takes an accuracy value, a targeted bodypart, and the projectile, tool or mob doing the hitting.
//Calculate all bonuses on the attacker's side before calling this, this proc handles the evasion on the defensive side
/mob/living/carbon/human/get_zone_with_miss_chance(var/accuracy, var/desired_zone, var/weapon)
	//Mobs on the floor are less good at evading
	var/evasion_mod = evasion
	if (lying)
		evasion_mod *= 0.5
	accuracy -= evasion_mod

	//Individual organs have varying difficulty to hit them
	var/obj/item/organ/external/organ = get_organ(desired_zone)
	if (organ)
		accuracy -= organ.base_miss_chance



	//For humans, we run the accuracy check twice
	//1. To see whether we hit anything at all. Fail, and the attack misses.
	if (!prob(accuracy))
		return	null

	//2. To see whether we hit the desired bodypart. Fail, and we'll hit a random bodypart instead
		//If no particular bodypart is desired, we skip this and just pick random
	if (desired_zone && prob(accuracy))
		return desired_zone	//It hit!
	else
		return pick(organs_by_name)	//Check if this is valid

/mob/living/carbon/human/bullet_act(var/obj/item/projectile/P, var/def_zone)

	def_zone = check_zone(def_zone)
	if(!has_organ(def_zone))
		return PROJECTILE_FORCE_MISS //if they don't have the organ in question then the projectile just passes by.

	//Shields
	/* //TODO: Make projectiles use strikes too
	var/shield_check = check_shields(P.damage, P, null, def_zone, "the [P.name]")
	if(shield_check)
		if(shield_check < 0)
			return shield_check
		else
			P.on_hit(src, 100, def_zone)
			return 100
	*/

	var/obj/item/organ/external/organ = find_target_organ(def_zone)
	var/armor = getarmor_organ(organ, P.check_armour)
	var/penetrating_damage = ((P.damage + P.armor_penetration) * P.penetration_modifier) - armor

	var/blocked = ..(P, def_zone)

	//Embed or sever artery
	if(P.can_embed() && !(species.species_flags & SPECIES_FLAG_NO_EMBED) && prob((22.5 + max(penetrating_damage, -10))*P.embed_mult) && !(prob(50) && (organ.sever_artery())))
		var/obj/item/SP = new P.shrapnel_type(organ, P)
		SP.SetName((P.name != "shrapnel")? "[P.name] shrapnel" : "shrapnel")
		SP.desc = "[SP.desc] It looks like it was fired from [P.shot_from]."
		organ.embed(SP)



	projectile_hit_bloody(P, P.damage*blocked_mult(blocked), def_zone)

	return blocked

/mob/living/carbon/human/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone)
	var/obj/item/organ/external/affected = get_organ(check_zone(def_zone))
	if(!affected)
		return

	var/siemens_coeff = get_siemens_coefficient_organ(affected)
	stun_amount *= siemens_coeff
	agony_amount *= siemens_coeff
	agony_amount *= affected.get_agony_multiplier()

	affected.stun_act(stun_amount, agony_amount)

	..(stun_amount, agony_amount, def_zone)

/mob/living/carbon/human/getarmor(var/def_zone, var/type)
	var/armorval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getarmor_organ(def_zone, type)
		var/obj/item/organ/external/affecting = get_organ(def_zone)
		if(affecting)
			return getarmor_organ(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/organ_name in organs_by_name)
		if (organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			if(organ)
				var/weight = organ_rel_size[organ_name]
				armorval += (getarmor_organ(organ, type) * weight) //use plain addition here because we are calculating an average
				total += weight
	return (armorval/max(total, 1))

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = max(species.siemens_coefficient,0)

	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.body_parts_covered & def_zone.body_part)) // Is that body part being targeted covered?
			siemens_coefficient *= C.siemens_coefficient

	return siemens_coefficient

//this proc returns the armour value for a particular external organ.
/mob/living/carbon/human/proc/getarmor_organ(var/obj/item/organ/external/def_zone, var/type)
	if(!type || !def_zone) return 0
	if(!istype(def_zone))
		def_zone = get_organ(check_zone(def_zone))
	if(!def_zone || !def_zone.species)
		return 0
	var/protection = def_zone.species.natural_armour_values ? def_zone.species.natural_armour_values[type] : 0
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/gear in protective_gear)
		if(gear.body_parts_covered & def_zone.body_part)
			protection = add_armor(protection, gear.armor[type])
		if(gear.accessories.len)
			for(var/obj/item/clothing/accessory/bling in gear.accessories)
				if(bling.body_parts_covered & def_zone.body_part)
					protection = add_armor(protection, bling.armor[type])
	return Clamp(protection,0,100)

/mob/living/carbon/human/proc/check_head_coverage()

	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & HEAD)
				return 1
	return 0

//Used to check if they can be fed food/drinks/pills
/mob/living/carbon/human/check_mouth_coverage()
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_parts_covered & FACE) && !(gear.item_flags & ITEM_FLAG_FLEXIBLEMATERIAL))
			return gear
	return null


/mob/living/carbon/human/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)

	for (var/obj/item/grab/G in grabbed_by)
		if(G.resolve_item_attack(user, I, target_zone))
			return null

	return target_zone

	//Accuracy handling is being moved elsewhere. this proc only exists to do special interactions like throat cutting

	/*
	if(user == src) // Attacking yourself can't miss
		return target_zone

	var/accuracy = 100 + user.melee_accuracy_mods()
	accuracy -= 8*get_skill_difference(SKILL_COMBAT, user)
	accuracy -= 8*(I.w_class - ITEM_SIZE_NORMAL)
	accuracy += I.melee_accuracy_bonus

	var/hit_zone = get_zone_with_miss_chance(accuracy, target_zone, I )

	if(!hit_zone)
		visible_message("<span class='danger'>\The [user] misses [src] with \the [I]!</span>")
		return null

	var/obj/item/organ/external/affecting = find_target_organ(hit_zone)
	if (!affecting || affecting.is_stump())
		to_chat(user, "<span class='danger'>They are missing that limb!</span>")
		return null


	return affecting.organ_tag
	*/

/mob/living/carbon/human/hit_with_weapon(var/datum/strike/implement/strike)
	return standard_weapon_hit_effects(strike.used_item, strike.user, strike.get_final_damage(), strike.blocked, strike.target_zone)


/mob/living/carbon/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return 0

	// Handle striking to cripple.
	if(user && user.a_intent == I_DISARM)
		effective_force *= 0.66 //reduced effective force...
		.=..(I, user, effective_force, blocked, hit_zone)
		if(!.)
			return

		//set the dislocate mult less than the effective force mult so that
		//dislocating limbs on disarm is a bit easier than breaking limbs on harm
		attack_joint(affecting, I, effective_force, 0.5, blocked) //...but can dislocate joints
	else
		.=..(I, user, effective_force, blocked, hit_zone)
		if(!.)
			return

	effective_force = .

	if(effective_force > 10 || effective_force >= 5 && prob(33))
		forcesay(GLOB.hit_appends)	//forcesay checks stat already
	if((I.damtype == BRUTE || I.damtype == PAIN) && prob(25 + (effective_force * 2)))
		if(!stat)
			if(headcheck(hit_zone))
				//Harder to score a stun but if you do it lasts a bit longer
				if(prob(effective_force))
					apply_effect(20, PARALYZE, blocked)
					if(lying)
						visible_message("<span class='danger'>[src] [species.knockout_message]</span>")
			else
				//Easier to score a stun but lasts less time
				if(prob(effective_force + 10))
					apply_effect(6, WEAKEN, blocked)
					if(lying)
						visible_message("<span class='danger'>[src] has been knocked down!</span>")

		//Apply blood
		attack_bloody(I, user, effective_force, hit_zone)


/mob/living/carbon/human/proc/attack_bloody(obj/item/W, mob/living/attacker, var/effective_force, var/hit_zone)
	if(W.damtype != BRUTE)
		return

	//make non-sharp low-force weapons less likely to be bloodied
	if(W.sharp || prob(effective_force*4))
		if(!(W.atom_flags & ATOM_FLAG_NO_BLOOD))
			W.add_blood(src)
	else
		return //if the weapon itself didn't get bloodied than it makes little sense for the target to be bloodied either

	//getting the weapon bloodied is easier than getting the target covered in blood, so run prob() again
	if(prob(33 + W.sharp*10))
		var/turf/location = loc
		if(istype(location, /turf/simulated))
			location.add_blood(src)
		if(ishuman(attacker))
			var/mob/living/carbon/human/H = attacker
			if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
				H.bloody_body(src)
				H.bloody_hands(src)

		switch(hit_zone)
			if(BP_HEAD)
				if(wear_mask)
					wear_mask.add_blood(src)
					update_inv_wear_mask(0)
				if(head)
					head.add_blood(src)
					update_inv_head(0)
				if(glasses && prob(33))
					glasses.add_blood(src)
					update_inv_glasses(0)
			if(BP_CHEST)
				bloody_body(src)

/mob/living/carbon/human/proc/projectile_hit_bloody(obj/item/projectile/P, var/effective_force, var/hit_zone)
	if(P.damage_type != BRUTE || P.nodamage)
		return
	if(!(P.sharp || prob(effective_force*4)))
		return
	if(prob(effective_force))
		var/turf/location = loc
		if(istype(location, /turf/simulated))
			location.add_blood(src)

		switch(hit_zone)
			if(BP_HEAD)
				if(wear_mask)
					wear_mask.add_blood(src)
					update_inv_wear_mask(0)
				if(head)
					head.add_blood(src)
					update_inv_head(0)
				if(glasses && prob(33))
					glasses.add_blood(src)
					update_inv_glasses(0)
			if(BP_CHEST)
				bloody_body(src)

/mob/living/carbon/human/proc/attack_joint(var/obj/item/organ/external/organ, var/obj/item/W, var/effective_force, var/dislocate_mult, var/blocked)
	if(!organ || (organ.dislocated == 2) || (organ.dislocated == -1) || blocked >= 100)
		return 0
	if(W.damtype != BRUTE)
		return 0

	//want the dislocation chance to be such that the limb is expected to dislocate after dealing a fraction of the damage needed to break the limb
	var/dislocate_chance = effective_force/(dislocate_mult * organ.min_broken_damage * config.organ_health_multiplier)*100
	if(prob(dislocate_chance * blocked_mult(blocked)))
		visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		organ.dislocate(1)
		return 1
	return 0

/mob/living/carbon/human/emag_act(var/remaining_charges, mob/user, var/emag_source)
	var/obj/item/organ/external/affecting = get_organ(user.zone_sel.selecting)
	if(!affecting || !BP_IS_ROBOTIC(affecting))
		to_chat(user, "<span class='warning'>That limb isn't robotic.</span>")
		return -1
	if(affecting.status & ORGAN_SABOTAGED)
		to_chat(user, "<span class='warning'>[src]'s [affecting.name] is already sabotaged!</span>")
		return -1
	to_chat(user, "<span class='notice'>You sneakily slide [emag_source] into the dataport on [src]'s [affecting.name] and short out the safeties.</span>")
	affecting.status |= ORGAN_SABOTAGED
	return 1

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/hitby(atom/movable/AM as mob|obj,var/speed = BASE_THROW_SPEED)
	if(istype(AM,/obj/))
		var/obj/O = AM

		if(in_throw_mode && !get_active_hand())	//empty active hand and we're in throw mode
			if(!incapacitated())
				if(isturf(O.loc))
					put_in_active_hand(O)
					visible_message("<span class='warning'>[src] catches [O]!</span>")
					throw_mode_off()
					return

	AM.launch_throw_strike(src, speed)

/mob/living/carbon/human/embed(var/obj/O, var/def_zone=null, var/datum/wound/supplied_wound)
	if(!def_zone) ..()

	var/obj/item/organ/external/affecting = get_organ(def_zone)
	if(affecting)
		affecting.embed(O, supplied_wound = supplied_wound)

/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if (gloves)
		gloves.add_blood(source)
		gloves:transfer_blood = amount
		gloves:bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(w_uniform)
		w_uniform.add_blood(source)
		update_inv_w_uniform(0)

/mob/living/carbon/human/proc/handle_suit_punctures(var/damtype, var/damage, var/def_zone)

	// Tox and oxy don't matter to suits.
	if(damtype != BURN && damtype != BRUTE) return

	// The rig might soak this hit, if we're wearing one.
	if(back && istype(back,/obj/item/weapon/rig))
		var/obj/item/weapon/rig/rig = back
		rig.take_hit(damage)

	// We may also be taking a suit breach.
	if(!wear_suit) return
	if(!istype(wear_suit,/obj/item/clothing/suit/space)) return
	var/obj/item/clothing/suit/space/SS = wear_suit
	SS.create_breaches(damtype, damage)

/mob/living/carbon/human/reagent_permeability()
	var/perm = 0

	var/list/perm_by_part = list(
		"head" = THERMAL_PROTECTION_HEAD,
		"upper_torso" = THERMAL_PROTECTION_UPPER_TORSO,
		"lower_torso" = THERMAL_PROTECTION_LOWER_TORSO,
		"legs" = THERMAL_PROTECTION_LEG_LEFT + THERMAL_PROTECTION_LEG_RIGHT,
		"feet" = THERMAL_PROTECTION_FOOT_LEFT + THERMAL_PROTECTION_FOOT_RIGHT,
		"arms" = THERMAL_PROTECTION_ARM_LEFT + THERMAL_PROTECTION_ARM_RIGHT,
		"hands" = THERMAL_PROTECTION_HAND_LEFT + THERMAL_PROTECTION_HAND_RIGHT
		)

	for(var/obj/item/clothing/C in src.get_equipped_items())
		if(C.permeability_coefficient == 1 || !C.body_parts_covered)
			continue
		if(C.body_parts_covered & HEAD)
			perm_by_part["head"] *= C.get_permeability()
		if(C.body_parts_covered & UPPER_TORSO)
			perm_by_part["upper_torso"] *= C.get_permeability()
		if(C.body_parts_covered & LOWER_TORSO)
			perm_by_part["lower_torso"] *= C.get_permeability()
		if(C.body_parts_covered & LEGS)
			perm_by_part["legs"] *= C.get_permeability()
		if(C.body_parts_covered & FEET)
			perm_by_part["feet"] *= C.get_permeability()
		if(C.body_parts_covered & ARMS)
			perm_by_part["arms"] *= C.get_permeability()
		if(C.body_parts_covered & HANDS)
			perm_by_part["hands"] *= C.get_permeability()

	for(var/part in perm_by_part)
		perm += perm_by_part[part]

	return perm


/mob/living/carbon/human/Stun(amount, bypass_resist = FALSE)
	if (!bypass_resist)
		amount *= species.stun_mod
		if(amount <= 0 || (HULK in mutations)) return
	..(amount)

/mob/living/carbon/human/Weaken(amount)
	amount *= species.weaken_mod
	if(amount <= 0 || (HULK in mutations)) return
	..(amount)

/mob/living/carbon/human/Paralyse(amount)
	amount *= species.paralysis_mod
	if(amount <= 0 || (HULK in mutations)) return
	// Notify our AI if they can now control the suit.
	if(wearing_rig && !stat && paralysis < amount) //We are passing out right this second.
		wearing_rig.notify_ai("<span class='danger'>Warning: user consciousness failure. Mobility control passed to integrated intelligence system.</span>")
	..(amount)


//Removed the horrible safety parameter. It was only being used by ninja code anyways.
//Now checks siemens_coefficient of the affected area by default
/mob/living/carbon/human/electrocute_act(var/shock_damage, var/obj/source, var/base_siemens_coeff = 1.0, var/def_zone = null)

	if(status_flags & GODMODE)	return 0	//godmode

	if(species.siemens_coefficient == -1)
		if(stored_shock_by_ref["\ref[src]"])
			stored_shock_by_ref["\ref[src]"] += shock_damage
		else
			stored_shock_by_ref["\ref[src]"] = shock_damage
		return

	if (!def_zone)
		def_zone = pick(BP_L_HAND, BP_R_HAND)

	return ..(shock_damage, source, base_siemens_coeff, def_zone)

/mob/living/carbon/human/apply_shock(var/shock_damage, var/def_zone, var/base_siemens_coeff = 1.0)
	var/obj/item/organ/external/initial_organ = get_organ(check_zone(def_zone))
	if(!initial_organ)
		initial_organ = pick(organs)

	var/obj/item/organ/external/floor_organ

	if(!lying)
		var/obj/item/organ/external/list/standing = list()
		for(var/limb_tag in species.locomotion_limbs)
			var/obj/item/organ/external/E = organs_by_name[limb_tag]
			if(E && E.is_usable())
				standing[limb_tag] = E
		if((def_zone == BP_L_FOOT || def_zone == BP_L_LEG) && standing[BP_L_FOOT])
			floor_organ = standing[BP_L_FOOT]
		if((def_zone == BP_R_FOOT || def_zone == BP_R_LEG) && standing[BP_R_FOOT])
			floor_organ = standing[BP_R_FOOT]
		else
			floor_organ = standing[pick(standing)]

	if(!floor_organ)
		floor_organ = pick(organs)

	var/obj/item/organ/external/list/to_shock = trace_shock(initial_organ, floor_organ)

	if(to_shock && to_shock.len)
		shock_damage /= to_shock.len
		shock_damage = round(shock_damage, 0.1)
	else
		return 0

	var/total_damage = 0

	for(var/obj/item/organ/external/E in to_shock)
		total_damage += ..(shock_damage, E.organ_tag, base_siemens_coeff * get_siemens_coefficient_organ(E))
	return total_damage

/mob/living/carbon/human/proc/trace_shock(var/obj/item/organ/external/init, var/obj/item/organ/external/floor)
	var/obj/item/organ/external/list/traced_organs = list(floor)

	if(!init)
		return

	if(!floor || init == floor)
		return list(init)

	for(var/obj/item/organ/external/E in list(floor, init))
		while(E && E.parent_organ)
			E = organs_by_name[E.parent_organ]
			traced_organs += E
			if(E == init)
				return traced_organs

	return traced_organs



/mob/living/carbon/human/proc/handle_shock()
	..()
	if(status_flags & GODMODE)	return 0	//godmode
	if(!can_feel_pain())
		shock_stage = 0
		return

	if(is_asystole())
		shock_stage = max(shock_stage + 1, 61)
	var/traumatic_shock = get_shock()
	if(traumatic_shock >= max(pain_shock_threshold, 0.8*shock_stage))
		shock_stage += 1
	else if (!is_asystole())
		shock_stage = min(shock_stage, 160)
		var/recovery = 1
		if(traumatic_shock < 0.5 * shock_stage) //lower shock faster if pain is gone completely
			recovery++
		if(traumatic_shock < 0.25 * shock_stage)
			recovery++
		shock_stage = max(shock_stage - recovery, 0)
		return
	if(stat) return 0

	if(shock_stage == 10)
		// Please be very careful when calling custom_pain() from within code that relies on pain/trauma values. There's the
		// possibility of a feedback loop from custom_pain() being called with a positive power, incrementing pain on a limb,
		// which triggers this proc, which calls custom_pain(), etc. Make sure you call it with nohalloss = TRUE in these cases!
		custom_pain("[pick("It hurts so much", "You really need some painkillers", "Dear god, the pain")]!", 10, nohalloss = TRUE)

	if(shock_stage >= 30)
		if(shock_stage == 30) visible_message("<b>[src]</b> is having trouble keeping \his eyes open.")
		if(prob(30))
			eye_blurry = max(2, eye_blurry)
			stuttering = max(stuttering, 5)

	if(shock_stage == 40)
		custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!", 40, nohalloss = TRUE)
	if (shock_stage >= 60)
		if(shock_stage == 60) visible_message("<b>[src]</b>'s body becomes limp.")
		if (prob(2))
			custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!", shock_stage, nohalloss = TRUE)
			Weaken(10)

	if(shock_stage >= 80)
		if (prob(5))
			custom_pain("[pick("The pain is excruciating", "Please, just end the pain", "Your whole body is going numb")]!", shock_stage, nohalloss = TRUE)
			Weaken(20)

	if(shock_stage >= 120)
		if (prob(2))
			custom_pain("[pick("You black out", "You feel like you could die any moment now", "You're about to lose consciousness")]!", shock_stage, nohalloss = TRUE)
			Paralyse(5)

	if(shock_stage == 150)
		visible_message("<b>[src]</b> can no longer stand, collapsing!")
		Weaken(20)

	if(shock_stage >= 150)
		Weaken(20)



/*-------------------------------
	Strike Defense
---------------------------------*/
/*
	Defensive instincts system. Humans will use their limbs to shield their squishy core parts from hits.
	If successful, the attack is redirected to the limb, AND its damage is reduced a little.
	An attack aimed at the face, but blocked by an arm hurts the arm less than an attack specifically aimed at that arm
*/
/mob/living/carbon/human/handle_strike_defense(var/datum/strike/strike)
	if (!can_defend(strike))
		return




	//Alright we've discovered that we can possibly defend, next lets figure out the factors that affect our chance of doing so
	var/block_chance_modifier = strike.difficulty * -1
	if (strike.melee)
		block_chance_modifier += 4*get_skill_difference(SKILL_COMBAT, strike.user)
	else
		block_chance_modifier += 3*get_skill_value(SKILL_COMBAT)

	//The intent we're in slightly affects blocking chances
	switch(src.a_intent)
		if(I_HELP)
			block_chance_modifier -= 5
		if(I_HURT, I_GRAB)
			block_chance_modifier += 5

	if (src.grabbed_by.len)
		block_chance_modifier -= 30	//If someone's holding you, guarding is near impossible





	//We can block with exactly one object or limb per attack.
	//Objects are -far- more effective so we check those first
	var/list/items = list(l_hand, r_hand)
	for (var/obj/item/I in items)
		if (I.can_block(strike))
			var/item_block_chance = I.get_block_chance(src) + block_chance_modifier
			if (prob(item_block_chance))
				I.handle_block(strike)
				return	//Only block with one item





	//Okay now we'll account for defending with a limb
	var/limb_block_chance = BASE_DEFENSE_CHANCE + block_chance_modifier


	//First up, is this a part that we care to guard at all? We check this here because, in the case of blocking with a shield, we'd defend all attacks
	if (strike.affecting && strike.affecting.defensive_group)
		if (prob(limb_block_chance))
			//It is! Alright, lets get the list of limbs that can be used to defend this one
			var/list/possible_defenses = species.defensive_limbs[strike.affecting.defensive_group].Copy()
			if (!LAZYLEN(possible_defenses))
				return
			var/obj/item/organ/external/blocker = null

			//Right lets loop through them and try to find one to block with
			while (!blocker && possible_defenses.len)
				var/organ_tag = pick_n_take(possible_defenses)
				blocker = get_organ(organ_tag)
				if (blocker && blocker.is_usable() && !blocker.retracted)
					//If this organ is fine, we're done with the loop,
					break
				else
					//Organ is missing or otherwise unuseable
					blocker = null


			if (!blocker)
				return

			//Alright block successful!
			strike.blocked_damage += blocker.block_reduction	//This will be subtracted from the eventual damage
			strike.target_zone = blocker.organ_tag	//The attack is redirected to our blocking limb
			strike.blocker = blocker	//And the limb is set on the attack too

/*
	This proc checks if this person can defend against an incoming strike
*/
/mob/living/carbon/human/can_defend(var/datum/strike/strike)

	if (strike.luser == src)
		//We don't block ourselves
		return FALSE

	//First of all, we must be conscious
	if (incapacitated(INCAPACITATION_KNOCKOUT))
		return FALSE

	//Does our species ever defend?
	if (!species.can_defend(src, strike))
		return FALSE

	//We have to be roughly facing the attacker, unless we're lying down. We have omnidirectional defense when curled up on the floor
	if (!lying)
		//200 degree frontal arc covers all the tiles infront of us, and directly to sides. 5/8 possible directions are defensible
		if (get_turf(strike.origin) != get_turf(src) && !target_in_frontal_arc(src, strike.origin, 200))
			return FALSE

	return TRUE






/*
	Temperature Mechanics
*/

/mob/living/carbon/human/get_fire_damage(var/temperature, var/multiplier)
	var/protection = get_heat_protection(temperature)

	if (protection >= 1)
		return 0
	else
		temperature *= (1 - protection)

		.=..(temperature, multiplier)


	//This proc returns a number made up of the flags for body parts which you are protected on. (such as HEAD, UPPER_TORSO, LOWER_TORSO, etc. See setup.dm for the full list)
/mob/living/carbon/human/proc/get_heat_protection_flags(temperature) //Temperature is the temperature you're being exposed to.
	. = 0
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.max_heat_protection_temperature && C.max_heat_protection_temperature >= temperature)
				. |= C.heat_protection

//See proc/get_heat_protection_flags(temperature) for the description of this proc.
/mob/living/carbon/human/proc/get_cold_protection_flags(temperature)
	. = 0
	//Handle normal clothing
	for(var/obj/item/clothing/C in list(head,wear_suit,w_uniform,shoes,gloves,wear_mask))
		if(C)
			if(C.min_cold_protection_temperature && C.min_cold_protection_temperature <= temperature)
				. |= C.cold_protection

/mob/living/carbon/human/get_heat_protection(var/temperature) //Temperature is the temperature you're being exposed to.
	//Not hot enough to bother us
	if (temperature < species.heat_level_1)
		return 1

	else
		//our natural heat resistance is deducted from this
		temperature -= species.heat_level_1

	var/thermal_protection_flags = get_heat_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/carbon/human/get_cold_protection(temperature)
	if(COLD_RESISTANCE in mutations)
		return TRUE //Fully protected from the cold.

	temperature = max(temperature, 2.7) //There is an occasional bug where the temperature is miscalculated in ares with a small amount of gas on them, so this is necessary to ensure that that bug does not affect this calculation. Space's temperature is 2.7K and most suits that are intended to protect against any cold, protect down to 2.0K.
	var/thermal_protection_flags = get_cold_protection_flags(temperature)
	return get_thermal_protection(thermal_protection_flags)

/mob/living/carbon/human/proc/get_thermal_protection(var/flags)
	.=0
	if(flags)
		if(flags & HEAD)
			. += THERMAL_PROTECTION_HEAD
		if(flags & UPPER_TORSO)
			. += THERMAL_PROTECTION_UPPER_TORSO
		if(flags & LOWER_TORSO)
			. += THERMAL_PROTECTION_LOWER_TORSO
		if(flags & LEG_LEFT)
			. += THERMAL_PROTECTION_LEG_LEFT
		if(flags & LEG_RIGHT)
			. += THERMAL_PROTECTION_LEG_RIGHT
		if(flags & FOOT_LEFT)
			. += THERMAL_PROTECTION_FOOT_LEFT
		if(flags & FOOT_RIGHT)
			. += THERMAL_PROTECTION_FOOT_RIGHT
		if(flags & ARM_LEFT)
			. += THERMAL_PROTECTION_ARM_LEFT
		if(flags & ARM_RIGHT)
			. += THERMAL_PROTECTION_ARM_RIGHT
		if(flags & HAND_LEFT)
			. += THERMAL_PROTECTION_HAND_LEFT
		if(flags & HAND_RIGHT)
			. += THERMAL_PROTECTION_HAND_RIGHT
	return min(1,.)