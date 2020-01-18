/datum/species/necromorph/ubermorph
	name = SPECIES_NECROMORPH_UBERMORPH
	name_plural =  "Ubermorphs"
	blurb = "A juvenile hivemind. Constantly regenerating, a nigh-immortal leader of the necromorph army. "

	//Health and Defense
	total_health = INFINITY	//This number doesn't matter, it won't ever be used
	can_obliterate = FALSE
	healing_factor = 4	//Lots of constant healing

	icon_template = 'icons/mob/necromorph/ubermorph.dmi'
	single_icon = FALSE
	lying_rotation = 90
	icon_lying = null//Ubermorph doesnt have a lying icon, due to complexity from regen animations
	pixel_offset_x = -16
	plane = LARGE_MOB_PLANE
	layer = LARGE_MOB_LAYER

	unarmed_types = list(/datum/unarmed_attack/claws/ubermorph, /datum/unarmed_attack/bite/strong) //Bite attack is a backup if blades are severed


	override_limb_types = list(
	BP_HEAD =  /obj/item/organ/external/head/ubermorph
	)


	//Collision and bulk
	strength    = STR_VHIGH
	mob_size	= MOB_LARGE
	bump_flag 	= HEAVY	// What are we considered to be when bumped?
	push_flags 	= ALLMOBS	// What can we push?
	swap_flags 	= ALLMOBS	// What can we swap place with?
	evasion = 0	//Big target, easier to shoot

	slowdown = 1.5 //Modest speed, but he has no charge ability

	//Vision
	view_range = 9


	//Audio
	step_volume = VOLUME_MID //Brute stomps are low pitched and resonant, don't want them loud
	step_range = 4
	step_priority = 5
	pain_audio_threshold = 0.03 //Gotta set this low to compensate for his high health
	species_audio = list(SOUND_FOOTSTEP = list('sound/effects/footstep/ubermorph_footstep_1.ogg',
	'sound/effects/footstep/ubermorph_footstep_2.ogg',
	'sound/effects/footstep/ubermorph_footstep_3.ogg',
	'sound/effects/footstep/ubermorph_footstep_4.ogg'),
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/ubermorph/ubermorph_attack_1.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_attack_2.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_attack_3.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_attack_4.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_attack_5.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_attack_6.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_attack_7.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_attack_8.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_1.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_2.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_3.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_4.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_5.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_6.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_7.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_pain_8.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_1.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_2.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_3.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_4.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_5.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_6.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_7.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_8.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_long_3.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_shout_long_4.ogg'),
	SOUND_SPEECH = list('sound/effects/creatures/necromorph/ubermorph/ubermorph_speech_1.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_speech_2.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_speech_3.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_speech_4.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_speech_5.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_speech_6.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_speech_7.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_speech_8.ogg'),
	SOUND_REGEN = list('sound/effects/creatures/necromorph/ubermorph/ubermorph_regen_1.ogg',
	'sound/effects/creatures/necromorph/ubermorph/ubermorph_regen_2.ogg')
	)

	inherent_verbs = list(/mob/living/carbon/human/proc/ubermorph_battlecry, /mob/living/carbon/human/proc/ubermorph_regenerate, /mob/living/carbon/human/proc/ubermorph_lunge, /mob/proc/shout, /mob/proc/sense_verb)
	modifier_verbs = list(KEY_CTRLALT = list(/mob/living/carbon/human/proc/ubermorph_battlecry), KEY_CTRLSHIFT = list(/mob/proc/sense_verb), KEY_ALT = list(/mob/living/carbon/human/proc/ubermorph_lunge))

/datum/species/necromorph/ubermorph/handle_death_check(var/mob/living/carbon/human/H)
	//No
	return FALSE

/*
	Basic attack isn't a huge deal, but its powerful anyway because endgame monster
*/
/datum/unarmed_attack/claws/ubermorph
	damage = 20
	airlock_force_power = 5
	airlock_force_speed = 2.5
	shredding = TRUE //Better environment interactions, even if not sharp

