/*
	A store schematic is a consumable item which is found in random loot.

	Each one contains a single design ID. When used on a store kiosk, that design is uploaded, and it becomes available for purchase

	In the event that the design is already uploaded, it will change to a different one
*/

/obj/item/store_schematic
	name = "pinpointer"
	icon = 'icons/obj/pinpointer.dmi'
	icon_state = "pinoff"


	var/design_id = null