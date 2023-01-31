/// This code was taken from Parallax code and changed to fit the needs

/// Paralax does this so we do it as well
INITIALIZE_IMMEDIATE(/atom/movable/screen/cameranet_static)
/atom/movable/screen/cameranet_static
	icon = 'icons/hud/cameranet_static.dmi'
	icon_state = "cameranet"
	blend_mode = BLEND_ADD
	plane = OBSCURITY_PLANE_MARKER
	screen_loc = "CENTER-7,CENTER-7"
	mouse_opacity = MOUSE_OPACITY_ICON
	var/speed = 1
	var/offset_x = 0
	var/offset_y = 0
	var/view_sized

/atom/movable/screen/cameranet_static/Initialize(mapload, mob/owner)
	. = ..()
	if(!owner)
		return INITIALIZE_HINT_QDEL
	if(owner.client)
		var/view = owner.client.view || world.view
		update_o(view)
		RegisterSignal(owner.client, COMSIG_VIEW_SET, .proc/on_view_change)

/atom/movable/screen/cameranet_static/Click(location, control, params)
	var/datum/stack/click_handlers

	if (usr)
		click_handlers = usr.GetClickHandlers()

		while (click_handlers.Num())
			var/datum/click_handler/CH = click_handlers.Pop()
			if (!CH.OnClick(src, params))
				return

/atom/movable/screen/cameranet_static/proc/on_view_change(datum/source, new_size)
	SIGNAL_HANDLER
	update_o(new_size)

/atom/movable/screen/cameranet_static/proc/update_o(view)
	view = view || world.view
	if(view == view_sized)
		return

	var/static/icon_scaler = world.icon_size / 480

	// Turn the view size into a grid of correctly scaled overlays
	var/list/viewscales = getviewsize(view)
	var/countx = CEILING((viewscales[1] / 2) * icon_scaler, 1) + 1
	var/county = CEILING((viewscales[2] / 2) * icon_scaler, 1) + 1
	var/list/new_overlays = new
	for(var/x in -countx to countx)
		for(var/y in -county to county)
			if(x == 0 && y == 0)
				continue
			var/mutable_appearance/texture_overlay = mutable_appearance(icon, icon_state, plane = src.plane)
			texture_overlay.transform = matrix(1, 0, x*480, 0, 1, y*480)
			new_overlays += texture_overlay
	cut_overlays()
	add_overlay(new_overlays)
	view_sized = view

/mob/dead/observer/signal/reload_fullscreens()
	if(..())
		var/datum/hud/marker/our_hud = hud_used
		our_hud.cameranet_static.update_o(client.view)

/mob/dead/observer/signal/proc/update_static(turf/previous_turf)
	var/turf/posobj = get_turf(client.eye)
	if(!posobj)
		return

	var/force = FALSE
	if(!previous_turf || (previous_turf.z != posobj.z))
		previous_turf = posobj
		force = TRUE

	var/offset_x = (posobj.x - previous_turf.x)
	var/offset_y = (posobj.y - previous_turf.y)

	if(!offset_x && !offset_y && !force)
		return

	var/datum/hud/marker/our_hud = hud_used
	var/atom/movable/screen/cameranet_static/cameranet_static = our_hud.cameranet_static

	var/glide_rate = round(world.icon_size / glide_size * world.tick_lag, world.tick_lag)
	var/largest_change = max(abs(offset_x), abs(offset_y))
	var/max_allowed_dist = (glide_rate / world.tick_lag) + 1

	// If we aren't already moving, have made some movement, and that movement was smaller then our "glide" size, animate
	var/run_parralax = (glide_rate && largest_change <= max_allowed_dist)

	offset_x *= world.icon_size
	offset_y *= world.icon_size

	// This is how we tile parralax sprites
	// It doesn't use change because we really don't want to animate this
	if(cameranet_static.offset_x - offset_x > 240)
		cameranet_static.offset_x -= 480
	else if(cameranet_static.offset_x - offset_x < -240)
		cameranet_static.offset_x += 480
	if(cameranet_static.offset_y - offset_y > 240)
		cameranet_static.offset_y -= 480
	else if(cameranet_static.offset_y - offset_y < -240)
		cameranet_static.offset_y += 480

	// Now that we have our offsets, let's do our positioning
	cameranet_static.offset_x -= offset_x
	cameranet_static.offset_y -= offset_y

	cameranet_static.screen_loc = "CENTER-7:[round(cameranet_static.offset_x, 1)],CENTER-7:[round(cameranet_static.offset_y, 1)]"

	// We're going to use a transform to "glide" that last movement out, so it looks nicer
	// Don't do any animates if we're not actually moving enough distance yeah? thanks lad
	if(run_parralax && (largest_change > 1))
		cameranet_static.transform = matrix(1,0,offset_x, 0,1,offset_y)
		animate(cameranet_static, transform=matrix(), time = glide_rate)
