//This dims the visible screen
//It renders above everything in the world, but below the pipe overlays from ventcrawling
/atom/movable/screen/fullscreen/ventcrawl
	icon_state = "black"
	layer = 0
	alpha = 140
	plane = BLACKNESS_PLANE
	no_animate = TRUE



//This simple extension handles the onscreen tracker to prevent duplication of it
/datum/extension/ventcrawl_tracker
	var/atom/movable/screen/movable/tracker/tracker

/datum/extension/ventcrawl_tracker/New(var/mob/newholder)
	.=..()
	tracker = new /atom/movable/screen/movable/tracker/ventcrawl(newholder, newholder)


/datum/extension/ventcrawl_tracker/Destroy()
	QDEL_NULL(tracker)
	.=..()

/atom/movable/screen/movable/tracker/ventcrawl	
	icon = 'icons/hud/old-noborder.dmi'
	icon_state =  "mask"
	layer = ABOVE_LIGHTING_LAYER
	plane = EFFECTS_ABOVE_LIGHTING_PLANE
	mouse_opacity = 2