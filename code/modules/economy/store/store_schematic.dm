/*
	A store schematic is a consumable item which is found in random loot.

	Each one contains a single design ID. When used on a store kiosk, that design is uploaded, and it becomes available for purchase

	In the event that the design is already uploaded, it will change to a different one


	At the end of a round, some uploaded schematics will be lost to data corruption
*/



/obj/item/store_schematic
	name = "Store Schematic"
	icon = 'icons/obj/economy.dmi'
	icon_state = "schematic"

	var/design_name
	var/design_id = null


/obj/item/store_schematic/Initialize()
	.=..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/store_schematic/LateInitialize()
	.=..()
	get_design()

/obj/machinery/store/proc/handle_schematic(obj/item/store_schematic/I, mob/user)
	GLOB.unlimited_store_designs += I.design_id
	visible_message("Thank you for participating in the CEC Data Recovery programme, [user.real_name]. Your account has been credited with [REWARD_SCHEMATIC] credits")
	occupant.recieve_credits(REWARD_SCHEMATIC, machine_id, machine_id, "Schematic Bounty")
	occupant.remove_item(I)
	qdel(I)


/obj/item/store_schematic/proc/get_design()
	if(length(GLOB.public_store_designs))
		var/id = pick(GLOB.public_store_designs)
		var/datum/design/D = SSresearch.designs_by_id[id]
		design_name = D.item_name
		design_id = D.id
		name = "Store Schematic ([design_name])"
		GLOB.public_store_designs -= id
	else // There are no unknown designs left? We'll just have to delete ourselves
		QDEL_IN(src, 1)
		new /obj/random/rare_loot(get_turf(src))


/obj/machinery/store/proc/handle_peng(obj/item/peng/I, mob/user)
	visible_message("Thank you for participating in the Peng cross-promotional scheme, [user.real_name]. Your account has been credited with [PENG_BOUNTY] credits")
	occupant.recieve_credits(PENG_BOUNTY, machine_id, machine_id, "Peng Bounty")

	occupant.remove_item(I)
	qdel(I)
