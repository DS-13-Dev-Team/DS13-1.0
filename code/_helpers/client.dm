/proc/dragged(var/params)
	var/list/L = params2list(params)
	var/dragged = L["drag"]
	if(dragged && !L[dragged])
		return	TRUE
	return FALSE

/client/proc/resolve_drag(var/atom/A, var/params)
	var/list/L = params2list(params)
	var/dragged = L["drag"]
	if(dragged && !L[dragged])
		return last_click_atom

	last_click_atom = A
	return A


/datum/proc/get_client()
	return null

/client/get_client()
	return src

/mob/get_client()
	return client

/mob/observer/eye/get_client()
	. = client || (owner && owner.get_client())

/mob/observer/virtual/get_client()
	return host.get_client()


/client/var/temp_view = 7
/client/proc/set_view_range(var/radius)

	if (view != radius && isnum(radius))
		//If radius has changed, we'll return true
		.=TRUE

		temp_view = radius

		remake_click_catcher()

		if (mob)
			mob.reload_fullscreen()
			if (mob.l_general)//It may not exist during login
				mob.l_general.resize(src)
			if (isliving(mob))
				var/mob/living/L = mob
				L.handle_regular_hud_updates(FALSE)//Pass false here to not call update vision and avoid an infinite loop


		spawn()
			view = temp_view


/client/proc/set_view_offset(var/direction, var/magnitude)
	var/vector2/offset = (Vector2.FromDir(direction))*magnitude
	if (pixel_x != offset.x || pixel_y != offset.y) //If the values already match the target, don't interrupt the animation by repeating it
		.=TRUE //Offset has changed, return true
		animate(src, pixel_x = offset.x, pixel_y = offset.y, time = 5, easing = SINE_EASING)


/client/proc/setup_click_catcher()
	if(!void)
		void = create_click_catcher(temp_view)
	if(!screen)
		screen = list()
	screen |= void

/client/proc/remove_click_catcher()
	screen -= void
	void = null

/client/proc/remake_click_catcher()
	remove_click_catcher()
	setup_click_catcher()


