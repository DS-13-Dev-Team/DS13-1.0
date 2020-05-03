	/*
	Click code cleanup
	~Sayu
*/

// 1 decisecond click delay (above and beyond mob/next_move)
/mob/var/next_click = 0



//It sucks that we have to do this
/client/Click(object,location,control,params)
	object = resolve_drag(object, params)
	.=..(object, location, control, params)

/*
	Before anything else, defer these calls to a per-mobtype handler.  This allows us to
	remove istype() spaghetti code, but requires the addition of other handler procs to simplify it.

	Alternately, you could hardcode every mob's variation in a flat ClickOn() proc; however,
	that's a lot of code duplication and is hard to maintain.

	Note that this proc can be overridden, and is in the case of screen objects.
*/

/atom/Click(var/location, var/control, var/params) // This is their reaction to being clicked on (standard proc)
	var/datum/stack/click_handlers

	if (usr)
		click_handlers = usr.GetClickHandlers()


		while (click_handlers.Num())
			var/datum/click_handler/CH = click_handlers.Pop()
			if (!CH.OnClick(src, params))
				return

/atom/DblClick(var/location, var/control, var/params)
	var/datum/stack/click_handlers

	if (usr)
		click_handlers = usr.GetClickHandlers()


		while (click_handlers.Num())
			var/datum/click_handler/CH = click_handlers.Pop()
			if (!CH.OnDblClick(src, params))
				return
/*
	Standard mob ClickOn()
	Handles exceptions: middle click, modified clicks, mech actions

	After that, mostly just check your state, check whether you're holding an item,
	check whether you're adjacent to the target, then pass off the click to whoever
	is recieving it.
	The most common are:
	* mob/UnarmedAttack(atom,adjacent) - used here only when adjacent, with no item in hand; in the case of humans, checks gloves
	* atom/attackby(item,user) - used only when adjacent
	* item/afterattack(atom,user,adjacent,params) - used both ranged and adjacent
	* mob/RangedAttack(atom,params) - used only ranged, only used for tk and laser eyes but could be changed
*/
/mob/proc/ClickOn(var/atom/A, var/params)
	if(world.time <= next_click) // Hard check, before anything else, to avoid crashing
		return

	next_click = world.time + 1


	//Limited click arc handling here
	if (limited_click_arc && !target_in_frontal_arc(src, A, limited_click_arc))
		face_atom(A)
		return

	var/list/modifiers = params2list(params)
	if(modifiers["shift"] && modifiers["ctrl"])
		CtrlShiftClickOn(A, params)
		return 1
	if(modifiers["ctrl"] && modifiers["alt"])
		CtrlAltClickOn(A, params)
		return 1
	if(modifiers["middle"])
		MiddleClickOn(A, params)
		return 1
	if(modifiers["right"])
		RightClickOn(A, params)
		return 1
	if(modifiers["shift"])
		ShiftClickOn(A, params)
		return 0
	if(modifiers["alt"]) // alt and alt-gr (rightalt)
		AltClickOn(A, params)
		return 1
	if(modifiers["ctrl"])
		CtrlClickOn(A, params)
		return 1
	if(modifiers["left"])
		LeftClickOn(A, params)
		return 1


/mob/proc/LeftClickOn(var/atom/A, var/params)
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.OnLeftClick(A,params))
				return

	if(stat || paralysis || stunned || weakened)
		return
	face_atom(A) // change direction to face what you clicked on
	if(!canClick()) // in the year 2000...
		return
	if(istype(loc, /obj/mecha))
		if(!locate(/turf) in list(A, A.loc)) // Prevents inventory from being drilled
			return
		var/obj/mecha/M = loc
		return M.click_action(A, src)

	if(restrained())
		setClickCooldown(10)
		RestrainedClickOn(A)
		return 1

	if(in_throw_mode)
		if(isturf(A) || isturf(A.loc))
			throw_item(A)
			trigger_aiming(TARGET_CAN_CLICK)
			return 1
		throw_mode_off()

	var/obj/item/W = get_active_hand()

	if(W == A) // Handle attack_self
		W.attack_self(src)
		trigger_aiming(TARGET_CAN_CLICK)
		if(hand)
			update_inv_l_hand(0)
		else
			update_inv_r_hand(0)
		return 1

	//Atoms on your person
	// A is your location but is not a turf; or is on you (backpack); or is on something on you (box in backpack); sdepth is needed here because contents depth does not equate inventory storage depth.
	var/sdepth = A.storage_depth(src)
	if((!isturf(A) && A == loc) || (sdepth != -1 && sdepth <= 1))
		if(W)
			var/resolved = W.resolve_attackby(A, src, params)
			if(!resolved && A && W)
				W.afterattack(A, src, 1, params) // 1 indicates adjacency
		else
			if(ismob(A)) // No instant mob attacking
				setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			UnarmedAttack(A, 1)

		trigger_aiming(TARGET_CAN_CLICK)
		return 1

	if(!isturf(loc)) // This is going to stop you from telekinesing from inside a closet, but I don't shed many tears for that
		return

	//Atoms on turfs (not on your person)
	// A is a turf or is on a turf, or in something on a turf (pen in a box); but not something in something on a turf (pen in a box in a backpack)
	sdepth = A.storage_depth_turf()
	if(isturf(A) || isturf(A.loc) || (sdepth != -1 && sdepth <= 1))
		if(A.Adjacent(src)) // see adjacent.dm
			if(W)
				// Return 1 in attackby() to prevent afterattack() effects (when safely moving items for example)
				var/resolved = W.resolve_attackby(A,src, params)
				if(!resolved && A && W)
					W.afterattack(A, src, 1, params) // 1: clicking something Adjacent
			else
				if(ismob(A)) // No instant mob attacking
					setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
				UnarmedAttack(A, 1)

			trigger_aiming(TARGET_CAN_CLICK)
			return
		else // non-adjacent click
			if(W)
				W.afterattack(A, src, 0, params) // 0: not Adjacent
			else
				RangedAttack(A, params)

			trigger_aiming(TARGET_CAN_CLICK)
	return 1

