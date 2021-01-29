/datum/emergency_call/usm
	name = "USM Valor Marine"
	pref_name = "EDF Marine"
	weight = 25
	landmark_tag = "edfteam"

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

	M.transfer_to(H, TRUE)
	if(original)
		qdel(original)

	GLOB.usm.add_antagonist(M, 1, 0, 0)
	print_backstory(H)
