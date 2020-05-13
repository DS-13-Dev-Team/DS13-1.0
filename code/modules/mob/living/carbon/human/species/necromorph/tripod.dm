#define LEAP_SHOCKWAVE_DAMAGE	10
#define LEAP_CONE_DAMAGE	10
#define LEAP_CONE_WEAKEN	2
#define LEAP_REDUCED_COOLDOWN	3 SECONDS
/datum/species/necromorph/tripod
	name = SPECIES_NECROMORPH_TRIPOD
	mob_type	=	/mob/living/carbon/human/necromorph/tripod
	name_plural =  "Tripods"
	blurb = "A heavy skirmisher, the tripod is adept at leaping around open spaces and fighting against multiple distant targets."
	total_health = 400
	torso_damage_mult = 1 //Hitting centre mass is fine for tripod

	icon_template = 'icons/mob/necromorph/tripod.dmi'
	icon_lying = "_lying"
	pixel_offset_x = -54
	single_icon = FALSE

	plane = LARGE_MOB_PLANE
	layer = LARGE_MOB_LAYER

	biomass = 350
	mass = 200
	biomass_reclamation_time	=	15 MINUTES


	//Collision and bulk
	strength    = STR_VHIGH
	mob_size	= MOB_LARGE
	bump_flag 	= HEAVY	// What are we considered to be when bumped?
	push_flags 	= ALLMOBS	// What can we push?
	swap_flags 	= ALLMOBS	// What can we swap place with?
	evasion = 0	//Tripod has no natural evasion, but this value will be constantly modified by a passive ability

	//Implacable
	stun_mod = 0.5
	weaken_mod = 0.3
	paralysis_mod = 0.3


	inherent_verbs = list(/mob/living/carbon/human/proc/tripod_leap, /mob/proc/shout)
	modifier_verbs = list(
	KEY_CTRLALT = list(/mob/living/carbon/human/proc/tripod_leap))


	unarmed_types = list(/datum/unarmed_attack/punch/tripod)

	slowdown = 6 //Note, this is a terribly awful way to do speed, bay's entire speed code needs redesigned

	//Vision
	view_range = 12


	has_limbs = list(
	BP_CHEST =  list("path" = /obj/item/organ/external/chest/giant),
	BP_L_ARM =  list("path" = /obj/item/organ/external/arm/giant),
	BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/giant)
	)

	locomotion_limbs = list(BP_R_ARM, BP_L_ARM)

	has_organ = list(    // which required-organ checks are conducted.
	BP_HEART =    /obj/item/organ/internal/heart/undead,
	BP_LUNGS =    /obj/item/organ/internal/lungs/undead,
	BP_BRAIN =    /obj/item/organ/internal/brain/undead/torso,
	BP_EYES =     /obj/item/organ/internal/eyes/torso
	)

	//Audio
	/*
	step_volume = 10 //Tripod stomps are low pitched and resonant, don't want them loud
	step_range = 4
	step_priority = 5
	pain_audio_threshold = 0.03 //Gotta set this low to compensate for his high health
	species_audio = list(SOUND_FOOTSTEP = list('sound/effects/footstep/tripod_step_1.ogg',
	'sound/effects/footstep/tripod_step_2.ogg',
	'sound/effects/footstep/tripod_step_3.ogg',
	'sound/effects/footstep/tripod_step_4.ogg',
	'sound/effects/footstep/tripod_step_5.ogg',
	'sound/effects/footstep/tripod_step_6.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/tripod/tripod_pain_1.ogg',
	 'sound/effects/creatures/necromorph/tripod/tripod_pain_2.ogg',
	 'sound/effects/creatures/necromorph/tripod/tripod_pain_3.ogg',
	 'sound/effects/creatures/necromorph/tripod/tripod_pain_extreme.ogg' = 0.2),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/tripod/tripod_death.ogg'),
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/tripod/tripod_attack_1.ogg',
	'sound/effects/creatures/necromorph/tripod/tripod_attack_2.ogg',
	'sound/effects/creatures/necromorph/tripod/tripod_attack_3.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/tripod/tripod_shout_1.ogg',
	'sound/effects/creatures/necromorph/tripod/tripod_shout_2.ogg',
	'sound/effects/creatures/necromorph/tripod/tripod_shout_3.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/tripod/tripod_shout_long.ogg')
	)
	*/


#define TRIPOD_PASSIVE_1	"<h2>PASSIVE: Personal Space:</h2><br>\
The tripod needs room to manoeuvre. For each clear tile within 2 radius around it, the tripod gains bonus evasion, up to a maximum of 35 if standing in a completely open space."

#define TRIPOD_PASSIVE_2	"<h2>PASSIVE: Cadence:</h2><br>\
The tripod is capable of a great top speed, but its huge mass requires some time to start moving. Tripod gains bonus movespeed for each tile it moves in the same direction, up to double speed after moving 5 tiles.<br>\
This speed bonus is lost if you stop moving in a straight line"


#define TRIPOD_LEAP_DESC	"<h2>High Leap:</h2><br>\
<h3>Hotkey: Ctrl+Alt+Click </h3><br>\
<h3>Cooldown: 6 seconds</h3><br>\
The tripod's signature ability. Leaps high into the air and briefly out of view, before landing hard at the designated spot. <br>\
Deals a small amount of damage to victims in a 1 tile radius around the landing point, and additional damage+knockdown to a cone shaped area infront of the tripod as it lands"


#define TRIPOD_SWING_DESC 	"<h2>High Leap:</h2><br>\
<h3>Hotkey: Ctrl+Alt+Click </h3><br>\
<h3>Cooldown: 6 seconds</h3><br>"

