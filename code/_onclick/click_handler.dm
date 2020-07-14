var/const/CLICK_HANDLER_NONE                 = 0
var/const/CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT = 1
var/const/CLICK_HANDLER_ALL                  = (~0)

/*
	Custom click handling
*/

/mob
	var/datum/stack/click_handlers
	var/has_mousemove_click_handler = FALSE

/mob/Destroy()
	if(click_handlers)
		click_handlers.QdelClear()
		QDEL_NULL(click_handlers)
	. = ..()

//Called when click handlers are added or removed
/mob/proc/update_click_handler_flags()
	has_mousemove_click_handler = FALSE

	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()

	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH.has_mousemove)
			has_mousemove_click_handler = TRUE

/datum/click_handler
	var/mob/user
	var/flags = 0
	var/id	//Used by signal abilities
	var/cursor_override
	var/cached_cursor

	//Flags, used to optimise
	var/has_mousemove = FALSE

/datum/click_handler/New(var/mob/user)
	..()
	src.user = user
	if(flags & (CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT))
		GLOB.logged_out_event.register(user, src, /datum/click_handler/proc/OnMobLogout)
	if (cursor_override && user.client)
		cached_cursor = user.client.mouse_pointer_icon
		user.client.mouse_pointer_icon = cursor_override

/datum/click_handler/Destroy()
	if(flags & (CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT))
		GLOB.logged_out_event.unregister(user, src, /datum/click_handler/proc/OnMobLogout)
	if (cursor_override && user.client)
		user.client.mouse_pointer_icon = cached_cursor

	if (user)
		user.click_handlers.Remove(src)
	user = null
	. = ..()

/datum/click_handler/proc/Enter()
	return

/datum/click_handler/proc/Exit()
	return



/datum/click_handler/proc/OnMobLogout()
	user.RemoveClickHandler(src)

/datum/click_handler/proc/OnClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnMiddleClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnLeftClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnRightClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnDblClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnCtrlClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnAltClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnShiftClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnCtrlAltClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/OnCtrlShiftClick(var/atom/A, var/params)
	return TRUE

/datum/click_handler/proc/MouseDown(object,location,control,params)
	return TRUE

/datum/click_handler/proc/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	return TRUE

/datum/click_handler/proc/MouseUp(object,location,control,params)
	return TRUE

/datum/click_handler/proc/MouseMove(object,location,control,params)
	return TRUE


/datum/click_handler/default/OnClick(var/atom/A, var/params)
	user.ClickOn(A, params)
	return TRUE

/datum/click_handler/default/OnDblClick(var/atom/A, var/params)
	user.DblClickOn(A, params)
	return TRUE

//Tests whether the target thing is valid, and returns it if so.
//If its not valid, null will be returned
//In the case of click catchers, we resolve and return the turf under it
/datum/click_handler/proc/resolve_world_target(var/a, var/params)
	if (params && user && user.client)
		var/b = user.client.resolve_drag(a, params)
		if (a != b)
			return b

		if (istype(a, /obj/screen/click_catcher))
			return RESOLVE_CLICK_CATCHER(params, user.client)

	if (istype(a, /turf))
		return a

	else if (istype(a, /atom))
		var/atom/A = a
		if (istype(A.loc, /turf))
			return A
	return null


/mob/proc/GetClickHandler(var/datum/click_handler/popped_handler)
	if(!click_handlers)
		click_handlers = new()
	if(IS_EMPTY(click_handlers.stack))
		PushClickHandler(/datum/click_handler/default)
	return click_handlers.Top()

/mob/proc/GetClickHandlerByType(var/required_type)
	var/datum/stack/CHL = GetClickHandlers()
	while (CHL.Num())
		var/datum/click_handler/CH = CHL.Pop()
		if (istype(CH, required_type))
			return CH

	return null


/mob/proc/GetClickHandlers()
	if(!click_handlers)
		click_handlers = new()
	if(IS_EMPTY(click_handlers.stack))
		PushClickHandler(/datum/click_handler/default)
	return click_handlers.Copy()

/mob/proc/RemoveClickHandler(var/datum/click_handler/click_handler)
	if(!click_handlers)
		return

	var/was_top = click_handlers.Top() == click_handler

	if(was_top)
		click_handler.Exit()
	click_handlers.Remove(click_handler)
	qdel(click_handler)

	update_click_handler_flags()

	if(!was_top)
		return
	click_handler = click_handlers.Top()
	if(click_handler)
		click_handler.Enter()

/mob/proc/RemoveClickHandlersByType(var/typepath)
	if(!click_handlers)
		return

	for (var/thing in click_handlers.stack)
		if (istype(thing, typepath))
			click_handlers.Remove(thing)
			qdel(thing)

/mob/proc/PopClickHandler()
	if(!click_handlers)
		return
	RemoveClickHandler(click_handlers.Top())

//Extra variables can be passed in here, and they will be propagated through to clickhandler /New
/mob/proc/PushClickHandler(var/datum/click_handler/new_click_handler_type)
	var/list/newarguments = list(src)
	if (length(args) > 1)
		newarguments = newarguments + args.Copy(2)

	if((initial(new_click_handler_type.flags) & CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT) && !client)
		return FALSE
	if(!click_handlers)
		click_handlers = new()
	var/datum/click_handler/click_handler = click_handlers.Top()
	if(click_handler)
		click_handler.Exit()

	click_handler = new new_click_handler_type(arglist(newarguments))
	click_handler.Enter()
	click_handlers.Push(click_handler)

	update_click_handler_flags()

	return click_handler














