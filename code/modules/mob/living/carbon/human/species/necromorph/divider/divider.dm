/datum/species/necromorph/divider
	name = SPECIES_NECROMORPH_DIVIDER
	name_plural =  "Dividers"
	mob_type = /mob/living/carbon/human/necromorph/divider
	blurb = "A bizarre walking horrorshow, slow but extremely durable. On death, it splits into five smaller creatures, in an attempt to find a new body to control"
	unarmed_types = list(/datum/unarmed_attack/claws/strong) //Bite attack is a backup if blades are severed
	total_health = 200
	biomass = 150
	mass = 120

	evasion = -10	//Slow and predictable

	override_limb_types = list(
	BP_HEAD =  list("path" = /obj/item/organ/external/head/simple/divider, "height" = new /vector2(2,2.4)),
	BP_TORSO =  list("path" = /obj/item/organ/external/chest/simple/divider, "height" = new /vector2(1,2))
	)

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


	species_audio = list(
	SOUND_ATTACK = list('sound/effects/creatures/necromorph/divider/divider_attack_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_attack_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_attack_3.ogg'),
	SOUND_DEATH = list('sound/effects/creatures/necromorph/divider/divider_death.ogg'),
	SOUND_PAIN = list('sound/effects/creatures/necromorph/divider/divider_pain_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_pain_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_pain_3.ogg'),
	SOUND_SHOUT = list('sound/effects/creatures/necromorph/divider/divider_shout_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_3.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_4.ogg'),
	SOUND_SHOUT_LONG = list('sound/effects/creatures/necromorph/divider/divider_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_3.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_4.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_5.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_6.ogg'),
	SOUND_SPEECH = list('sound/effects/creatures/necromorph/divider/divider_shout_long_1.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_2.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_3.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_4.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_5.ogg',
	'sound/effects/creatures/necromorph/divider/divider_shout_long_6.ogg')
	)//Since it has so many of them and no speech sounds, the divider uses its long shouts for speech


	species_audio_volume = list(SOUND_SHOUT_LONG = VOLUME_MAX, SOUND_SPEECH = VOLUME_HIGH, SOUND_SHOUT = VOLUME_MID)

	slowdown = 3.5

	inherent_verbs = list(/mob/living/carbon/human/proc/divider_divide, /mob/living/carbon/human/proc/divider_tongue, /mob/proc/shout, /mob/proc/shout_long)
	modifier_verbs = list(KEY_CTRLSHIFT = list(/mob/living/carbon/human/proc/divider_divide),
	KEY_CTRLALT = list(/mob/living/carbon/human/proc/divider_tongue))


#define DIVIDER_PASSIVE_1	"<h2>PASSIVE: Gestalt Being:</h2><br>\
The divider is a colony of smaller creatures working in tandem. <br>\
On death, dismemberment, or manual division, it will split off into its component parts - five in total.<br>\
The original player will control the head component, while four other players will be drawn from the necroqueue to control the arms and legs."

#define DIVIDER_PASSIVE_2	"<h2>PASSIVE: Strange Anatomy:</h2><br>\
The divider has a tiny head atop its huge frame, and its torso has a sizeable hole in it. <br>\
This means that these parts of its body are comparitively much harder to hit with projectile attacks"


#define DIVIDER_TONGUE 	"<h2>Execution: Tonguetacle:</h2><br>\
<h3>Hotkey: Ctrl+Alt+Click </h3><br>\
<h3>Cooldown: 12 seconds</h3><br>\
The divider launches its ropelike prehensile tongue, attempting to latch onto a victim.<br>\
 If it hits a standing humanoid, it will wrap around their neck, rooting them in place as it slowly garottes their throat.<br>\
  The tongue will deal damage over time until it completely severs the neck and decapitates the victim, but it can be interrupted if the divider is knocked down, decapitated, or the tongue itself takes enough damage.<br>\
  <br>\
  The tongue is vulnerable to blades and takes double damage from edged weapons.<br>\
  Tonguetacle is best used on a lone victim who is trying to escape, it is fairly easy for teammates to break them out of it if they aren't alone."



/datum/species/necromorph/divider/get_ability_descriptions()
	.= ""
	. += DIVIDER_PASSIVE_1
	. += "<hr>"
	. += DIVIDER_PASSIVE_2
	. += "<hr>"
	. += TRIPOD_LEAP_DESC
	. += "<hr>"
	. += TRIPOD_SWING_DESC
	. += "<hr>"
	. += TRIPOD_TONGUE_DESC
	. += "<hr>"
	. += TRIPOD_DEATHKISS_DESC



/*
	Division
*/
/mob/living/carbon/human/proc/divider_divide()
	set category = "Abilities"
	set name = "Divide"

	if (stat == DEAD)
		return
	playsound(src, 'sound/effects/creatures/necromorph/divider/divider_split.ogg', VOLUME_LOUD, TRUE)
	facedir(SOUTH)
	root()

	//Fall over
	shake_animation(45)
	spawn(1.25 SECONDS)
		if (!lying)
			Weaken(99)
		shake_animation(45)
		sleep(0.75 SECONDS)

		var/datum/species/necromorph/divider/D = species
		if (istype(D))
			D.divide(src)

/datum/species/necromorph/divider/handle_amputated(var/mob/living/carbon/human/H, var/obj/item/organ/external/E, var/clean, var/disintegrate, var/ignore_children, var/silent)
	//If the limb is cut uncleanly with an edge, then its gonna fly, so we'll give it a window to finish flying then create the mob where it lands
	if (disintegrate == DROPLIMB_EDGE && !clean)
		spawn(20)
			if (!QDELETED(E))
				E.create_divider_component(H, deletion_delay = 0)
		return

	else if (!QDELETED(E))
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
	if (!divider_component_type)
		return FALSE
	var/mob/living/simple_animal/necromorph/divider_component/L = new divider_component_type(get_turf(src))
	divider_component_type = null //This is an efficient way to mark that this organ has already been turned into a mob, and shouldn't do it again
	L.dna = dna


	//Turning into a component deletes the organ, but let it finish execution first, make it invisible in the meantime
	alpha = 0
	spawn(deletion_delay)
		if (!QDELETED(src))
			qdel(src)
	return L




/*
	The divider has a hole in its torso, harder to land hits
*/
/obj/item/organ/external/chest/simple/divider
	base_miss_chance = 35