/mob/proc/setClickCooldown(var/timeout)
	next_move = max(world.time + timeout, next_move)

/mob/proc/addClickCooldown(var/timeout)
	next_move += timeout

/mob/proc/canClick()
	if(config.no_click_cooldown || next_move <= world.time)
		return 1
	return 0

// Default behavior: ignore double clicks, the second click that makes the doubleclick call already calls for a normal click
/mob/proc/DblClickOn(var/atom/A, var/params)
	return

/*
	Translates into attack_hand, etc.

	Note: proximity_flag here is used to distinguish between normal usage (flag=1),
	and usage when clicking on things telekinetically (flag=0).  This proc will
	not be called at ranged except with telekinesis.

	proximity_flag is not currently passed to attack_hand, and is instead used
	in human click code to allow glove touches only at melee range.
*/
/mob/proc/UnarmedAttack(var/atom/A, var/proximity_flag)
	return

/mob/living/UnarmedAttack(var/atom/A, var/proximity_flag)

	if(!ticker)
		to_chat(src, "You cannot attack people before the game has started.")
		return 0

	if(stat)
		return 0

	return 1

/*
	Ranged unarmed attack:

	This currently is just a default for all mobs, involving
	laser eyes and telekinesis.  You could easily add exceptions
	for things like ranged glove touches, spitting alien acid/neurotoxin,
	animals lunging, etc.
*/
/mob/proc/RangedAttack(var/atom/A, var/params)
	if(!mutations.len) return
	if((LASER in mutations) && a_intent == I_HURT)
		LaserEyes(A) // moved into a proc below
	else if(TK in mutations)
		setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		A.attack_tk(src)
/*
	Restrained ClickOn

	Used when you are handcuffed and click things.
	Not currently used by anything but could easily be.
*/
/mob/proc/RestrainedClickOn(var/atom/A)
	return

/*
	Middle click
	Only used for swapping hands
*/
/mob/proc/MiddleClickOn(var/atom/A, var/params)
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.OnMiddleClick(A,params))
				return
	swap_hand()
	return


/*
	Right Click
	Only used for cancelling placement click handler
*/
/mob/proc/RightClickOn(var/atom/A, var/params)
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.OnRightClick(A,params))
				return

	return


// In case of use break glass
/*
/atom/proc/MiddleClick(var/mob/M as mob)
	return
*/

/*
	Shift click
	For most mobs, examine.
	This is overridden in ai.dm
*/
/mob/proc/ShiftClickOn(var/atom/A, var/params)
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.OnShiftClick(A,params))
				return

	A.ShiftClick(src)

/atom/proc/ShiftClick(var/mob/user)
	if(user.client && user.client.eye == user)
		user.examinate(src)
	return

/*
	Ctrl click
	For most objects, pull
*/
/mob/proc/CtrlClickOn(var/atom/A, var/params)
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.OnCtrlClick(A,params))
				return
	A.CtrlClick(src)

/atom/proc/CtrlClick(var/mob/user)
	return

/atom/movable/CtrlClick(var/mob/user)
	if(Adjacent(user))
		user.start_pulling(src)

/*
	Alt click
	Unused except for AI
*/
/mob/proc/AltClickOn(var/atom/A, var/params)
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.OnAltClick(A,params))
				return
	.=..()
	A.AltClick(src)

