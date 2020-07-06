/*
	TODO LIST:
		Throw impacts, human_defense.dm/hitby
		Possible: Syringe attacks

*/

/*
	A strike is a temporary datum created when one atom (usually a human) attempts to physically harm another atom at close range, typically with an arm, leg,
	or appendage. It is also used for swinging melee weapons

	In this initial phase, strikes are only supported where one human attacks another human, this will be expanded in future
*/
#define CACHE_USER	if (isliving(target))\
		{L = target;}\
		if (ishuman(target))\
			{H = target;}\
	if (isliving(user))\
		{luser = user;}\
		if (ishuman(user))\
			{huser = user;\
			damage *= huser.damage_multiplier}
//Helper Procs
//------------------------------
/atom/proc/launch_strike(var/atom/target, var/damage, var/used_weapon, var/damage_flags, var/armor_penetration, var/damage_type = BRUTE, var/armor_type = "melee", var/target_zone)
	var/datum/strike/strike = new /datum/strike(src, target, damage, used_weapon, damage_flags, armor_penetration, damage_type, armor_type, target_zone)
	strike.start()
	return strike

/atom/proc/launch_unarmed_strike(var/atom/target, var/datum/unarmed_attack/method)
	if (!method)
		if (ishuman(src))
			var/mob/living/carbon/human/H = src
			var/hit_zone = get_zone_sel(H)
			method = H.get_unarmed_attack(src, hit_zone)
		if(!method)
			return 0

	var/mob/living/carbon/human/H
	if (ishuman(src))
		H = src
		if(world.time < H.last_attack + method.get_delay(H))
			to_chat(H, "<span class='notice'>You can't attack again so soon.</span>")
			return null
		else
			H.last_attack = world.time

		H.set_click_cooldown(method.get_delay(H))

	var/datum/strike/unarmed/strike = new /datum/strike/unarmed(src, target, method)
	strike.start()

	//Here seems a good enough place for attack audio
	//Its not impact sounds, but screams of rage while swinging
	if (H && H.check_audio_cooldown(SOUND_ATTACK))
		H.play_species_audio(H, SOUND_ATTACK, VOLUME_MID, 1)
		H.set_audio_cooldown(SOUND_ATTACK, 3 SECONDS)

	return strike



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


//Main Code
//------------------
/datum/strike
	var/name = "strike"	//Name should be a lowercase present-tense verb, it will be shown to users
	var/atom/user
	var/atom/target

	//Pre-cast types
	var/mob/living/L
	var/mob/living/luser
	var/mob/living/carbon/human/H
	var/mob/living/carbon/human/huser

	var/damage = 0

	//Only set after we have impacted, this contains the actual final quantity of health we removed from the target
	var/damage_done = null

	var/atom/used_weapon

	var/damage_flags


	var/armor_penetration = 0

	//Used to save the result of bay armor checks
	var/blocked = 0

	//Damage blocked by defensive limbs intercepting the attack
	var/blocked_damage = 0

	//This is subtracted from the blocking chance
	var/difficulty = 0

	//If the victim uses a limb or object to block the hit, it will be set here
	var/atom/blocker = null

	var/original_target_zone
	var/target_zone
	var/obj/item/organ/external/affecting

	//Is this a melee strike?
	//Set false for projectiles and thrown objects
	//True for unarmed attacks and melee swings
	var/melee = TRUE

	//What type of armor is used to block this attack?
	var/armor_type = "melee"

	//Base chance to hit, only used for ranged attacks. Melee attacks never miss
	var/accuracy = 100

	var/missed = FALSE	//Set true if this attack did not/will not hit its target
	var/turf/origin	//Where is this strike hitting from? This is generally adjacent to the target.
	//In the case of projectiles or thrown objects, the tile the projectile was in before it attempted to enter where the target is now.
	//It is NOT the turf where the firer/thrower is

	var/damage_type = BRUTE

