
/mob/living/carbon/human/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/damage_flags = 0, var/obj/used_weapon = null, var/obj/item/organ/external/given_organ = null)
	SET_ARGS(species.handle_apply_damage(arglist(list(src)+args)))
	var/obj/item/organ/external/organ = given_organ
	if(!organ)
		if(isorgan(def_zone))
			organ = def_zone
		else
			if(!def_zone)	def_zone = ran_zone(def_zone)
			organ = find_target_organ(check_zone(def_zone))

	//Handle other types of damage
	if(!(damagetype in list(BRUTE, BURN, PAIN, CLONE)))
		..(damage, damagetype, def_zone, blocked)
		return 1

	//If the damage is one of the above types, it will be multiplied in the parent proc.
	//If not, we multiply it here
	damage *= incoming_damage_mult

	handle_suit_punctures(damagetype, damage, def_zone)

	if(blocked >= 100)	return 0

	if(!organ)	return 0

	if(blocked)
		damage *= blocked_mult(blocked)

	if(damage > 5 && prob(damage*4))
		make_reagent(round(damage/10), /datum/reagent/adrenaline)
	damageoverlaytemp = 20
	switch(damagetype)
		if(BRUTE)
			damage = damage*species.brute_mod
			organ.take_external_damage(damage, 0, damage_flags, used_weapon)	//This calls update health
		if(BURN)
			damage = damage*species.burn_mod
			organ.take_external_damage(0, damage, damage_flags, used_weapon)	//This calls update health
		if(PAIN)
			organ.add_pain(damage)	//This calls update health
		if(CLONE)
			organ.add_genetic_damage(damage)	//This calls update health


	// Will set our damageoverlay icon to the next level, which will then be set back to the normal level the next mob.Life().
	//Updatehealth is called by all the above procs, we don't call it here
	BITSET(hud_updateflag, HEALTH_HUD)
	return damage

// Find out in how much pain the mob is at the moment.
/mob/living/carbon/human/proc/get_shock()

	if (!can_feel_pain())
		return 0

	var/traumatic_shock = getHalLoss()                 // Pain.
	traumatic_shock -= chem_effects[CE_PAINKILLER] // TODO: check what is actually stored here.

	if(stat == UNCONSCIOUS)
		traumatic_shock *= 0.6
	return max(0,traumatic_shock)




//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()

	if(status_flags & GODMODE)
		health = max_health
		set_stat(CONSCIOUS)
		return

	health = max_health - getBrainLoss()

	GLOB.updatehealth_event.raise_event(src)

	handle_death_check()	//This is where people die

	//TODO: fix husking
	if(((max_health - getFireLoss()) < config.health_threshold_dead) && stat == DEAD)
		ChangeToHusk()
	return

/mob/living/carbon/human/adjustBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			sponge.take_internal_damage(amount)	//This calls update health


/mob/living/carbon/human/setBrainLoss(var/amount)
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			sponge.damage = min(max(amount, 0),sponge.species.total_health)
			updatehealth() //This is needed since damage procs aren't called


/mob/living/carbon/human/getBrainLoss()
	if(status_flags & GODMODE)	return 0	//godmode
	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			if(sponge.status & ORGAN_DEAD)
				return sponge.species.total_health
			else
				return sponge.damage
		else
			return species.total_health
	return 0

//Straight pain values, not affected by painkillers etc
/mob/living/carbon/human/getHalLoss()
	var/amount = 0
	for(var/obj/item/organ/external/E in organs)
		amount += E.get_pain()
	return amount

/mob/living/carbon/human/setHalLoss(var/amount)
	adjustHalLoss(getHalLoss()-amount)

/mob/living/carbon/human/adjustHalLoss(var/amount)
	var/heal = (amount < 0)
	amount = abs(amount)
	var/list/pick_organs = organs.Copy()
	while(amount > 0 && pick_organs.len)
		var/obj/item/organ/external/E = pick(pick_organs)
		pick_organs -= E
		if(!istype(E))
			continue

		if(heal)
			amount -= E.remove_pain(amount)
		else
			amount -= E.add_pain(amount)
	BITSET(hud_updateflag, HEALTH_HUD)

