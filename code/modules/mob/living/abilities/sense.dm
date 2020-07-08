/*
	Sense ability, used by ubermorph
	Detects all nearby living creatures and reveals them to yourself and all nearby allies
*/

/datum/extension/sense
	name = "Sense"
	expected_type = /mob
	flags = EXTENSION_FLAG_IMMEDIATE
	var/list/seen = list()
	var/list/trackers = list()
	var/list/seers = list()
	var/mob/user

/datum/extension/sense/New(var/mob/holder, var/range_sense, var/range_buff, var/buff_faction, var/duration, var/cooldown)
	..()
	user = holder

	var/list/turfs_buff = trange(range_buff, get_turf(user))
	var/list/turfs_sense = trange(range_sense, get_turf(user))
	for (var/mob/living/L in GLOB.living_mob_list)
		if (L.stat == DEAD)
			continue	//Gotta be alive to see or be seen

		var/turf/T = get_turf(L)
		if (T in turfs_sense)
			seen += L //We can see this mob

		//To se things you've got to be:
			//In the correct faction
			//Have a client
			//Near enough to the user
			//Alive and conscious
		if ((!buff_faction || buff_faction == L.faction) && L.client && (T in turfs_buff) && !L.stat)
			//This mob gets to see
			seers += L

	for (var/mob/living/L in seen)
		for (var/mob/living/S in seers)
			if (L == S)
				continue //Don't see yourself
			var/obj/screen/movable/tracker/TR = new (S,L, duration)
			TR.appearance = new /mutable_appearance(L)
			trackers += TR

	addtimer(CALLBACK(src, /datum/extension/sense/proc/finish), duration)

	addtimer(CALLBACK(src, /datum/extension/sense/proc/finish_cooldown), cooldown)

	//Lets do some cool effects
	var/obj/effect/effect/expanding_circle/EC = new /obj/effect/effect/expanding_circle(user.loc, 2, 2 SECOND)
	EC.pixel_y += 40	//Offset it so it appears to be at our mob's head
	spawn(4)
		EC = new /obj/effect/effect/expanding_circle(user.loc, 2, 2 SECOND)
		EC.pixel_y += 40	//Offset it so it appears to be at our mob's head
		spawn(4)
			EC = new /obj/effect/effect/expanding_circle(user.loc, 2, 2 SECOND)
			EC.pixel_y += 40	//Offset it so it appears to be at our mob's head

/datum/extension/sense/proc/finish()
	QDEL_NULL_LIST(trackers)

/datum/extension/sense/proc/finish_cooldown()
	remove_extension(holder, /datum/extension/sense)