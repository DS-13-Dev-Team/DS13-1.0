/*
	A necrohatch is a simple arrow on the ground which can be used to exit a spawning area
*/
/obj/effect/necrohatch
	name = "Necrohatch"
	icon = 'icons/effects/effects.dmi'
	icon_state = "green_arrow"
	var/turf/epicentre


/obj/effect/necrohatch/Initialize()
	.=..()
	//Lets get the epicentre
	var/vector2/offset = Vector2.NewFromDir(dir)
	var/vector2/offset_delta = offset.Copy()
	for (var/i in 1 to 5)
		var/turf/T = get_turf_at_offset(offset)
		if (turf_clear(T))
			epicentre = T
			break
		offset.SelfAdd(offset_delta)


	release_vector(offset)
	release_vector(offset_delta)
	if (!epicentre)
		crash_with("Error, necrohatch unable to find landing spot at [jumplink(src)]")
		return INITIALIZE_HINT_QDEL



/obj/effect/necrohatch/attack_hand(var/mob/user)
	var/response = tgui_alert(user,"Would you like to leave this spawning area?","Leave Spawn Confirmation", list("Send me out","Not Yet"))
	if (response != "Send me out")
		return
	transport_user(user)


/obj/effect/necrohatch/proc/transport_user(var/mob/user)
	//Must be in area
	if (get_area(user) != get_area(src))
		return

	//Lets give the user a second for their vision to fix before we toss them out
	if (has_extension(user, /datum/extension/spawn_buff))
		remove_extension(user, /datum/extension/spawn_buff)
		sleep(2 SECONDS)

	var/turf/target = get_landing_turf()
	if (target)
		user.forceMove(target)

	transport_fx(user)

/obj/effect/necrohatch/proc/transport_fx(var/mob/user)
	if (istype(user.loc, /turf))
		user.pixel_y += 32
		user.alpha = 0

		user.animate_to_default(0.5 SECONDS)

/obj/effect/necrohatch/proc/get_landing_turf()
	var/list/shortlist = list()
	for (var/turf/T as anything in trange(1, epicentre))
		if (turf_clear(T))
			shortlist += T


	if (shortlist.len)
		return pick(shortlist)

	else
		return null