var/const/CLICK_HANDLER_NONE                 = 0
var/const/CLICK_HANDLER_REMOVE_ON_MOB_LOGOUT = 1
var/const/CLICK_HANDLER_SUPPRESS_POPUP_MENU = 2
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


/*
	Sets the state of the user's rightclick menu.
	If ANYTHING wants to suppress it, then it is suppressed without argument.
	Otherwise it is available
*/
/mob/proc/update_popup_menu()
	//If theres no client, we can't do anything here
	if (!client)
		return

	var/target_status = TRUE
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()

	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (QDELETED(CH))
			continue
		if ((CH.flags & CLICK_HANDLER_SUPPRESS_POPUP_MENU))
			target_status = FALSE
			//A single false is authoritative, we dont need to check any others
			break

	/* //Future TODO: Check extensions here
	if (target_status == TRUE)

	*/
	client.show_popup_menus = target_status

/datum/click_handler
	var/mob/user
	var/flags = 0
	var/id	//Used by signal abilities
	var/cursor_override
	var/cached_cursor

	//Flags, used to optimise
	var/has_mousemove = FALSE

	//Is the user currently holding down the left mouse button, as far as we know?
	//This isn't used internally, but some external things may check it
	var/left_mousedown = FALSE

/datum/click_handler/New(mob/user)
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
	if (flags & CLICK_HANDLER_SUPPRESS_POPUP_MENU)
		user.update_popup_menu()
	if (cursor_override && user.client)
		user.client.mouse_pointer_icon = cached_cursor

	if (user)
		user.click_handlers.Remove(src)
	user = null
	. = ..()

/datum/click_handler/proc/Enter()
	if (user && (flags & CLICK_HANDLER_SUPPRESS_POPUP_MENU))
		user.update_popup_menu()
	return

/datum/click_handler/proc/Exit()
	return



/datum/click_handler/proc/OnMobLogout()
	user.RemoveClickHandler(src)

/datum/click_handler/proc/OnClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnMiddleClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnLeftClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnRightClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnDblClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnCtrlClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnAltClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnShiftClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnCtrlAltClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/OnCtrlShiftClick(atom/A, params)
	return TRUE

/datum/click_handler/proc/MouseDown(object,location,control,params)
	left_mousedown = TRUE
	return TRUE

/datum/click_handler/proc/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	return TRUE

/datum/click_handler/proc/MouseUp(object,location,control,params)
	left_mousedown = FALSE
	return TRUE

/datum/click_handler/proc/MouseMove(object,location,control,params)
	return TRUE


/datum/click_handler/default/OnClick(atom/A, params)
	user.ClickOn(A, params)
	return TRUE

/datum/click_handler/default/OnDblClick(atom/A, params)
	user.DblClickOn(A, params)
	return TRUE

//Tests whether the target thing is valid, and returns it if so.
//If its not valid, null will be returned
//In the case of click catchers, we resolve and return the turf under it
/datum/click_handler/proc/resolve_world_target(a, params)
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


/mob/proc/GetClickHandler(datum/click_handler/popped_handler)
	if(!click_handlers)
		click_handlers = new()
	if(IS_EMPTY(click_handlers.stack))
		PushClickHandler(/datum/click_handler/default)
	return click_handlers.Top()

/mob/proc/GetClickHandlerByType(required_type)
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

/mob/proc/RemoveClickHandler(datum/click_handler/click_handler)
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

/mob/proc/RemoveClickHandlersByType(typepath)
	if(!click_handlers)
		return

	for( var/thing in click_handlers.stack)
		if (istype(thing, typepath))
			click_handlers.Remove(thing)
			qdel(thing)

/mob/proc/PopClickHandler()
	if(!click_handlers)
		return
	RemoveClickHandler(click_handlers.Top())

//Extra variables can be passed in here, and they will be propagated through to clickhandler /New
/mob/proc/PushClickHandler(datum/click_handler/new_click_handler_type)
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

	click_handlers.Push(click_handler)
	click_handler.Enter()

	update_click_handler_flags()
	return click_handler

//Creates a new click handler of the supplied type, but only if the mob does not already have one.
//If one exists, the existing is returned instead
/mob/proc/PushUniqueClickHandler(datum/click_handler/new_click_handler_type)
	var/existing = GetClickHandlerByType(new_click_handler_type)
	if (existing)
		return existing


	return PushClickHandler(arglist(args))













