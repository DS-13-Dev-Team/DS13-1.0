var/list/outfits_decls_
var/list/outfits_decls_root_
var/list/outfits_decls_by_type_

/proc/outfit_by_type(var/outfit_type)
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_by_type_[outfit_type]

/proc/outfits()
	if(!outfits_decls_root_)
		init_outfit_decls()
	return outfits_decls_

/proc/init_outfit_decls()
	if(outfits_decls_root_)
		return
	outfits_decls_ = list()
	outfits_decls_by_type_ = list()
	outfits_decls_root_ = new/decl/hierarchy/outfit()

/decl/hierarchy/outfit
	name = "Naked"

	var/uniform = null
	var/suit = null
	var/back = null
	var/belt = null
	var/gloves = null
	var/shoes = null
	var/head = null
	var/mask = null
	var/l_ear = null
	var/r_ear = null
	var/glasses = null
	var/id = null
	var/l_pocket = null
	var/r_pocket = null
	var/suit_store = null
	var/r_hand = null
	var/l_hand = null
	var/list/backpack_contents = list() // In the list(path=count,otherpath=count) format

	var/id_type
	var/id_desc
	var/id_slot

	var/pda_type
	var/pda_slot

	var/id_pda_assignment

	var/list/backpack_overrides = list()
	var/flags = OUTFIT_RESET_EQUIPMENT

	var/contains_randomisation = FALSE

	var/list/loadout_tags

	var/list/all_types = list()
	var/list/all_possible_types = list()
	var/list/implants

/decl/hierarchy/outfit/New(var/full_init = TRUE, var/list_entry = FALSE)
	..()

	setup_loadout_tags()

	for (var/a in ALL_OUTFIT_SLOTS)
		if (islist(vars[a]))
			contains_randomisation = TRUE
			all_possible_types += vars[a]
			vars[a] = pickweight(vars[a])
			all_types += vars[a]
		else if(vars[a])
			all_possible_types += vars[a]
			all_types += vars[a]

	if (list_entry)
		backpack_overrides = backpack_overrides || list()

		if(is_hidden_category())
			return
		outfits_decls_by_type_[type] = src
		dd_insertObjectList(outfits_decls_, src)
		setup_loadout_tags()

/decl/hierarchy/outfit/proc/pre_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_RESET_EQUIPMENT)
		H.delete_inventory(TRUE)

/decl/hierarchy/outfit/proc/post_equip(mob/living/carbon/human/H)
	if(flags & OUTFIT_HAS_JETPACK)
		var/obj/item/weapon/tank/jetpack/J = locate(/obj/item/weapon/tank/jetpack) in H
		if(!J)
			return
		J.toggle()
		J.toggle_valve()

// A proc for non-human species, specially Unathi and Tajara, since they e.g.
// can't normally wear gloves as humans. Correct this issue by trying again, but
// apply some changes to the said item.
//
// Currently checks for gloves
//
// If you want to add more items that has species restriction, consider follow-
// ing the same format as the gloves shown in the code below. Thanks.
/decl/hierarchy/outfit/proc/check_and_try_equip_xeno(mob/living/carbon/human/H)
	var/datum/species/S = H.species
	if (!S || istype(S, /datum/species/human)) // null failcheck & get out here you damn humans
		return

	// Gloves
	if (gloves && !H.get_equipped_item(slot_gloves)) // does mob not have gloves, despite the outfit has one specified?
		var/obj/item/clothing/gloves/G = create_item(gloves, H) // we've no use of a null object, instantize one
		if (S.get_bodytype(H) in G.species_restricted) // what was the problem?
			if ("exclude" in G.species_restricted) // are they excluded?
				G.cut_fingertops()
				// I could optimize this bit when we are trying to apply the gloves to e.g. Vox, a species still restricted despite G.cut_fingertops(). But who cares if this is codebase is like a plate of spaghetti twice over the brim, right? RIGHT?
				H.equip_to_slot_or_del(G,slot_gloves) // try again
		else
			qdel(G)
	// end Gloves

// end of check_and_try_equip_xeno

