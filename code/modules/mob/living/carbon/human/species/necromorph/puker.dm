#define PUKER_SNAPSHOT_RANGE	6
/datum/species/necromorph/puker
	name = SPECIES_NECROMORPH_PUKER
	name_plural = "pukers"
	total_health = 200
	biomass = 130
	mass = 120
	view_range = 9
	limb_health_factor = 1.15
	icon_template = 'icons/mob/necromorph/puker.dmi'
	icon_lying = "_lying"
	pixel_offset_x = -8
	single_icon = FALSE
	blurb = "A tanky and flexible elite who is effective at all ranges. Good for crowd control and direct firefights,"
	unarmed_types = list(/datum/unarmed_attack/claws/puker)

	vision_organ = null	//Acid has long since burned out its eyes, somehow the puker sees without them

	mob_type = /mob/living/carbon/human/necromorph/puker

	inherent_verbs = list(/mob/living/proc/puker_snapshot, /mob/living/proc/puker_longshot, /mob/living/carbon/human/proc/puker_vomit, /mob/proc/shout, /mob/proc/shout_long)
	modifier_verbs = list(KEY_MIDDLE = list(/mob/living/proc/puker_snapshot),
	KEY_ALT = list(/mob/living/proc/puker_longshot),
	KEY_CTRLALT = list(/mob/living/carbon/human/proc/puker_vomit))

	//Slightly faster than a slasher
	slowdown = 3
	/*
	species_audio = list(
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/puker/puker_attack_1.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_2.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_3.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_4.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_5.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_6.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_7.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_8.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_9.ogg',
	'sound/effects/creatures/necromorph/puker/puker_attack_extreme.ogg' = 0.2),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/puker/puker_death_1.ogg',
	'sound/effects/creatures/necromorph/puker/puker_death_2.ogg',
	'sound/effects/creatures/necromorph/puker/puker_death_3.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/puker/puker_pain_1.ogg',
	'sound/effects/creatures/necromorph/puker/puker_pain_2.ogg',
	'sound/effects/creatures/necromorph/puker/puker_pain_3.ogg',
	'sound/effects/creatures/necromorph/puker/puker_pain_4.ogg',
	'sound/effects/creatures/necromorph/puker/puker_pain_5.ogg',
	'sound/effects/creatures/necromorph/puker/puker_pain_6.ogg',
	'sound/effects/creatures/necromorph/puker/puker_pain_7.ogg',
	'sound/effects/creatures/necromorph/puker/puker_pain_8.ogg',
	'sound/effects/creatures/necromorph/puker/puker_pain_extreme.ogg' = 0.2,
	'sound/effects/creatures/necromorph/puker/puker_pain_extreme_2.ogg' = 0.2),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/puker/puker_shout_1.ogg',
	'sound/effects/creatures/necromorph/puker/puker_shout_2.ogg',
	'sound/effects/creatures/necromorph/puker/puker_shout_3.ogg',
	'sound/effects/creatures/necromorph/puker/puker_shout_4.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/puker/puker_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/puker/puker_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/puker/puker_shout_long_3.ogg',
	'sound/effects/creatures/necromorph/puker/puker_shout_long_4.ogg',
	'sound/effects/creatures/necromorph/puker/puker_shout_long_5.ogg'),
	SOUND_SPEECH = list('sound/effects/creatures/necromorph/puker/puker_speech_1.ogg',
	'sound/effects/creatures/necromorph/puker/puker_speech_2.ogg',
	'sound/effects/creatures/necromorph/puker/puker_speech_3.ogg',
	'sound/effects/creatures/necromorph/puker/puker_speech_4.ogg',
	'sound/effects/creatures/necromorph/puker/puker_speech_5.ogg')
	)
	*/
/*
	Unarmed Attacks
*/
//Weaker version of slasher blades
//Light claw attack, not its main means of damage
/datum/unarmed_attack/claws/puker
	damage = 7


