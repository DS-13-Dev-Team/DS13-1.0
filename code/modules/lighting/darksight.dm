/*
	Toggling verbs
*/
/mob/living/carbon/human/proc/toggle_darkvision()
	set name = "Toggle Darkvision"
	set category = "Abilities"

	var/newstring = ""
	switch(lighting_alpha)
		if(LIGHTING_PLANE_ALPHA_NV_TRAIT)
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			newstring = "enabled"
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
			newstring = "disabled"

	sync_lighting_plane_alpha()
	to_chat(src, "Darksight is now [newstring].")

/mob/dead/observer/eye/signal/verb/toggle_darkvision()
	set name = "Toggle Darkvision"
	set category = "Necromorph"

	var/newstring = ""
	switch(lighting_alpha)
		if(LIGHTING_PLANE_ALPHA_VISIBLE)
			lighting_alpha = LIGHTING_PLANE_ALPHA_NV_TRAIT
			newstring = "at low level"
		if(LIGHTING_PLANE_ALPHA_NV_TRAIT)
			lighting_alpha = LIGHTING_PLANE_ALPHA_MOSTLY_VISIBLE
			newstring = "at high level"
		else
			lighting_alpha = LIGHTING_PLANE_ALPHA_VISIBLE
			newstring = "disabled"

	sync_lighting_plane_alpha()
	to_chat(src, "Darksight is now [newstring].")
