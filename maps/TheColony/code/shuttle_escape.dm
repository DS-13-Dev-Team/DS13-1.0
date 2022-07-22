GLOBAL_LIST_EMPTY(shuttlerepairspawnlocs)
GLOBAL_LIST_EMPTY(shuttleparts)
/obj/item/shuttle_part
	name = "machine part"
	desc = "This is the part of some machine, yet you can't figure out which one."
	icon = 'icons/obj/items.dmi'
	icon_state = "shuttle_part"
	origin_tech = null

/obj/item/shuttle_part/Initialize()
	.=..()
	GLOB.shuttleparts += src
