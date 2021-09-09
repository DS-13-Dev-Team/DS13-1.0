/*
	species_changed is called on an item which is held or equipped on a mob at the moment it gets a species set.
	This will generally only happen during necromorph conversion
*/
/obj/item/proc/species_changed(var/mob/living/carbon/human/H, var/datum/species/S)
	//Retaining items which aren't clothing, is currently unsupported
	H.unEquip(src)

//Clothing is retained only if the new species supports it, which is checked through mob_can_equip
/obj/item/clothing/species_changed(var/mob/living/carbon/human/H, var/datum/species/S)
	if (equip_slot)
		if (!mob_can_equip(H, equip_slot, disable_warning = TRUE, force = TRUE))
			H.unEquip(src)

	//Future TODO: If a species alternative is set, spawn and equip it, then delete the old one here

//Dynamically converting rigs to necromorphs is not currently supported. This is a bit of a complex problem
//It will be added in future, for now rigs are simply unequpped
/obj/item/weapon/rig/species_changed(var/mob/living/carbon/human/H, var/datum/species/S)
	instant_unequip()