/datum/species/necromorph/ubermorph
	name = SPECIES_NECROMORPH_UBERMORPH
	name_plural =  "Ubermorphs"
	blurb = "A juvenile hivemind. Constantly regenerating, a nigh-immortal leader of the necromorph army. "

	//Health and Defense
	total_health = INFINITY	//This number doesn't matter, it won't ever be used
	healing_factor = 3	//Lots of constant healing

	icon_template = 'icons/mob/necromorph/ubermorph.dmi'
	single_icon = FALSE
	lying_rotation = 90
	icon_lying = null//Ubermorph doesnt have a lying icon, due to complexity from regen animations
	pixel_offset_x = -16


	override_limb_types = list(
	BP_HEAD =  /obj/item/organ/external/head/ubermorph
	)


	//Collision and bulk
	strength    = STR_VHIGH
	mob_size	= MOB_LARGE
	bump_flag 	= HEAVY	// What are we considered to be when bumped?
	push_flags 	= ALLMOBS	// What can we push?
	swap_flags 	= ALLMOBS	// What can we swap place with?
	density_lying = TRUE	//Chunky boi
	evasion = -10	//Big target, easier to shoot

	slowdown = 1.5 //Modest speed, but he has no charge ability

	//Vision
	view_range = 9


	//Audio
	step_volume = 10 //Brute stomps are low pitched and resonant, don't want them loud
	step_range = 4
	step_priority = 5
	pain_audio_threshold = 0.03 //Gotta set this low to compensate for his high health
	species_audio = list(SOUND_FOOTSTEP = list('sound/effects/footstep/brute_step_1.ogg',
	'sound/effects/footstep/brute_step_2.ogg',
	'sound/effects/footstep/brute_step_3.ogg',
	'sound/effects/footstep/brute_step_4.ogg',
	'sound/effects/footstep/brute_step_5.ogg',
	'sound/effects/footstep/brute_step_6.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/brute/brute_pain_1.ogg',
	 'sound/effects/creatures/necromorph/brute/brute_pain_2.ogg',
	 'sound/effects/creatures/necromorph/brute/brute_pain_3.ogg',
	 'sound/effects/creatures/necromorph/brute/brute_pain_extreme.ogg' = 0.2),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/brute/brute_death.ogg'),
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/brute/brute_attack_1.ogg',
	'sound/effects/creatures/necromorph/brute/brute_attack_2.ogg',
	'sound/effects/creatures/necromorph/brute/brute_attack_3.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/brute/brute_shout_1.ogg',
	'sound/effects/creatures/necromorph/brute/brute_shout_2.ogg',
	'sound/effects/creatures/necromorph/brute/brute_shout_3.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/brute/brute_shout_long.ogg')
	)

	inherent_verbs = list(/mob/living/carbon/human/proc/ubermorph_battlecry, /mob/living/carbon/human/proc/ubermorph_regenerate, /mob/proc/shout)
	modifier_verbs = list(KEY_CTRLALT = list(/mob/living/carbon/human/proc/ubermorph_battlecry), KEY_CTRLSHIFT = list(/mob/living/carbon/human/proc/ubermorph_regenerate))

/datum/species/necromorph/ubermorph/handle_death_check(var/mob/living/carbon/human/H)
	//No
	return FALSE


/*
	Regenerate
	Immobilises you for 4 seconds, healing a fair chunk of damage and regrowing a missing limb.
	No cooldown, can be used endlessly, can't be interrupted
	It can't be used again while in progress though, obviously
*/
/mob/living/carbon/human/proc/ubermorph_regenerate()
	set name = "Regenerate"
	set category = "Abilities"


	.= regenerate_ability(_heal_amount = 40, _duration = 4 SECONDS, _max_organs = 1, _cooldown = 0)
	if (.)
		play_species_audio(src, SOUND_PAIN, VOLUME_HIGH, 1, 3)


/*
	Battle cry
	Drives necros into a frenzy, increasing their movement and attackspeed.

	Duration is far longer than cooldown, so it has 100% uptime as long as necros stay nearby
	Does not affect yourself, only other allies.
*/
/mob/living/carbon/human/proc/ubermorph_battlecry()
	set name = "Battle Cry"
	set category = "Abilities"

	.=frenzy_shout_ability(30 SECONDS, 0.3, 10 SECONDS, FACTION_NECROMORPH, 9)
	if (.)
		play_species_audio(src, SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 3)