#define TRIPOD_TONGUE_DESC "<h2>Slam:</h2><br>\
<h3>Hotkey: Alt Click</h3><br>\
<h3>Cooldown: 3 seconds</h3><br>\
The tripod's signature move. Slam causes the user to rear back over 1.25 seconds, and then smash down in a devastating hit. The resulting strike hits a 3x2 area of effect infront of the user.<br>\
Mobs hit by slam will take up to 40 damage depending on distance, and will be knocked down. This damage is doubled if the victim was already lying down when hit, making it an excellent finishing move<br>\
<br>\
Slam deals massive damage to any objects caught in its radius, making it an excellent obstacle-clearing ability. It will easily break through doors, barricades, machinery, girders, windows, etc. With repeated uses and some patience, you can even dig your way through solid walls, creating new paths<br>\
Slam is heavily telegraphed, and hard to land hits with. Don't count on reliably hitting humans with it if they have any space to dodge"

#define TRIPOD_DEATHKISS_DESC "<h2>Curl:</h2><br>\
<h3>Hotkey: Ctrl+Shift+Click</h3><br>\
The user curls up into a ball, attempting to shield their vulnerable parts from damage, but becoming unable to turn, move or attack. While curled up, the strength of the tripod's organic armor is massively increased (75% more!) and its coverage is increased to 100%<br>\
This causes the tripod to be practically invincible to attacks from the front and side, however the rear is still completely undefended.<br>\
Tripod will be forced into a reflexive curl under certain circumstances, but it can also be used manually. With the right timing, you can tank an entire firing squad while they waste ammo and deal no damage to you, leaving them vulnerable for your allies to attack from another angle."

/datum/species/necromorph/tripod/get_ability_descriptions()
	.= ""
	. += TRIPOD_PASSIVE_1
	. += "<hr>"
	. += TRIPOD_PASSIVE_2
	. += "<hr>"
	. += TRIPOD_LEAP_DESC
	. += "<hr>"
	. += TRIPOD_SWING_DESC
	. += "<hr>"
	. += TRIPOD_TONGUE_DESC
	. += "<hr>"
	. += TRIPOD_DEATHKISS_DESC


/*--------------------------------
	Cadence
--------------------------------*/
/datum/species/necromorph/tripod/setup_movement(var/mob/living/carbon/human/H)
	.=..()
	set_extension(H, /datum/extension/cadence/tripod)



/datum/extension/cadence/tripod
	max_speed_buff = 2.5
	max_steps = 6


/*--------------------------------
	Evasion
--------------------------------*/
/datum/species/necromorph/tripod/setup_defense(var/mob/living/carbon/human/H)
	.=..()
	set_extension(H, /datum/extension/tripod_evasion)

/*
	Tripod punch, heavy damage, slow
*/
/datum/unarmed_attack/punch/tripod
	name = "Claw Strike"
	desc = "A powerful punch that hits like a truck. Human-sized creatures will be sent flying and stunnned. Deals massive damage to airlocks and structures."
	delay = 18
	damage = 16
	airlock_force_power = 3
	airlock_force_speed = 1.5
	structure_damage_mult = 1.25	//Slightly annoys obstacles
	shredding = TRUE //Better environment interactions, even if not sharp
	edge = TRUE


/*--------------------------------
	Leap
--------------------------------*/
/mob/living/carbon/human/proc/tripod_leap(var/atom/target)
	set name = "High Leap"
	set desc = "Leaps to a target location, dealing damage around the landing point, and knockdown in a frontal cone"
	set category = "Abilities"

	high_leap_ability(target, windup_time = 0.8 SECOND, winddown_time = 0.8 SECOND, cooldown = 6 SECONDS, minimum_range = 3, travel_speed = 5.25)

/datum/species/necromorph/tripod/high_leap_impact(var/mob/living/user, var/atom/target, var/distance)

	//The leap impact deals two burst of damage.

	//Firstly, to mobs within 1 tile of us
	new /obj/effect/effect/expanding_circle(user.loc, -0.65, 0.5 SECONDS)
	for (var/mob/living/L in range(1, user))
		if (L == user)
			continue

		shake_camera(src,8,2)

		L.take_overall_damage(LEAP_SHOCKWAVE_DAMAGE)

	var/vector2/direction = Vector2.FromDir(user.dir)

	var/conehit = FALSE

	//Secondly, to mobs in a frontal cone
	new /obj/effect/effect/forceblast/tripod(user.loc, 0.65 SECOND, direction.Rotation())
	spawn(1.5)
		new /obj/effect/effect/forceblast/tripod(user.loc, 0.65 SECOND, direction.Rotation())
	spawn(3)
		new /obj/effect/effect/forceblast/tripod(user.loc, 0.75 SECOND, direction.Rotation())
	for (var/turf/T as anything in get_cone(user.loc, direction, 3, 80))
		for (var/mob/living/L in T)
			if (L == user)
				continue

			L.take_overall_damage(LEAP_CONE_DAMAGE)
			L.Weaken(LEAP_CONE_WEAKEN)
			shake_camera(src,10,3)
			conehit = TRUE

	if (conehit)
		//If we managed to hit any mob with the cone, we get rewarded with half cooldown on the leap
		var/datum/extension/high_leap/E = get_extension(user, /datum/extension/high_leap)
		if (E)
			E.cooldown = LEAP_REDUCED_COOLDOWN


/obj/effect/effect/forceblast/tripod
	color = "#EE0000"
	max_length = 4

/datum/species/necromorph/tripod/make_scary(mob/living/carbon/human/H)
	//H.set_traumatic_sight(TRUE, 5) //All necrmorphs are scary. Some are more scary than others though