/datum/strike/New(var/atom/user, var/atom/target)
	cache_data(arglist(args))
	cache_origin()
	.=..()

/datum/strike/Destroy()
	user = null
	target = null
	L = null
	luser = null
	H = null
	huser = null
	used_weapon = null
	blocker = null
	affecting = null
	.=..()


//Override this in subtypes and DO NOT CALL PARENT
//Copypaste the code instead
/datum/strike/proc/cache_data(var/atom/user, var/atom/target, var/damage, var/used_weapon, var/damage_flags, var/armor_penetration, var/damage_type = BRUTE, var/armor_type = "melee", var/target_zone)
	src.user = user
	src.target = target
	src.damage = damage
	src.target_zone = target_zone
	CACHE_USER

	src.used_weapon = used_weapon
	src.damage_flags = damage_flags
	src.damage_type = damage_type
	src.armor_type = armor_type
	src.armor_penetration = armor_penetration

//Special proc for figuring out where the attack is coming from
/datum/strike/proc/cache_origin()

	var/atom/movable/origin_atom = used_weapon
	if (!origin_atom)
		origin_atom = user

	//If the origin atom is a turf, thats not supported

	var/origin_atom_turf = get_turf(origin_atom)
	var/target_turf = get_turf(target)

	//In most cases, the location of the user/weapon is enough
	if (target_turf != origin_atom_turf)
		origin = origin_atom_turf
		return

	//In an uncommon special case, the weapon and target may be in the same location. In this case, the origin is where the origin atom came from
	origin = get_step(origin_atom_turf, GLOB.reverse_dir[origin_atom.last_move])







/datum/strike/proc/start()
	if (ismob(target))
		setup_difficulty()
		handle_target_zone()
	handle_accuracy()
	if (!missed)
		if (ismob(target))
			handle_defense()
			handle_armor()
		impact_target()

	else
		handle_miss()
	show_result()
	end()










/datum/strike/proc/end()
	qdel(src)

//Returns the damage this will probably deal, accounting for blocks, but before resistance
//If we have already impacted, it returns the damage we actually dealt
/datum/strike/proc/get_final_damage()
	if (!isnull(damage_done))
		return damage_done

	return max(damage - blocked_damage, 0)

/datum/strike/proc/get_impact_sound()
	if (blocker)
		if (istype(blocker, /obj/item))
			var/obj/item/I = blocker
			return I.blocksound


/datum/strike/proc/calculate_accuracy()
	return accuracy
//Variants
//----------------------
//This variant specifically deals with unarmed attacks from one human to another
/datum/strike/unarmed
	var/datum/unarmed_attack/attack

/datum/strike/unarmed/Destroy()
	attack = null
	.=..()


/datum/strike/unarmed/cache_data(var/atom/user, var/atom/target, var/datum/unarmed_attack/attack)
	src.user = user
	src.target = target
	src.attack = attack
	name = pick(attack.attack_noun)

	src.damage = attack.get_unarmed_damage(user)
	if (attack.rand_damage)
		damage += rand_between(attack.rand_damage*-1, attack.rand_damage)

	CACHE_USER

	armor_penetration = attack.armor_penetration
	src.used_weapon = user
	damage_flags = attack.damage_flags()



	if (istype(target, /obj))
		src.damage *= attack.structure_damage_mult


/datum/strike/unarmed/impact_mob()

	.=..()
	// Apply additional unarmed effects, but only if we dealt damage. Completely blocked hits don't get any effects
	if (.)
		attack.apply_effects(src)

/datum/strike/unarmed/get_impact_sound()
	.=..()
	if (!.)
		return attack.attack_sound

/datum/strike/unarmed/show_result()
	var/sound = get_impact_sound()
	if (blocker)
		if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
		target.shake_animation(3)
		user.shake_animation(3)
	else if (!damage_done)
		if (sound)	playsound(target, sound, VOLUME_QUIET, 1)
	else
		if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
		target.shake_animation(8)
	attack.show_attack(src)