/*
	Snapshot fires a highly accurate projectile which autoaims at a nearby target.
	It has low damage and a limited range, but is almost certain to hit. Making it very consistent damage and easily useable in a chaotic fight
*/
/mob/living/proc/puker_snapshot(var/atom/A)
	set name = "Snapshot"
	set category = "Abilities"
	set desc = "A moderate-strength projectile that auto-aims at targets within [PUKER_SNAPSHOT_RANGE] range. HK: Middleclick"

	//If the user tried to fire at something out of range, change the target to their turf. This will block firing unless a valid mob is found in range
	if (get_dist(src, A) > PUKER_SNAPSHOT_RANGE)
		A = get_turf(A)

	//If the target isn't a living mob (including if we just changed it to not be) then we attempt to find a valid enemy mob in range
	if (!isliving(A))
		A = autotarget_enemy_mob(A, 17, src, PUKER_SNAPSHOT_RANGE)

	if (!isliving(A))
		to_chat(src, SPAN_WARNING("No valid targets found within [PUKER_SNAPSHOT_RANGE] range"))
		return FALSE

	face_atom(A)
	.= shoot_ability(/datum/extension/shoot/snapshot, A , /obj/item/projectile/bullet/acid/puker_snap, accuracy = 150, dispersion = 0, num = 1, windup_time = 0, fire_sound = null, nomove = 1 SECOND, cooldown = 3 SECONDS)
	if (.)
		play_species_audio(src, SOUND_ATTACK, VOLUME_MID, 1, 3)


/*
	Longshot fires an unguided accurate projectile with no range limits and good damage.
	It can be difficult to land on a moving target
*/
/mob/living/proc/puker_longshot(var/atom/A)
	set name = "Long shot"
	set category = "Abilities"
	set desc = "A powerful projectile for longrange shooting. HK: Alt+Click"

	face_atom(A)
	.= shoot_ability(/datum/extension/shoot/longshot, A , /obj/item/projectile/bullet/acid/puker_long, accuracy = 150, dispersion = 0, num = 1, windup_time = 0.5 SECONDS, fire_sound = null, nomove = 1 SECOND, cooldown = 1 SECONDS)
	if (.)
		play_species_audio(src, SOUND_ATTACK, VOLUME_MID, 1, 3)


/mob/living/carbon/human/proc/puker_vomit(var/atom/A)
	set name = "Vomit"
	set category = "Abilities"
	set desc = "A powerful projectile for longrange shooting. HK: Alt+Click"

	if (!can_spray())
		return
	face_atom(A)
	var/vangle = 70
	var/vlength = 5
	if (!has_organ(BP_HEAD))
		to_chat(src, SPAN_WARNING("Without a mouth to focus it, the pressure of your acid is reduced!"))
		vangle = 100
		vlength = 2.5
	play_species_audio(src, SOUND_SHOUT, VOLUME_MID, 1, 3)
	.= spray_ability(A , angle = vangle, length = vlength, chemical = /datum/reagent/acid/necromorph, volume = 4, tick_delay = 0.2 SECONDS, stun = TRUE, duration = 3.5 SECONDS, cooldown = 12 SECONDS, windup = 1 SECOND)





//Snapshot projectile. Lower damage, limited range
/obj/item/projectile/bullet/acid/puker_snap
	icon_state = "acid_small"
	damage = 17.5
	step_delay = 1.25
	kill_count = PUKER_SNAPSHOT_RANGE


//Longshot projectile. Good damage, no range limits, slower moving
/obj/item/projectile/bullet/acid/puker_long
	name = "acid blast"
	icon_state = "acid_large"
	step_delay = 1.75
	damage = 35


/*
	Acid Blood
*/
/mob/living/proc/puker_acidblood()
	var/target = pick(view(1, src))	//Pick literally anything as target, it doesnt matter. We just need something to avoid runtimes
	var/datum/extension/spray/defensive/S = set_extension(src, /datum/extension/spray/defensive, target,
	360, //Angle
	1.5, //Range
	/datum/reagent/acid/necromorph, //Chem
	15, //Volume
	0.1, //Tickdelay
	FALSE,	//Stun
	0.8 SECOND,	//Duration
	0)//Cooldown
	S.start()

/datum/extension/spray/defensive
	flags = EXTENSION_FLAG_IMMEDIATE | EXTENSION_FLAG_MULTIPLE_INSTANCES	//This version is allowed


/datum/species/necromorph/puker/handle_amputated(var/mob/living/carbon/human/H,var/obj/item/organ/external/E, var/clean, var/disintegrate, var/ignore_children, var/silent)
	H.puker_acidblood()

#undef PUKER_SNAPSHOT_RANGE