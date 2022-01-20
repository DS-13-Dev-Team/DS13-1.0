//"Wall" mounted vent variant. Pixelshifted to appear as though it's on the wall, however it should be placed on the floor to avoid suffocation / atmos issues.

/obj/machinery/atmospherics/unary/vent/pump/wall
	name = "Wall mounted vent pump"
	var/cover = TRUE //Is the wall-vent covered?
	layer = ABOVE_HUMAN_LAYER //So that the vents stack on top of the necromorphs.
	icon = 'icons/atmos/wallvent.dmi'

/obj/machinery/atmospherics/unary/vent/pump/wall/examine(mob/user)
	. = ..()
	if(!cover && locate(/mob) in contents)
		to_chat(user, "<span class='warning'>There's something lurking inside it...</span>")

/obj/machinery/atmospherics/unary/vent/pump/wall/north
	pixel_y = 26
	dir = NORTH

/obj/machinery/atmospherics/unary/vent/pump/wall/south
	pixel_y = -26
	dir = SOUTH

/obj/machinery/atmospherics/unary/vent/pump/wall/east
	pixel_x = 26
	dir = EAST

/obj/machinery/atmospherics/unary/vent/pump/wall/west
	pixel_x = -26
	dir = WEST


/mob/living/carbon/human/necromorph/is_allowed_vent_crawl_item(var/obj/item/carried_item)
	//FOR NOW. This is because necros can't really take their clothes off.
	if(istype(species, /datum/species/necromorph))
		return TRUE
	return ..()

/*
/obj/machinery/atmospherics/unary/vent/pump/wall/update_icon(safety)
	. = ..()
	//Probably best to do this with a icon state to save CPU.
	/*
	//No cover? Expose the necromorph underneath it..
	vis_contents = list()
	if(!cover)
		for(var/mob/living/M in contents)
			vis_contents |= M
	*/
*/

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
