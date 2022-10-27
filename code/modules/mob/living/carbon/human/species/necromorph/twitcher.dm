/*
	The Twitcher
	Subtype of slasher. A slasher created from someone who was wearing a stasis module
	They're slightly out of phase with time or something like that

	Fastest necro in the game.
	Same power as a slasher, but faster all around

	Unique Features:
		-Charge attack starts with shortrange blink
		-Defensive blink to dodge one attack, every 5 seconds
		-Random blink while walking

	Note: Blink = reallyfast movement that looks like teleporting
*/

#define TWITCHER_DODGE_EVASION	72
#define TWITCHER_DODGE_DURATION	1.8 SECONDS

/datum/species/necromorph/slasher/twitcher
	name = SPECIES_NECROMORPH_TWITCHER
	mob_type	=	/mob/living/carbon/human/necromorph/twitcher
	name_plural = "Twitchers"
	blurb = "An elite soldier displaced in time, blinks around randomly and is difficult to hit. Charges extremely quickly"
	icon_template = 'icons/mob/necromorph/twitcher.dmi'
	icon_lying = "_lying"
	single_icon = FALSE
	spawner_spawnable = FALSE
	virus_immune = 1
	biomass	=	150
	require_total_biomass	=	BIOMASS_REQ_T2
	lying_rotation = 90
	total_health = 110
	damage_mask = null

	slowdown = 1.5

	override_limb_types = list(
	BP_L_ARM =  /obj/item/organ/external/arm/blade,
	BP_R_ARM =  /obj/item/organ/external/arm/blade/right,
	)

	evasion = 20
	inherent_verbs = list(/mob/living/carbon/human/proc/twitcher_charge, /mob/living/carbon/human/proc/twitcher_step_strike, /mob/proc/shout)
	modifier_verbs = list(KEY_MIDDLE = list(/mob/living/carbon/human/proc/twitcher_step_strike),
	KEY_CTRLALT = list(/mob/living/carbon/human/proc/twitcher_charge))

	var/blink_damage_mult = 0.20 	//When the twitcher dodges an attack, the incoming damage is multiplied by this value

	step_priority = 1	//We'll play our footstep sounds on hard surfaces only
	step_volume = VOLUME_NEAR_SILENT
	species_audio = list(
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/twitcher/twitcher_attack_1.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_attack_2.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_attack_3.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_attack_4.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_attack_5.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_attack_6.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_attack_7.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_attack_8.ogg'),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/twitcher/twitcher_death_1.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_death_2.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_death_3.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_death_4.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/twitcher/twitcher_pain_1.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_2.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_3.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_4.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_5.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_6.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_7.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_8.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_9.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_pain_extreme.ogg' = 0.2),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/twitcher/twitcher_shout_1.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_shout_2.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_shout_3.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_shout_4.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_shout_5.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/twitcher/twitcher_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_shout_long_3.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_shout_long_4.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_shout_long_5.ogg'),
	SOUND_SPEECH = list('sound/effects/creatures/necromorph/twitcher/twitcher_speech_1.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_speech_2.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_speech_3.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_speech_4.ogg',
	'sound/effects/creatures/necromorph/twitcher/twitcher_speech_5.ogg'),
	SOUND_FOOTSTEP = list('sound/effects/footstep/twitcher_footstep_1.ogg',
	'sound/effects/footstep/twitcher_footstep_2.ogg',
	'sound/effects/footstep/twitcher_footstep_3.ogg',
	'sound/effects/footstep/twitcher_footstep_4.ogg')
	)

	special_step_sounds = list(
		'sound/effects/footstep/twitcher_footstep_1.ogg',
		'sound/effects/footstep/twitcher_footstep_2.ogg',
		'sound/effects/footstep/twitcher_footstep_3.ogg',
		'sound/effects/footstep/twitcher_footstep_4.ogg'
	)

	lowest_money_drop = 4000
	highest_money_drop = 5000

	variants = null
	outfits = null

#define TWITCHER_PASSIVE	"<h2>PASSIVE: Temporal Displacement:</h2><br>\
The twitcher is out of phase with normal time as a result of a stasis module embedded in their body. This causes them to randomly displace in a random direction periodically while moving<br>\
\
When hit by any attack, a defensive effect triggers, that attack deals 75% less damage, and the twitcher blinks one tile in a random direction. <br>\
This defensive effect has a cooldown of 3 seconds."


