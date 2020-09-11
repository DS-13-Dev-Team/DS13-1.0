//This is called in human_attackhand.dm
/mob/living/carbon/human/proc/grab(var/mob/living/target)
	world << "human grab"
	return species.attempt_grab(src, target)


/datum/species/proc/attempt_grab(var/mob/living/carbon/human/grabber, var/atom/movable/target, var/grab_type)
	grabber.visible_message("<span class='danger'>[grabber] attempted to grab \the [target]!</span>")
	return grabber.make_grab(grabber, target, grab_type)




//Procs involved with making a grab
/mob/living/carbon/human
	var/current_grab_type 	// What type of grab they use when they grab someone. This should be a typepath, an instance of it will be created


/mob/living/carbon/human/proc/make_grab(var/mob/living/carbon/human/attacker, var/mob/living/victim, var/grab_tag)
	var/obj/item/grab/G
	world << "Human make grab"
	if(!grab_tag)
		G = new attacker.current_grab_type(attacker, victim)
	else
		var/obj/item/grab/given_grab_type = all_grabobjects[grab_tag]
		G = new given_grab_type(attacker, victim)

	if(!G.pre_check())
		qdel(G)
		return FALSE

	if(G.can_grab() && G.init())
		return G
	else
		qdel(G)
		return FALSE






/obj/item/grab/proc/can_grab()

	// can't grab non-carbon/human/'s
	if(!istype(affecting))
		return FALSE

	if(assailant.anchored || affecting.anchored)
		return FALSE

	if(!assailant.Adjacent(affecting))
		return FALSE

	if (!assailant.can_pull(affecting))
		return FALSE

	/*
	var/datum/species/S = assailant.get_species_datum()
	if (S && !S.can_pickup)
		return FALSE	//You need to be able to pick things up to hold a grab object
	*/
	for(var/obj/item/grab/G in affecting.grabbed_by)
		if(G.assailant == assailant && G.target_zone == target_zone)
			var/obj/O = G.get_targeted_organ()
			if (O)
				to_chat(assailant, "<span class='notice'>You already grabbed [affecting]'s [O.name].</span>")
			else
				to_chat(assailant, "<span class='notice'>You already grabbed [affecting].</span>")
			return FALSE

	return TRUE



/*
	Helper Procs
*/

//Attempts to grab with any available arm
/mob/living/carbon/human/proc/grab_with_any_limb(var/mob/living/target)
	var/hands_tried = list()

	//If we've already tried the currently selected hand, we have failed, quit
	while (!(hand in hands_tried))



		//Result will be false if grab fails.
		//If successful it will be a grab object
		var/result = grab(target)

		//If a positive result was returned we have succeeded
		if (result)
			return result

		else
			//Well that failed, add it to the list of failures
			hands_tried |= hand

			//lets switch hands and try another
			swap_hand()

	//If we get here, all of our hands were unable to grab the target
	return FALSE