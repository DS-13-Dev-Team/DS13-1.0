/datum/unarmed_attack/bite/sharp //eye teeth
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = 1
	edge = 1





/datum/unarmed_attack/claws
	name = "Claws"
	desc = "Sharp, causes bleeding."
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	airlock_force_power = 1
	sharp = 1
	edge = 1
	damage = 7

/datum/unarmed_attack/claws/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(user.gloves)
		var/obj/item/clothing/gloves/gloves = user.gloves
		if(istype(gloves) && !gloves.clipped)
			return 0
		else
			return 1
	else
		return 1

/datum/unarmed_attack/claws/show_attack(var/mob/living/carbon/human/user, var/atom/target, var/zone, var/attack_damage)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affecting = H.find_target_organ(zone)

		attack_damage = Clamp(attack_damage, 1, 5)

		if(H == user)
			user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [affecting.name]!</span>")
			return 0

		switch(zone)
			if(BP_HEAD, BP_MOUTH, BP_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2) user.visible_message("<span class='danger'>[user] scratched [H] across \his cheek!</span>")
					if(3 to 4)
						user.visible_message(pick(
							80; user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [H]'s [pick("face", "neck", affecting.name)]!</span>"),
							20; user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("[H] in the [affecting.name]", "[H] across \his [pick("face", "neck", affecting.name)]")]!</span>"),
							))
					if(5)
						user.visible_message(pick(
							"<span class='danger'>[user] rakes \his [pick(attack_noun)] across [H]'s [pick("face", "neck", affecting.name)]!</span>",
							"<span class='danger'>[user] tears \his [pick(attack_noun)] into [H]'s [pick("face", "neck", affecting.name)]!</span>",
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message("<span class='danger'>[user] [pick("scratched", "grazed")] [H]'s [affecting.name]!</span>")
					if(3 to 4)
						user.visible_message(pick(
							80; user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [H]'s [affecting.name]!</span>"),
							20; user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("[H] in the [affecting.name]", "[H] across \his [affecting.name]")]!</span>"),
							))
					if(5)		user.visible_message("<span class='danger'>[user] tears \his [pick(attack_noun)] [pick("deep into", "into", "across")] [H]'s [affecting.name]!</span>")
	else
		.=..()

/datum/unarmed_attack/claws/strong
	attack_verb = list("slashed")
	airlock_force_power = 2
	damage = 10.5
	shredding = 1

/datum/unarmed_attack/claws/monkey
	attack_verb = list("scratched")
	damage = 6.5

/datum/unarmed_attack/bite/weak
	damage = 4

/datum/unarmed_attack/bite/strong
	attack_verb = list("mauled")
	damage = 8
	shredding = 1

/datum/unarmed_attack/slime_glomp
	attack_verb = list("glomped")
	attack_noun = list("body")
	damage = 2

/datum/unarmed_attack/slime_glomp/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	user.apply_stored_shock_to(target)

/datum/unarmed_attack/stomp/weak
	attack_verb = list("jumped on")

/datum/unarmed_attack/stomp/weak/get_unarmed_damage()
	return damage

/datum/unarmed_attack/stomp/weak/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affecting = H.get_organ(zone)
		user.visible_message("<span class='warning'>[user] jumped up and down on \the [H]'s [affecting.name]!</span>")
		playsound(user.loc, attack_sound, 25, 1, -1)
	else
		.=..()

/datum/unarmed_attack/tail //generally meant for people like unathi
	attack_verb = list ("bludgeoned", "lashed", "smacked", "whapped")
	attack_noun = list ("tail")

/datum/unarmed_attack/tail/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone) //ensures that you can't tail someone in the skull

	if(!(zone in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT, BP_GROIN)))

		return 0

	var/obj/item/organ/external/E = user.organs_by_name[BP_L_FOOT]

	if(E && !E.is_stump())

		return 1


	E = user.organs_by_name[BP_R_FOOT]

	if(E && !E.is_stump())

		return 1

	return 0

/datum/unarmed_attack/tail/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	if (ishuman(target))
		var/mob/living/carbon/human/H = target
		var/obj/item/organ/external/affecting = H.get_organ(zone)

		var/organ = affecting.name
		attack_damage = Clamp(attack_damage, 1, 6)
		attack_damage = 3 + attack_damage - rand(1, 5)
		switch(attack_damage)

			if(3 to 5)	user.visible_message("<span class='danger'>[user] glanced [H] with their [pick(attack_noun)] in the [organ]!</span>")

			if(6 to 7)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [H] in \his [organ]!</span>")

			if(8)		user.visible_message("<span class='danger'>[user] landed a heavy blow with their [pick(attack_noun)] against [H]'s [organ]!</span>")

	else
		.=..()
