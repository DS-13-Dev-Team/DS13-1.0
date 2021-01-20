GLOBAL_DATUM_INIT(ert, /datum/antagonist/ert, new)

/datum/antagonist/ert
	id = MODE_ERT
	role_text = "ERT"
	role_text_plural = "ERT"
	valid_species = list(SPECIES_HUMAN)
	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	var/decl/hierarchy/outfit/ertfit
	var/members_types = list()

/datum/antagonist/ert/equip(mob/living/carbon/human/player)
	if(!..())
		return FALSE
	if(!ertfit)
		return FALSE
	dressup_human(player, ertfit)
	return TRUE