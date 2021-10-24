/datum/gear/tool
	sort_category = CATEGORY_TOOLS
	base_type = /datum/gear/tool

/*
	Dangerous Tools, high cost
*/

/datum/gear/tool/crowbar
	display_name = "crowbar"
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS
	path = /obj/item/weapon/tool/crowbar
	cost = 2

/datum/gear/tool/plasmasaw
	display_name = "plasma saw"
	subcategory = SUBCATEGORY_DANGEROUS_TOOLS
	path = /obj/item/weapon/tool/saw/plasma
	cost = 3

/datum/gear/tool/laserpick
	display_name = "laser pick"
	subcategory =SUBCATEGORY_DANGEROUS_TOOLS
	path = /obj/item/weapon/tool/pickaxe/laser
	cost = 3


/*
	Non dangerous tools
*/
/datum/gear/tool/tape
	display_name = "duct tape"
	subcategory = "Tools"
	path = /obj/item/weapon/tool/tape_roll
	cost = 2

/datum/gear/tool/cleanerspray
	display_name = "space cleaner spray"
	subcategory = "Tools"
	path = /obj/item/weapon/reagent_containers/spray/cleaner
	cost = 1

/*
	Illumination
*/
/datum/gear/tool/flashlight
	display_name = "flashlight"
	subcategory = "Illumination"
	path = /obj/item/device/flashlight
	cost = 1


/datum/gear/tool/flashlight2
	display_name = "LED flashlight"
	subcategory = "Illumination"
	path = /obj/item/device/flashlight/upgraded
	cost = 2

/datum/gear/tool/flashlight3
	display_name = "maglight"
	subcategory = "Illumination"
	path = /obj/item/device/flashlight/maglight
	cost = 3



/*
	Single Use tools
*/
/datum/gear/tool/metalfoam
	display_name = "metal foam grenade"
	subcategory = "Consumables"
	path = 	/obj/item/weapon/grenade/chem_grenade/metalfoam
	cost = 1

/datum/gear/tool/cleaner
	display_name = "cleaning grenade"
	subcategory = "Consumables"
	path = 	/obj/item/weapon/grenade/chem_grenade/cleaner
	cost = 1

/datum/gear/tool/oxycandle
	display_name = "oxygen candle"
	subcategory = "Consumables"
	path = 	/obj/item/device/oxycandle
	cost = 1


