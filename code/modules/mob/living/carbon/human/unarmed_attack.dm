var/global/list/sparring_attack_cache = list()

//Species unarmed attacks
/datum/unarmed_attack
	var/name = "Attack" //Capitalise this
	var/list/tags = list()
	var/desc = ""	//Make this short, typically one sentance
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/damage = 4				// Extra empty hand attack damage.
	var/rand_damage = 2			//The attack can deal this much damage more or less than standard
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = 0 // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = 0
	var/edge = 0
	var/delay = 1 SECOND	//Default delay, overrideable
	var/required_limb = list(BP_L_ARM, BP_R_ARM)	//The mob must have any of these limbs to do this attack

	var/deal_halloss
	var/sparring_variant_type = /datum/unarmed_attack/light_strike

	var/eye_attack_text
	var/eye_attack_text_victim

	var/airlock_force_power = 0	//Can this attack be used to force open airlocks?
		//A power of 1 can open a normal airlock.
		//Power of 2 is needed to force open a welded and bolted airlock
		//Power of 3 will open a bolted and reinforced airlock
		//Power of 5 will open everything, even with a brace attached

		//Extra power above what's required will make the forcing go faster

	//Additional divider on time required to force open airlocks.
	var/airlock_force_speed = 1

	var/structure_damage_mult = 1

	var/lying_cooldown_factor	=	2
	var/lying_damage_factor	=	0.75

	var/armor_penetration = 0

/datum/unarmed_attack/New()
	.=..()
	if (edge)
		tags += "edged"
	if (sharp)
		tags += "sharp"

/datum/unarmed_attack/proc/get_damage_type()
	if(deal_halloss)
		return PAIN
	return BRUTE

/datum/unarmed_attack/proc/get_sparring_variant()
	if(sparring_variant_type)
		if(!sparring_attack_cache[sparring_variant_type])
			sparring_attack_cache[sparring_variant_type] = new sparring_variant_type()
		return sparring_attack_cache[sparring_variant_type]

/datum/unarmed_attack/proc/is_usable(var/mob/living/carbon/human/user, var/atom/target, var/zone)
	if(user.restrained())
		return 0

	// Check if they have a functioning hand.
	var/has_required_organ = FALSE
	for (var/organ_tag in required_limb)
		var/obj/item/organ/external/E = user.organs_by_name[organ_tag]
		if(E && !E.is_stump() && !E.retracted)
			has_required_organ = TRUE

	if (!has_required_organ)
		return FALSE

	return TRUE

/datum/unarmed_attack/proc/get_unarmed_damage(var/mob/living/user)
	.= damage
	if (user && user.lying)
		.*=lying_damage_factor


//Factor in attackspeed here
/datum/unarmed_attack/proc/get_delay(var/mob/living/user)
	if (isnum(delay) && delay > 0)
		.= (delay / user.get_attack_speed_factor())
		if (user.lying)
			. *= lying_cooldown_factor
		return
	return 0

