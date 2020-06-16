//DO NOT INCLUDE THIS FILE
//ITs here as a template for abilites to copypaste

//retractable_cover
//Retractable Cover
//retracting
///atom
/datum/extension/retractable_cover
	name = "Retractable Cover"
	base_type = /datum/extension/retractable_cover
	expected_type = /atom
	flags = EXTENSION_FLAG_IMMEDIATE

	var/status
	var/mob/living/user
	var/power = 1
	var/cooldown = 1 SECOND
	var/duration = 1 SECOND

	var/started_at
	var/stopped_at

	var/ongoing_timer


	//A list of organ tags to retract when we close the cover
	var/list/retract_limbs
	var/cover

	var/close_time = 1 SECOND
	var/open_time = 1 SECOND

	var/open = FALSE


/datum/extension/retractable_cover/New(var/atom/_user, var/cover, var/list/limbs)
	.=..()
	if (isliving(_user))
		user = _user
	retract_limbs = limbs
	src.cover = cover












/*
	Closing
*/
/datum/extension/retractable_cover/proc/start_closing()

	if (user)
		user.extra_move_cooldown(close_time)
		user.add_click_cooldown(close_time)
	sleep(close_time)
	close()

/datum/extension/retractable_cover/proc/close()
	open = FALSE
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		for (var/organ_tag in retract_limbs)
			var/obj/item/organ/external/E = H.get_organ(organ_tag)
			if (istype(E))

				E.retracted = TRUE

		H.update_body(TRUE)






/*
	Opening
*/
/datum/extension/retractable_cover/proc/start_opening()
	if (user)
		user.extra_move_cooldown(open_time)
		user.add_click_cooldown(open_time)
	sleep(open_time)
	open()

/datum/extension/retractable_cover/proc/open()
	open = TRUE
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		for (var/organ_tag in retract_limbs)
			var/obj/item/organ/external/E = H.get_organ(organ_tag)
			if (istype(E))
				E.retracted = FALSE

		H.update_body(TRUE)



/***********************
	Safety Checks
************************/
//Access Proc


/atom/proc/can_toggle_cover(var/error_messages = TRUE)
	return TRUE

/mob/living/can_toggle_cover(var/error_messages = TRUE)
	if (incapacitated())
		return FALSE

	.=..()