/*
	Regenerate
	Immobilises you for 4 seconds, healing a fair chunk of damage and regrowing a missing limb.
	No cooldown, can be used endlessly, can't be interrupted
	It can't be used again while in progress though, obviously
*/
/mob/living/carbon/human/proc/ubermorph_regenerate()
	set name = "Regenerate"
	set category = "Abilities"
	set desc = "Regrows a missing limb and restores some of your health."

	.= regenerate_ability(_heal_amount = 40, _duration = 4 SECONDS, _max_limbs = 1, _cooldown = 0)
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
	set desc = "Grants a 30% move and attackspeed buff to other nearby necromorphs. Doesn't affect yourself, HK: Ctrl+Alt+Click"

	.=frenzy_shout_ability(60 SECONDS, 0.3, 30 SECONDS, FACTION_NECROMORPH, 9)
	if (.)
		play_species_audio(src, SOUND_SHOUT_LONG, VOLUME_MAX, 1, 6)//Very loud, heard far away
		shake_camera(src, 6, 4)

		//Lets do some cool effects
		var/obj/effect/effect/expanding_circle/EC = new /obj/effect/effect/expanding_circle(loc, 1.5, 1.5 SECOND,"#ff0000")
		EC.pixel_y += 40	//Offset it so it appears to be at our mob's head
		spawn(4)
			EC = new /obj/effect/effect/expanding_circle(loc, 1.5, 1.5 SECOND,"#ff0000")
			EC.pixel_y += 40	//Offset it so it appears to be at our mob's head
			spawn(4)
				EC = new /obj/effect/effect/expanding_circle(loc, 1.5, 1.5 SECOND,"#ff0000")
				EC.pixel_y += 40	//Offset it so it appears to be at our mob's head

/*
	Lunge: A variant of charge used by ubermorph. Short ranged
	On impact, it impales the victim, dealing heavy damage to both an external AND internal organ. It will probably prove fatal

	We completely replace the charge_attack proc, as we have different safety checks
*/
/mob/living/carbon/human/proc/ubermorph_lunge(var/atom/A)
	set name = "Lunge"
	set category = "Abilities"
	set desc = "A shortrange charge which causes heavy internal damage to one victim. Often fatal. HK: Alt+Click:"

	//Check for an existing charge extension. that means a charge is already in progress or cooling down, don't repeat
	var/datum/extension/charge/EC = get_extension(src, /datum/extension/charge/lunge)
	if(istype(EC))
		if (EC.status == CHARGE_STATE_COOLDOWN)
			to_chat(src, "[EC.name] is cooling down. You can use it again in [EC.get_cooldown_time() /10] seconds")
			return
		to_chat(src, "You're already [EC.verb_name]!")
		return FALSE

	var/dist = get_dist(src, A)
	if (dist < 1) //This is changed from <= , A distance of 1 is allowed
		to_chat(src, "You are too close to [A], get some distance first!")
		return FALSE

	if (!has_organ(BP_R_ARM) && !has_organ(BP_L_ARM))
		to_chat(src, SPAN_DANGER("You have no arms to impale [A] with!"))
		return FALSE

	play_species_audio(src, SOUND_SHOUT, VOLUME_MID, 1, 3)
	//Ok we've passed all safety checks, let's commence charging!
	//We simply create the extension on the movable atom, and everything works from there
	set_extension(src, /datum/extension/charge/lunge, /datum/extension/charge/lunge, A, 8, 2 SECONDS, 3, FALSE, TRUE, 1, 0, 0.75 SECONDS)

	return TRUE


//The impale
/datum/species/necromorph/ubermorph/charge_impact(var/mob/living/user, var/atom/obstacle, var/power, var/target_type, var/distance_travelled)
	if (isliving(obstacle))
		var/mob/living/L = obstacle
		.=FALSE	//We won't keep charging after this
		var/targetstring = "[L.name]"


		if (ishuman(L))
			var/mob/living/carbon/human/H = L

			//Lets deal heavy damage to one external organ
			var/obj/item/organ/external/found_organ = H.find_target_organ(user.zone_sel.selecting)

			//Find target organ should never fail, we won't bother checking
			targetstring = "[H]'s [found_organ]"

			//Handle the external damage
			L.apply_damage(30, BRUTE, user.zone_sel.selecting, 0, DAM_SHARP, user, found_organ)

			//Next, we will also deal damage to one internal organ within the target area, if such exists
			var/obj/item/organ/internal/I = safepick(found_organ.internal_organs)

			if (istype(I))
				I.take_internal_damage(30)	//Heavy damage to an internal organ is often fatal. Try surviving this!



		else
			//If its not human, just deal external damage
			L.apply_damage(40, BRUTE, user.zone_sel.selecting, 0, DAM_SHARP, user)

		user.Stun(3, TRUE) //User is stunned for a few seconds, giving some time for a desperate and probably doomed escape attempt
		play_species_audio(user, SOUND_ATTACK, VOLUME_MID, 1, 3)
		user.visible_message(SPAN_DANGER("[user] punches through [targetstring] with an impaling claw"))

	else
		..()



/*
	Sense
*/
/mob/proc/sense_verb()
	set name = "Sense"
	set category = "Abilities"
	set desc = "Reveals nearby living creatures around you, to yourself and allies. HK: Ctrl+Shift+Click"
	var/datum/extension/sense/S = get_extension(src, /datum/extension/sense)
	if (S)
		return
	set_extension(src, /datum/extension/sense, /datum/extension/sense, 9, 9, FACTION_NECROMORPH, 9 SECONDS, 12 SECONDS)
	play_species_audio(src, SOUND_SPEECH, VOLUME_MID, 1, 3)
