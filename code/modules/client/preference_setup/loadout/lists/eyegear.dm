/datum/gear/eyes
	sort_category = "Glasses and Eyewear"
	category = /datum/gear/eyes
	slot = slot_glasses

/datum/gear/eyes/glasses
	display_name = "prescription glasses"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/eyepatch
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch

/datum/gear/eyes/fashionglasses/New()
	..()
	var/glasses = list()
	glasses["green glasses"] = /obj/item/clothing/glasses/gglasses
	glasses["hipster glasses"] = /obj/item/clothing/glasses/regular/hipster
	glasses["monocle"] = /obj/item/clothing/glasses/monocle
	gear_tweaks += new/datum/gear_tweak/path(glasses)

/datum/gear/eyes/shades/
	display_name = "sunglasses"
	path = /obj/item/clothing/glasses/sunglasses
	cost = 3

/datum/gear/eyes/shades/sunglasses
	display_name = "sunglasses, fat"
	path = /obj/item/clothing/glasses/sunglasses/big
	cost = 3

/datum/gear/eyes/shades/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 3