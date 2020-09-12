/datum/gear/head
	sort_category = "Hats and Headwear"
	slot = slot_head
	category = /datum/gear/head

/datum/gear/head/beret
	display_name = "beret, colour select"
	path = /obj/item/clothing/head/beret/plaincolor
	flags = GEAR_HAS_COLOR_SELECTION
	description = "A simple, solid color beret. This one has no emblems or insignia on it."

/datum/gear/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head

/datum/gear/head/cap/New()
	..()
	var/caps = list()
	caps["black cap"] = /obj/item/clothing/head/soft/black
	caps["flat cap"] = /obj/item/clothing/head/flatcap
	caps["green cap"] = /obj/item/clothing/head/soft/green
	caps["grey cap"] = /obj/item/clothing/head/soft/grey
	caps["orange cap"] = /obj/item/clothing/head/soft/orange
	gear_tweaks += new/datum/gear_tweak/path(caps)

/datum/gear/head/formalhat
	display_name = "formal hat selection"
	path = /obj/item/clothing/head

/datum/gear/head/formalhat/New()
	..()
	var/formalhats = list()
	formalhats["top hat"] = /obj/item/clothing/head/that
	gear_tweaks += new/datum/gear_tweak/path(formalhats)
