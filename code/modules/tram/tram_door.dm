/obj/machinery/door/airlock/multi_tile/civilian/tram
	icon = 'icons/obj/doors/double/doortram.dmi'
	fill_file = null
	color_file = null
	color_fill_file = null
	stripe_file = null
	stripe_fill_file = null
	glass_file = null
	bolts_file = null
	deny_file = null
	lights_file = null
	welded_file = 'icons/obj/doors/double/doortram_weld.dmi'
	emag_file = null
	open_sound_powered = "doorheavyopen"
	open_sound_unpowered = "doorheavyopen"
	close_sound_powered = "doorheavyclose"
	close_sound_unpowered = "doorheavyclose"
	opacity = FALSE
	lights = 0
	glass = TRUE
	var/id = MAIN_STATION_TRAM

/obj/machinery/door/airlock/civilian/tram
	icon = 'icons/obj/doors/station/door_tram.dmi'
	stripe_color = null
	stripe_file = null
	stripe_fill_file = null
	bolts_file = null
	deny_file = null
	lights_file = null
	welded_file = 'icons/obj/doors/hazard/welded.dmi'
	emag_file = null
	opacity = FALSE
	glass = TRUE
	lights = 0
	open_sound_powered = "doorheavyopen"
	open_sound_unpowered = "doorheavyopen"
	close_sound_powered = "doorheavyclose"
	close_sound_unpowered = "doorheavyclose"

/obj/machinery/door/airlock/multi_tile/civilian/tram/shuttle
	icon = 'icons/obj/doors/double/doorshuttle.dmi'
	opacity = TRUE
	glass = FALSE
