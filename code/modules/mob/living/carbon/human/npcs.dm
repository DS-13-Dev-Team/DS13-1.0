/mob/living/carbon/human/monkey/punpun/New()
	..()
	name = "Pun Pun"
	real_name = name

/decl/hierarchy/outfit/blank_subject
	name = "Test Subject"
	uniform = /obj/item/clothing/under/color/white
	shoes = /obj/item/clothing/shoes/white
	head = /obj/item/clothing/head/helmet/facecover
	mask = /obj/item/clothing/mask/muzzle
	suit = /obj/item/clothing/suit/straight_jacket

/mob/living/carbon/human/blank/New(var/new_loc)
	..(new_loc, "Vat-Grown Human")

/mob/living/carbon/human/blank/Initialize()
	. = ..()
	var/number = "[pick(possible_changeling_IDs)]-[rand(1,30)]"
	fully_replace_character_name("Subject [number]")
	var/decl/hierarchy/outfit/outfit = outfit_by_type(/decl/hierarchy/outfit/blank_subject)
	outfit.equip(src)
	var/obj/item/clothing/head/helmet/facecover/F = locate() in src
	if(F)
		F.SetName("[F.name] ([number])")

/mob/living/carbon/human/blank/ssd_check()
	return FALSE