/decl/hierarchy/outfit/proc/equip(mob/living/carbon/human/H, var/rank, var/assignment, var/equip_adjustments)
	equip_base(H, equip_adjustments)

	rank = id_pda_assignment || rank
	assignment = id_pda_assignment || assignment || rank
	var/obj/item/weapon/card/id/W = equip_id(H, rank, assignment, equip_adjustments)
	if(W)
		rank = W.rank
		assignment = W.assignment

	equip_pda(H, rank, assignment, equip_adjustments)

	equip_stored(H, equip_adjustments)

	if(!(OUTFIT_ADJUSTMENT_SKIP_POST_EQUIP & equip_adjustments))
		post_equip(H)
	H.regenerate_icons()
	if(W) // We set ID info last to ensure the ID photo is as correct as possible.
		H.set_id_info(W)
	return TRUE

/decl/hierarchy/outfit/proc/equip_base(mob/living/carbon/human/H, var/equip_adjustments, var/overwrite = FALSE)
	pre_equip(H)

	//Start with uniform,suit,backpack for additional slots
	if(uniform)
		if (overwrite && H.w_uniform)
			QDEL_NULL(H.w_uniform)
		H.equip_to_slot_or_del(create_item(uniform, H),slot_w_uniform)
	if(suit)
		if (overwrite && H.wear_suit)
			QDEL_NULL(H.wear_suit)
		H.equip_to_slot_or_del(create_item(suit, H),slot_wear_suit)
	if(back)
		if (overwrite && H.back)
			QDEL_NULL(H.back)
		H.equip_to_slot_or_del(create_item(back, H),slot_back)
	if(belt)
		if (overwrite && H.belt)
			QDEL_NULL(H.belt)
		H.equip_to_slot_or_del(create_item(belt, H),slot_belt)
	if(gloves)
		if (overwrite && H.gloves)
			QDEL_NULL(H.gloves)
		H.equip_to_slot_or_del(create_item(gloves, H),slot_gloves)
	if(shoes)
		if (overwrite && H.shoes)
			QDEL_NULL(H.shoes)
		H.equip_to_slot_or_del(create_item(shoes, H),slot_shoes)
	if(head)
		if (overwrite && H.head)
			QDEL_NULL(H.head)
		H.equip_to_slot_or_del(create_item(head, H),slot_head)
	if(mask)
		if (overwrite && H.wear_mask)
			QDEL_NULL(H.wear_mask)
		H.equip_to_slot_or_del(create_item(mask, H),slot_wear_mask)
	if(l_ear)
		if (overwrite && H.l_ear)
			QDEL_NULL(H.l_ear)
		H.equip_to_slot_or_del(create_item(l_ear, H),slot_l_ear)
	if(r_ear)
		if (overwrite && H.r_ear)
			QDEL_NULL(H.r_ear)
		H.equip_to_slot_or_del(create_item(r_ear, H),slot_r_ear)
	if(glasses)
		if (overwrite && H.glasses)
			QDEL_NULL(H.glasses)
		H.equip_to_slot_or_del(create_item(glasses, H),slot_glasses)
	if(id)
		if (overwrite && H.wear_id)
			QDEL_NULL(H.wear_id)
		H.equip_to_slot_or_del(create_item(id, H),slot_wear_id)
	if(suit_store)
		if (overwrite && H.s_store)
			QDEL_NULL(H.s_store)
		H.equip_to_slot_or_del(create_item(suit_store, H),slot_s_store)
	if(l_hand)
		H.put_in_l_hand(create_item(l_hand, H))
	if(r_hand)
		H.put_in_r_hand(create_item(r_hand, H))

	if((flags & OUTFIT_HAS_BACKPACK) && !(OUTFIT_ADJUSTMENT_SKIP_BACKPACK & equip_adjustments))
		var/decl/backpack_outfit/bo
		var/metadata

		if(H.backpack_setup)
			bo = H.backpack_setup.backpack
			metadata = H.backpack_setup.metadata
		else
			bo = get_default_outfit_backpack()

		var/override_type = backpack_overrides[bo.type]
		var/backpack = bo.spawn_backpack(H, metadata, override_type)

		if(backpack)
			if(back)
				if(!H.put_in_hands(backpack))
					H.equip_to_appropriate_slot(backpack)
			else
				H.equip_to_slot_or_del(backpack, slot_back)


	check_and_try_equip_xeno(H)

