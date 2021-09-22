#define SHOULD_SHOW_TO(mymob, myscreen) (!(mymob.stat == DEAD && !myscreen.show_when_dead))

/mob
	var/list/screens = list()

/mob/proc/set_fullscreen(condition, screen_name, screen_type, arg)
	condition ? overlay_fullscreen(screen_name, screen_type, arg) : clear_fullscreen(screen_name)

/mob/proc/overlay_fullscreen_timer(duration, animated, category, type, severity)
	overlay_fullscreen(category, type, severity)
	addtimer(CALLBACK(src, .proc/clear_fullscreen, category, animated), duration)

/mob/proc/overlay_fullscreen(category, type, severity)
	var/obj/screen/fullscreen/screen = screens[category]
	if (!screen || screen.type != type)
		// needs to be recreated
		clear_fullscreen(category, FALSE)
		screens[category] = screen = new type()
	else if ((!severity || severity == screen.severity) && (!client || screen.fs_view == client.view))
		// doesn't need to be updated
		return screen

	screen.icon_state = "[initial(screen.icon_state)][severity]"
	screen.severity = severity
	if (client && SHOULD_SHOW_TO(src, screen))
		screen.update_for_view(client.view)
		client.screen += screen

	return screen

/mob/proc/clear_fullscreen(category, animated = 10)
	var/obj/screen/fullscreen/screen = screens[category]
	if(!screen)
		return

	screens -= category

	if(animated)
		animate(screen, alpha = 0, time = animated)
		addtimer(CALLBACK(src, .proc/clear_fullscreen_after_animate, screen), animated, TIMER_CLIENT_TIME)
	else
		if(client)
			client.screen -= screen
		qdel(screen)

/mob/proc/clear_fullscreen_after_animate(obj/screen/fullscreen/screen)
	if(client)
		client.screen -= screen
	qdel(screen)

/mob/proc/clear_fullscreens()
	for(var/category in screens)
		clear_fullscreen(category)

/mob/proc/hide_fullscreens()
	if(client)
		for(var/category in screens)
			client.screen -= screens[category]

/mob/proc/reload_fullscreens()
	if(client)
		var/obj/screen/fullscreen/screen
		for(var/category in screens)
			screen = screens[category]
			if(SHOULD_SHOW_TO(src, screen))
				screen.update_for_view(client.view)
				client.screen |= screen
			else
				client.screen -= screen

/obj/screen/fullscreen
	icon = 'icons/hud/screen_full.dmi'
	icon_state = "default"
	screen_loc = "BOTTOMLEFT"
	plane = FULLSCREEN_PLANE
	mouse_opacity = 0
	var/severity = 0
	var/fs_view = WORLD_VIEW
	var/show_when_dead = FALSE


/obj/screen/fullscreen/Destroy()
	severity = 0
	hud = null
	return ..()

/obj/screen/fullscreen/proc/update_for_view(client_view)
	if (fs_view != client_view)
		fs_view = client_view
		icon = get_or_create_fullscreen(client_view)

/obj/screen/fullscreen/proc/get_or_create_fullscreen(client_view)
	var/list/view_list = getviewsize(client_view)
	var/pixels_x = view_list[1]*world.icon_size
	var/pixels_y = view_list[2]*world.icon_size
	var/entry_name = "[pixels_x]x[pixels_y]"
	if (!GLOB.fullscreen_icons[entry_name])
		//If the icons isn't made yet, make it and set it in the global list
		GLOB.fullscreen_icons[entry_name] = rescale_icon(icon, pixels_x, pixels_y)
	return GLOB.fullscreen_icons[entry_name] //Then return it

/obj/screen/fullscreen/brute
	icon_state = "brutedamageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/oxy
	icon_state = "oxydamageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/crit
	icon_state = "passage"
	layer = CRIT_LAYER

/obj/screen/fullscreen/blind
	icon_state = "blackimageoverlay"
	layer = DAMAGE_LAYER

/obj/screen/fullscreen/impaired
	icon_state = "impairedoverlay"
	layer = IMPAIRED_LAYER

/obj/screen/fullscreen/flash/noise
	icon_state = "noise"

/obj/screen/fullscreen/fishbed
	icon_state = "fishbed"
	show_when_dead = TRUE

/obj/screen/fullscreen/pain
	icon_state = "brutedamageoverlay6"
	alpha = 0



//Small icons
//-------------------------
/obj/screen/fullscreen/blackout
	icon = 'icons/hud/screen1.dmi'
	icon_state = "black"
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	layer = DAMAGE_LAYER



/obj/screen/fullscreen/blurry
	icon = 'icons/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "blurry"

/obj/screen/fullscreen/flash
	icon = 'icons/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "flash"



/obj/screen/fullscreen/high
	icon = 'icons/hud/screen1.dmi'
	screen_loc = "WEST,SOUTH to EAST,NORTH"
	icon_state = "druggy"

/obj/screen/fullscreen/noise
	icon = 'icons/effects/static.dmi'
	icon_state = "1 light"
	screen_loc = ui_entire_screen
	layer = FULLSCREEN_LAYER
	alpha = 127

/obj/screen/fullscreen/fadeout
	icon = 'icons/hud/screen1.dmi'
	icon_state = "black"
	screen_loc = ui_entire_screen
	layer = FULLSCREEN_LAYER
	alpha = 0
	show_when_dead = TRUE

/obj/screen/fullscreen/fadeout/Initialize()
	. = ..()
	animate(src, alpha = 255, time = 10)

/obj/screen/fullscreen/scanline
	icon = 'icons/effects/static.dmi'
	icon_state = "scanlines"
	screen_loc = ui_entire_screen
	alpha = 50
	layer = FULLSCREEN_LAYER

#undef SHOULD_SHOW_TO