/atom/proc/AltClick(var/mob/user)
	var/turf/T = get_turf(src)
	if(T && user.TurfAdjacent(T))
		if(user.listed_turf == T)
			user.listed_turf = null
		else
			user.listed_turf = T
			user.client.statpanel = "Turf"
	return 1



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
	var/datum/stack/click_handlers

	if (mob)
		click_handlers = mob.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.MouseMove(object,location,control,params) )
				return
	.=..()



/mob/proc/TurfAdjacent(var/turf/T)
	return T.AdjacentQuick(src)

/mob/observer/ghost/TurfAdjacent(var/turf/T)
	if(!isturf(loc) || !client)
		return FALSE
	return z == T.z && (get_dist(loc, T) <= client.view)

/*
	Control+Shift click
	Unused except for AI
*/
/mob/proc/CtrlShiftClickOn(var/atom/A, var/params)
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.OnCtrlShiftClick(A,params))
				return
	A.CtrlShiftClick(src)

/atom/proc/CtrlShiftClick(var/mob/user)
	return

/*
	Control+Alt click
*/
/mob/proc/CtrlAltClickOn(var/atom/A, var/params)
	var/datum/stack/click_handlers

	click_handlers = src.GetClickHandlers()


	while (click_handlers.Num())
		var/datum/click_handler/CH = click_handlers.Pop()
		if (CH)
			if (!CH.OnCtrlAltClick(A,params))
				return
	A.CtrlAltClick(src)

/atom/proc/CtrlAltClick(var/mob/user)
	return

/*
	Misc helpers

	Laser Eyes: as the name implies, handles this since nothing else does currently
	face_atom: turns the mob towards what you clicked on
*/
/mob/proc/LaserEyes(atom/A)
	return

/mob/living/LaserEyes(atom/A)
	setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	var/turf/T = get_turf(src)

	var/obj/item/projectile/beam/LE = new (T)
	LE.icon = 'icons/effects/genetics.dmi'
	LE.icon_state = "eyelasers"
	playsound(usr.loc, 'sound/weapons/taser2.ogg', 75, 1)
	LE.launch(A)
/mob/living/carbon/human/LaserEyes()
	if(nutrition>0)
		..()
		nutrition = max(nutrition - rand(1,5),0)
		handle_regular_hud_updates()
	else
		to_chat(src, "<span class='warning'>You're out of energy!  You need food!</span>")



/obj/screen/click_catcher
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "click_catcher"
	plane = CLICKCATCHER_PLANE
	mouse_opacity = 2
	screen_loc = "CENTER-7,CENTER-7"

/proc/create_click_catcher(var/radius = 7)
	var/diameter = (radius*2) + 1
	. = list()
	for(var/i = 0, i<diameter, i++)
		for(var/j = 0, j<diameter, j++)
			var/obj/screen/click_catcher/CC = new()
			CC.screen_loc = "NORTH-[i],EAST-[j]"
			. += CC

/obj/screen/click_catcher/Click(location, control, params)
	var/list/modifiers = params2list(params)
	if(modifiers["middle"] && istype(usr, /mob/living/carbon))
		var/mob/living/carbon/C = usr
		C.swap_hand()
	else
		var/turf/T = screen_loc2turf(screen_loc, get_turf(usr))
		if(T)
			usr.client.Click(T, location, control, params)
			//T.Click(location, control, params)
	. = 1

/obj/screen/click_catcher/proc/resolve(var/mob/user)
	var/turf/T = screen_loc2turf(screen_loc, get_turf(user))
	return T

/*
	Custom click handling
*/

/mob
	var/datum/stack/click_handlers

/mob/Destroy()
	if(click_handlers)
		click_handlers.QdelClear()
		QDEL_NULL(click_handlers)
	. = ..()


//Checks if target is within arc degrees either side of user's forward vector.
//Used to make mobs that can only click on stuff infront of them
//Code supplied by Kaiochao
	//Note: Rounding included to compensate for a byond bug in 513.1497.
	//Without the rounding, cos(90) returns an erroneous value which breaks this proc
/proc/target_in_frontal_arc(var/mob/user, var/atom/target, var/arc)
	//You are allowed to click yourself and things in your own turf
	if (user.loc == target.loc)
		return TRUE
	return (round(Vector2.FromDir(user.dir).Dot(new/vector2(target.x - user.x, target.y - user.y).Normalized()),0.000001) >= round(cos(arc),0.000001))


//Checks if target is within arc degrees either side of a specified direction vector from user. All parameters are mandatory
//Rounding explained above
/proc/target_in_arc(var/atom/origin, var/atom/target, var/vector2/direction, var/arc)
	origin = get_turf(origin)
	target = get_turf(target)
	if (origin == target)
		return TRUE
	return (round(direction.Dot(new/vector2(target.x - origin.x, target.y - origin.y).Normalized()),0.000001) >= round(cos(arc),0.000001))