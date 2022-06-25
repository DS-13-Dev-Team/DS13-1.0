/obj/effect/projectile/tether/gravity
	light_range = 5
	light_power = 0.6
	light_color = COLOR_DEEP_SKY_BLUE
	icon = 'icons/effects/tethers.dmi'
	icon_state = "gravity_tether"

	start_offset = new /vector2(-16, 0)
	end_offset = new /vector2(-16, 0)

	animate_movement = 0
	lifespan = 0
	base_length = WORLD_ICON_SIZE *2

	atom_flags = ATOM_FLAG_INTANGIBLE | ATOM_FLAG_INDESTRUCTIBLE
