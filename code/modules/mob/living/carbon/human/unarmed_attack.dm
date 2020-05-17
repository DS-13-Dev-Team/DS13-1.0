var/global/list/sparring_attack_cache = list()

//Species unarmed attacks
/datum/unarmed_attack
	var/name = "Attack" //Capitalise this
	var/list/tags = list()
	var/desc = ""	//Make this short, typically one sentance
	var/attack_verb = list("attack")	// Empty hand hurt intent verb.
	var/attack_noun = list("fist")
	var/damage = 0						// Extra empty hand attack damage.
	var/attack_sound = "punch"
	var/miss_sound = 'sound/weapons/punchmiss.ogg'
	var/shredding = 0 // Calls the old attack_alien() behavior on objects/mobs when on harm intent.
	var/sharp = 0
	var/edge = 0
	var/delay = 1 SECOND	//Default delay, overrideable


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
	var/obj/item/organ/external/E = user.organs_by_name[BP_L_HAND]
	if(E && !E.is_stump())
		return 1

	E = user.organs_by_name[BP_R_HAND]
	if(E && !E.is_stump())
		return 1

	return 0

/datum/unarmed_attack/proc/get_unarmed_damage()
	return damage

//Factor in attackspeed here
/datum/unarmed_attack/proc/get_delay(var/mob/living/user)
	if (isnum(delay) && delay > 0)
		return delay / user.get_attack_speed_factor()
	return 0

/datum/unarmed_attack/proc/apply_effects(var/mob/living/carbon/human/user,var/atom/target,var/armour,var/attack_damage,var/zone)

	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.stat == DEAD)
			return

		//Can't knockdown people bigger than you
		if (H.mob_size > user.mob_size)
			return

		var/stun_chance = rand(0, 100)

		if(attack_damage >= 5 && armour < 100 && !(H == user) && stun_chance <= attack_damage * 5) // 25% standard chance
			switch(zone) // strong punches can have effects depending on where they hit
				if(BP_HEAD, BP_EYES, BP_MOUTH)
					// Induce blurriness
					H.visible_message("<span class='danger'>[H] looks momentarily disoriented.</span>", "<span class='danger'>You see stars.</span>")
					H.apply_effect(attack_damage*2, EYE_BLUR, armour)
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
						H.apply_effect(attack_damage * 0.4, WEAKEN, armour)
				if(BP_GROIN)
					H.visible_message("<span class='warning'>[H] looks like \he is in pain!</span>", "<span class='warning'>[(H.gender=="female") ? "Oh god that hurt!" : "Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!"]</span>")
					H.apply_effects(stutter = attack_damage * 2, agony = attack_damage* 3, blocked = armour)
				if(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT)
					if(!H.lying)
						H.visible_message("<span class='warning'>[H] gives way slightly.</span>")
						H.apply_effect(attack_damage*3, PAIN, armour)
		else if(attack_damage >= 5 && !(H == user) && (stun_chance + attack_damage * 5 >= 100) && armour < 100) // Chance to get the usual throwdown as well (25% standard chance)
			if(!H.lying)
				H.visible_message("<span class='danger'>[H] [pick("slumps", "falls", "drops")] down to the ground!</span>")
			else
				H.visible_message("<span class='danger'>[H] has been weakened!</span>")
			H.apply_effect(3, WEAKEN, armour)

/datum/unarmed_attack/proc/show_attack(var/mob/living/carbon/human/user, var/atom/target, var/zone, var/attack_damage)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		user.visible_message("<span class='warning'>[user] [pick(attack_verb)] [target] in the [affecting.name]!</span>")
	else
		user.visible_message("<span class='warning'>[user] [pick(attack_verb)] [target][attack_damage?"":", to no effect"]!</span>")
	user.do_attack_animation(target)
	if (attack_damage)
		playsound(user.loc, attack_sound, 25, 1, -1)
	else
		playsound(user.loc, attack_sound, VOLUME_NEAR_SILENT, 1, -2)//If we deal 0 damage, the attacksound is much quieter

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
		if(world.time < last_attack + u_attack.delay)
			to_chat(src, "<span class='notice'>You can't attack again so soon.</span>")
			return 0
		last_attack = world.time
		setClickCooldown(u_attack.delay)
		var/damage_done = target.hit(src, null, u_attack.damage*u_attack.structure_damage_mult) //TODO Later: Add in an attack flag for ignoring resistance?
		u_attack.show_attack(src, target, null, damage_done)
		return TRUE



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
		if(world.time < last_attack + u_attack.delay)
			to_chat(src, "<span class='notice'>You can't attack again so soon.</span>")
			return 0
		last_attack = world.time
		setClickCooldown(u_attack.delay)
		var/damage_done = u_attack.damage*u_attack.structure_damage_mult
		if (target.take_damage(damage_done, BRUTE, src, u_attack))
			u_attack.show_attack(src, target, null, damage_done-target.resistance)
		else
			u_attack.show_attack(src, target, null, 0)




/*
	Specific Types
*/
/datum/unarmed_attack/bite
	attack_verb = list("bit")
	attack_verb = list("teeth")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	damage = 0
	sharp = 0
	edge = 0

