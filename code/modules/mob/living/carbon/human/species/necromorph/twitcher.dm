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
/datum/species/necromorph/slasher/twitcher
	name = SPECIES_NECROMORPH_TWITCHER
	mob_type	=	/mob/living/carbon/human/necromorph/twitcher
	name_plural = "Twitchers"
	blurb = "An elite soldier displaced in time, blinks around randomly and is difficult to hit. Charges extremely quickly"
	icon_template = 'icons/mob/necromorph/48x48necros.dmi'
	icon_normal = "twitcher"
	icon_lying = "twitcher"
	icon_dead = "twitcher"
	single_icon = TRUE

	biomass	=	150


	slowdown = 1.5
	view_offset = 3 * WORLD_ICON_SIZE //Forward view offset allows longer-ranged charges


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

//Setup the twitch extension which handles a lot of the special behaviour
/datum/species/necromorph/slasher/twitcher/add_inherent_verbs(var/mob/living/carbon/human/H)
	.=..()
	set_extension(H, /datum/extension/twitch)




//Twitcher charge
//Aside from being faster moving, it also kicks off with a shortrange teleport, and has a much lower cooldown
/mob/living/carbon/human/proc/twitcher_charge(var/atom/A)
	set name = "Charge"
	set category = "Abilities"


	.= charge_attack(A, _delay = 1.3 SECONDS, _speed = 6, _cooldown = 6 SECONDS)
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

			var/vector2/delta = new /vector2(A.x - x, A.y - y)
			delta = delta.ToMagnitude(3)
			var/turf/blink_target = locate(x+delta.x, y+delta.y, z)
			if (blink_target)
				var/datum/extension/twitch/T = get_extension(src, /datum/extension/twitch)
				T.move_to(blink_target, speed = 12)



/mob/living/carbon/human/proc/twitcher_step_strike(var/atom/A)
	set name = "Step Strike"
	set category = "Abilities"


	.= step_strike_ability(A, _distance = 2, _cooldown = 3 SECONDS)
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
	H.set_traumatic_sight(TRUE, 5) //All necrmorphs are scary. Some are more scary than others though