//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in organs)
		if(BP_IS_ROBOTIC(O) && !O.vital)
			continue //robot limbs don't count towards shock and crit
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in organs)
		if(BP_IS_ROBOTIC(O) && !O.vital)
			continue //robot limbs don't count towards shock and crit
		amount += O.burn_dam
	return amount

/mob/living/carbon/human/adjustBruteLoss(var/amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/adjustFireLoss(var/amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)
	BITSET(hud_updateflag, HEALTH_HUD)



/mob/living/carbon/human/getCloneLoss()
	var/amount = 0
	for(var/obj/item/organ/external/E in organs)
		amount += E.get_genetic_damage()
	return amount

/mob/living/carbon/human/setCloneLoss(var/amount)
	adjustCloneLoss(getCloneLoss()-amount)

/mob/living/carbon/human/adjustCloneLoss(var/amount)
	var/heal = amount < 0
	amount = abs(amount)

	var/list/pick_organs = organs.Copy()
	while(amount > 0 && pick_organs.len)
		var/obj/item/organ/external/E = pick(pick_organs)
		pick_organs -= E
		if(heal)
			amount -= E.remove_genetic_damage(amount)//This calls update health
		else
			amount -= E.add_genetic_damage(amount)	//This calls update health
	BITSET(hud_updateflag, HEALTH_HUD)

// Defined here solely to take species flags into account without having to recast at mob/living level.
/mob/living/carbon/human/getOxyLoss()
	if(!need_breathe())
		return 0
	else
		var/obj/item/organ/internal/lungs/breathe_organ = internal_organs_by_name[species.breathing_organ]
		if(!breathe_organ)
			return max_health/2
		return breathe_organ.get_oxygen_deprivation()

/mob/living/carbon/human/setOxyLoss(var/amount)
	if(!need_breathe())
		return 0
	else
		adjustOxyLoss(getOxyLoss()-amount)

/mob/living/carbon/human/adjustOxyLoss(var/amount)
	if(!need_breathe())
		return
	var/heal = amount < 0
	amount = abs(amount*species.oxy_mod)
	var/obj/item/organ/internal/lungs/breathe_organ = internal_organs_by_name[species.breathing_organ]
	if(breathe_organ)
		if(heal)
			breathe_organ.remove_oxygen_deprivation(amount)
		else
			breathe_organ.add_oxygen_deprivation(amount)
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/getToxLoss()
	if((species.species_flags & SPECIES_FLAG_NO_POISON) || isSynthetic())
		return 0
	var/amount = 0
	for(var/obj/item/organ/internal/I in internal_organs)
		amount += I.getToxLoss()
	return amount

/mob/living/carbon/human/setToxLoss(var/amount)
	if(!(species.species_flags & SPECIES_FLAG_NO_POISON) && !isSynthetic())
		adjustToxLoss(getToxLoss()-amount)

// TODO: better internal organ damage procs.
/mob/living/carbon/human/adjustToxLoss(var/amount)
	if((species.species_flags & SPECIES_FLAG_NO_POISON) || isSynthetic())
		return

	var/heal = amount < 0
	amount = abs(amount)

	if(!heal && (CE_ANTITOX in chem_effects))
		amount *= 1 - (chem_effects[CE_ANTITOX] * 0.25)

	var/list/pick_organs = shuffle(internal_organs.Copy())

	// Prioritize damaging our filtration organs first.
	var/obj/item/organ/internal/kidneys/kidneys = internal_organs_by_name[BP_KIDNEYS]
	if(kidneys)
		pick_organs -= kidneys
		pick_organs.Insert(1, kidneys)
	var/obj/item/organ/internal/liver/liver = internal_organs_by_name[BP_LIVER]
	if(liver)
		pick_organs -= liver
		pick_organs.Insert(1, liver)

	// Move the brain to the very end since damage to it is vastly more dangerous
	// (and isn't technically counted as toxloss) than general organ damage.
	var/obj/item/organ/internal/brain/brain = internal_organs_by_name[BP_BRAIN]
	if(brain)
		pick_organs -= brain
		pick_organs += brain

	for(var/internal in pick_organs)
		var/obj/item/organ/internal/I = internal
		if(amount <= 0)
			break
		if(heal)
			if(I.damage < amount)
				amount -= I.damage
				I.damage = 0
			else
				I.damage -= amount
				amount = 0
		else
			var/cap_dam = I.max_damage - I.damage
			if(amount >= cap_dam)
				I.take_internal_damage(cap_dam, silent=TRUE)
				amount -= cap_dam
			else
				I.take_internal_damage(amount, silent=TRUE)
				amount = 0

	if (heal)
		//If this is causing damage, take_internal_damage will call update health
		updatehealth()

/mob/living/carbon/human/proc/can_autoheal(var/dam_type)
	if(!species || !dam_type) return FALSE

	if(dam_type == BRUTE)
		return(getBruteLoss() < species.total_health / 2)
	else if(dam_type == BURN)
		return(getFireLoss() < species.total_health / 2)
	return FALSE

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(var/brute, var/burn)
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in organs)
		if((brute && O.brute_dam) || (burn && O.burn_dam))
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs()
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in organs)
		if(O.is_damageable())
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(var/brute, var/burn)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute,burn)
	if(!parts.len)	return
	var/obj/item/organ/external/picked = pick(parts)
	if(picked.heal_damage(brute,burn))//This updates health
		BITSET(hud_updateflag, HEALTH_HUD)