/decl/hierarchy/outfit/proc/equip_id(var/mob/living/carbon/human/H, var/rank, var/assignment, var/equip_adjustments)
	if(!id_slot || !id_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/weapon/card/id/W = create_item(id_type, H)
	if(id_desc)
		W.desc = id_desc
	if(rank)
		W.rank = rank
	if(assignment)
		W.assignment = assignment
	H.set_id_info(W)
	if(H.equip_to_slot_or_store_or_drop(W, id_slot))
		return W

/decl/hierarchy/outfit/proc/equip_pda(var/mob/living/carbon/human/H, var/rank, var/assignment, var/equip_adjustments)
	if(!pda_slot || !pda_type)
		return
	if(OUTFIT_ADJUSTMENT_SKIP_ID_PDA & equip_adjustments)
		return
	var/obj/item/modular_computer/pda/pda = create_item(pda_type, H)
	if(H.equip_to_slot_or_store_or_drop(pda, pda_slot))
		return pda

/decl/hierarchy/outfit/proc/equip_stored(mob/living/carbon/human/H, var/equip_adjustments, var/overwrite = FALSE)
	var/list/items_to_store = list()
	for(var/path in backpack_contents)
		var/number = backpack_contents[path]
		for(var/i=0,i<number,i++)
			items_to_store += path

	H.mass_equip_to_storage(items_to_store)


	if(H.species && !(OUTFIT_ADJUSTMENT_SKIP_SURVIVAL_GEAR & equip_adjustments))
		H.species.equip_survival_gear(H, flags&OUTFIT_EXTENDED_SURVIVAL)

/decl/hierarchy/outfit/dd_SortValue()
	return name


//Wrapper for creating, so that we can manipulate the items
/decl/hierarchy/outfit/proc/create_item(var/path, var/location)
	return new path(location)


/decl/hierarchy/outfit/proc/copy()
    var/savefile/s = new
    s << src
    var/decl/hierarchy/outfit/copy
    s >> copy
    return copy


//Returns a list of all the item paths this outfit contains, along with a quantity
//Returned list is in the format path = quantity
/decl/hierarchy/outfit/proc/get_all_item_paths()
	var/list/data = list()
	for (var/item in all_types)
		data[item] = 1
	for (var/implant in implants)
		data[implant] = 1

	data.Add(backpack_contents)
	return data

//Returns a list of all the paths this outfit could contain. This includes the entireity of random lists
/decl/hierarchy/outfit/proc/get_all_possible_item_paths()
	var/list/data = list()
	for (var/item in all_possible_types)
		data[item] = 1
	for (var/implant in implants)
		data[implant] = 1

	data.Add(backpack_contents)
	return data

/*
	Returns all the things in this outfit, in the format:
	list(list(inventory slot, outfit_slot,typepath, quantity))
*/
/decl/hierarchy/outfit/proc/get_slotted_item_paths()
	var/list/slots = OUTFIT_SLOT_TO_INVENTORY_SLOT
	var/list/data = list()
	for (var/outfit_slot in slots)
		if (vars[outfit_slot])
			var/inventory_slot = slots[outfit_slot]
			var/list/subdata = list(inventory_slot, outfit_slot, vars[outfit_slot], 1)

			data += list(subdata)


/decl/hierarchy/outfit/proc/setup_loadout_tags()
	loadout_tags = list()
	for (var/typepath in get_all_item_paths())
		loadout_tags |= get_loadout_tags_from_type(typepath)

/*
	INSTANCE ONLY PROCS
	These modify ourself in destructive ways, they should only be called from an instanced copy of an outfit, not on the version stored in global lists
*/
/*
	Takes a list of tags to exclude
	Removes anything from this loadout which have those tags
*/
/decl/hierarchy/outfit/proc/filter_loadout_tags(var/list/exclusion)
	loadout_tags = list()
	var/list/outfit_items = get_slotted_item_paths()

	//Outfit item is a sublist in the format: list(inventory slot, outfit_slot,typepath, quantity)
	for (var/list/outfit_item in outfit_items)
		var/list/itemtags = get_loadout_tags_from_type(outfit_item[3])

		//Does this item have any of the excluded tags?
		if (itemtags & exclusion)
			//If so, we remove it from this outfit
			var/outfit_slot = outfit_item[2]
			vars[outfit_slot] = null