//Implement
//--------
//This variant specifically deals with humans swinging objects. Tools, knives, swords, etc
/datum/strike/implement
	var/obj/item/used_item

/datum/strike/implement/Destroy()
	used_item = null
	.=..()

/datum/strike/implement/cache_data(var/atom/user, var/atom/target, var/obj/item/used_weapon)
	src.user = user
	src.target = target
	damage = used_weapon.force
	CACHE_USER
	src.used_weapon = used_weapon
	used_item = used_weapon
	damage_flags = used_weapon.damage_flags()
	armor_penetration = used_item.armor_penetration

/datum/strike/implement/impact_mob()
	.=..()
	if (damage_done)
		used_item.apply_hit_effect(target, user, target_zone)
		L.hit_with_weapon(src)

/datum/strike/implement/show_result()
	var/sound = get_impact_sound()
	if (L)
		if (blocker)
			if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
			target.shake_animation(3)
			user.shake_animation(3)
			var/obj/item/organ/external/original = H.get_organ(original_target_zone)
			user.visible_message("<span class='minorwarning'>[user] tried to [pick(used_item.attack_noun)] [target] in the [original.name] but was blocked by [H.get_pronoun(POSESSIVE_ADJECTIVE)] [blocker.name]!</span>")


		else
			if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
			target.shake_animation(8)
			user.visible_message("<span class='warning'>[user] [pick(used_item.attack_verb)] [target] in the [affecting.name]!</span>")
	else
		user.visible_message("<span class='warning'>[user] [pick(used_item.attack_verb)] [target] in the [affecting.name][damage_done?"":", to no effect"]!</span>")


/datum/strike/implement/setup_difficulty()
	difficulty += used_item.melee_accuracy_bonus


/datum/strike/implement/get_impact_sound()
	.=..()
	if (!.)
		return used_item.hitsound


//Thrown implement
//-----------------
/datum/strike/thrown
	melee = FALSE
	armor_type = "bullet"
	target_zone = RANDOM

	var/speed = 1	//How fast was the thrown object moving, in tiles per second

	//This is not guaranteed to be populated, any movable atom can be thrown
	var/obj/item/used_item


/datum/strike/thrown/get_impact_sound()
	.=..()
	if (!.)
		if (used_item)
			return used_item.hitsound

/datum/strike/thrown/calculate_accuracy()
	var/atom/movable/AM = used_weapon
	accuracy = 100

	if (AM.throw_source)
		var/distance = get_dist(AM.throw_source, get_turf(target))
		accuracy -= min(max(5*(distance-2), 0), 60)	//Distance makes things less accurate, but only to a point

/datum/strike/thrown/cache_data(var/atom/movable/self, var/atom/target, var/speed)
	src.user = self.thrower
	src.target = target

	if (isliving(target))
		L = target
		if (ishuman(target))
			H = target

	src.used_weapon = self	//The weapon is itself
	if (istype(user, /mob/living))
		target_zone = get_zone_sel(user)

	//If the thing isnt an item, all these values will be left at their quite-suitable defaults
	if (istype(self, /obj/item))
		used_item = self
		damage_type = used_item.damtype
		damage_flags = used_item.damage_flags()
		armor_penetration = used_item.armor_penetration
	src.speed = speed
	damage = used_item.throwforce*(soft_cap(speed, 1, 1, 0.92))//Damage depends on how fast it was going, with some falloff



/datum/strike/thrown/impact_target()
	//it hit, so stop moving
	var/atom/movable/AM = used_weapon
	AM.throwing = FALSE
	.=..()

	//If our target is a mobile atom, we will impart our force upon it, assuming the whole hit hasn't been blocked
	if (!QDELETED(target) && !QDELETED(AM) && istype(target, /atom/movable) && get_final_damage())
		var/atom/movable/AM2 = target
		if (AM2.apply_push_impulse_from(AM, AM.get_mass()*speed, 0))
			AM2.visible_message("<span class='warning'>\The [AM2] staggers under the impact!</span>")

