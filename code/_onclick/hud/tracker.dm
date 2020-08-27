//A tracker is a screen object which is bound not only to the client screen,but also to an inworld atom.
//It will strive, as much as possible, to track the location of that atom, and adjust its screen position so it is overlaid on that atom
//If the specified atom is not onscreen, the tracker will turn invisible, but keep tracking

/obj/screen/movable/tracker
	var/client/C
	var/mob/origin	//Todo: Accomodate for origin possibly changing
	var/atom/tracked
	alpha = 128
	icon = 'icons/mob/screen1.dmi'
	icon_state = "health6"
	var/lifetimer
	mouse_opacity = 0

/obj/screen/movable/tracker/New(var/mob/host, var/atom/_tracked, var/lifetime)
	if (host.client)
		origin = host
		C = origin.client
		tracked = _tracked
		setup()
		C.screen |= src
		if (lifetime)
			set_lifetime(lifetime)
		.=..()
	else
		//Can't add it to a mob without a client
		qdel(src)
		return

/obj/screen/movable/tracker/proc/setup()
	return

/obj/screen/movable/tracker/proc/set_lifetime(var/lifetime)
	deltimer(lifetimer)
	lifetimer = addtimer(CALLBACK(src, /obj/screen/movable/tracker/proc/end), lifetime,  TIMER_STOPPABLE)

/obj/screen/movable/tracker/proc/end()
	deltimer(lifetimer)
	qdel(src)

/obj/screen/movable/tracker/Initialize()
	.=..()
	//Create moved observations for host and target
	GLOB.moved_event.register(origin, src, /obj/screen/movable/tracker/proc/update)
	GLOB.moved_event.register(tracked, src, /obj/screen/movable/tracker/proc/update)

	//Create dir set observation for host only
	GLOB.dir_set_event.register(origin, src, /obj/screen/movable/tracker/proc/update)

	//Create a view changed observation for host only
	GLOB.view_changed_event.register(origin, src, /obj/screen/movable/tracker/proc/update)
	spawn()
		update()

/obj/screen/movable/tracker/Destroy()
	clear_from_screen()
	.=..()

/obj/screen/movable/tracker/proc/clear_from_screen()
	if (C)
		C.screen -= src

/obj/screen/movable/tracker/hide()
	screen_loc = "CENTER"
	alpha = 0

/obj/screen/movable/tracker/proc/update()
	if (QDELETED(tracked) || QDELETED(origin))
		qdel(src)	//if our target atom is gone, so are we
		return

	if (!origin.client || !C)//Player logged out?
		qdel(src)
		return

	if (origin.client && origin.client != C)	//Someone else posessed the player? Lets transfer ourselves to the new client
		clear_from_screen()
		C = origin.client

	alpha = initial(alpha)

	var/atom/track_target
	if (isturf(tracked.loc))
		track_target = tracked	//If our target is on a turf, we move to it
	else
		track_target = get_turf(tracked) //If its hidden inside an object, we move to its tile

	//Ok, now lets see if the target is onscreen,
	//First we've got to figure out what onscreen is

	//The point we work from, the client eye. Which is probably screen centre, but there can be offsets
	if (origin.z != track_target.z)
		//If its on another zlevel we can't see it
		//Possible todo: Add support for openspace/transparent floors and seeing things below. But not now
		hide()
		return

	//Lets get how far the screen extends around the origin
	var/list/bound_offsets = C.get_tile_bounds(FALSE) //Cut off partial tiles or they might stretch the screen
	var/vector2/delta = get_new_vector(track_target.x - origin.x, track_target.y - origin.y)	//Lets get the position delta from origin to target
	//Now check whether or not that would put it onscreen
	//Bottomleft first
	var/vector2/BL = bound_offsets["BL"]
	if (delta.x < BL.x || delta.y < BL.y)
		//Its offscreen
		hide()
		release_vector(delta)
		return


	//Then topright
	var/vector2/TR = bound_offsets["TR"]
	if (delta.x > TR.x || delta.y > TR.y)
		//Its offscreen
		hide()
		release_vector(delta)
		return


	//If we get here, the target is on our screen!
	//Lets place it
	delta += bound_offsets["OFFSET"]
	delta.x += C.view + 1
	delta.y += C.view + 1
	screen_loc = "[encode_screen_X(delta.x, origin)],[encode_screen_Y(delta.y,origin)]"
	release_vector(delta)
	//AAaaand done