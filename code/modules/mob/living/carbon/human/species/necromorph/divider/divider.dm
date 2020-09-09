/datum/species/necromorph/divider
	name = SPECIES_NECROMORPH_DIVIDER
	name_plural =  "Dividers"
	mob_type = /mob/living/carbon/human/necromorph/divider
	blurb = "A bizarre walking horrorshow, slow but extremely durable. On death, it splits into five smaller creatures, in an attempt to find a new body to control"
	unarmed_types = list(/datum/unarmed_attack/claws/strong) //Bite attack is a backup if blades are severed
	total_health = 200
	biomass = 150
	mass = 120

	view_range = 9//The world looks small from up here

	biomass_reclamation_time	=	12 MINUTES

	icon_template = 'icons/mob/necromorph/divider.dmi'
	icon_lying = null
	lying_rotation = 90
	pixel_offset_x = -8
	single_icon = FALSE
	evasion = 0	//No natural evasion
	spawner_spawnable = TRUE



	//hud_type = /datum/hud_data/necromorph/divider

	/*
	species_audio = list(
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/divider/divider_attack_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_attack_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_attack_3.ogg',
	'sound/effects/creatures/necromorph/divider/divider_attack_4.ogg',
	'sound/effects/creatures/necromorph/divider/divider_attack_5.ogg',
	'sound/effects/creatures/necromorph/divider/divider_attack_6.ogg',
	'sound/effects/creatures/necromorph/divider/divider_attack_7.ogg'),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/divider/divider_death_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_death_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_death_3.ogg',
	'sound/effects/creatures/necromorph/divider/divider_death_4.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/divider/divider_pain_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_pain_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_pain_3.ogg',
	'sound/effects/creatures/necromorph/divider/divider_pain_4.ogg',
	'sound/effects/creatures/necromorph/divider/divider_pain_5.ogg',
	'sound/effects/creatures/necromorph/divider/divider_pain_6.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/divider/divider_shout_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_3.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_4.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/divider/divider_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_3.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_4.ogg'),
	SOUND_SPEECH = list('sound/effects/creatures/necromorph/divider/divider_speech_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_speech_2.ogg')
	)
	*/

	slowdown = 3.5

	inherent_verbs = list(/mob/living/carbon/human/proc/divider_divide, /mob/proc/shout)
	modifier_verbs = list(KEY_CTRLSHIFT = list(/mob/living/carbon/human/proc/divider_divide),
	KEY_CTRLALT = list(/mob/living/carbon/human/proc/divider_tongue))



/*
	Division
*/
/mob/living/carbon/human/proc/divider_divide()
	set category = "Abilities"
	set name = "Divide"

	if (stat == DEAD)
		return

	facedir(SOUTH)
	Stun(9999)
	//Fall over
	spawn(1.5 SECONDS)
		if (!lying)
			Weaken(99)

		sleep(0.5 SECONDS)

		var/datum/species/necromorph/divider/D = species
		if (istype(D))
			D.divide(src)

/datum/species/necromorph/divider/handle_amputated(var/mob/living/carbon/human/H, var/obj/item/organ/external/E, var/clean, var/disintegrate, var/ignore_children, var/silent)
	//If the limb is cut uncleanly with an edge, then its gonna fly, so we'll give it a window to finish flying then create the mob where it lands
	if (disintegrate == DROPLIMB_EDGE && !clean)
		spawn(20)
			E.create_divider_component(H, deletion_delay = 0)
		return

	else
		//If its a different type of cut, the limb is about to be deleted, we've got to get in there first, right now

		//We create the limb right here
		var/mob/living/L = E.create_divider_component(H, deletion_delay = 1 SECOND)

		//And then throw the newly created creature
		L.throw_at(pick(trange(3, H)), speed = (BASE_THROW_SPEED / 2))


/datum/species/necromorph/divider/handle_death(var/mob/living/carbon/human/H) //Handles any species-specific death events (such as dionaea nymph spawns).
	divide(H)
	.=..()


//Called on death or when using the ability manually. Disconnects all limbs
/datum/species/necromorph/divider/proc/divide(var/mob/living/carbon/human/H)
	H.facedir(SOUTH)
	for (var/limbtype in list(BP_HEAD, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG))
		var/obj/item/organ/external/E = H.get_organ(limbtype)
		if (istype(E) && !E.is_stump())
			E.droplimb(TRUE, DROPLIMB_EDGE, FALSE, FALSE, H)






/*
	Limb Code
*/
/obj/item/organ/external
	var/divider_component_type = /mob/living/simple_animal/necromorph/divider_component/arm


/obj/item/organ/external/proc/create_divider_component(var/mob/living/carbon/human/H, var/deletion_delay = 0)
	var/mob/living/simple_animal/necromorph/divider_component/L = new divider_component_type(get_turf(src))

	//Turning into a component deletes the organ, but let it finish execution first, make it invisible in the meantime
	alpha = 0
	spawn(deletion_delay)
		if (!QDELETED(src))
			qdel(src)
	return L





