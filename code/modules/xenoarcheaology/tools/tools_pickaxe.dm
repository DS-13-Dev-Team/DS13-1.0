

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pack for holding pickaxes

/obj/item/weapon/storage/excavation
	name = "excavation pick set"
	icon = 'icons/obj/storage.dmi'
	icon_state = "excavation"
	item_state = "utility"
	desc = "A rugged case containing a set of standardized picks used in archaeological digs."
	item_state = "syringe_kit"
	storage_slots = 7
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/weapon/tool/pickaxe/xeno)
	max_storage_space = 18
	max_w_class = ITEM_SIZE_NORMAL
	use_to_pickup = 1
	startswith = list(
		/obj/item/weapon/tool/pickaxe/xeno/brush,
		/obj/item/weapon/tool/pickaxe/xeno/one_pick,
		/obj/item/weapon/tool/pickaxe/xeno/two_pick,
		/obj/item/weapon/tool/pickaxe/xeno/three_pick,
		/obj/item/weapon/tool/pickaxe/xeno/four_pick,
		/obj/item/weapon/tool/pickaxe/xeno/five_pick,
		/obj/item/weapon/tool/pickaxe/xeno/six_pick)

/obj/item/weapon/storage/excavation/handle_item_insertion()
	..()
	sort_picks()

/obj/item/weapon/storage/excavation/proc/sort_picks()
	var/list/obj/item/weapon/tool/pickaxe/xeno/picksToSort = list()
	for(var/obj/item/weapon/tool/pickaxe/xeno/P in src)
		picksToSort += P
		P.loc = null
	while(picksToSort.len)
		var/min = 200 // No pick is bigger than 200
		var/selected = 0
		for(var/i = 1 to picksToSort.len)
			var/obj/item/weapon/tool/pickaxe/xeno/current = picksToSort[i]
			if(current.get_tool_quality(QUALITY_DIGGING) <= min)
				selected = i
				min = current.get_tool_quality(QUALITY_DIGGING)
		var/obj/item/weapon/tool/pickaxe/xeno/smallest = picksToSort[selected]
		smallest.loc = src
		picksToSort -= smallest
	prepare_ui()
