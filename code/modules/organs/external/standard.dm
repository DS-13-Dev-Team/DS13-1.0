/****************************************************
			   ORGAN DEFINES
****************************************************/

//Make sure that w_class is set as if the parent mob was medium sized! This is because w_class is adjusted automatically for mob_size in New()

/obj/item/organ/external/chest
	name = "upper body"
	organ_tag = BP_CHEST
	icon_name = "torso"
	max_damage = 90 //these damage values don't really do anything as organs can't be damaged through the bodypart nor can they be broken. maybe something cna be done here in future to make baycode function more like TG where once an organ takes this much damage, it spills what is inside - so torso drops internal organs or something.
	min_broken_damage = 25
	w_class = ITEM_SIZE_HUGE //Used for dismembering thresholds, in addition to storage. Humans are w_class 6, so it makes sense that chest is w_class 5.
	body_part = UPPER_TORSO
	vital = 1
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	parent_organ = null
	encased = "ribcage"
	artery_name = "aorta"
	cavity_name = "thoracic"
	limb_flags = ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_GENDERED_ICON | ORGAN_FLAG_HEALS_OVERKILL
	limb_height = new /vector2(1.25,1.65)	//40cm from upper abdomen to neck

/obj/item/organ/external/chest/proc/get_current_skin()
	return

/obj/item/organ/external/chest/robotize()
	if(..())
		// Give them a new cell.
		var/obj/item/organ/internal/cell/C = owner.internal_organs_by_name[BP_CELL]
		if(!istype(C))
			owner.internal_organs_by_name[BP_CELL] = new /obj/item/organ/internal/cell(owner,1)

/obj/item/organ/external/get_scan_results()
	. = ..()
	var/obj/item/organ/internal/lungs/L = locate() in src
	if( L && L.is_bruised())
		. += "Lung ruptured"

/obj/item/organ/external/groin
	name = "lower body"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 90
	min_broken_damage = 50
	w_class = ITEM_SIZE_LARGE
	body_part = LOWER_TORSO
	parent_organ = BP_CHEST
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	artery_name = "iliac artery"
	cavity_name = "abdominal"
	limb_flags = ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_GENDERED_ICON
	limb_height = new /vector2(1,1.25)	//25cm from bottom of groin to upper abdomen
	defensive_group = LOWERBODY

/obj/item/organ/external/arm
	organ_tag = BP_L_ARM
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 60
	min_broken_damage = 30
	w_class = ITEM_SIZE_NORMAL
	body_part = ARM_LEFT
	parent_organ = BP_CHEST
	joint = "left elbow"
	amputation_point = "left shoulder"
	tendon_name = "palmaris longus tendon"
	artery_name = "basilic vein"
	arterial_bleed_severity = 0.75
	limb_flags = ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_GRASP
	base_miss_chance = 12
	limb_height = new /vector2(0.9,1.60) //80cm long, assuming theyre hanging down
	best_direction	=	WEST
	defensive_group = null

/obj/item/organ/external/arm/right
	organ_tag = BP_R_ARM
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"
	best_direction	=	EAST

/obj/item/organ/external/leg
	organ_tag = BP_L_LEG
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 45
	min_broken_damage = 25
	w_class = ITEM_SIZE_NORMAL
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	tendon_name = "cruciate ligament"
	artery_name = "femoral artery"
	arterial_bleed_severity = 0.75
	limb_flags = ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND
	base_miss_chance = 5
	limb_height = new /vector2(0.1,1)	//Approx 90cm from ankle to groin
	best_direction	=	WEST
	defensive_group = null
	divider_component_type = /mob/living/simple_animal/necromorph/divider_component/leg

/obj/item/organ/external/leg/right
	organ_tag = BP_R_LEG
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"
	best_direction	=	EAST

/obj/item/organ/external/foot
	organ_tag = BP_L_FOOT
	name = "left foot"
	icon_name = "l_foot"
	max_damage = 45
	min_broken_damage = 25
	w_class = ITEM_SIZE_SMALL
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = BP_L_LEG
	joint = "left ankle"
	amputation_point = "left ankle"
	tendon_name = "Achilles tendon"
	arterial_bleed_severity = 0.5
	limb_flags = ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND
	base_miss_chance = 15
	limb_height = new /vector2(0,0.1)	//about 10cm from sole to ankle
	defensive_group = null
	divider_component_type = /mob/living/simple_animal/necromorph/divider_component/leg

/obj/item/organ/external/foot/right
	organ_tag = BP_R_FOOT
	name = "right foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = BP_R_LEG
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	organ_tag = BP_L_HAND
	name = "left hand"
	icon_name = "l_hand"
	max_damage = 60
	min_broken_damage = 30
	w_class = ITEM_SIZE_SMALL
	body_part = HAND_LEFT
	parent_organ = BP_L_ARM
	joint = "left wrist"
	amputation_point = "left wrist"
	tendon_name = "carpal ligament"
	arterial_bleed_severity = 0.5
	limb_flags = ORGAN_FLAG_CAN_BREAK | ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_GRASP | ORGAN_FLAG_FINGERPRINT
	base_miss_chance = 15
	limb_height = new /vector2(0.8,0.9)	//10cm long, hanging down in middle of leg
	defensive_group = null

/obj/item/organ/external/hand/right
	organ_tag = BP_R_HAND
	name = "right hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = BP_R_ARM
	joint = "right wrist"
	amputation_point = "right wrist"


/obj/item/organ/external/tail
	organ_tag = BP_TAIL
	name = "tail"
	icon_name = "tail"
	body_part = TAIL
	parent_organ = BP_GROIN
	joint = "coccyx"
	amputation_point = "hip"
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE | ORGAN_FLAG_CAN_STAND
	max_damage = 90
	min_broken_damage = 50
	w_class = ITEM_SIZE_HUGE
	base_miss_chance = 20
	limb_height = new /vector2(0,1)	//Assuming a tail on a humanoid, extends from waist to floor
	defensive_group = null