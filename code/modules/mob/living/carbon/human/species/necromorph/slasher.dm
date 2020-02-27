/*
	Slasher variant, the most common necromorph. Has an additional pair of arms with scything blades on the end
*/
/datum/species/necromorph/slasher
	name = SPECIES_NECROMORPH_SLASHER
	name_plural =  "Slashers"
	mob_type = /mob/living/carbon/human/necromorph/slasher
	blurb = "The frontline soldier of the necromorph horde. Slow when not charging, but its blade arms make for powerful melee attacks"
	unarmed_types = list(/datum/unarmed_attack/blades, /datum/unarmed_attack/bite/weak) //Bite attack is a backup if blades are severed
	total_health = 80

	icon_template = 'icons/mob/necromorph/slasher.dmi'
	icon_lying = "_lying"
	pixel_offset_x = -8
	single_icon = FALSE
	evasion = 5	//Below the normal human value of 15, because they're slow

	override_limb_types = list(
	BP_L_ARM =  /obj/item/organ/external/arm/blade,
	BP_R_ARM =  /obj/item/organ/external/arm/blade/right,
	)


	species_audio = list(
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/slasher/slasher_attack_1.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_attack_2.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_attack_3.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_attack_4.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_attack_5.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_attack_6.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_attack_7.ogg'),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/slasher/slasher_death_1.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_death_2.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_death_3.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_death_4.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/slasher/slasher_pain_1.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_pain_2.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_pain_3.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_pain_4.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_pain_5.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_pain_6.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/slasher/slasher_shout_1.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_shout_2.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_shout_3.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_shout_4.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/slasher/slasher_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_shout_long_3.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_shout_long_4.ogg'),
	SOUND_SPEECH = list('sound/effects/creatures/necromorph/slasher/slasher_speech_1.ogg',
	'sound/effects/creatures/necromorph/slasher/slasher_speech_2.ogg')
	)

	slowdown = 3.5

	inherent_verbs = list(/atom/movable/proc/slasher_charge, /mob/proc/shout)
	modifier_verbs = list(KEY_ALT = list(/atom/movable/proc/slasher_charge))

/datum/species/necromorph/slasher/enhanced
	name = SPECIES_NECROMORPH_SLASHER_ENHANCED
	marker_spawnable = FALSE 	//Enable this once we have sprites for it
	mob_type = /mob/living/carbon/human/necromorph/slasher/enhanced
	unarmed_types = list(/datum/unarmed_attack/blades/strong, /datum/unarmed_attack/bite/strong)
	total_health = 200
	slowdown = 2.8
	biomass = 160
	biomass_reclamation = 0.75



/* Unarmed attacks*/
/datum/unarmed_attack/blades
	name = "Scything blades"
	desc = "These colossal blades can cleave a man in half."
	attack_verb = list("slashed", "scythed", "cleaved")
	attack_noun = list("blades")
	eye_attack_text = "impales"
	eye_attack_text_victim = "blade"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = TRUE
	edge = TRUE
	shredding = TRUE
	damage = 15
	delay = 12
	airlock_force_power = 2

//Can't slash things without arms
/datum/unarmed_attack/blades/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if(!user.has_organ(BP_R_ARM) && !user.has_organ(BP_L_ARM))
		return FALSE
	return TRUE

/datum/unarmed_attack/blades/strong
	damage = 22
	delay = 10


/atom/movable/proc/slasher_charge(var/atom/A)
	set name = "Charge"
	set category = "Abilities"


	.= charge_attack(A, _delay = 1.5 SECONDS, _speed = 4)
	if (.)
		var/mob/H = src
		if (istype(H))
			H.face_atom(A)

			//Long shout when targeting mobs, normal when targeting objects
			if (ismob(A))
				H.play_species_audio(src, SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 3)
			else
				H.play_species_audio(src, SOUND_SHOUT, VOLUME_HIGH, 1, 3)
		shake_animation(30)


/*
	Slashers have a special charge impact. Each of their blade arms gets a free hit on impact with the primary target
*/
/datum/species/necromorph/slasher/charge_impact(var/mob/living/charger, var/atom/obstacle, var/power, var/target_type, var/distance_travelled)
	if (target_type == CHARGE_TARGET_PRIMARY && isliving(obstacle))
		var/mob/living/carbon/human/H = charger
		var/mob/living/L = obstacle

		//We need to be in harm intent for this, set it if its not already
		if (H.a_intent != I_HURT)
			H.a_intent_change(I_HURT)

		//This is a bit of a hack because unarmed attacks are poorly coded:
			//We'll set the user's last attack to some time in the past so they can attack again
		if (H.has_organ(BP_R_ARM))
			H.last_attack = 0
			H.UnarmedAttack(L)

		if (H.has_organ(BP_L_ARM))
			H.last_attack = 0
			H.UnarmedAttack(L)
		return FALSE
	else
		return ..()



//Special death condition: Slashers die when they lose both blade arms
/datum/species/necromorph/slasher/handle_death_check(var/mob/living/carbon/human/H)
	.=..()
	if (!.)
		if (!H.has_organ(BP_L_ARM) && !H.has_organ(BP_R_ARM))
			return TRUE