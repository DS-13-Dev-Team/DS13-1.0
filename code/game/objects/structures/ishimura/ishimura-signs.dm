/obj/structure/sign/ishimura
	icon = 'maps/DeadSpace/icons/ishimura-signs.dmi'
	icon_state = "sign_base"
	anchored = 1
	opacity = 0
	density = 0
	max_health = 50
	layer = ABOVE_WINDOW_LAYER
	w_class = ITEM_SIZE_NORMAL
	name = "Direction Sign"
	desc = "A sign, telling you which way something is. This one is on."
	var/sign_dir = SOUTH

/obj/structure/sign/ishimura/update_icon()

	overlays.Cut()

	overlays += image(icon, src, "sign_directions") // Arrow signs.

	if (max_health < max_health*0.7)
		overlays += image(icon, src, "cracked_overlay")  // If item is damaged, this takes the overlay.
	if (max_health < max_health*0.25)
		icon_state = "broken_on" // If a sign is completely broken, it will no longer display any useful text that it originates from. Instead just blinks between error messages.
	else
		icon_state = "sign_base" // A healthy sign base, is a happy sign base.
		overlays += image(icon, src, "dept_eng")  // Base sign text.


/obj/structure/sign/ishimura/proc/set_pixel_offset()
	set_pixels(Vector2.FromDir(GLOB.reverse_dir[dir])*WORLD_ICON_SIZE*0.5)

