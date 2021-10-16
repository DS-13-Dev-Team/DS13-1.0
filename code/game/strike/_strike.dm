/*
	A strike is a temporary datum created when one atom (usually a human) attempts to physically harm another atom at close range,
	typically with an arm, leg,or appendage. It is also used for swinging melee weapons, and for a variety of damage-dealing special abilities


	Strikes were created to act as a centralised layer of abstraction and allow violent interactions between various kinds of objects,
	creatures and species much more easily. They replace a lot of bad code and duplicated concepts


*/
/*
	TODO LIST:
		Possible: Syringe attacks
		Bullets and projectiles

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

	//A temporary value, set just before impact, factoring in all calculations on the attacker's side_effects =
	//Calculations on the defending side may still affect damage, so this value is not the actual damage dealt
	var/final_damage

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


	var/allow_dismemberment = TRUE	//If false, damage dealt by this strike cannot sever limbs

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
/datum/strike/proc/cache_data(var/atom/user, var/atom/target, var/damage, var/used_weapon, var/damage_flags, var/armor_penetration, var/damage_type = BRUTE, var/armor_type = "melee", var/target_zone, var/difficulty, var/allow_dismemberment)
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
	src.difficulty = difficulty
	src.allow_dismemberment = allow_dismemberment

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

	final_damage = max(damage - blocked_damage, 0)

	return final_damage

/datum/strike/proc/get_impact_sound()
	if (blocker)
		if (istype(blocker, /obj/item))
			var/obj/item/I = blocker
			return I.blocksound


/datum/strike/proc/calculate_accuracy()
	return accuracy


//Targeting
//-------------------------
/datum/strike/proc/handle_target_zone()


	if (target_zone == RANDOM)
		target_zone = ran_zone(BP_CHEST, 0)	//Pick a random zone
	else if (!target_zone)	//Don't grab from zonesel if a specific organ was already chosen
		target_zone = get_zone_sel(user)

	original_target_zone = target_zone
	if (H)
		affecting = H.find_target_organ(target_zone)
		if (affecting)

			target_zone = affecting.organ_tag


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

	else if (istype(target, /obj/structure) || istype(target, /obj/machinery/deployable))
		impact_structure()

	else if(istype(target, /obj/machinery/vending) && ishuman(huser) && huser.is_necromorph())
		impact_vending()

	else if (istype(target, /turf))
		impact_turf()

//This is called when the target is a living mob, so we can assume L is populated
/datum/strike/proc/impact_mob()
	//Alright, how much damage are we going to deal
	get_final_damage()
	if (final_damage <= 0)
		return FALSE
	// Finally, apply damage to target
	damage_done = L.apply_damage(final_damage, damage_type, target_zone, blocked, damage_flags=src.damage_flags,used_weapon = used_weapon, allow_dismemberment = src.allow_dismemberment)
	return TRUE


/datum/strike/proc/impact_door()
	var/obj/machinery/door/D = target
	damage_done = D.hit(user, used_weapon, get_final_damage()) //TODO Later: Add in an attack flag for ignoring resistance?

/datum/strike/proc/impact_structure()
	var/obj/structure/S = target
	damage_done = get_final_damage()
	damage_done = S:take_damage(damage_done, BRUTE, user, used_weapon)


/datum/strike/proc/impact_turf()
	var/turf/T = target
	damage_done = get_final_damage()
	damage_done = T.handle_strike(src)

/datum/strike/proc/impact_vending()
	var/obj/machinery/vending/S = target
	damage_done = TRUE
	S.fall_down(user)

//Result Showing
/datum/strike/proc/show_result()
	//No default behaviour, only in overrides


