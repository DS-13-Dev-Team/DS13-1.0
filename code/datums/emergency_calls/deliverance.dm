/datum/emergency_call/deliverance
	name = "Unitologist"
	pref_name = "Unitologist Missionary"
	weigh = 25
	landmark_tag = "unitologiststeam"
	specials_outfits = list(/decl/hierarchy/outfit/healer, /decl/hierarchy/outfit/mechanic, /decl/hierarchy/outfit/faithful)

/datum/emergency_call/deliverance/print_backstory(mob/living/carbon/human/H)
	to_chat(H, "<B>You are Unitologist.</b>")
	to_chat(H, "")
	to_chat(H, "<B>Follow any orders directly from Unitologist Central Command.</b>")

/datum/emergency_call/deliverance/create_member(datum/mind/M)
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

	var/decl/hierarchy/outfit/ertfit = new /decl/hierarchy/outfit/berserker
	if(!leader)
		leader = H
		ertfit = new /decl/hierarchy/outfit/deacon
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the Unitologist squad.</span></p>")
		return

	if(specials_outfits)
		ertfit = new(pick_n_take(specials_outfits))
		dressup_human(H, ertfit)
		return

	dressup_human(H, ertfit)
	to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of the Unitologist squad.</span></p>")