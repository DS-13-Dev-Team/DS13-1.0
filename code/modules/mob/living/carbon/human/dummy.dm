/*
	Dummy: An inert humanoid mob used for testing and debugging.
	They don't do life ticks, and they won't fall over without a client in them
*/
/mob/living/carbon/human/dummy
	real_name = "Test Dummy"
	status_flags = GODMODE|CANPUSH
	virtual_mob = null

//This one starts off holding a riot shield and wearing riot armor
/mob/living/carbon/human/dummy/shielded/Initialize()
	.=..()
	equip_to_appropriate_slot(new /obj/item/clothing/suit/armor/riot(loc))
	put_in_hands(new /obj/item/weapon/shield/riot(loc))


/mob/living/carbon/human/dummy/mannequin/Initialize()
	. = ..()
	STOP_PROCESSING(SSmobs, src)
	GLOB.human_mob_list -= src
	delete_inventory()

/mob/living/carbon/human/dummy/mannequin/add_to_living_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/add_to_dead_mob_list()
	return FALSE

/mob/living/carbon/human/dummy/mannequin/fully_replace_character_name(new_name)
	..("[new_name] (mannequin)", FALSE)

/mob/living/carbon/human/dummy/mannequin/InitializeHud()
	return	// Mannequins don't get HUDs