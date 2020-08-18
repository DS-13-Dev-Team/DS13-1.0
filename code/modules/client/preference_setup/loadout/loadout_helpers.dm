/proc/create_loadout_from_preferences(var/host, var/datum/preferences/prefs, var/assume_job = TRUE)
	var/datum/extension/loadout/L = set_extension(host, /datum/extension/loadout)
	L.set_prefs(prefs)

	return L