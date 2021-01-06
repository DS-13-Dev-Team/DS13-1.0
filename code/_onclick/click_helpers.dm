/*
	Is the user currently holding down the left mouse button?
	We check the first click handler to see

	This isn't entirely foolproof, since mouseup events may not register outside the map window
*/
/mob/proc/left_mouse_down()
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()

	var/datum/click_handler/CH = click_handlers.Pop()
	if (CH)
		return CH.left_mousedown

	return FALSE