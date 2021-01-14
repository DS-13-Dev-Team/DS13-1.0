/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/atom/Click(location, control, params) // This is their reaction to being clicked on (standard proc)
	var/datum/stack/click_handlers

	if (usr)
		click_handlers = usr.GetClickHandlers()


		while (click_handlers.Num())
			var/datum/click_handler/CH = click_handlers.Pop()
			if (!CH.OnClick(src, params))
				return

	.=..()

/atom/DblClick(location, control, params)
	var/datum/stack/click_handlers

	if (usr)
		click_handlers = usr.GetClickHandlers()


		while (click_handlers.Num())
			var/datum/click_handler/CH = click_handlers.Pop()
			if (!CH.OnDblClick(src, params))
				return

	.=..()



/*
	Click recieving base procs
	Override these to do special stuff with an atom
*/
/atom/proc/ShiftClick(mob/user)
	if(user.client && user.client.eye == user)
		user.examinate(src)
	return


/atom/proc/CtrlClick(mob/user)
	return



/atom/proc/AltClick(mob/user)
	var/turf/T = get_turf(src)
	if(T && user.TurfAdjacent(T))
		if(user.listed_turf == T)
			user.listed_turf = null
		else
			user.listed_turf = T
			user.client.statpanel = "Turf"
	return 1



/atom/proc/CtrlShiftClick(mob/user)
	return

/atom/proc/CtrlAltClick(mob/user)
	return

/*
	Click recieving overrides
*/


/atom/movable/CtrlClick(mob/user)
	if(user.is_within_reach(src))
		user.start_pulling(src)