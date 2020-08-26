/datum/gear/tool
	sort_category = "Tools"
	category = /datum/gear/tool

/*
	Dangerous Tools, high cost
*/
/datum/gear/tool/rivetgun
	subcategory = "Dangerous Tools"
	display_name = "711-MarkCL Rivet Gun"
	path = /obj/item/weapon/gun/projectile/rivet
	patron_only = TRUE
	cost = 4


/datum/gear/tool/cutter
	display_name = "210-V mining cutter"
	subcategory = "Dangerous Tools"
	path = /obj/item/weapon/gun/energy/cutter
	cost = 4


/datum/gear/tool/crowbar
	display_name = "crowbar"
	subcategory = "Dangerous Tools"
	path = /obj/item/weapon/tool/crowbar
	cost = 2

/datum/gear/tool/plasmasaw
	display_name = "plasma saw"
	subcategory = "Dangerous Tools"
	path = /obj/item/weapon/tool/saw/plasma
	cost = 3

/datum/gear/tool/laserpick
	display_name = "laser pick"
	subcategory = "Dangerous Tools"
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


