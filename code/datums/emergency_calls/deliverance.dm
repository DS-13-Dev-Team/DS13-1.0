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

	var/mob/original = M.current
	var/mob/living/carbon/human/H = .

	M.transfer_to(H, TRUE)
	if(original)
		qdel(original)

	GLOB.actor.add_antagonist(M, TRUE, FALSE, do_not_announce = FALSE)

	print_backstory(H)

	var/decl/hierarchy/outfit/ertfit = new /decl/hierarchy/outfit/berserker
	if(!leader)
		leader = H
		ertfit = new /decl/hierarchy/outfit/deacon
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the Unitologist squad.</span></p>")
		return

	if(medics < max_medics)
		ertfit = new /decl/hierarchy/outfit/healer
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the Unitologist squad.</span></p>")
		medics++
		return

	if(enginers < max_enginers)
		ertfit = new /decl/hierarchy/outfit/mechanic
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the Unitologist squad.</span></p>")
		enginers++
		return

	dressup_human(H, ertfit)
	to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of the Unitologist squad.</span></p>")