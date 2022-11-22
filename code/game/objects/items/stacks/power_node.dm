/obj/item/stack/power_node
	name = "power nodes"
	desc = "It seems to be radiating a lot of energy."
	singular_name = "power node"
	icon = 'icons/obj/tools.dmi'
	icon_state = "powernode"
	w_class = ITEM_SIZE_SMALL
	max_amount = 20
	item_flags = ITEM_FLAG_NO_BLUDGEON
	origin_tech = list(TECH_MATERIAL = 6, TECH_BLUESPACE = 4)

/obj/item/stack/special_node
	name = "cutter nodes"
	desc = "A power node that seems to have been built to specifically enhance a plasma cutter in a strange manner."
	singular_name = "cutter node"
	icon = 'icons/obj/tools.dmi'
	color = "#e97f83"
	icon_state = "powernode"
	w_class = ITEM_SIZE_SMALL
	max_amount = 20
	item_flags = ITEM_FLAG_NO_BLUDGEON
	origin_tech = list(TECH_MATERIAL = 6, TECH_BLUESPACE = 4)

obj/item/stack/special_node/cutter

obj/item/stack/special_node/divet
	desc = "A power node that seems to have been built to specifically enhance a divet gun in a strange manner."
	name = "divet nodes"
	singular_name = "divet node"
	color = "#6e6ec1"