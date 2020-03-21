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
	caps["blue cap"] = /obj/item/clothing/head/soft/blue
	caps["flat cap"] = /obj/item/clothing/head/flatcap
	caps["green cap"] = /obj/item/clothing/head/soft/green
	caps["grey cap"] = /obj/item/clothing/head/soft/grey
	caps["orange cap"] = /obj/item/clothing/head/soft/orange
	caps["purple cap"] = /obj/item/clothing/head/soft/purple
	caps["red cap"] = /obj/item/clothing/head/soft/red
	caps["white cap"] = /obj/item/clothing/head/soft/mime
	caps["yellow cap"] = /obj/item/clothing/head/soft/yellow
	gear_tweaks += new/datum/gear_tweak/path(caps)

/datum/gear/head/formalhat
	display_name = "formal hat selection"
	path = /obj/item/clothing/head

/datum/gear/head/formalhat/New()
	..()
	var/formalhats = list()
	formalhats["boatsman hat"] = /obj/item/clothing/head/boaterhat
	formalhats["bowler hat"] = /obj/item/clothing/head/bowler
	formalhats["fedora"] = /obj/item/clothing/head/fedora //m'lady
	formalhats["feather trilby"] = /obj/item/clothing/head/feathertrilby
	formalhats["fez"] = /obj/item/clothing/head/fez
	formalhats["top hat"] = /obj/item/clothing/head/that
	formalhats["fedora, brown"] = /obj/item/clothing/head/det
	formalhats["fedora, grey"] = /obj/item/clothing/head/det/grey
	gear_tweaks += new/datum/gear_tweak/path(formalhats)
