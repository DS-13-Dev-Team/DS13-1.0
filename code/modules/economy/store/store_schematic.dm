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

/obj/machinery/store/proc/handle_schematic(var/obj/item/store_schematic/I, var/mob/user)

	if (!I.design_id)
		I.get_design()

	var/success = SSdatabase.upload_design(I.design_id)

	if (!success)
		var/former_design = I.design_id
		I.get_design()
		to_chat(user, "Incorrect identification tag on schematic. Contents were falsely identified as [former_design] but are actually [I.design_id]")


		//One last attempt
		success = SSdatabase.upload_design(I.design_id)

	if (!success)
		//Terminal failure
		to_chat(user, "Fatal error: If this error persists, please contact your system administrator")
		return success


	visible_message("Thank you for participating in the CEC Data Recovery programme, [user.real_name]. Your account has been credited with [REWARD_SCHEMATIC] credits")
	occupant.recieve_credits(REWARD_SCHEMATIC, machine_id, machine_id, "Schematic Bounty")

	occupant.remove_item(I)
	qdel(I)

	return success

/obj/item/store_schematic/proc/get_design()

	//If the designs aren't populated, add ourself to a pending list, we'll be back!
	if (!SSdatabase.unknown_designs)
		SSdatabase.pending_schematics |= src
		return

	if (!length(SSdatabase.unknown_designs))
		//There are no unknown designs left? We'll just have to delete ourselves
		QDEL_IN(src, 1)
		new /obj/random/rare_loot(get_turf(src))
		return

	design_id = pick(SSdatabase.unknown_designs)

	var/datum/design/D = SSresearch.designs_by_id[design_id]
	design_name = D.item_name
	name = "Store Schematic ([design_name])"



/obj/machinery/store/proc/handle_peng(var/obj/item/weapon/peng/I, var/mob/user)



	visible_message("Thank you for participating in the Peng cross-promotional scheme, [user.real_name]. Your account has been credited with [PENG_BOUNTY] credits")
	occupant.recieve_credits(PENG_BOUNTY, machine_id, machine_id, "Peng Bounty")

	occupant.remove_item(I)
	qdel(I)
