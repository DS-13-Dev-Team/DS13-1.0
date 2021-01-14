
/*
	apply_damage() args
	damage - How much damage to take
	damage_type - What type of damage to take, brute, burn
	def_zone - Where to take the damage if its brute or burn

	Returns
	standard 0 if fail
*/
/mob/living/proc/apply_damage(var/damage = 0,var/damagetype = BRUTE, def_zone = null, blocked = 0, damage_flags = 0, used_weapon = null)
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


/mob/living/proc/apply_damages(var/brute = 0, burn = 0, tox = 0, oxy = 0, clone = 0, halloss = 0, def_zone = null, blocked = 0, damage_flags = 0)
	if(blocked >= 100)	return 0
	if(brute)	apply_damage(brute, BRUTE, def_zone, blocked)
	if(burn)	apply_damage(burn, BURN, def_zone, blocked)
	if(tox)		apply_damage(tox, TOX, def_zone, blocked)
	if(oxy)		apply_damage(oxy, OXY, def_zone, blocked)
	if(clone)	apply_damage(clone, CLONE, def_zone, blocked)
	if(halloss) apply_damage(halloss, PAIN, def_zone, blocked)
	return 1


/mob/living/proc/apply_effect(var/effect = 0,var/effecttype = STUN, blocked = 0)
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


/mob/living/proc/apply_effects(var/stun = 0, weaken = 0, paralyze = 0, irradiate = 0, stutter = 0, eyeblur = 0, drowsy = 0, agony = 0, blocked = 0)
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
/mob/living/proc/heal_organ_damage(var/brute, burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage ONE external organ, organ gets randomly selected from damaged ones.
/mob/living/proc/take_organ_damage(var/brute, burn, emp=0)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()

// heal MANY external organs, in random order
/mob/living/proc/heal_overall_damage(var/brute, burn)
	adjustBruteLoss(-brute)
	adjustFireLoss(-burn)
	src.updatehealth()

// damage MANY external organs, in random order
/mob/living/proc/take_overall_damage(var/brute, burn, used_weapon = null)
	if(status_flags & GODMODE)	return 0	//godmode
	adjustBruteLoss(brute)
	adjustFireLoss(burn)
	src.updatehealth()



/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		set_stat(CONSCIOUS)
	else
		health = max_health - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss() - getHalLoss() - getLastingDamage()


	if (health <= 0)
		zero_health()
	GLOB.updatehealth_event.raise_event(src)

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