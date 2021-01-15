/datum/emergency_call/kellionteam
	name = "Kellionteam"
	pref_name = "CEC Repair Crew"
	weigh = 50
	landmark_tag = "kellionteam"
	specials_outfits = list(/decl/hierarchy/outfit/isaac, /decl/hierarchy/outfit/kendra)

/datum/emergency_call/kellionteam/print_backstory(mob/living/carbon/human/H)
	to_chat(H, "<B> You are part of the Kellion Repair Team.</b>")
	to_chat(H, "")
	to_chat(H, "<B>Follow any orders directly from CEC Headquarters.</b>")

/datum/emergency_call/kellionteam/create_member(datum/mind/M)
	. = ..()
	if(!.)
		return

	var/mob/original = M.current
	var/mob/living/carbon/human/H = .

	M.transfer_to(H, TRUE)
	if(original)
		qdel(original)

	GLOB.actor.add_antagonist(M, TRUE, FALSE, do_not_announce = FALSE, preserve_appearance = FALSE)
	H.change_appearance(APPEARANCE_ALL_HAIR|APPEARANCE_GENDER|APPEARANCE_SKIN, H.loc, H, SPECIES_HUMAN, state = GLOB.z_state)

	print_backstory(H)

	var/decl/hierarchy/outfit/ertfit = new /decl/hierarchy/outfit/kellion_sec
	if(!leader)
		leader = H
		ertfit = new /decl/hierarchy/outfit/kellion_sec_leader
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of squad.</span></p>")
		return

	if(specials_outfits)
		ertfit = new(pick_n_take(specials_outfits))
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of squad.</span></p>")
		return

	dressup_human(H, ertfit)
	to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of squad.</span></p>")