/datum/unarmed_attack/bite/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)

	if(istype(user.wear_mask, /obj/item/clothing/mask/muzzle))
		return 0
	for(var/obj/item/clothing/C in list(user.wear_mask, user.head, user.wear_suit))
		if(C && (C.body_parts_covered & FACE) && (C.item_flags & ITEM_FLAG_THICKMATERIAL))
			return 0 //prevent biting through a space helmet or similar
	if (user == target && (zone == BP_HEAD || zone == BP_EYES || zone == BP_MOUTH))
		return 0 //how do you bite yourself in the head?
	return 1

/datum/unarmed_attack/punch
	name = "Punch"
	desc = "Requires arms"
	attack_verb = list("punched")
	attack_noun = list("fist")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"
	damage = 0

/datum/unarmed_attack/punch/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)

	if (ishuman(target))
		var/obj/item/organ/external/affecting = target.get_organ(zone)
		var/organ = affecting.name

		attack_damage = Clamp(attack_damage, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

		if(target == user)
			user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [organ]!</span>")
			return 0

		if(!target.lying)
			switch(zone)
				if(BP_HEAD, BP_MOUTH, BP_EYES)
					// ----- HEAD ----- //
					switch(attack_damage)
						if(1 to 2)
							user.visible_message("<span class='danger'>[user] slapped [target] across \his cheek!</span>")
						if(3 to 4)
							user.visible_message(pick(
								80; "<span class='danger'>[user] [pick(attack_verb)] [target] in the head!</span>",
								20; "<span class='danger'>[user] struck [target] in the head[pick("", " with a closed fist")]!</span>",
								50; "<span class='danger'>[user] threw a hook against [target]'s head!</span>"
								))
						if(5)
							user.visible_message(pick(
								10; "<span class='danger'>[user] gave [target] a solid slap across \his face!</span>",
								90; "<span class='danger'>[user] smashed \his [pick(attack_noun)] into [target]'s [pick("[organ]", "face", "jaw")]!</span>"
								))
				else
					// ----- BODY ----- //
					switch(attack_damage)
						if(1 to 2)	user.visible_message("<span class='danger'>[user] threw a glancing punch at [target]'s [organ]!</span>")
						if(1 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \his [organ]!</span>")
						if(5)		user.visible_message("<span class='danger'>[user] smashed \his [pick(attack_noun)] into [target]'s [organ]!</span>")
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
	damage = 0

/datum/unarmed_attack/kick/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(!(zone in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_GROIN)))
		return 0

	var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
	if(E && !E.is_stump())
		return 1

	E = user.organs_by_name[BP_R_FOOT]
	if(E && !E.is_stump())
		return 1

	return 0

/datum/unarmed_attack/kick/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	if(!istype(shoes))
		return damage
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/kick/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	attack_damage = Clamp(attack_damage, 1, 5)

	switch(attack_damage)
		if(1 to 2)	user.visible_message("<span class='danger'>[user] threw [target] a glancing [pick(attack_noun)] to the [organ]!</span>") //it's not that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target] in \his [organ]!</span>")
		if(5)		user.visible_message("<span class='danger'>[user] landed a strong [pick(attack_noun)] against [target]'s [organ]!</span>")

/datum/unarmed_attack/stomp
	attack_verb = list("stomped on")
	attack_noun = list("stomp")
	attack_sound = "swing_hit"
	damage = 0

/datum/unarmed_attack/stomp/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(!istype(target))
		return 0

	if (!user.lying && (target.lying || (zone in list(BP_L_FOOT, BP_R_FOOT))))
		if(target.grabbed_by == user && target.lying)
			return 0
		var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]
		if(E && !E.is_stump())
			return 1

		E = user.organs_by_name[BP_R_FOOT]
		if(E && !E.is_stump())
			return 1

		return 0

/datum/unarmed_attack/stomp/get_unarmed_damage(var/mob/living/carbon/human/user)
	var/obj/item/clothing/shoes = user.shoes
	return damage + (shoes ? shoes.force : 0)

/datum/unarmed_attack/stomp/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name
	var/obj/item/clothing/shoes = user.shoes

	attack_damage = Clamp(attack_damage, 1, 5)

	var/shoe_text = shoes ? copytext(shoes.name, 1, -1) : "foot"
	switch(attack_damage)
		if(1 to 4)
			user.visible_message(pick(
				"<span class='danger'>[user] stomped on [target]'s [organ][pick("", "with their [shoe_text]")]!</span>",
				"<span class='danger'>[user] stomped \his [shoe_text] down onto [target]'s [organ]!</span>"))
		if(5)
			user.visible_message(pick(
				"<span class='danger'>[user] stomped down hard onto [target]'s [organ][pick("", "with their [shoe_text]")]!</span>",
				"<span class='danger'>[user] slammed \his [shoe_text] down onto [target]'s [organ]!</span>"))

/datum/unarmed_attack/light_strike
	deal_halloss = 3
	attack_noun = list("tap","light strike")
	attack_verb = list("tapped", "lightly struck")
	damage = 2
	shredding = 0
	damage = 0
	sharp = 0
	edge = 0
