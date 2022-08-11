/*
	Mining and plant bags, can store a ridiculous number of items in order to deal with the ridiculous amount of ores or plant products
	that can be produced by mining or (xeno)botany, however it can only hold those items.

	These storages typically should also support quick gather and quick empty to make managing large numbers of items easier.
*/

// -----------------------------
//        Mining Satchel
// -----------------------------

/obj/item/storage/ore
	name = "mining satchel"
	desc = "This sturdy bag can be used to store and transport ores."
	icon = 'icons/obj/mining.dmi'
	icon_state = "satchel"
	slot_flags = SLOT_BELT
	max_storage_space = 30
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_LARGE
	can_hold = list(/obj/item/stack/ore)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1


/obj/item/storage/ore/gather_all(var/turf/T, var/mob/user)
	var/success = 0
	var/failure = 0

	for(var/obj/item/stack/ore/O in T.contents)
		if(!can_be_inserted(O, user, 0))	// Note can_be_inserted still makes noise when the answer is no
			failure = 1
			continue
		success = 1
		//We assume there is only ore in the satchel
		for(var/obj/item/stack/ore/ore as anything in contents)
			if(!istype(O, ore.type))
				continue
			O.transfer_to(ore)
		if(!QDELING(O))
			handle_item_insertion(O, 1, 1) // First 1 is no messages, second 1 is no ui updates
	if(success && !failure)
		to_chat(user, "<span class='notice'>You put everything into \the [src].</span>")
		update_ui_after_item_insertion()
	else if(success)
		to_chat(user, "<span class='notice'>You put some things into \the [src].</span>")
		update_ui_after_item_insertion()
	else
		to_chat(user, "<span class='notice'>You fail to pick anything up with \the [src].</span>")

// -----------------------------
//          Plant bag
// -----------------------------

/obj/item/storage/plants
	name = "botanical satchel"
	desc = "This bag can be used to store all kinds of plant products and botanical specimen."
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbag"
	slot_flags = SLOT_BELT
	max_storage_space = 100
	max_w_class = ITEM_SIZE_SMALL
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/reagent_containers/food/snacks/grown,/obj/item/seeds,/obj/item/grown)
	allow_quick_gather = 1
	allow_quick_empty = 1
	use_to_pickup = 1


// -----------------------------
//        Sheet Snatcher
// -----------------------------
// Because it stacks stacks, this doesn't operate normally.
// However, making it a storage/bag allows us to reuse existing code in some places. -Sayu
// This is old and terrible

/obj/item/storage/sheetsnatcher
	name = "sheet snatcher"
	icon = 'icons/obj/mining.dmi'
	icon_state = "sheetsnatcher"
	desc = "A patented storage system designed for any kind of mineral sheet."

	storage_ui = /datum/storage_ui/default/sheetsnatcher

	var/capacity = 300; //the number of sheets it can carry.
	w_class = ITEM_SIZE_NORMAL
	storage_slots = 7

	allow_quick_empty = 1 // this function is superceded
	use_to_pickup = 1
	New()
		..()
		//verbs -= /obj/item/storage/verb/quick_empty
		//verbs += /obj/item/storage/sheetsnatcher/quick_empty

	can_be_inserted(obj/item/W, mob/user, stop_messages = 0)
		if(!istype(W,/obj/item/stack/material))
			if(!stop_messages)
				to_chat(user, "The snatcher does not accept [W].")
			return 0
		var/current = 0
		for(var/obj/item/stack/material/S in contents)
			current += S.amount
		if(capacity == current)//If it's full, you're done
			if(!stop_messages)
				to_chat(user, "<span class='warning'>The snatcher is full.</span>")
			return 0
		return 1


// Modified handle_item_insertion.  Would prefer not to, but...
	handle_item_insertion(obj/item/W as obj, prevent_warning = 0)
		var/obj/item/stack/material/S = W
		if(!istype(S)) return 0

		var/amount
		var/inserted = 0
		var/current = 0
		for(var/obj/item/stack/material/S2 in contents)
			current += S2.amount
		if(capacity < current + S.amount)//If the stack will fill it up
			amount = capacity - current
		else
			amount = S.amount

		for(var/obj/item/stack/material/sheet in contents)
			if(S.type == sheet.type) // we are violating the amount limitation because these are not sane objects
				sheet.amount += amount	// they should only be removed through procs in this file, which split them up.
				S.amount -= amount
				inserted = 1
				break

		if(!inserted || !S.amount)
			usr.drop_from_inventory(S, src)
			if(!S.amount)
				qdel(S)

		prepare_ui(usr)
		update_icon()
		return 1

// Modified quick_empty verb drops appropriate sized stacks
	quick_empty()
		var/location = get_turf(src)
		for(var/obj/item/stack/material/S in contents)
			while(S.amount)
				var/obj/item/stack/material/N = new S.type(location)
				var/stacksize = min(S.amount,N.max_amount)
				N.amount = stacksize
				S.amount -= stacksize
			if(!S.amount)
				qdel(S) // todo: there's probably something missing here
		prepare_ui()
		if(usr.s_active)
			usr.s_active.show_to(usr)
		update_icon()

// Instead of removing
	remove_from_storage(obj/item/W as obj, atom/new_location)
		var/obj/item/stack/material/S = W
		if(!istype(S)) return 0

		//I would prefer to drop a new stack, but the item/attack_hand code
		// that calls this can't recieve a different object than you clicked on.
		//Therefore, make a new stack internally that has the remainder.
		// -Sayu

		if(S.amount > S.max_amount)
			var/obj/item/stack/material/temp = new S.type(src)
			temp.amount = S.amount - S.max_amount
			S.amount = S.max_amount

		return ..(S,new_location)

// -----------------------------
//    Sheet Snatcher (Cyborg)
// -----------------------------

/obj/item/storage/sheetsnatcher/borg
	name = "sheet snatcher 9000"
	desc = ""
	capacity = 500//Borgs get more because >specialization