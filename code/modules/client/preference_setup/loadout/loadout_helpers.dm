/proc/create_loadout_from_preferences(host, datum/preferences/prefs, assume_job = TRUE)
	var/datum/extension/loadout/L = set_extension(host, /datum/extension/loadout)
	L.set_prefs(prefs)

	return L



//Called during character creation, at roundstart and latejoin.
//This assembles a loadout and equips it
/proc/equip_loadout(mob/living/carbon/human/H, jobtitle, datum/preferences/P)
	var/datum/extension/loadout/L = set_extension(H, /datum/extension/loadout)
	L.set_prefs(P)
	L.set_human(H)
	L.set_job(jobtitle)

	//The loadout will do all the necessary preparations from here

	L.equip_to_mob()

	remove_extension(H, /datum/extension/loadout)