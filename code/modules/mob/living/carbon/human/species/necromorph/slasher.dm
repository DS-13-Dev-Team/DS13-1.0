/*
	Slasher variant, the most common necromorph. Has an additional pair of arms with scything blades on the end
*/
/datum/species/necromorph/slasher
	name = "Slasher"
	name_plural =  "Slashers"
	blurb = "The Slasher is created from a single human corpse, and is one of the more common Necromorphs encountered in a typical outbreak\
	. The Slasher is named for its specialized arms, which sport sharp blade-like protrusions of bone."
	unarmed_types = list(/datum/unarmed_attack/blades)
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

/datum/species/necromorph/slasher/enhanced
	unarmed_types = list(/datum/unarmed_attack/blades/strong)
	total_health = 200

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
	delay = 10

/datum/unarmed_attack/blades/strong
	damage = 22
	delay = 8