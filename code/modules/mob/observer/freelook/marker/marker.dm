/*
	The marker is the heart of the necromorph army
*/
/obj/machinery/marker
	icon = 'icons/obj/marker_giant.dmi'
	icon_state = "marker_giant_dormant"
	pixel_x = -33
	plane = ABOVE_HUMAN_PLANE
	density = TRUE
	anchored = TRUE
	var/light_colour = "#FF9999"
	var/player

/obj/machinery/marker/New()
	..()
	GLOB.necrovision.add_source(src)


/obj/machinery/marker/update_icon()
	icon_state = "marker_giant_active_anim"
	set_light(1, 1, 12, 2, light_colour)

/obj/machinery/marker/proc/posess(var/mob/M)
	player = M

/obj/machinery/marker/attack_ghost(var/mob/user)
	.=..()
	if (!player)
		posess(user)