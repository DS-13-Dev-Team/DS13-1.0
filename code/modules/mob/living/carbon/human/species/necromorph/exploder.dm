/*
	Exploder variant, the most common necromorph. Has an additional pair of arms with scything blades on the end
*/

#define EXPLODER_DODGE_EVASION	60
#define EXPLODER_DODGE_DURATION	1.5 SECONDS

/datum/species/necromorph/exploder
	name = SPECIES_NECROMORPH_EXPLODER
	name_plural =  "Exploders"
	mob_type = /mob/living/carbon/human/necromorph/exploder
	blurb = "An expendable suicide bomber, the exploder's sole purpose is to go out in a blaze of glory, and hopefully take a few people with it."
	unarmed_types = list(/datum/unarmed_attack/bite/weak) //Bite attack is a backup if blades are severed
	total_health = 85
	biomass = 40
	mass = 50

	biomass_reclamation_time	=	3 MINUTES

	icon_template = 'icons/mob/necromorph/slasher.dmi'
	icon_lying = "_lying"
	pixel_offset_x = -8
	single_icon = FALSE
	evasion = 10	//Awkward movemetn makes it a tricky target
	spawner_spawnable = TRUE

	override_limb_types = list(
	BP_L_HAND =  /obj/item/organ/external/arm/blade,
	)

	/*
	species_audio = list(
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/exploder/exploder_attack_1.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_attack_2.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_attack_3.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_attack_4.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_attack_5.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_attack_6.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_attack_7.ogg'),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/exploder/exploder_death_1.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_death_2.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_death_3.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_death_4.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/exploder/exploder_pain_1.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_pain_2.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_pain_3.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_pain_4.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_pain_5.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_pain_6.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/exploder/exploder_shout_1.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_shout_2.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_shout_3.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_shout_4.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/exploder/exploder_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_shout_long_3.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_shout_long_4.ogg'),
	SOUND_SPEECH = list('sound/effects/creatures/necromorph/exploder/exploder_speech_1.ogg',
	'sound/effects/creatures/necromorph/exploder/exploder_speech_2.ogg')
	)
	*/

	slowdown = 3.75

	inherent_verbs = list(/atom/movable/proc/exploder_charge, /mob/living/carbon/human/proc/exploder_explode, /mob/proc/shout)
	modifier_verbs = list(KEY_CTRLALT = list(/atom/movable/proc/exploder_charge),
	KEY_CTRLSHIFT = list(/mob/living/carbon/human/proc/exploder_explode))


#define EXPLODER_PASSIVE	"<h2>PASSIVE: Explosive Pustule:</h2><br>\
The Exploder's left hand is a massive pustule full of flammable chemicals, which can create a devastating explosion when triggered.<br>\
The pustule is very fragile, and can be detonated by a fairly minor quantity of damage aimed at it, so it is vitally important to avoid gunfire while approaching enemies.<br>\
<br>\
The pustule does NOT automatically detonate on death, and if the exploder's left arm is severed, the pustule can fall off without exploding."

#define EXPLODER_CHARGE_DESC	"<h2>Charge:</h2><br>\
<h3>Hotkey: Ctrl+Alt+Click </h3><br>\
<h3>Cooldown: 20 seconds</h3><br>\
The user screams for a few seconds, then runs towards the target at high speed. If they successfully hit a human, the explosive pustule detonates immediately.<br>\
A successful charge is the most effective and reliable way to detonate. It should be considered the prime goal of the exploder."


#define EXPLODER_EXPLODE_DESC "<h2>Explode:</h2><br>\
<h3>Hotkey: Ctrl+Shift+Click</h3><br>\
The last resort. The exploder screams and shakes violently for 2 seconds, before detonating the pustule.<br>\
 This is quite telegraphed and it can give your victims time to back away before the explosion. Not the most ideal way to detonate, but it can be a viable backup if you fail to hit something with charge."

/datum/species/necromorph/exploder/get_ability_descriptions()
	.= ""
	. += EXPLODER_CHARGE_DESC
	. += "<hr>"
	. += EXPLODER_DODGE_DESC




/*---------------------
	Pustule
---------------------*/
/*
	The exploder's left hand is a giant organic bomb
*/