/datum/unarmed_attack/proc/apply_effects(var/datum/strike/strike)

	var/mob/living/user = strike.user
	var/attack_damage = strike.get_final_damage()

	if (ishuman(strike.target))
		var/mob/living/carbon/human/H = strike.target
		if(H.stat == DEAD)
			return

		//Can't knockdown people bigger than you
		if (H.mob_size > user.mob_size)
			return

		var/stun_chance = rand(0, 100)
		if (strike.blocker)
			stun_chance *= 0.5	//Attacks which are blocked are much less likely to have special effects

		if(attack_damage >= 5 && strike.blocked < 100 && !(H == user) && stun_chance <= attack_damage * 5) // 25% standard chance
			switch(strike.target_zone) // strong punches can have effects depending on where they hit
				if(BP_HEAD, BP_EYES, BP_MOUTH)
					// Induce blurriness
					H.visible_message("<span class='danger'>[H] looks momentarily disoriented.</span>", "<span class='danger'>You see stars.</span>")
					H.apply_effect(attack_damage*2, EYE_BLUR, strike.blocked)
				if(BP_L_ARM, BP_L_HAND)
					if (H.l_hand)
						// Disarm left hand
						//Urist McAssistant dropped the macguffin with a scream just sounds odd.
						H.visible_message("<span class='danger'>\The [H.l_hand] was knocked right out of [H]'s grasp!</span>")
						H.drop_l_hand()
				if(BP_R_ARM, BP_R_HAND)
					if (H.r_hand)
						// Disarm right hand
						H.visible_message("<span class='danger'>\The [H.r_hand] was knocked right out of [H]'s grasp!</span>")
						H.drop_r_hand()
				if(BP_CHEST)
					if(!H.lying)
						var/turf/T = get_step(get_turf(H), get_dir(get_turf(user), get_turf(H)))
						if(!T.density)
							step(H, get_dir(get_turf(user), get_turf(H)))
							H.visible_message("<span class='danger'>[pick("[H] was sent flying backward!", "[H] staggers back from the impact!")]</span>")
						if(prob(50))
							H.set_dir(GLOB.reverse_dir[H.dir])
						H.apply_effect(attack_damage * 0.4, WEAKEN, strike.blocked)
				if(BP_GROIN)
					H.visible_message("<span class='warning'>[H] looks like \he is in pain!</span>", "<span class='warning'>[(H.gender=="female") ? "Oh god that hurt!" : "Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!"]</span>")
					H.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = strike.blocked)
				if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
					if(!H.lying)
						H.visible_message("<span class='warning'>[H] gives way slightly.</span>")
						H.apply_effect(attack_damage*3, PAIN, strike.blocked)
		else if(attack_damage >= 5 && !(H == user) && (stun_chance + attack_damage * 5 >= 100) && strike.blocked < 100) // Chance to get the usual throwdown as well (25% standard chance)
			if(!H.lying)
				H.visible_message("<span class='danger'>[H] [pick("slumps", "falls", "drops")] down to the ground!</span>")
			else
				H.visible_message("<span class='danger'>[H] has been weakened!</span>")
			H.apply_effect(3, WEAKEN, strike.blocked)

/datum/unarmed_attack/proc/show_attack(var/datum/strike/strike)
	var/fallback = FALSE
	if (ishuman(strike.target))
		var/mob/living/carbon/human/H = strike.target
		var/obj/item/organ/external/affecting = H.get_organ(strike.target_zone)
		if (affecting)
			if (strike.blocker)
				var/obj/item/organ/external/original = H.get_organ(strike.original_target_zone)
				if (original)
					strike.user.visible_message("<span class='minorwarning'>[strike.user] tried to [pick(attack_noun)] [strike.target] in the [original.name] but was blocked by [H.get_pronoun(POSESSIVE_ADJECTIVE)] [strike.blocker.name]!</span>")
				else
					fallback = TRUE
			else
				strike.user.visible_message("<span class='warning'>[strike.user] [pick(attack_verb)] [strike.target] in the [affecting.name]!</span>")
		else
			fallback = TRUE
	else
		fallback = TRUE

	if (fallback)
		strike.user.visible_message("<span class='warning'>[strike.user] [pick(attack_verb)] [strike.target][strike.damage_done?"":", to no effect"]!</span>")

	if (strike.luser)
		strike.luser.do_attack_animation(strike.target)



/datum/unarmed_attack/proc/handle_eye_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target)
	var/obj/item/organ/internal/eyes/eyes = target.internal_organs_by_name[BP_EYES]
	if(eyes)
		eyes.take_internal_damage(rand(3,4), 1)
		user.visible_message("<span class='danger'>[user] presses \his [eye_attack_text] into [target]'s [eyes.name]!</span>")
		var/eye_pain = eyes.can_feel_pain()
		to_chat(target, "<span class='danger'>You experience[(eye_pain) ? "" : " immense pain as you feel" ] [eye_attack_text_victim] being pressed into your [eyes.name][(eye_pain)? "." : "!"]</span>")
		return
	user.visible_message("<span class='danger'>[user] attempts to press \his [eye_attack_text] into [target]'s eyes, but they don't have any!</span>")