#define TWITCHER_CHARGE_DESC	"<h2>Charge:</h2><br>\
<h3>Hotkey: Ctrl+Alt+Click </h3><br>\
<h3>Cooldown: 6 seconds</h3><br>\
The user screams for a few seconds, teleports 2 tiles towards the target, then runs the rest of the distance towards the target at extreme speed. If they successfully hit the target, they deal two free melee attacks on impact.<br>\
Charge has some autoaim, clicking within 1 tile of a living mob is enough to target them. It will also attempt to home in on targets, but will not path around obstacles<br>\
If the user hits a solid obstacle while charging, they will be stunned and take some minor damage. The obstacle will also be hit hard, and destroyed in some cases. <br>\
<br>\
Charge is a great move to initiate a fight, or to damage obstacles blocking your path. If you manage to land that first hit on a human, it is devastating, and often fatal."


#define TWITCHER_STEPSTRIKE_DESC "<h2>Step Strike:</h2><br>\
<h3>Hotkey: Middle Click</h3><br>\
<h3>Cooldown: 3 seconds</h3><br>\
The user teleports up to 2 tiles towards a nearby enemy, and then deals a free melee attack to them.<br>\
This ability is completely autoaimed, picking a random target, and always moving to a new position even if the target is already in reach. Naturally, this constant movement makes the user hard to shoot at.<br>\
Step strike puts your melee attack on cooldown, but it can still be used if your attack is already cooling. So for optimal damage output, use it immediately after landing a normal hit.<br>\

All of these properties combined make Step Strike tricky and disorienting to use, but when used properly, the twitcher is a master close combatant"

/datum/species/necromorph/slasher/twitcher/get_ability_descriptions()
	.= ""
	. += TWITCHER_PASSIVE
	. += "<hr>"
	. += TWITCHER_CHARGE_DESC
	. += "<hr>"
	. += TWITCHER_STEPSTRIKE_DESC



//Setup the twitch extension which handles a lot of the special behaviour
/datum/species/necromorph/slasher/twitcher/add_inherent_verbs(var/mob/living/carbon/human/H)
	.=..()
	set_extension(H, /datum/extension/twitch)


/datum/species/necromorph/slasher/twitcher/oracle
	name = SPECIES_NECROMORPH_TWITCHER_ORACLE
	mob_type	=	/mob/living/carbon/human/necromorph/twitcher/oracle
	name_plural = "Twitchers"
	blurb = "Extremely rare twitcher variant achieved by infecting an oracle operative."
	icon_template = 'icons/mob/necromorph/twitcher_oracle.dmi'
	biomass	=	320
	require_total_biomass	=	BIOMASS_REQ_T3
	layer = LARGE_MOB_LAYER
	biomass_reclamation_time	=	14 MINUTES
	total_health = 210
	limb_health_factor = 1 //This can't be too low thanks to evasion.
	burn_mod = 1.1

	slowdown = 1.2
	strength    = STR_VHIGH
	mob_size	= MOB_LARGE
	bump_flag 	= HEAVY	// What are we considered to be when bumped?
	push_flags 	= ALLMOBS	// What can we push?
	swap_flags 	= ALLMOBS	// What can we swap place with?

	unarmed_types = list(/datum/unarmed_attack/blades/oracle, /datum/unarmed_attack/bite/strong)

	override_limb_types = list(
	BP_L_ARM =  /obj/item/organ/external/arm/blade,
	BP_R_ARM =  /obj/item/organ/external/arm/blade/right,
	)

	evasion = 30
	inherent_verbs = list(/mob/living/carbon/human/proc/twitcher_charge, /mob/living/carbon/human/proc/twitcher_step_strike_oracle, /mob/proc/shout, /mob/living/proc/oracle_dodge)
	modifier_verbs = list(KEY_MIDDLE = list(/mob/living/carbon/human/proc/twitcher_step_strike_oracle),
	KEY_ALT = list(/mob/living/proc/oracle_dodge),
	KEY_CTRLALT = list(/mob/living/carbon/human/proc/twitcher_charge))

	blink_damage_mult = 0.15 	//When the twitcher dodges an attack, the incoming damage is multiplied by this value

/datum/unarmed_attack/blades/oracle // Fast and deadly thanks to the armor penetration
	damage = 13
	delay = 7
	airlock_force_power = 3
	armor_penetration = 10