//TODO reorganize damage procs so that there is a clean API for damaging living mobs

/*
In most cases it makes more sense to use apply_damage() instead! And make sure to check armour if applicable.
*/
//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(var/brute, var/burn, var/sharp = 0, var/edge = 0)
	var/list/obj/item/organ/external/parts = get_damageable_organs()
	if(!parts.len)
		return

	var/obj/item/organ/external/picked = pick(parts)
	var/damage_flags = (sharp? DAM_SHARP : 0)|(edge? DAM_EDGE : 0)

	if(picked.take_external_damage(brute, burn, damage_flags))
		BITSET(hud_updateflag, HEALTH_HUD)



//Heal MANY external organs, in random order
//If no damage type specified, heals all forms of external damage
/mob/living/carbon/human/heal_overall_damage(var/heal_amount, var/damage_type)
	if (heal_amount <= 0 || !isnum(heal_amount))
		return

	var/list/obj/item/organ/external/parts
	if (damage_type == BRUTE)
		parts = get_damaged_organs(heal_amount,0)
	else if (damage_type == BURN)
		parts = get_damaged_organs(0,heal_amount)
	else
		parts = get_damaged_organs(heal_amount,heal_amount)

	while(parts.len && heal_amount > 0)

		var/obj/item/organ/external/picked = pick(parts)
		world << "About to heal organ [picked], heal amount remaining [heal_amount]"


		var/brute_heal = 0
		if (damage_type != BURN)
			brute_heal = min(picked.brute_dam, heal_amount)
			heal_amount -= brute_heal
		var/burn_heal = 0
		if (damage_type != BRUTE)
			burn_heal = min(picked.burn_dam, heal_amount)
			heal_amount -= burn_heal


		picked.heal_damage(brute_heal,burn_heal)

		parts -= picked
	BITSET(hud_updateflag, HEALTH_HUD)

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(var/brute, var/burn, var/sharp = 0, var/edge = 0, var/used_weapon = null, var/armortype ="melee" )
	if(status_flags & GODMODE)	return	//godmode
	var/list/obj/item/organ/external/parts = get_damageable_organs()
	if(!parts.len) return

	var/dam_flags = (sharp? DAM_SHARP : 0)|(edge? DAM_EDGE : 0)
	var/brute_avg = brute / parts.len
	var/burn_avg = burn / parts.len
	for(var/obj/item/organ/external/E in parts)
		var/block = 0
		if (armortype)
			block = getarmor_organ(E, armortype)
		if(brute_avg)
			apply_damage(damage = brute_avg, damagetype = BRUTE, blocked = block, damage_flags = dam_flags, used_weapon = used_weapon, given_organ = E)
		if(burn_avg)
			apply_damage(damage = burn_avg, damagetype = BURN, blocked = block, damage_flags = dam_flags, used_weapon = used_weapon, given_organ = E)
	//Apply damage will call update health through limb damage
	BITSET(hud_updateflag, HEALTH_HUD)


