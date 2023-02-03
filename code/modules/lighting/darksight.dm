/mob/dead/observer/signal/verb/toggle_darkvision()
	set name = "Toggle Darkvision"
	set category = "Necromorph"

	var/newstring = ""
	switch(lighting_alpha)
		if(LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
			newstring = "at low level"
		if(LIGHTING_PLANE_ALPHA_NV_TRAIT)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_INVISIBLE
			newstring = "at high level"
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			newstring = "disabled"

	sync_lighting_plane_alpha()
	to_chat(src, "Darksight is now [newstring].")