/datum/unarmed_attack/proc/damage_flags()
	return (src.sharp? DAM_SHARP : 0)|(src.edge? DAM_EDGE : 0)



//Procs for attacking airlocks and structures
//------------------------------------
/mob/proc/force_door(var/obj/machinery/door/target)
	return FALSE

/mob/proc/strike_door(var/obj/machinery/door/target)
	return FALSE


/mob/living/carbon/human/force_door(var/obj/machinery/door/target)
	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if (u_attack.force_door(src, target))
			return TRUE
		return FALSE

//Perhaps someday we'll have a unified atom damage framework and not need lots of procs like this
/mob/living/carbon/human/strike_door(var/obj/machinery/door/target)
	var/datum/unarmed_attack/u_attack = get_unarmed_attack(target)
	if (u_attack)
		var/datum/strike/strike = launch_unarmed_strike(target, u_attack)
		return strike



/datum/unarmed_attack/proc/force_door(var/mob/living/carbon/human/user, var/obj/machinery/door/target)

	if (!airlock_force_power)
		return FALSE

	if (!is_usable(user, target))
		return FALSE

	//Can we force this door open?
	var/difficulty = target.get_force_difficulty()
	if (airlock_force_power < difficulty)
		//Nope, its too tough. But since the user has some forcing ability, lets inform them that this door is an exception
		to_chat(user, "\The [target] is too tough for you to force open!")
		return FALSE

	else
		.=TRUE //Returning true prevents parent attack from continuing

		//Yes we are strong enough!
		//First of all, lets get the base time it will take
		var/time = target.get_force_time()

		//Now, if we have more power than we need, we get a discount on that time
		if (airlock_force_power > difficulty)
			time /= 1 + (airlock_force_power - difficulty)

		//And we divide by our speed too
		time /= get_force_speed(user, target)

		//Ok lets start
		if (!do_after(user, time, target))
			return//Fail

		//Success!
		target.break_open()

//Return the force power here. this attack could modulate this value to make certain doors easier.
/datum/unarmed_attack/proc/get_force_power(var/mob/living/carbon/human/user, var/obj/machinery/door/target)
	return airlock_force_power

//Return the force speed here. It will probably be desireable to return half of the normal value if some needed limbs are missing
/datum/unarmed_attack/proc/get_force_speed(var/mob/living/carbon/human/user, var/obj/machinery/door/target)
	return airlock_force_speed


/mob/proc/strike_structure(var/obj/structure/target)
	return

/mob/living/carbon/human/strike_structure(var/obj/structure/target)
	var/datum/unarmed_attack/u_attack = get_unarmed_attack(target)
	if (u_attack)
		var/datum/strike/strike = launch_unarmed_strike(target, u_attack)

		return strike




