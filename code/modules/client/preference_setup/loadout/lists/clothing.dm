
/datum/gear/clothing/
	sort_category = "Clothing Pieces"
	category = /datum/gear/clothing/
	slot = slot_tie

/datum/gear/clothing/scarf
	display_name = "scarf"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/clothing/hazard
	display_name = "hazard overalls"
	slot = slot_w_uniform
	path = /obj/item/clothing/under/hazard
	allowed_roles = list(/datum/job/ce, /datum/job/tech_engineer)

/datum/gear/clothing/bomberjacket
	display_name = "bomber jacket"
	slot = slot_wear_suit_str
	path = /obj/item/clothing/suit/storage/toggle/bomber
	allowed_roles = list(/datum/job/salvage, /datum/job/dom, /datum/job/foreman, /datum/job/planet_cracker)

/datum/gear/clothing/medicaljacket
	display_name = "emergency medical jacket"
	slot = slot_wear_suit_str
	path = /obj/item/clothing/suit/storage/toggle/ems
	allowed_roles = list(/datum/job/md)

/datum/gear/clothing/leatherjacket
	display_name = "leather jacket"
	slot = slot_wear_suit_str
	path = /obj/item/clothing/suit/storage/leather_jacket
	allowed_roles = list(/datum/job/so, /datum/job/serviceman, /datum/job/botanist)














