/datum/emergency_call/deliverance
	name = "Unitologist"
	pref_name = "Unitologist Missionary"
	weigh = 25
	landmark_tag = "unitologiststeam"

/datum/emergency_call/deliverance/print_backstory(mob/living/carbon/human/H)
	to_chat(H, "<B>You are Unitologist.</b>")
	to_chat(H, "")
	to_chat(H, "<B>Follow any orders directly from Unitologist Central Command.</b>")

/datum/emergency_call/deliverance/create_member(datum/mind/M)
	. = ..()
	if(!.)
		return

	M.ert_role = name
	var/mob/original = M.current
	var/mob/living/carbon/human/H = .

	M.transfer_to(H, TRUE)
	if(original)
		qdel(original)

	spawn(1)
		var/newname = sanitize(input(H, "You are a ERT. Would you like to change your name to something else?", "Name change") as null|text, MAX_NAME_LEN)
		if (newname)
			H.real_name = newname
			H.SetName(H.real_name)
			if(H.dna)
				H.dna.real_name = newname
		M.name = H.name

	spawn(3)
		H.change_appearance(APPEARANCE_ALL, H.loc, H, SPECIES_HUMAN, state = GLOB.z_state)

	print_backstory(H)

	var/decl/hierarchy/outfit/ertfit = new /decl/hierarchy/outfit/berserker
	if(!leader)
		leader = H
		ertfit = new /decl/hierarchy/outfit/deacon
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the Unitologist squad.</span></p>")
		return

	if(specs < max_specs)
		ertfit = new /decl/hierarchy/outfit/faithful
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the specialist of the Unitologist squad.</span></p>")
		specs++
		return

	if(medics < max_medics)
		ertfit = new /decl/hierarchy/outfit/healer
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the medic of the Unitologist squad.</span></p>")
		medics++
		return

	if(enginers < max_enginers)
		ertfit = new /decl/hierarchy/outfit/mechanic
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the engineer of the Unitologist squad.</span></p>")
		enginers++
		return

	dressup_human(H, ertfit)
	to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of the Unitologist squad.</span></p>")