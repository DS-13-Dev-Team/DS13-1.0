/*
	Sense ability, used by ubermorph
	Detects all nearby living creatures and reveals them to yourself and all nearby allies
*/

/datum/extension/sense
	name = "Sense"
	expected_type = /mob
	flags = EXTENSION_FLAG_IMMEDIATE
	var/list/seen = list()
	var/list/seen_images = list()
	var/list/seers = list()
	var/mob/user

/datum/extension/sense/New(var/mob/holder, var/range_sense, var/range_buff, var/buff_faction, var/duration, var/cooldown)
	..()
	user = holder

	var/list/turfs_buff = trange(user, range_buff)
	var/list/turfs_sense = trange(user, range_sense)
	for (var/mob/living/L in GLOB.living_mobs)
		var/turf/T = get_turf(L)
		if (T in turfs_sense)
			seen += L //We can see this mob
			world << "Seeing [L]"

		if ((!buff_faction || buff_faction == L.faction) && L.client && T in turfs_buff)
			//This mob gets to see
			seers += get_client(L)
			world << "Seer [L]"

	for (var/mob/living/L in seen)
		var/icon/mobicon = getFlatIcon(L)
		var/image/I = image(mobicon, L)
		I.plane = HUD_PLANE
		I.layer = UNDER_HUD_LAYER
		I.appearance_flags = RESET_ALPHA
		seen_images += I

	//Lastly, show it to everyone
	for (var/I in seen_images)
		flick_overlay(I, seers, duration)


	addtimer(CALLBACK(src, /datum/extension/sense/proc/finish_cooldown), cooldown)


/datum/extension/sense/proc/finish_cooldown()
	world << "Sense done cooling"
	remove_extension(holder, /datum/extension/sense)