/*
	Specific Types
*/
/datum/unarmed_attack/bite
	attack_verb = list("bit", "gnawed", "chomped")
	attack_noun = list("bite", "chomp")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = TRUE
	edge = 0
	required_limb = list(BP_HEAD)

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)

	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return 0
	for(var/obj/item/clothing/C in list(user.wear_mask, user.head, user.wear_suit))
		if(C && (C.body_parts_covered & FACE) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
			return 0 //prevent biting through a space helmet or similar
	if (user == target && (zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH))
		return 0 //how do you bite yourself in the head?
	.=..()

/datum/unarmed_attack/punch
	name = "Punch"
	desc = "Requires arms"
	attack_verb = list("punched")
	attack_noun = list("punch")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"


/datum/unarmed_attack/punch/show_attack(var/datum/strike/strike)

	if (strike.luser)
		strike.luser.do_attack_animation(strike.target)
	if (strike.H)
		var/obj/item/organ/external/affecting = strike.H.get_organ(strike.target_zone)
		var/mob/living/user = strike.luser
		var/mob/living/carbon/human/target = strike.H
		var/organ = affecting.name

		var/attack_damage = Clamp(round(strike.get_final_damage(),1), 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

		if(strike.target == strike.user)
			user.visible_message("<span class='danger'>[strike.user] [pick(attack_verb)] \himself in the [organ]!</span>")
			return 0

		if (strike.blocker)
			var/obj/item/organ/external/original = target.get_organ(strike.original_target_zone)
			strike.user.visible_message("<span class='minorwarning'>[strike.user] tried to [pick(attack_noun)] [strike.target] in the [original.name] but was blocked by [target.get_pronoun(POSESSIVE_ADJECTIVE)] [strike.blocker.name]!</span>")
			return

		if(!strike.L.lying)
			switch(strike.target_zone)
				if(BP_HEAD, BP_MOUTH, BP_EYES)
					// ----- HEAD ----- //
					switch(attack_damage)
						if(2 to 3)
							user.visible_message("<span class='danger'>[user] slapped [target] across \his cheek!</span>")
						if(4 to 5)
							user.visible_message(pick(
								80; "<span class='danger'>[user] [pick(attack_verb)] [target] in the head!</span>",
								20; "<span class='danger'>[user] struck [target] in the head[pick("", " with a closed fist")]!</span>",
								50; "<span class='danger'>[user] threw a hook against [target]'s head!</span>"
								))
						if(6)
							user.visible_message(pick(
								10; "<span class='danger'>[user] gave [target] a solid slap across \his face!</span>",
								90; "<span class='danger'>[user] smashed \his [pick(attack_noun)] into [target]'s [pick("[organ]", "face", "jaw")]!</span>"
								))
				else
					// ----- BODY ----- //
					switch(attack_damage)
						if(1 to 3)	user.visible_message("<span class='danger'>[user] threw a glancing punch at [target]'s [organ]!</span>")
						if(4 to 5)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \his [organ]!</span>")
						if(6)		user.visible_message("<span class='danger'>[user] smashed \his [pick(attack_noun)] into [target]'s [organ]!</span>")
		else
			user.visible_message("<span class='danger'>[user] [pick("punched", "threw a punch at", "struck", "slammed their [pick(attack_noun)] into")] [target]'s [organ]!</span>") //why do we have a separate set of verbs for lying targets?
	else
		return ..()

/datum/unarmed_attack/kick
	name = "Kick"
	desc = "Requires legs"
	attack_verb = list("kicked", "kicked", "kicked", "kneed")
	attack_noun = list("kick", "kick", "kick", "knee strike")
	attack_sound = "swing_hit"

	required_limb = list(BP_L_LEG, BP_R_LEG)

/datum/unarmed_attack/kick/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(!(zone in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_GROIN)))
		return 0

	.=..()

/datum/unarmed_attack/kick/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	if(!istype(shoes))
		return damage
	return (..() + (shoes ? shoes.force : 0))

/datum/unarmed_attack/stomp
	attack_verb = list("stomped")
	attack_noun = list("stomp")
	attack_sound = "swing_hit"

	required_limb = list(BP_L_LEG, BP_R_LEG)

/datum/unarmed_attack/stomp/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(!istype(target))
		return 0

	if (!user.lying && (target.lying || (zone in list(BP_L_FOOT, BP_R_FOOT))))
		if(target.grabbed_by == user && target.lying)
			return 0
		.=..()

/datum/unarmed_attack/stomp/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	return .=..() + (shoes ? shoes.force : 0)


/datum/unarmed_attack/light_strike
	deal_halloss = 3
	attack_noun = list("tap","light strike")
	attack_verb = list("tapped", "lightly struck")
	damage = 2
	shredding = 0
	sharp = 0
	edge = 0
