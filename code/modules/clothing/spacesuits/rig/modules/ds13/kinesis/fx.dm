/obj/effect/projectile/tether/lightning
	light_range = 5
	light_power = 0.8
	light_color = COLOR_KINESIS_INDIGO
	icon = 'icons/effects/128x48.dmi'
	icon_state = "lightning"
	alpha = 128

	//These should not be necessary, there's something fundamentally wrong with pixel calculations
	start_offset = new /vector2(-48,-8)
	end_offset = new /vector2(-48,-8)
	base_length = 128

/obj/effect/projectile/tether/lightning/can_telegrip()
	return FALSE
