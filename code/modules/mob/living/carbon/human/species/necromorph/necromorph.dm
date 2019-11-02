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
	blood_volume = 0  // Initial blood volume.
	hunger_factor = 0 // Necros don't eat
	taste_sensitivity = 0      // no eat



	death_message = "spasms and falls silent"
	knockout_message = "crumples into a heap"
	halloss_message = "twitches and collapses"
	halloss_message_self = "your limbs spasm violently, pitching you forward onto the ground"



	//Vision
	darksight_range = 5 //Decent dark vision


	//Sprites
	damage_overlays = null
	damage_mask = null

	//Single iconstates. These are somewhat of a hack
	var/icon = "icons/mob/necromorph/48x48necros.dmi"
	var/icon_normal = "slasher_d"
	var/icon_lying = "slasher_d_lying"
	var/icon_dead = "slasher_d_dead"


	//Defense
	total_health = 80
	burn_mod = 1.3	//Takes more damage from burn attacks



	//Breathing and Environment
	warning_low_pressure = 0             // Low pressure warning.
	hazard_low_pressure = 0               // Dangerously low pressure.

	breath_pressure = 0 // does not breathe
	oxy_mod =        0 //No breathing, no suffocation

	//Far better cold tolerance than humans
	cold_level_1 = 200                                      // Cold damage level 1 below this point. -30 Celsium degrees
	cold_level_2 = 140                                      // Cold damage level 2 below this point.
	cold_level_3 = 100                                      // Cold damage level 3 below this point.

	cold_discomfort_level = 220                             // Aesthetic messages about feeling chilly.



	//Interaction
	has_fine_manipulation = FALSE //Can't use most objects

	species_flags = SPECIES_FLAG_NO_PAIN | SPECIES_FLAG_NO_MINOR_CUT          // Various specific features.
	appearance_flags = 0      // Appearance/display related features.
	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN           // Flags that specify who can spawn as this specie


	/* //TODO: Uncomment this once limbs are sorted
	var/list/has_limbs = list(
	BP_CHEST =  list("path" = /obj/item/organ/external/chest),
	BP_GROIN =  list("path" = /obj/item/organ/external/groin),
	BP_HEAD =   list("path" = /obj/item/organ/external/head),
	BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
	BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
	BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
	BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right)
	)
	*/

/datum/species/necromorph/New()
	.=..()
	breathing_organ = null //This is autoset to lungs in the parent if they exist.
	//We want it to be unset but we stil want to have our useless lungs