////////////////////////////////////////////

/*
This function restores the subjects blood to max.
*/
/mob/living/carbon/human/proc/restore_blood()
	if(!should_have_organ(BP_HEART))
		return
	if(vessel.total_volume < species.blood_volume)
		vessel.add_reagent(/datum/reagent/blood, species.blood_volume - vessel.total_volume)

/*
This function restores all organs.
*/
/mob/living/carbon/human/restore_all_organs(var/ignore_prosthetic_prefs)
	for(var/bodypart in BP_BY_DEPTH)
		var/obj/item/organ/external/current_organ = organs_by_name[bodypart]
		if(istype(current_organ))
			current_organ.rejuvenate(ignore_prosthetic_prefs)

/mob/living/carbon/human/proc/HealDamage(zone, brute, burn)
	var/obj/item/organ/external/E = get_organ(zone)
	if(istype(E, /obj/item/organ/external))
		if (E.heal_damage(brute, burn))
			BITSET(hud_updateflag, HEALTH_HUD)
	else
		return 0
	return


/mob/proc/get_organ(var/zone)
	return null

/mob/living/carbon/human/get_organ(var/zone)
	return organs_by_name[check_zone(zone)]


/mob/living/carbon/human/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(effecttype == IRRADIATE && (effect * blocked_mult(blocked) <= RAD_LEVEL_LOW))
		return 0
	return ..()


/mob/living/carbon/human/ex_act(severity, var/atom/epicentre)
	if(!blinded)
		flash_eyes()

	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss = 400
			f_loss = 100
			if (!prob(getarmor(null, "bomb")))
				gib()
				return
			else
				var/atom/target = get_edge_target_turf(src, get_dir(src, get_step_away(src, epicentre)))
				throw_at(target, 200, 4)
			//return
//				var/atom/target = get_edge_target_turf(user, get_dir(src, get_step_away(user, src)))
				//user.throw_at(target, 200, 4)

		if (2.0)
			b_loss = 60
			f_loss = 60

			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 30
				ear_deaf += 120
			if (prob(70))
				Paralyse(10)

		if(3.0)
			b_loss = 30
			if (!istype(l_ear, /obj/item/clothing/ears/earmuffs) && !istype(r_ear, /obj/item/clothing/ears/earmuffs))
				ear_damage += 15
				ear_deaf += 60
			if (prob(50))
				Paralyse(10)

	// factor in armour
	var/protection = blocked_mult(getarmor(null, "bomb"))
	b_loss *= protection
	f_loss *= protection

	// focus most of the blast on one organ
	var/obj/item/organ/external/take_blast = pick(organs)
	take_blast.take_external_damage(b_loss * 0.7, f_loss * 0.7, used_weapon = "Explosive blast")

	// distribute the remaining 30% on all limbs equally (including the one already dealt damage)
	b_loss *= 0.3
	f_loss *= 0.3

	for(var/obj/item/organ/external/temp in organs)
		var/loss_val
		if(temp.organ_tag  == BP_HEAD)
			loss_val = 0.2
		else if(temp.organ_tag == BP_CHEST)
			loss_val = 0.4
		else
			loss_val = 0.05
		temp.take_external_damage(b_loss * loss_val, f_loss * loss_val, used_weapon = epicentre)


/*
	Used by healthbars. This proc attempts to estimate how wounded a human is.

	It takes several measurements and uses the lowest one
*/
/mob/living/carbon/human/healthpercent()
	var/list/measures = list()

	//This measures braindamage, the final and most important measure
	var/working_health = clamp(health, 0, max_health)
	measures += ((working_health / max_health) * 100)


	//Direct damage + Pain
	var/remaining_physical_health = max_health - getFireLoss() - getBruteLoss() - getHalLoss()
	measures += ((remaining_physical_health / max_health) * 100)

	var/lowest = 100
	for (var/measure in measures)
		if (measure < lowest)
			lowest = measure

	return lowest