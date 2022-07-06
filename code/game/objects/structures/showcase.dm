/obj/structure/showcase
	name = "showcase"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "showcase_1"
	desc = "A stand with the empty body of a cyborg bolted to it."
	density = 1
	anchored = 1
	unacidable = 1//temporary until I decide whether the borg can be removed. -veyveyr

/obj/structure/showcase/marker
	name = "Marker"
	icon = 'icons/obj/marker_giant.dmi'
	icon_state = "marker_giant_dormant"
	atom_flags = ATOM_FLAG_INDESTRUCTIBLE
	pixel_x = -32
	density = TRUE
	anchored = TRUE
	bound_x = -32
	bound_height = 64
	bound_width = 96
