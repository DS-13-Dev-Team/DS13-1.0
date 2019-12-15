/obj/item/organ/external/arm/blade
	organ_tag = BP_L_ARM
	name = "left blade"
	icon_name = "l_arm"
	max_damage = 60
	min_broken_damage = 40
	w_class = ITEM_SIZE_NORMAL
	body_part = ARM_LEFT
	parent_organ = BP_CHEST
	joint = "left elbow"
	amputation_point = "left shoulder"
	tendon_name = "palmaris longus tendon"
	artery_name = "basilic vein"
	arterial_bleed_severity = 0.75
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE

/obj/item/organ/external/arm/blade/right
	organ_tag = BP_R_ARM
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"




//Giant limbs
//---------------
//Used by brute, these limbs have 4x the health
/obj/item/organ/external/head/giant
	max_damage = 260
	min_broken_damage = 140

/obj/item/organ/external/chest/giant
	max_damage = 360
	min_broken_damage = 180

/obj/item/organ/external/groin/giant
	max_damage = 180
	min_broken_damage = 90

/obj/item/organ/external/arm/giant
	max_damage = 180
	min_broken_damage = 100

/obj/item/organ/external/arm/right/giant
	max_damage = 180
	min_broken_damage = 100

/obj/item/organ/external/leg/giant
	max_damage = 180
	min_broken_damage = 100

/obj/item/organ/external/leg/right/giant
	max_damage = 180
	min_broken_damage = 100


/obj/item/organ/external/foot/giant
	max_damage = 180
	min_broken_damage = 100

/obj/item/organ/external/foot/right/giant
	max_damage = 180
	min_broken_damage = 100

/obj/item/organ/external/hand/giant
	max_damage = 180
	min_broken_damage = 100

/obj/item/organ/external/hand/right/giant
	max_damage = 180
	min_broken_damage = 100


/obj/item/organ/external/head/ubermorph
	glowing_eyes = TRUE
	eye_icon_location = 'icons/mob/necromorph/ubermorph.dmi'
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_HEALS_OVERKILL