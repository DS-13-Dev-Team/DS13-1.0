/datum/emergency_call/kellionteam
	name = "Kellionteam"
	pref_name = "CEC Repair Crew"
	weight = 1
	landmark_tag = "kellionteam"
	antag_id = "Kellionteam"

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

	GLOB.kellion.add_antagonist(M, 1, 0, 0)
	print_backstory(H)
