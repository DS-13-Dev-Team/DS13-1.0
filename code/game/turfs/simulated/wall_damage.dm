// When destroyed by explosions, properly handle contents.
/turf/simulated/wall/ex_act(severity, var/atom/epicentre)
	if(atom_flags & ATOM_FLAG_INDESTRUCTIBLE)
		return
	switch(severity)
		if(1.0)
			for(var/atom/movable/AM in contents)
				AM.ex_act(severity++, epicentre)

			take_damage(rand(200,400), BRUTE, null, epicentre)
		if(2.0)
			if(prob(50))
				for(var/atom/movable/AM in contents)
					AM.ex_act(severity++, epicentre)

			take_damage(rand(100,200), BRUTE, null, epicentre)

		if(3.0)
			take_damage(rand(25,100), BRUTE, null, epicentre)

/turf/simulated/wall/bullet_act(var/obj/item/projectile/P)
	take_damage(P.get_structure_damage(), user = P.firer, used_weapon = P)
	if (health > 0)
		return FALSE
	return TRUE





/turf/simulated/wall/repair(var/repair_power, var/datum/repair_source, var/mob/user)
	health = clamp(health+repair_power, 0, max_health)
	updatehealth()

/turf/simulated/wall/repair_needed()
	return (health < max_health)


//Called when health drops to zero. Parameters are the params of the final hit that broke us, if this was called from take_damage
/turf/simulated/wall/zero_health(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist)
	dismantle_wall(explode = (used_weapon == DAMAGE_SOURCE_EXPLOSION))
	return TRUE


/turf/simulated/wall/proc/get_damage()
	return max_health - health