/datum/strike/thrown/impact_mob()
	.=..()
	if (used_item)
		used_item.apply_hit_effect(target, user, target_zone)
		L.hit_with_weapon(src)

/datum/strike/thrown/show_result()
	if (missed)
		used_weapon.visible_message("<span class='notice'>\The [used_weapon] misses [target] narrowly!</span>")
		return
	else
		var/sound = get_impact_sound()
		if (blocker)
			if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
			target.shake_animation(3)
			user.shake_animation(3)
			user.visible_message("<span class='minorwarning'>[target] blocked the [used_weapon] with their [blocker]!</span>")


		else
			if (sound)	playsound(target, sound, VOLUME_HIGH, 1, 1)
			target.shake_animation(8)
			if (H)
				var/obj/item/organ/external/affecting = H.find_target_organ(target_zone)
				H.visible_message("<span class='warning'>\The [H] has been hit in the [affecting.name] by \the [used_weapon].</span>")
		/*


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
		*/

//Targeting
//-------------------------
/datum/strike/proc/handle_target_zone()
	if (target_zone == RANDOM)
		target_zone = ran_zone(BP_CHEST, 0)	//Pick a random zone
	else if (!target_zone)	//Don't grab from zonesel if a specific organ was already chosen
		target_zone = get_zone_sel(user)
	if (H)
		affecting = H.find_target_organ(target_zone)
		if (affecting)
			target_zone = affecting.organ_tag

	original_target_zone = target_zone

//Defense Handling
//-----------------------
/datum/strike/proc/setup_difficulty()
	if (luser)
		difficulty += luser.melee_accuracy_mods()

//Do we actually hit the victim?
/datum/strike/proc/handle_accuracy()

	//Melee attacks don't miss
	if (melee)
		return TRUE

	if (L)
		target_zone = L.get_zone_with_miss_chance(accuracy, target_zone, used_weapon)
		if (!target_zone)
			missed = TRUE

//Currently unused
/datum/strike/proc/handle_miss()
	missed = TRUE
	return

//Tell the victim they're about to be struck, so we can calculate defenses like blocking the hit with a different limb
/datum/strike/proc/handle_defense()
	if (L)
		L.handle_strike_defense(src) //We just pass ourselves, the proc will modify us accordingly.

/datum/strike/proc/handle_armor()
	if (L)
		blocked = L.run_armor_check(target_zone, armor_type, armour_pen = armor_penetration)

		if(prob(blocked)) //armour provides a chance to turn sharp/edge weapon attacks into blunt ones
			damage_flags &= ~(DAM_SHARP|DAM_EDGE)



//Impact procs.
//------------------------------
//These are the final stage, called to deal damage to the victim

/datum/strike/proc/impact_target()
	if (L)
		impact_mob()

	else if (istype(target, /obj/machinery/door))
		impact_door()

	else if (istype(target, /obj/structure))
		impact_structure()

//This is called when the target is a living mob, so we can assume L is populated
/datum/strike/proc/impact_mob()
	//Alright, how much damage are we going to deal
	var/final_damage = get_final_damage()
	if (final_damage <= 0)
		return FALSE
	// Finally, apply damage to target
	damage_done = L.apply_damage(final_damage, damage_type, target_zone, blocked, damage_flags=src.damage_flags,used_weapon = used_weapon)
	return TRUE


/datum/strike/proc/impact_door()
	var/obj/machinery/door/D = target
	damage_done = D.hit(user, used_weapon, get_final_damage()) //TODO Later: Add in an attack flag for ignoring resistance?

/datum/strike/proc/impact_structure()
	var/obj/structure/S = target
	damage_done = get_final_damage()
	damage_done = S.take_damage(damage_done, BRUTE, user, used_weapon)

//Result Showing
/datum/strike/proc/show_result()
	//No default behaviour, only in overrides


