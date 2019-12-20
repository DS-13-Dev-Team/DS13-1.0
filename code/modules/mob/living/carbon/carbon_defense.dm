
/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/hit_zone)
	if(!effective_force || blocked >= 100)
		return 0

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	var/damage_flags = I.damage_flags()
	if(prob(blocked)) //armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		damage_flags &= ~(DAM_SHARP|DAM_EDGE)

	var/datum/wound/created_wound = apply_damage(effective_force, I.damtype, hit_zone, blocked, damage_flags, used_weapon=I)

	//Melee weapon embedded object code.
	if(!(I.item_flags & ITEM_FLAG_NO_EMBED) && istype(created_wound) && I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I))
		var/weapon_sharp = (damage_flags & DAM_SHARP)
		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		if (blocked)
			damage *= blocked_mult(blocked)

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weapon_sharp? damage/I.w_class : damage/(I.w_class*3)
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//Sharp objects will always embed if they do enough damage.
		if((weapon_sharp && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
			src.embed(I, hit_zone, supplied_wound = created_wound)

	return 1


/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null)
	if(status_flags & GODMODE)	return 0	//godmode

	shock_damage = apply_shock(shock_damage, def_zone, siemens_coeff)

	if(!shock_damage)
		return 0

	stun_effect_act(agony_amount=shock_damage, def_zone=def_zone)

	playsound(loc, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			"<span class='warning'>[src] was electrocuted[source ? " by the [source]" : ""]!</span>", \
			"<span class='danger'>You feel a powerful shock course through your body!</span>", \
			"<span class='warning'>You hear a heavy electrical crack.</span>" \
		)
	else
		src.visible_message(
			"<span class='warning'>[src] was shocked[source ? " by the [source]" : ""].</span>", \
			"<span class='warning'>You feel a shock course through your body.</span>", \
			"<span class='warning'>You hear a zapping sound.</span>" \
		)

	switch(shock_damage)
		if(16 to 20)
			Stun(2)
		if(21 to 25)
			Weaken(2)
		if(26 to 25)
			Weaken(4)
		if(31 to INFINITY)
			Weaken(7) //This should work for now, more is really silly and makes you lay there forever

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage

/mob/living/carbon/proc/apply_shock(var/shock_damage, var/def_zone, var/siemens_coeff = 1.0)
	shock_damage *= siemens_coeff
	if(shock_damage < 0.5)
		return 0
	if(shock_damage < 1)
		shock_damage = 1
	apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")
	return(shock_damage)