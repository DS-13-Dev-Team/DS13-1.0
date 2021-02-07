/obj/lighting_general
	plane = LIGHTING_PLANE
	screen_loc = "CENTER"

	icon = LIGHTING_ICON
	icon_state = LIGHTING_ICON_STATE_DARK

	color = "#ffffff"

	blend_mode = BLEND_MULTIPLY

	//What size are we currently set at? Used in screen rescaling
	var/size = 7
	var/cached_color

/obj/lighting_general/New(var/atom/location, var/client/C)
	. = ..()
	var/newscale = ((C.view * 2) + 1) / C.view
	transform *= newscale

/obj/lighting_general/proc/sync(var/new_colour)
	color = new_colour
	cached_color = new_colour

/obj/lighting_general/proc/resize(var/new_size = 2, var/client/C)
	if (istype(C))
		new_size = min(new_size, C.temp_view)
	size = new_size
	var/newscale = ((new_size * 2) + 1)
	var/matrix/M = matrix()
	M *= newscale
	transform = M

/mob
	var/obj/lighting_plane/l_plane
	var/obj/lighting_general/l_general


/mob/proc/set_darksight_color(var/new_colour)
	if(l_general)
		l_general.sync(new_colour)

/mob/proc/set_darksight_range(var/new_range)
	if(l_general && client)
		client.screen -= l_general
		l_general.resize(new_range, client)
		client.screen += l_general
	else if (l_general)
		l_general.size = new_range


/*
	Toggling verbs
*/
/mob/observer/ghost/verb/toggle_darkvision()
	set name = "Toggle Darkvision"
	set category = "Ghost"

	if (!l_general)
		return

	//If the darkness tint isnt set to none, our nightvision is on
	var/current_status = ((l_general.color) && (l_general.color != DARKTINT_NONE))


	var/newcolor = DARKTINT_NONE
	var/newstring = "disabled"
	if (!current_status)
		newcolor = DARKTINT_GOOD
		newstring = "enabled"


	set_darksight_color(newcolor)
	to_chat(src, "Darksight is now [newstring].")



/*
	Toggling verbs
*/
/mob/living/carbon/human/proc/toggle_darkvision()
	set name = "Toggle Darkvision"
	set category = "Abilities"

	if (!l_general)
		return

	//If the darkness tint isnt set to none, our nightvision is on
	var/current_status = ((l_general.color) && (l_general.color != DARKTINT_NONE))


	var/newcolor = DARKTINT_NONE
	var/newstring = "disabled"
	if (!current_status)
		newcolor = species.darksight_tint
		newstring = "enabled"


	set_darksight_color(newcolor)
	to_chat(src, "Darksight is now [newstring].")