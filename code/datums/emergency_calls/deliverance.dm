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

	if(!leader)
		leader = H
		dressup_human(H, /decl/hierarchy/outfit/deacon)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the Unitologist squad.</span></p>")
		return

	if(specials_outfits)
		var/k = pick(specials_outfits)
		specials_outfits -= k
		dressup_human(H, k)
		return

	dressup_human(H, /decl/hierarchy/outfit/berserker)
	to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of the Unitologist squad.</span></p>")