/obj/item/organ/external/hand/exploder_pustule
	organ_tag = BP_L_HAND
	name = "pustule"
	icon_name = "l_hand"
	max_damage = 15
	min_broken_damage = 15
	w_class = ITEM_SIZE_HUGE
	body_part = HAND_LEFT
	parent_organ = BP_L_ARM
	joint = "left wrist"
	amputation_point = "left wrist"
	tendon_name = "carpal ligament"
	arterial_bleed_severity = 0.5
	limb_flags = ORGAN_FLAG_CAN_AMPUTATE
	base_miss_chance = 5
	var/exploded = FALSE

//A multi-level explosion using a broad variety of cool mechanics
/obj/item/organ/external/hand/exploder_pustule/proc/explode()
	if (exploded)
		return

	exploded = TRUE


	var/turf/T = get_turf(src)
	//A bioblast, dealing some burn and acid damage
	spawn()
		bioblast(epicentre = T,
		power = 60,
		maxrange = 4,
		falloff_factor = 0.3)

	//A normal explosion
	spawn()
		explosion(T, 0, 2, 4, 6)

	//Make sure the pustule is deleted if these explosions don't destroy it
	spawn()
		if (!QDELETED(src))
			qdel(src)

	//If we're still attached to the owner, gib them
	if (owner && loc == owner)
		owner.gib()
		return


/*
	Checks
*/
/datum/species/necromorph/exploder/proc/can_explode(var/mob/living/carbon/human/H)
	.=FALSE
	var/obj/item/organ/external/hand/exploder_pustule/E = H.get_organ(BP_L_HAND)
	if (!E || E.is_stump() || E.exploded || E.owner != H)
		return

	return TRUE


/mob/living/carbon/human/proc/exploder_explode(var/mob/living/A)
	set name = "Explode"
	set category = "Abilities"

	if (incapacitated())
		return

	if (!can_explode(H))
		return


	H.play_species_audio(src, SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 3)
	shake_animation(30)
	sleep(20)

	//Make sure its still there
	if (!can_explode(H))
		return

	var/obj/item/organ/external/hand/exploder_pustule/E = H.get_organ(BP_L_HAND)
	E.explode()	//Kaboom!

/*
	Abilities
*/
/atom/movable/proc/exploder_charge(var/mob/living/A)
	set name = "Charge"
	set category = "Abilities"

	//Charge autotargets enemies within one tile of the clickpoint
	if (!isliving(A))
		A = autotarget_enemy_mob(A, 1, src, 999)


	.= charge_attack(A, _delay = 1 SECONDS, _speed = 5.5, _lifespan = 6 SECONDS)
	if (.)
		var/mob/H = src
		if (istype(H))
			H.face_atom(A)

			//Long shout when targeting mobs, normal when targeting objects
			if (ismob(A))
				H.play_species_audio(src, SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 3)
			else
				H.play_species_audio(src, SOUND_SHOUT, VOLUME_HIGH, 1, 3)
		shake_animation(30)



/*
	Exploders have a special charge impact. They detonate on impact
*/
/datum/species/necromorph/exploder/charge_impact(var/mob/living/charger, var/atom/obstacle, var/power, var/target_type, var/distance_travelled)
	if (target_type == CHARGE_TARGET_PRIMARY && isliving(obstacle))
		//Make sure its still there
		if (!can_explode(charger))
			return



		var/mob/living/L = obstacle
		L.Weaken(3)	//Knock them down
		charger.forceMove(get_turf(obstacle))	//Move ontop of them for maximum damage

		var/obj/item/organ/external/hand/exploder_pustule/E = charger.get_organ(BP_L_HAND)
		E.explode()	//Kaboom!

		return FALSE
	else
		return ..()






//Special death condition: Exploders die when they lose both blade arms
/datum/species/necromorph/exploder/handle_death_check(var/mob/living/carbon/human/H)
	.=..()
	if (!.)
		if (!H.has_organ(BP_L_ARM) && !H.has_organ(BP_R_ARM))
			return TRUE



#undef EXPLODER_DODGE_EVASION
#undef EXPLODER_DODGE_DURATION