/*
	Arm

	Leaps onto mobs and latches on. Can also wallrun
*/
/mob/living/simple_animal/necromorph/divider_component/arm
	name = "arm"
	icon_state = "arm"
	icon_living = "arm"
	icon_dead = list("arm_dead_1", "arm_dead_2")
	speed = 2.25
	melee_damage_lower = 2
	melee_damage_upper = 4
	attacktext = "scratched"
	attack_sound = 'sound/weapons/bite.ogg'
	leap_range = 5
	health = 30

	pain_sounds = list('sound/effects/creatures/necromorph/divider/component/arm_pain_1.ogg',
	'sound/effects/creatures/necromorph/divider/component/arm_pain_2.ogg',
	'sound/effects/creatures/necromorph/divider/component/arm_pain_3.ogg')

	attack_sounds = list('sound/effects/creatures/necromorph/divider/component/arm_attack_1.ogg',
	'sound/effects/creatures/necromorph/divider/component/arm_attack_2.ogg',
	'sound/effects/creatures/necromorph/divider/component/arm_attack_3.ogg',
	'sound/effects/creatures/necromorph/divider/component/arm_attack_4.ogg',
	'sound/effects/creatures/necromorph/divider/component/arm_attack_5.ogg')

	leap_state = "arm_leap"
	attack_state = "arm_attack"


/mob/living/simple_animal/necromorph/divider_component/arm/Initialize()
	.=..()
	set_extension(src, /datum/extension/wallrun)

/mob/living/simple_animal/necromorph/divider_component/arm/charge_impact(var/datum/extension/charge/leap/charge)
	shake_camera(charge.user,5,3)
	.=TRUE
	if (isliving(charge.last_obstacle))
		//Lets make mount parameters for posterity. We're just using the default settings at time of writing, but maybe they'll change in future
		var/datum/mount_parameters/WP = new()
		WP.attach_walls	=	FALSE	//Can this be attached to wall turfs?
		WP.attach_anchored	=	FALSE	//Can this be attached to anchored objects, eg heaving machinery
		WP.attach_unanchored	=	FALSE	//Can this be attached to unanchored objects, like janicarts?
		WP.dense_only = FALSE	//If true, only sticks to dense atoms
		WP.attach_mob_standing		=	TRUE		//Can this be attached to mobs, like brutes?
		WP.attach_mob_downed		=	TRUE	//Can this be/remain attached to mobs that are lying down?
		WP.attach_mob_dead	=	FALSE	//Can this be/remain attached to mobs that are dead?
		charge.do_winddown_animation = FALSE
		mount_to_atom(src, charge.last_obstacle, /datum/extension/mount/parasite/arm, WP)
	..()





//The divider arm has an additional effect, the target is steered around randomly
/datum/extension/mount/parasite/arm/Process()
	.=..()
	if (.)
		var/mob/living/victim = mountpoint
		victim.lurch()


/client/verb/arm_and_dummy()
	var/mob/arm = new /mob/living/simple_animal/necromorph/divider_component/arm(mob.loc)
	new /mob/living/carbon/human/dummy(mob.loc)

	arm.key = key