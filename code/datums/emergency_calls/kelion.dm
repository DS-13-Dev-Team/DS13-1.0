/datum/emergency_call/kellionteam
	name = "Kellionteam"
	pref_name = "CEC Repair Crew"
	weigh = 50
	landmark_tag = "kellionteam"

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

	GLOB.actor.add_antagonist(M, TRUE, FALSE, do_not_announce = FALSE)

	print_backstory(H)

	var/decl/hierarchy/outfit/ertfit = new /decl/hierarchy/outfit/kellion_sec
	if(!leader)
		leader = H
		ertfit = new /decl/hierarchy/outfit/kellion_sec_leader
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of squad.</span></p>")
		return

	if(medics < max_medics)
		ertfit = new /decl/hierarchy/outfit/kendra
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the Unitologist squad.</span></p>")
		medics++
		return

	if(enginers < max_enginers)
		ertfit = new /decl/hierarchy/outfit/isaac
		dressup_human(H, ertfit)
		to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are the leader of the Unitologist squad.</span></p>")
		enginers++
		return

	dressup_human(H, ertfit)
	to_chat(H, "<p style='font-size:1.5em'><span class='notice'>You are a member of squad.</span></p>")