/datum/species/necromorph/slasher/twitcher/oracle/add_inherent_verbs(var/mob/living/carbon/human/H)
	.=..()
	var/datum/extension/twitch/twitch = get_extension(H, /datum/extension/twitch)
	twitch.defensive_displace_cooldown = 2 SECONDS

/mob/living/proc/oracle_dodge()
	set name = "Dodge"
	set category = "Abilities"


	.= dodge_ability(_duration = TWITCHER_DODGE_DURATION, _cooldown = 8 SECONDS, _power = TWITCHER_DODGE_EVASION) //similar to enhanced slasher, only slightly longer duration, for a much longer cooldown

/datum/species/necromorph/slasher/twitcher/oracle/get_ability_descriptions()
	.= ""
	. += TWITCHER_PASSIVE
	. += "<hr>"
	. += TWITCHER_CHARGE_DESC
	. += "<hr>"
	. += TWITCHER_STEPSTRIKE_DESC
	. += "<hr>"
	. += SLASHER_DODGE_DESC

//Twitcher charge
//Aside from being faster moving, it also kicks off with a shortrange teleport, and has a much lower cooldown
/mob/living/carbon/human/proc/twitcher_charge(var/mob/living/A)
	set name = "Charge"
	set category = "Abilities"

	//Charge autotargets enemies within one tile of the clickpoint
	if (!isliving(A))
		A = autotarget_enemy_mob(A, 2, src, 999)


	.= charge_attack(A, _delay = 1.3 SECONDS, _speed = 7, _cooldown = 6 SECONDS)
	if (.)
		face_atom(A)
		//Long shout when targeting mobs, normal when targeting objects
		if (ismob(A))
			play_species_audio(src, SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 3)
		else
			play_species_audio(src, SOUND_SHOUT, VOLUME_HIGH, 1, 3)
		shake_animation(30)
		spawn(13)
			if (!(A && (isturf(A.loc) || isturf(A)) && src && isturf(src.loc) && can_continue_charge()))
				//Safety checks
				return

			//Lets teleport up to 3 spaces towards the target just as we start running, to scare them
			if (get_dist(src, A) <= 2)
				return	//Can't do this if we're too close

			var/vector2/delta = get_new_vector(A.x - x, A.y - y)
			var/magnitude = 3
			delta.SelfToMagnitude(magnitude)
			var/turf/blink_target = locate(x+delta.x, y+delta.y, z)
			while(blink_target)
				if(!check_trajectory(blink_target, src, pass_flags|PASS_FLAG_TABLE|PASS_FLAG_NOMOB))
					if(magnitude)
						delta.SelfToMagnitude(magnitude)
						blink_target = locate(x+delta.x, y+delta.y, z)
						--magnitude
					else
						release_vector(delta)
						return
				else
					break
			if (blink_target)
				var/datum/extension/twitch/T = get_extension(src, /datum/extension/twitch)
				T.move_to(blink_target, speed = 12)

			release_vector(delta)



/mob/living/carbon/human/proc/twitcher_step_strike(var/atom/A)
	set name = "Step Strike"
	set category = "Abilities"


	.= step_strike_ability(A, _distance = 2, _cooldown = 4 SECONDS)
	if (.)
		play_species_audio(src, SOUND_ATTACK, VOLUME_MID, 1, 3)

/mob/living/carbon/human/proc/twitcher_step_strike_oracle(var/atom/A)
	set name = "Step Strike"
	set category = "Abilities"


	.= step_strike_ability(A, _distance = 1, _cooldown = 3 SECONDS)
	if (.)
		play_species_audio(src, SOUND_ATTACK, VOLUME_MID, 1, 3)

//Defensive blinking
//The twitcher will dodge one attack every 5 secs or so, greatly reducing its damage and moving to a nearby tile
/datum/species/necromorph/slasher/twitcher/handle_organ_external_damage(var/obj/item/organ/external/organ, brute, burn, damage_flags, used_weapon)
	var/mob/living/L = organ.owner
	var/datum/extension/twitch/T = get_extension(L, /datum/extension/twitch)
	if (T && T.displace(TRUE))
		//Displace will return false if its on cooldown
		brute *= blink_damage_mult
		burn *= blink_damage_mult

	return ..()

/datum/species/necromorph/slasher/twitcher/make_scary(mob/living/carbon/human/H)
	//H.set_traumatic_sight(TRUE, 5) //All necrmorphs are scary. Some are more scary than others though