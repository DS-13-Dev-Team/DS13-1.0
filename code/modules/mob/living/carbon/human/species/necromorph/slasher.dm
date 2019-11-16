/*
	Slasher variant, the most common necromorph. Has an additional pair of arms with scything blades on the end
*/
/datum/species/necromorph/slasher
	name = SPECIES_NECROMORPH_SLASHER
	name_plural =  "Slashers"
	blurb = "The Slasher is created from a single human corpse, and is one of the more common Necromorphs encountered in a typical outbreak\
	. The Slasher is named for its specialized arms, which sport sharp blade-like protrusions of bone."
	unarmed_types = list(/datum/unarmed_attack/blades, /datum/unarmed_attack/bite/weak) //Bite attack is a backup if blades are severed
	total_health = 80

	icon_template = 'icons/mob/necromorph/48x48necros.dmi'
	icon_normal = "slasher_d"
	icon_lying = "slasher_d_lying"
	icon_dead = "slasher_d_dead"
	pixel_offset_x = -8

	has_limbs = list(
	BP_CHEST =  list("path" = /obj/item/organ/external/chest),
	BP_GROIN =  list("path" = /obj/item/organ/external/groin),
	BP_HEAD =   list("path" = /obj/item/organ/external/head),
	BP_L_ARM =  list("path" = /obj/item/organ/external/arm/blade),
	BP_R_ARM =  list("path" = /obj/item/organ/external/arm/blade/right),
	BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
	BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
	BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
	BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
	)

	inherent_verbs = list(/atom/movable/proc/slasher_charge)
	modifier_verbs = list(KEY_ALT = list(/atom/movable/proc/slasher_charge))

/datum/species/necromorph/slasher/enhanced
	name = SPECIES_NECROMORPH_SLASHER_ENHANCED
	unarmed_types = list(/datum/unarmed_attack/blades/strong, /datum/unarmed_attack/bite/strong)
	total_health = 200



/* Unarmed attacks*/
/datum/unarmed_attack/blades
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


	.= charge_attack(A, _delay = 1.5 SECONDS)
	if (.)
		//Do some audio cues here
		shake_animation(20)


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
		return
	else
		return ..()