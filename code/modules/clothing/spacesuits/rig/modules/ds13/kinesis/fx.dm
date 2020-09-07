/obj/effect/projectile/tether/lightning
	light_outer_range = 5
	light_max_bright = 1
	light_color = COLOR_KINESIS_INDIGO
	icon = 'icons/effects/128x48.dmi'
	icon_state = "lightning"
	plane = MOB_PLANE
	alpha = 128
	start_offset = new /vector2(-48,-8)
	base_length = 128

/obj/effect/projectile/tether/lightning/can_telegrip()
	return FALSE
