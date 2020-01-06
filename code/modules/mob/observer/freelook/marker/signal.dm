/mob/observer/eye/signal
	name = "Signal"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"

	movement_handlers = list(
		/datum/movement_handler/mob/incorporeal/eye
	)


//This will have a mob passed in that we were created from
/mob/observer/eye/signal/New(var/mob/body)
	..()
	visualnet = GLOB.necrovision	//Set the visualnet of course



	var/turf/T = get_turf(body)
	if(ismob(body))
		key = body.key
		possess(src) //Possess thyself
		if(body.mind && body.mind.name)
			name = body.mind.name
		else
			if(body.real_name)
				name = body.real_name
			else
				if(gender == MALE)
					name = capitalize(pick(GLOB.first_names_male)) + " " + capitalize(pick(GLOB.last_names))
				else
					name = capitalize(pick(GLOB.first_names_female)) + " " + capitalize(pick(GLOB.last_names))

		mind = body.mind	//we don't transfer the mind but we keep a reference to it.

	forceMove(T)


/mob/observer/eye/signal/master
	icon = 'icons/mob/eye.dmi'
	icon_state = "AI-eye"


//Joining and leaving
//-------------------------------
/mob/observer/ghost/verb/join_marker_verb()
	set name = "Join Necromorphs"
	set category = "Necromorph"
	set desc = "Joins the necromorph team, and allows you to control horrible creatures."

	var/response = alert(src, "Would you like to join the necromorph side?", "Make us whole again", "Yes", "No")
	if (!response || response == "No")
		return

	join_marker()	//This cannot fail, do safety checks first

	qdel(src)



/mob/proc/join_marker()
	var/mob/observer/eye/signal/S = new(src)
	return S
