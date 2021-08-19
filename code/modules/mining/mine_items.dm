


/**********************Mining car (Crate like thing, not the rail car)**************************/

/obj/structure/closet/crate/miningcar
	desc = "A mining car. This one doesn't work on rails, but has to be dragged."
	name = "Mining car (not for rails)"
	icon = 'icons/obj/storage.dmi'
	icon_state = "miningcar"
	density = 1
	icon_opened = "miningcaropen"
	icon_closed = "miningcar"

// Flags.

/obj/item/stack/flag
	name = "flags"
	desc = "Some colourful flags."
	singular_name = "flag"
	amount = 10
	max_amount = 10
	icon = 'icons/obj/mining.dmi'

	var/upright = 0
	var/fringe = null

/obj/item/stack/flag/red
	name = "red flags"
	singular_name = "red flag"
	icon_state = "redflag"
	fringe = "redflag_fringe"
	light_color = COLOR_RED

/obj/item/stack/flag/yellow
	name = "yellow flags"
	singular_name = "yellow flag"
	icon_state = "yellowflag"
	fringe = "yellowflag_fringe"
	light_color = COLOR_YELLOW

/obj/item/stack/flag/green
	name = "green flags"
	singular_name = "green flag"
	icon_state = "greenflag"
	fringe = "greenflag_fringe"
	light_color = COLOR_LIME

/obj/item/stack/flag/solgov
	name = "sol gov flags"
	singular_name = "sol gov flag"
	icon_state = "solgovflag"
	fringe = "solgovflag_fringe"
	desc = "A portable flag with the Sol Government symbol on it. I claim this land for Sol!"
	light_color = COLOR_BLUE

/obj/item/stack/flag/attackby(var/obj/item/W, var/mob/user)
	if(upright)
		attack_hand(user)
		return
	return ..()

/obj/item/stack/flag/attack_hand(var/mob/user)
	if(upright)
		knock_down()
		user.visible_message("\The [user] knocks down \the [singular_name].")
		return
	return ..()

/obj/item/stack/flag/attack_self(var/mob/user)
	var/turf/T = get_turf(src)

	if(istype(T, /turf/space) || istype(T, /turf/simulated/open))
		to_chat(user, "<span class='warning'>There's no solid surface to plant the flag on.</span>")
		return

	for(var/obj/item/stack/flag/F in T)
		if(F.upright)
			to_chat(user, "<span class='warning'>\The [F] is already planted here.</span>")
			return

	if(use(1)) // Don't skip use() checks even if you only need one! Stacks with the amount of 0 are possible, e.g. on synthetics!
		var/obj/item/stack/flag/newflag = new src.type(T, 1)
		newflag.set_up()
		if(istype(T, /turf/simulated/floor/asteroid) || istype(T, /turf/simulated/floor/exoplanet))
			user.visible_message("\The [user] plants \the [newflag.singular_name] firmly in the ground.")
		else
			user.visible_message("\The [user] attaches \the [newflag.singular_name] firmly to the ground.")

/obj/item/stack/flag/proc/set_up()
	pixel_x = 0
	pixel_y = 0
	upright = 1
	anchored = 1
	icon_state = "[initial(icon_state)]_open"
	if(fringe)
		set_light(0.2, 0.1, 1) // Very dim so the rest of the flag is barely visible - if the turf is completely dark, you can't see anything on it, no matter what
		var/image/addon = image(icon = src.icon, icon_state = fringe) // Bright fringe
		addon.layer = ABOVE_LIGHTING_LAYER
		addon.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		overlays += addon

/obj/item/stack/flag/proc/knock_down()
	pixel_x = rand(-randpixel, randpixel)
	pixel_y = rand(-randpixel, randpixel)
	upright = 0
	anchored = 0
	icon_state = initial(icon_state)
	overlays.Cut()
	set_light(0)