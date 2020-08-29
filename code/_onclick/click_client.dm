//It sucks that we have to do this
/client/Click(object,location,control,params)
	object = resolve_drag(object, params)
	.=..(object, location, control, params)


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