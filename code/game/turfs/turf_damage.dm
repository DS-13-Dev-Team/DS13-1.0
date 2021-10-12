// Called when turf is hit by a thrown object
/turf/hitby(atom/movable/AM as mob|obj, var/speed)
	if(src.density)
		spawn(2)
			step(AM, turn(AM.last_move, 180))
		var/force
		if(isliving(AM))
			force = AM.mass
			var/mob/living/M = AM
			M.turf_collision(src, speed)

		else if (isobj(AM))


			var/obj/O = AM
			force = O.throwforce
		var/tforce = force * (speed/THROWFORCE_SPEED_DIVISOR)

		take_damage(tforce, BRUTE, AM.thrower, AM)

//Called when a structure takes damage
/turf/proc/take_damage(var/amount, var/damtype = BRUTE, var/user, var/used_weapon, var/bypass_resist = FALSE)
	if ((atom_flags & ATOM_FLAG_INDESTRUCTIBLE))
		return
	if (!bypass_resist)
		var/AP = 0
		if (isitem(used_weapon))
			var/obj/item/I = used_weapon
			AP = I.armor_penetration
		amount -= max(0, resistance - AP)

	if (amount <= 0)
		return 0

	health -= amount

	updatehealth()
	return amount

/turf/proc/handle_strike(var/datum/strike/S)
	if (hitsound)
		playsound(src, hitsound, VOLUME_MID, TRUE)

	if (S.final_damage > 0)
		return take_damage(amount = S.final_damage, damtype = S.damage_type, user = S.user, used_weapon = S.used_weapon)


/turf/proc/updatehealth()
	if (health <= 0)
		health = 0
		return zero_health()

	update_icon()
	return TRUE	//True means not dead yet


/turf/proc/zero_health()