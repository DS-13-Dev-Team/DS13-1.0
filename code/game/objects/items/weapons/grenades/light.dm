/obj/item/grenade/light
	name = "illumination grenade"
	desc = "A grenade designed to illuminate an area without the use of a flame or electronics, regardless of the atmosphere."
	icon_state = "lightgrenade"
	item_state = "flashbang"
	det_time = 20
	light_range = 6
	light_power = 1
	light_on = FALSE

/obj/item/grenade/light/detonate()
	..()
	var/lifetime = rand(2 MINUTES, 4 MINUTES)
	var/color = pick("#49f37c", "#fc0f29", "#599dff", "#fa7c0b", "#fef923")

	playsound(src, 'sound/effects/snap.ogg', 80, 1)
	audible_message("<span class='warning'>\The [src] detonates with a sharp crack!</span>")
	set_light_color(color)
	QDEL_IN(src, lifetime)

	if (active)
		set_light_on(TRUE)
	else
		set_light_on(FALSE)