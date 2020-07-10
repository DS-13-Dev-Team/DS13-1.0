/obj/lighting_plane
	screen_loc = "1,1"
	plane = LIGHTING_PLANE

	blend_mode = BLEND_MULTIPLY
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR
	// use 20% ambient lighting; be sure to add full alpha

	color = list(
			-1, 00, 00, 00,
			00, -1, 00, 00,
			00, 00, -1, 00,
			00, 00, 00, 00,
			01, 01, 01, 01
		)

	mouse_opacity = 0    // nothing on this plane is mouse-visible


