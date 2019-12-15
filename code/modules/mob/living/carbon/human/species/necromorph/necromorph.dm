/*
	Base species for necromorphs,. the reanimated organic assemblages of the Dead Space universe

	This datum should probably not be used as is, but instead make subspecies of it for each type of necromorph
*/

/datum/species/necromorph
	name = "Necromorph"
	name_plural =  "Necromorphs"
	blurb = "Mutated and reanimated corpses, reshaped into horrific new forms by a recombinant extraterrestrial infection. \
	The resulting creatures are extremely aggressive and will attack any uninfected organism on sight."


	strength    = STR_HIGH
	show_ssd = "dead" //If its not moving, it looks like a corpse
	hunger_factor = 0 // Necros don't eat
	taste_sensitivity = 0      // no eat



	death_message = ""
	knockout_message = "crumples into a heap"
	halloss_message = "twitches and collapses"
	halloss_message_self = "your limbs spasm violently, pitching you forward onto the ground"



	//Vision
	darksight_range = 5 //Decent dark vision


	//Sprites
	damage_overlays = null
	damage_mask = null
	lying_rotation = 0

	//Single iconstates. These are somewhat of a hack
	var/single_icon = TRUE
	icon_template = 'icons/mob/necromorph/48x48necros.dmi'
	var/icon_normal = "slasher_d"
	icon_lying = "slasher_d_lying"
	var/icon_dead = "slasher_d_dead"

	//Icon details. null out all of these, maybe someday they can be done
	deform 			=   null
	preview_icon 	= 	null
	husk_icon 		=   null
	damage_overlays =   null
	damage_mask 	=   null
	blood_mask 		=   null



	//Biology
	blood_color = COLOR_BLOOD_NECRO
	can_vomit = FALSE

	//Defense
	total_health = 80
	healing_factor = 0	//Necromorphs don't naturally heal, but they will be able to heal through certain situational effects
	wound_remnant_time = 0 //No cuts sitting around forever
	burn_mod = 1.3	//Takes more damage from burn attacks
	blood_oxy = FALSE

	var/list/initial_health_values	//This list is populated once for each species, when a necromorph of that type is created
	//It stores the starting max health values of each limb this necromorph has
	//It is an associative list in the format organ_tag = initial health

	var/torso_damage_mult	=	0.3
	/*
		For the purpose of determining whether or not the necromorph has taken enough damage to be killed:
			Damage to the chest and groin is treated as being multiplied by this,
	*/

	var/dismember_mult = 1.5
	/*
		For the purpose of determining whether or not the necromorph has taken enough damage to be killed:
			A limb which is completely severed counts as its max damage multiplied by this
	*/


	//Breathing and Environment
	warning_low_pressure = 0             // Low pressure warning.
	hazard_low_pressure = 0               // Dangerously low pressure.

	breath_pressure = 0 // does not breathe
	oxy_mod =        0 //No breathing, no suffocation

	//Far better cold tolerance than humans
	body_temperature = null //No thermoregulation, will be the same temp as the environment around it
	cold_level_1 = 200                                      // Cold damage level 1 below this point. -30 Celsium degrees
	cold_level_2 = 140                                      // Cold damage level 2 below this point.
	cold_level_3 = 100                                      // Cold damage level 3 below this point.

	cold_discomfort_level = 220                             // Aesthetic messages about feeling chilly.



	//Interaction
	has_fine_manipulation = FALSE //Can't use most objects
	can_pickup = FALSE	//Can't pickup objects
	species_flags = SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_MINOR_CUT | SPECIES_FLAG_NO_POISON         // Various specific features.
	appearance_flags = 0      // Appearance/display related features.
	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN           // Flags that specify who can spawn as this specie


	//Audio
	step_volume = 60 //Necromorphs can't wear shoes, so their base footstep volumes are louder
	step_range = 1
	pain_audio_threshold = 0.10
	speech_chance = 15


	has_organ = list(    // which required-organ checks are conducted.
	BP_HEART =    /obj/item/organ/internal/heart/undead,
	BP_LUNGS =    /obj/item/organ/internal/lungs/undead,
	BP_LIVER =    /obj/item/organ/internal/liver/undead,
	BP_KIDNEYS =  /obj/item/organ/internal/kidneys/undead,
	BP_BRAIN =    /obj/item/organ/internal/brain,
	BP_EYES =     /obj/item/organ/internal/eyes
	)

	locomotion_limbs = list(BP_L_LEG, BP_R_LEG)

	has_limbs = list(
	BP_CHEST =  list("path" = /obj/item/organ/external/chest/simple),
	BP_HEAD =   list("path" = /obj/item/organ/external/head/simple),
	BP_L_ARM =  list("path" = /obj/item/organ/external/arm/simple),
	BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/simple),
	BP_L_LEG =  list("path" = /obj/item/organ/external/leg/simple),
	BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/simple)
	)


/datum/species/necromorph/New()
	.=..()
	breathing_organ = null //This is autoset to lungs in the parent if they exist.
	//We want it to be unset but we stil want to have our useless lungs


/datum/species/necromorph/get_blood_name()
	return "ichor"

/datum/species/necromorph/get_icobase(var/mob/living/carbon/human/H)
	return icon_template //We don't need to duplicate the same dmi path twice


/datum/species/necromorph/setup_interaction(var/mob/living/carbon/human/H)
	.=..()
	H.a_intent = I_HURT	//Don't start in help intent, we want to kill things
	H.faction = FACTION_NECROMORPH


//We don't want to be suffering for the lack of most particular organs
/datum/species/necromorph/should_have_organ(var/query)
	if (query in list(BP_EYES))	//Expand this list as needed
		return ..()
	return FALSE


//Populate the initial health values
/datum/species/necromorph/create_organs(var/mob/living/carbon/human/H)
	.=..()
	if (!initial_health_values)
		initial_health_values = list()
		for (var/organ_tag in H.organs_by_name)
			var/obj/item/organ/external/E	= H.organs_by_name[organ_tag]
			initial_health_values[organ_tag] = E.max_damage



//Necromorphs die when they've taken enough total damage to all their limbs.
/datum/species/necromorph/handle_death_check(var/mob/living/carbon/human/H)

	var/damage = get_weighted_total_limb_damage(H)
	if (damage >= total_health)
		return TRUE

	return FALSE

//How much damage has this necromorph taken?
//We'll loop through each organ tag in the species' initial health values list, which should definitely be populated already, and try to get the organ for each
	//Any limb still attached, adds its current damage to the total
	//Any limb no longer attached (or stumped) adds its pre-cached max damage * dismemberment mult to the total
	//Any limb which is considered to be a torso part adds its damage, multiplied by the torso mult, to the total
/datum/species/necromorph/proc/get_weighted_total_limb_damage(var/mob/living/carbon/human/H)
	var/total = 0
	if (!initial_health_values)
		return 0 //Not populated? welp

	for (var/organ_tag in initial_health_values)
		var/obj/item/organ/external/E	= H.organs_by_name[organ_tag]
		var/subtotal = 0
		if (!E || E.is_stump())
			//Its not here!
			subtotal = initial_health_values[organ_tag] * dismember_mult
		else
			//Its here
			subtotal = E.damage

		//Is it a torso part?
		if ((E.organ_tag in BP_TORSO))
			subtotal *= torso_damage_mult

		//And now add to total
		total += subtotal

	return total

//Individual necromorphs are identified only by their species
/datum/species/necromorph/get_random_name()
	return src.name

