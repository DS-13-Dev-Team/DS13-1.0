//"Wall" mounted vent variant. Pixelshifted to appear as though it's on the wall, however it should be placed on the floor to avoid suffocation / atmos issues.

/obj/machinery/atmospherics/unary/vent/pump/wall
	name = "Wall mounted vent pump"
	var/cover = TRUE //Is the wall-vent covered?
	layer = ABOVE_HUMAN_LAYER //So that the vents stack on top of the necromorphs.
	icon = 'icons/atmos/wallvent.dmi'
	icon_state = "composite"

/obj/machinery/atmospherics/unary/vent/pump/wall/examine(mob/user)
	. = ..()
	if(!cover && locate(/mob) in contents)
		to_chat(user, "<span class='warning'>There's something lurking inside it...</span>")

/obj/machinery/atmospherics/unary/vent/pump/wall/Initialize()
	default_pixel_x = pixel_x
	default_pixel_y = pixel_y
	.=..()
	icon = initial(icon)
	
	var/turf/T = get_step(src, reverse_direction(dir))
	if (istype(T))
		var/atom/wall = T.is_connected_vertical_surface()

		if (istype(wall))
			mount_to_atom(subject = src, mountpoint = wall)


/obj/machinery/atmospherics/unary/vent/pump/wall/north
	pixel_y = -32
	dir = NORTH

/obj/machinery/atmospherics/unary/vent/pump/wall/south
	pixel_y = 30
	dir = SOUTH

/obj/machinery/atmospherics/unary/vent/pump/wall/east
	pixel_x = -32
	dir = EAST

/obj/machinery/atmospherics/unary/vent/pump/wall/west
	pixel_x = 32
	dir = WEST


/obj/machinery/atmospherics/unary/vent/pump/wall/update_icon()

	if (!node)
		use_power = 0

	

	cut_overlays()
	if (cover_status == VENT_COVER_BROKEN)
		icon_state = "background_blank"
		add_overlay("cover_broken")
	else
		icon_state = "background_fan"
		add_overlay("cover")
		if (cover_status == VENT_COVER_SEALED)
			add_overlay("sealed")

	update_ventcrawl_network()


/mob/living/carbon/human/necromorph/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	//FOR NOW. This is because necros can't really take their clothes off.
	if(istype(species, /datum/species/necromorph))
		return TRUE
	return ..()

/*
/obj/machinery/atmospherics/unary/vent/pump/wall/proc/exit_vent(mob/living/user)
	//If there's a cover, break that first.
	if(cover)
		shake_animation(10)
		user.shake_animation(2)
		playsound(src.loc, 'sound/effects/vent_scare.ogg', 100, FALSE)
		cover = FALSE
		update_icon() //This vent is now burst.
	(cover) ? user.visible_message("<span class='userdanger'>[user] violently bursts out of [src]!</span>", "<span class='warning'>You burst through [src]!</span>") : user.visible_message("You hear something squeezing through the ducts.", "You climb out the ventilation system.")
	user.remove_ventcrawl()
	user.forceMove(get_turf(src)) //handles entering and so on
*/