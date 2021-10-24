//Helper Procs
//------------------------------
///atom/proc/launch_strike(target = target, damage = 0, used_weapon = src, damage_flags = 0, armor_penetration = 0, damage_type = BRUTE, armor_type = "melee", target_zone = ran_zone(), difficulty = 0)

/atom/proc/launch_strike(var/atom/target, var/damage, var/used_weapon, var/damage_flags, var/armor_penetration, var/damage_type = BRUTE, var/armor_type = "melee", var/target_zone = ran_zone(), var/difficulty = 0, var/allow_dismemberment = TRUE)
	var/datum/strike/strike = new /datum/strike(src, target, damage, used_weapon, damage_flags, armor_penetration, damage_type, armor_type, target_zone, difficulty)
	strike.start()
	return strike



/*
	Launches a strike using an atom as a weapon. All the damage/type/AP vars are drawn from that weapon
*/
/atom/proc/launch_weapon_strike(var/atom/target, var/obj/item/I)
	var/mob/living/carbon/human/H
	if (ishuman(src))
		H = src
		if(world.time < H.last_attack + I.get_delay(H))
			to_chat(H, "<span class='notice'>You can't attack again so soon.</span>")
			return null
		else
			H.last_attack = world.time
			H.set_click_cooldown(I.get_delay(H))
	//user.do_attack_animation(M)
	var/datum/strike/implement/strike = new /datum/strike/implement(src, target, I)
	strike.start()


//When a thrown object hits a mob, it calls this itself
/atom/proc/launch_throw_strike(var/atom/target, var/speed)
	var/datum/strike/thrown/strike = new /datum/strike/thrown(src, target, speed)
	strike.start()