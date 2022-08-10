
/*
	apply_damage() args
	damage - How much damage to take
	damage_type - What type of damage to take, brute, burn
	def_zone - Where to take the damage if its brute or burn

	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/damage_flags = 0, var/used_weapon = null, var/allow_dismemberment = TRUE)
	if(status_flags & GODMODE)
		return
	if(!damage || (blocked >= 100))	return 0

	//Multiply the incoming damage
	damage *= incoming_damage_mult

	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage * blocked_mult(blocked))	//This calls organ damage procs which call updatehealth
		if(BURN)
			if(COLD_RESISTANCE in mutations)	damage = 0
			adjustFireLoss(damage * blocked_mult(blocked))	//This calls organ damage procs which call updatehealth
		if(TOX)
			adjustToxLoss(damage * blocked_mult(blocked))
		if(OXY)
			adjustOxyLoss(damage * blocked_mult(blocked))	//This calls lungs.add oxygen deprivation, which calls updatehealth
		if(CLONE)
			adjustCloneLoss(damage * blocked_mult(blocked))	//Calls updatehealth through organ procs
		if(PAIN)
			adjustHalLoss(damage * blocked_mult(blocked))
		if(ELECTROCUTE)
			electrocute_act(damage, used_weapon, 1.0, def_zone)

	updatehealth()
	return damage


/mob/living/proc/apply_damages(var/brute = 0, var/burn = 0, var/tox = 0, var/oxy = 0, var/clone = 0, var/halloss = 0, var/def_zone = null, var/blocked = 0, var/damage_flags = 0)
	if(blocked >= 100)	return 0
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, PAIN, def_zone, blocked)
	return 1


/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))	return 0

	switch(effecttype)
		if(STUN)
			Stun(effect * blocked_mult(blocked))
		if(WEAKEN)
			Weaken(effect * blocked_mult(blocked))
		if(PARALYZE)
			Paralyse(effect * blocked_mult(blocked))
		if(PAIN)
			adjustHalLoss(effect * blocked_mult(blocked))
		if(IRRADIATE)
			radiation += effect * blocked_mult(blocked)
		if(STUTTER)
			if(status_flags & CANSTUN) // stun is usually associated with stutter - TODO CANSTUTTER flag?
				stuttering = max(stuttering, effect * blocked_mult(blocked))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry, effect * blocked_mult(blocked))
		if(DROWSY)
			drowsyness = max(drowsyness, effect * blocked_mult(blocked))
	updatehealth()
	return 1


/mob/living/proc/apply_effects(var/stun = 0, var/weaken = 0, var/paralyze = 0, var/irradiate = 0, var/stutter = 0, var/eyeblur = 0, var/drowsy = 0, var/agony = 0, var/blocked = 0)
	if(blocked >= 2)	return 0
	if(stun)		apply_effect(stun,      STUN, blocked)
	if(weaken)		apply_effect(weaken,    WEAKEN, blocked)
	if(paralyze)	apply_effect(paralyze,  PARALYZE, blocked)
	if(irradiate)	apply_effect(irradiate, IRRADIATE, blocked)
	if(stutter)		apply_effect(stutter,   STUTTER, blocked)
	if(eyeblur)		apply_effect(eyeblur,   EYE_BLUR, blocked)
	if(drowsy)		apply_effect(drowsy,    DROWSY, blocked)
	if(agony)		apply_effect(agony,     PAIN, blocked)
	return 1


// heal ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/heal_organ_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()



// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute, var/burn, var/emp=0)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, var/burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, var/burn, var/used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

//Heals a total number of points of all types of damage. Not divided equally, but done in order
//Returns the unused number of points, if any
/mob/living/proc/heal_quantified_damage(var/total, var/brute = TRUE, var/fire = TRUE, var/tox = FALSE, var/lasting = FALSE)
	if (total <= 0)
		return 0

	if (brute)
		var/heal_amount = min(total, getBruteLoss())
		adjustBruteLoss(-heal_amount)
		total -= heal_amount

	if (total <= 0)
		return 0

	if (fire)
		var/heal_amount = min(total, getFireLoss())
		adjustFireLoss(-heal_amount)
		total -= heal_amount

	if (total <= 0)
		return 0

	if (tox)
		var/heal_amount = min(total, getToxLoss())
		adjustToxLoss(-heal_amount)
		total -= heal_amount

	if (total <= 0)
		return 0

	if (lasting)
		var/heal_amount = min(total, getLastingDamage())
		adjustLastingDamage(-heal_amount)
		total -= heal_amount

	return total

/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = max_health - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - getHalLoss() - getLastingDamage()


	if (health <= 0)
		zero_health()
	SEND_SIGNAL(src, COMSIG_MOB_HEALTH_CHANGED)

/mob/living/proc/zero_health()
	handle_death_check()

/mob/living/proc/healthpercent()
	var/working_health = clamp(health, 0, max_health)
	return ((working_health / max_health) * 100)


/mob/living/proc/getAdjustedMaxHealth()
	return (max_health - getLastingDamage())

/mob/living/proc/getBruteLoss()
	return getAdjustedMaxHealth() - health

/mob/living/proc/adjustBruteLoss(var/amount)
	if (status_flags & GODMODE)
		return
	health = Clamp(health - amount, 0, getAdjustedMaxHealth())

/mob/living/proc/getOxyLoss()
	return 0

/mob/living/proc/adjustOxyLoss(var/amount)
	return

/mob/living/proc/setOxyLoss(var/amount)
	return

/mob/living/proc/getToxLoss()
	return 0

/mob/living/proc/adjustToxLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setToxLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getFireLoss()
	return

/mob/living/proc/adjustLastingDamage(var/amount)
	lasting_damage += amount
	health = min(health, getAdjustedMaxHealth())
	updatehealth()

/mob/living/proc/getLastingDamage()
	return lasting_damage

/mob/living/proc/adjustFireLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setFireLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getHalLoss()
	return 0

/mob/living/proc/adjustHalLoss(var/amount)
	adjustBruteLoss(amount * 0.5)

/mob/living/proc/setHalLoss(var/amount)
	adjustBruteLoss((amount * 0.5)-getBruteLoss())

/mob/living/proc/getBrainLoss()
	return 0

/mob/living/proc/adjustBrainLoss(var/amount)
	return

/mob/living/proc/setBrainLoss(var/amount)
	return

/mob/living/proc/getCloneLoss()
	return 0

/mob/living/proc/setCloneLoss(var/amount)
	return

/mob/living/proc/adjustCloneLoss(var/amount)
	return