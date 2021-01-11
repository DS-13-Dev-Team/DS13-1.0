/datum/emergency_call/usm
	name = "USM Valor Marine"
	pref_name = "EDF Marine"
	weigh = 25
	landmark_tag = "edfteam"
	specials_outfits = list(/decl/hierarchy/outfit/edf_engie, /decl/hierarchy/outfit/edf_medic)

/datum/emergency_call/usm/print_backstory(mob/living/carbon/human/H)
	to_chat(H, "<B>You are USM Valor Marine EarthGov.</b>")
	to_chat(H, "")
	to_chat(H, "<B>Follow any orders directly from EarthGov Central Command.</b>")

/datum/emergency_call/usm/create_member(datum/mind/M)
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

	var/decl/hierarchy/outfit/ertfit = new /decl/hierarchy/outfit/edf_grunt
	if(!leader)
		leader = H
		ertfit = new /decl/hierarchy/outfit/edf_commander
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the elite Asset Protection commando squad.</span></p>")
		return

	if(specials_outfits)
		ertfit = pick(specials_outfits)
		specials_outfits -= ertfit
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of the elite Asset Protection commando squad.</span></p>")
		return

	dressup_human(H, ertfit)
	to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of the elite Asset Protection commando squad.</span></p>")