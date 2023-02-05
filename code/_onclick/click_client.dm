#define LIMITER_SIZE 5
#define CURRENT_SECOND 1
#define SECOND_COUNT 2
#define CURRENT_MINUTE 3
#define MINUTE_COUNT 4
#define ADMINSWARNED_AT 5

//It sucks that we have to do this
/client/Click(atom/object,atom/location,control,params)
	var/ab = FALSE
	var/list/modifiers = params2list(params)

	if (object && IS_WEAKREF_OF(object, middle_drag_atom_ref) && LAZYACCESS(modifiers, LEFT_CLICK))
		ab = max(0, 5 SECONDS-(world.time-middragtime)*0.1)

	var/mcl = CONFIG_GET(number/minute_click_limit)
	if (!holder && mcl)
		var/minute = round(world.time, 600)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (minute != clicklimiter[CURRENT_MINUTE])
			clicklimiter[CURRENT_MINUTE] = minute
			clicklimiter[MINUTE_COUNT] = 0
		clicklimiter[MINUTE_COUNT] += 1+(ab)
		if (clicklimiter[MINUTE_COUNT] > mcl)
			var/msg = "Your previous click was ignored because you've done too many in a minute."
			if (minute != clicklimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				clicklimiter[ADMINSWARNED_AT] = minute

				msg += " Administrators have been informed."
				if (ab)
					log_game("[key_name(src)] is using the middle click aimbot exploit")
					message_admins("[ADMIN_FLW(usr)] [ADMIN_PP(usr)] is using the middle click aimbot exploit</span>")
					notes_add(src.ckey, "Is using the middle click aimbot exploit", "The Game")
				log_game("[key_name(src)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
				message_admins("[ADMIN_FLW(usr)] [ADMIN_PP(usr)] Has hit the per-minute click limit of [mcl] clicks in a given game minute")
			to_chat(src, SPAN_DANGER("[msg]"))
			return

	var/scl = CONFIG_GET(number/second_click_limit)
	if (!holder && scl)
		var/second = round(world.time, 10)
		if (!clicklimiter)
			clicklimiter = new(LIMITER_SIZE)
		if (second != clicklimiter[CURRENT_SECOND])
			clicklimiter[CURRENT_SECOND] = second
			clicklimiter[SECOND_COUNT] = 0
		clicklimiter[SECOND_COUNT] += 1+(!!ab)
		if (clicklimiter[SECOND_COUNT] > scl)
			to_chat(src, SPAN_DANGER("Your previous click was ignored because you've done too many in a second"))
			return

	object = resolve_drag(object, params)

	if(holder?.callproc?.waiting_for_click)
		if(tgui_alert(usr, "Do you want to select \the [object] as the [holder.callproc.arguments.len+1]\th argument?", "Confirmation", list("Yes", "No")) == "Yes")
			holder.callproc.arguments += object

		holder.callproc.waiting_for_click = 0
		remove_verb(src, /client/proc/cancel_callproc_select)
		holder.callproc.do_args()
	else
		return ..()

/client/MouseDown(object,location,control,params)
	var/datum/stack/click_handlers

	if (mob)
		click_handlers = mob.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.MouseDown(object,location,control,params))
				return

	.=..()

/client/MouseUp(object,location,control,params)
	var/datum/stack/click_handlers

	if (mob)
		click_handlers = mob.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.MouseUp(object,location,control,params))
				return
	.=..()


/client/MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params)
	var/list/modifiers = params2list(params)
	if (LAZYACCESS(modifiers, MIDDLE_CLICK))
		if (src_object && src_location != over_location)
			middragtime = world.time
			middle_drag_atom_ref = WEAKREF(src_object)
		else
			middragtime = 0
			middle_drag_atom_ref = null

	var/datum/stack/click_handlers

	if (mob)
		click_handlers = mob.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.MouseDrag(src_object,over_object,src_location,over_location,src_control,over_control,params) )
				return
	.=..()

/client/MouseMove(object,location,control,params)
	//Optimisation, prevent the below code if we dont have this flag set
	if (mob && mob.has_mousemove_click_handler)
		var/datum/stack/click_handlers

		click_handlers = mob.GetClickHandlers()


		while (click_handlers.Num())
			var/datum/click_handler/CH = click_handlers.Pop()
			if (CH)
				if (!CH.MouseMove(object,location,control,params) )
					return
	.=..()

/client/MouseDrop(atom/src_object, atom/over_object, atom/src_location, atom/over_location, src_control, over_control, params)
	if (IS_WEAKREF_OF(src_object, middle_drag_atom_ref))
		middragtime = 0
		middle_drag_atom_ref = null
	..()
