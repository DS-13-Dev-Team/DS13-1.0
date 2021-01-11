/datum/emergency_call/kellionteam
	name = "Kellionteam"
	probability = 50
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

	var/choosen = input(M, "Random name or input name?", "Name") as null|anything in list("Random", "Input")
	if(choosen == "Input")
		H.name = input(M, "Input name of character.", "Name") as text
	else
		H.name = pick(GLOB.first_names_female + GLOB.first_names_male) + " " + pick(GLOB.last_names) //Random as default
	H.real_name = H.name

	M.transfer_to(H, TRUE)
	H.fully_replace_character_name(M.name, H.real_name)

	if(original)
		qdel(original)

	print_backstory(H)

	var/decl/hierarchy/outfit/ertfit = new /decl/hierarchy/outfit/kellion_sec
	if(!leader)
		leader = H
		ertfit = new /decl/hierarchy/outfit/kellion_sec_leader
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of squad.</span></p>")
		return

	if(specials_outfits)
		ertfit = pick(specials_outfits)
		specials_outfits -= ertfit
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of squad.</span></p>")
		return

	dressup_human(H, ertfit)
	to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of squad.</span></p>")
