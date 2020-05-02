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


	//world << "[weapon] 	[accuracy]% acc against [src]"

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
	var/shield_check = check_shields(P.damage, P, null, def_zone, "the [P.name]")
	if(shield_check)
		if(shield_check < 0)
			return shield_check
		else
			P.on_hit(src, 100, def_zone)
			return 100

	var/obj/item/organ/external/organ = find_target_organ(def_zone)
	var/armor = getarmor_organ(organ, P.check_armour)
	var/penetrating_damage = ((P.damage + P.armor_penetration) * P.penetration_modifier) - armor

	var/blocked = ..(P, def_zone)

	//Embed or sever artery
	if(P.can_embed() && !(species.species_flags & SPECIES_FLAG_NO_EMBED) && prob((22.5 + max(penetrating_damage, -10))*P.embed_mult) && !(prob(50) && (organ.sever_artery())))
		var/obj/item/SP = new P.shrapnel_type()
		SP.SetName((P.name != "shrapnel")? "[P.name] shrapnel" : "shrapnel")
		SP.desc = "[SP.desc] It looks like it was fired from [P.shot_from]."
		SP.loc = organ
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

/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/atom/damage_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	for(var/obj/item/shield in list(l_hand, r_hand, wear_suit))
		if(!shield) continue
		. = shield.handle_shield(src, damage, damage_source, attacker, def_zone, attack_text)
		if(.) return
	return 0

/mob/living/carbon/human/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)

	for (var/obj/item/grab/G in grabbed_by)
		if(G.resolve_item_attack(user, I, target_zone))
			return null

	if(user == src) // Attacking yourself can't miss
		return target_zone

	var/accuracy = 100 - user.melee_accuracy_mods()
	accuracy -= 10*get_skill_difference(SKILL_COMBAT, user)
	accuracy -= 10*(I.w_class - ITEM_SIZE_NORMAL)
	accuracy += I.melee_accuracy_bonus

	var/hit_zone = get_zone_with_miss_chance(accuracy, target_zone, I )

	if(!hit_zone)
		visible_message("<span class='danger'>\The [user] misses [src] with \the [I]!</span>")
		return null

	if(check_shields(I.force, I, user, target_zone, "the [I.name]"))
		return null

	var/obj/item/organ/external/affecting = find_target_organ(hit_zone)
	if (!affecting || affecting.is_stump())
		to_chat(user, "<span class='danger'>They are missing that limb!</span>")
		return null


	return affecting.organ_tag

/mob/living/carbon/human/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return //should be prevented by attacked_with_item() but for sanity.

	visible_message("<span class='danger'>[src] has been [I.attack_verb.len? pick(I.attack_verb) : "attacked"] in the [affecting.name] with [I.name] by [user]!</span>")

	var/blocked = run_armor_check(hit_zone, "melee", I.armor_penetration, "Your armor has protected your [affecting.name].", "Your armor has softened the blow to your [affecting.name].")
	standard_weapon_hit_effects(I, user, effective_force, blocked, hit_zone)

	return blocked

/mob/living/carbon/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return 0

	// Handle striking to cripple.
	if(user.a_intent == I_DISARM)
		effective_force *= 0.66 //reduced effective force...
		if(!..(I, user, effective_force, blocked, hit_zone))
			return 0

		//set the dislocate mult less than the effective force mult so that
		//dislocating limbs on disarm is a bit easier than breaking limbs on harm
		attack_joint(affecting, I, effective_force, 0.5, blocked) //...but can dislocate joints
	else if(!..())
		return 0

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

	return 1

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
/mob/living/carbon/human/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)
	if(istype(AM,/obj/))
		var/obj/O = AM

		if(in_throw_mode && !get_active_hand() && speed <= THROWFORCE_SPEED_DIVISOR)	//empty active hand and we're in throw mode
			if(!incapacitated())
				if(isturf(O.loc))
					put_in_active_hand(O)
					visible_message("<span class='warning'>[src] catches [O]!</span>")
					throw_mode_off()
					return

		var/dtype = O.damtype
		var/throw_damage = O.throwforce*(speed/THROWFORCE_SPEED_DIVISOR)

		var/zone
		if (istype(O.thrower, /mob/living))
			var/mob/living/L = O.thrower
			zone = check_zone(L.zone_sel.selecting)
		else
			zone = ran_zone(BP_CHEST,75)	//Hits a random part of the body, geared towards the chest

		//check if we hit
		var/miss_chance = species.evasion
		if (O.throw_source)
			var/distance = get_dist(O.throw_source, loc)
			miss_chance += max(5*(distance-2), 0)
		var/accuracy = 100 - miss_chance
		zone = get_zone_with_miss_chance(accuracy, zone, AM)

		if(zone && O.thrower != src)
			var/shield_check = check_shields(throw_damage, O, thrower, zone, "[O]")
			if(shield_check == PROJECTILE_FORCE_MISS)
				zone = null
			else if(shield_check)
				return

		if(!zone)
			visible_message("<span class='notice'>\The [O] misses [src] narrowly!</span>")
			return

		O.throwing = 0		//it hit, so stop moving

		var/obj/item/organ/external/affecting = find_target_organ(zone)

		if (!affecting)
			visible_message("<span class='notice'>\The [O] misses [src] narrowly!</span>")
			return

		var/hit_area = affecting.name
		var/datum/wound/created_wound

		src.visible_message("<span class='warning'>\The [src] has been hit in the [hit_area] by \the [O].</span>")
		var/armor = run_armor_check(affecting, "melee", O.armor_penetration, "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].") //I guess "melee" is the best fit here
		if(armor < 100)
			var/damage_flags = O.damage_flags()
			if(prob(armor))
				damage_flags &= ~(DAM_SHARP|DAM_EDGE)
			created_wound = apply_damage(throw_damage, dtype, zone, armor, damage_flags, O)

		if(ismob(O.thrower))
			var/mob/M = O.thrower
			var/client/assailant = M.client
			if(assailant)
				admin_attack_log(M, src, "Threw \an [O] at their victim.", "Had \an [O] thrown at them", "threw \an [O] at")

		//thrown weapon embedded object code.
		if(dtype == BRUTE && istype(O,/obj/item))
			var/obj/item/I = O
			if (!is_robot_module(I) && !(I.item_flags & ITEM_FLAG_NO_EMBED))
				var/sharp = is_sharp(I)
				var/damage = throw_damage //the effective damage used for embedding purposes, no actual damage is dealt here
				if (armor)
					damage *= blocked_mult(armor)

				//blunt objects should really not be embedding in things unless a huge amount of force is involved
				var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
				var/embed_threshold = sharp? 5*I.w_class : 15*I.w_class

				//Sharp objects will always embed if they do enough damage.
				//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
				if((sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance)))
					affecting.embed(I, supplied_wound = created_wound)

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = speed*mass

		if(O.throw_source && momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = get_dir(O.throw_source, src)

			visible_message("<span class='warning'>\The [src] staggers under the impact!</span>","<span class='warning'>You stagger under the impact!</span>")
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!O || !src) return

			if(O.loc == src && O.sharp) //Projectile is embedded and suitable for pinning.
				var/turf/T = near_wall(dir,2)

				if(T)
					src.loc = T
					visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
					src.anchored = 1
					src.pinned += O

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