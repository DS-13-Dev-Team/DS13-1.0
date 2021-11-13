/mob/dead/observer/ghost/Login()
	..()

	if (ghost_image)
		ghost_image.appearance = src
		ghost_image.appearance_flags = RESET_ALPHA
	updateghostimages()
	set_darksight_color(DARKTINT_MODERATE)
	set_darksight_range(WORLD_VIEW_RANGE)
