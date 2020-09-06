/datum/species/necromorph/divider
	name = SPECIES_NECROMORPH_DIVIDER
	name_plural =  "Dividers"
	mob_type = /mob/living/carbon/human/necromorph/divider
	blurb = "The frontline soldier of the necromorph horde. Slow when not charging, but its blade arms make for powerful melee attacks"
	unarmed_types = list(/datum/unarmed_attack/claws/strong) //Bite attack is a backup if blades are severed
	total_health = 200
	biomass = 150
	mass = 120


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
	modifier_verbs = list(KEY_CTRLSHIFT = list(/mob/living/carbon/human/proc/divider_divide))



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
	var/divider_component_type = /mob/living/simple_animal/divider_component/arm


/obj/item/organ/external/proc/create_divider_component(var/mob/living/carbon/human/H, var/deletion_delay = 0)
	var/mob/living/simple_animal/divider_component/L = new divider_component_type(get_turf(src))

	//Turning into a component deletes the organ, but let it finish execution first, make it invisible in the meantime
	alpha = 0
	spawn(deletion_delay)
		if (!QDELETED(src))
			qdel(src)
	return L





/*
	Component Species

	This is only used for creating a preference option to opt in/out of playing components
	its not actually assigned to anyone
*/
/datum/species/necromorph/divider_component
	name = SPECIES_NECROMORPH_DIVIDER_COMPONENT
	marker_spawnable = FALSE
	spawner_spawnable = FALSE
	preference_settable = TRUE




/*
	Component Mobs
*/
/mob/living/simple_animal/divider_component
	max_health = 35
	icon = 'icons/mob/necromorph/divider/components.dmi'

/mob/living/simple_animal/divider_component/Initialize()
	.=..()
	get_controlling_player()


/mob/living/simple_animal/divider_component/proc/get_controlling_player()
	SSnecromorph.fill_vessel_from_queue(src, SPECIES_NECROMORPH_DIVIDER_COMPONENT)



/*
	Arm

	Leaps onto mobs and latches on
*/
/mob/living/simple_animal/divider_component/arm
	icon_state = "arm"



/*
	Leg
	Kicks mobs and bounces off
*/
/mob/living/simple_animal/divider_component/leg
	icon_state = "leg"


/*
	Head

	The head does not autofill from queue normally, the mob controlling the divider will take over it
*/
//If the divider player is still connected, they transfer control to the head
/obj/item/organ/external/head/create_divider_component(var/mob/living/carbon/human/H, var/deletion_delay)
	.=..()
	var/mob/living/simple_animal/divider_component/L = .
	if (H && H.mind && H.client)
		H.mind.transfer_to(L)

	else
		//If the player can't take control, then we'll fetch someone from necroqueue
		L.get_controlling_player(TRUE)

	//Removing the head kills the divider's main body
	//We do a spawn then some checks here to prevent infinite loops
	spawn(1 SECOND)
		if (!QDELETED(H) && H.stat != DEAD)
			H.death()



/mob/living/simple_animal/divider_component/head
	icon_state = "head"

/mob/living/simple_animal/divider_component/head/get_controlling_player(var/fetch = FALSE)
	if (!fetch)
		return
	.=..()