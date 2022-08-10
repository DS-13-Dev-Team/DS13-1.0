

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pack for holding pickaxes

/obj/item/storage/excavation
	name = "excavation pick set"
	icon = 'icons/obj/storage.dmi'
	icon_state = "excavation"
	item_state = "utility"
	desc = "A rugged case containing a set of standardized picks used in archaeological digs."
	item_state = "syringe_kit"
	storage_slots = 7
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/tool/pickaxe/xeno)
	max_storage_space = 18
	max_w_class = ITEM_SIZE_NORMAL
	use_to_pickup = 1
	startswith = list(
		/obj/item/tool/pickaxe/xeno/brush,
		/obj/item/tool/pickaxe/xeno/one_pick,
		/obj/item/tool/pickaxe/xeno/two_pick,
		/obj/item/tool/pickaxe/xeno/three_pick,
		/obj/item/tool/pickaxe/xeno/four_pick,
		/obj/item/tool/pickaxe/xeno/five_pick,
		/obj/item/tool/pickaxe/xeno/six_pick)

/obj/item/storage/excavation/handle_item_insertion()
	..()
	sort_picks()

/obj/item/storage/excavation/proc/sort_picks()
	var/list/obj/item/tool/pickaxe/xeno/picksToSort = list()
	for(var/obj/item/tool/pickaxe/xeno/P in src)
		picksToSort += P
		P.loc = null
	while(picksToSort.len)
		var/min = 200 // No pick is bigger than 200
		var/selected = 0
		for(var/i = 1 to picksToSort.len)
			var/obj/item/tool/pickaxe/xeno/current = picksToSort[i]
			if(current.get_tool_quality(QUALITY_DIGGING) <= min)
				selected = i
				min = current.get_tool_quality(QUALITY_DIGGING)
		var/obj/item/tool/pickaxe/xeno/smallest = picksToSort[selected]
		smallest.loc = src
		picksToSort -= smallest
	prepare_ui()

/obj/item/tool/pickaxe/xeno/excavationdrill
	name = "excavation drill"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "excavationdrill0"
	item_state = "excavationdrill"
	tool_qualities = list(QUALITY_DIGGING = 5)
	desc = "Basic archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The tip is adjustable from 1 to 30 cms."
	worksound = 'sound/weapons/thudswoosh.ogg'
	hitsound = 'sound/weapons/circsawhit.ogg'
	force = 15.0
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("drills")

/obj/item/tool/pickaxe/xeno/excavationdrill/attack_self(mob/user)
	var/excavation_amount = input("Put the desired depth (1-30 centimeters).", "Set Depth", tool_qualities[QUALITY_DIGGING])
	if(excavation_amount > 30 || excavation_amount < 1)
		to_chat(user, "<span class='notice'>Invalid depth.</span>")
		return
	tool_qualities[QUALITY_DIGGING] = excavation_amount

	to_chat(user, "<span class='notice'>You set the depth to [tool_qualities[QUALITY_DIGGING]]cm.</span>")
	if (tool_qualities[QUALITY_DIGGING] < 4)
		icon_state = "excavationdrill0"
	else if (tool_qualities[QUALITY_DIGGING] >= 4 && tool_qualities[QUALITY_DIGGING] < 8)
		icon_state = "excavationdrill1"
	else if (tool_qualities[QUALITY_DIGGING] >= 8 && tool_qualities[QUALITY_DIGGING] < 12)
		icon_state = "excavationdrill2"
	else if (tool_qualities[QUALITY_DIGGING] >= 12 && tool_qualities[QUALITY_DIGGING] < 16)
		icon_state = "excavationdrill3"
	else if (tool_qualities[QUALITY_DIGGING] >= 16 && tool_qualities[QUALITY_DIGGING] < 20)
		icon_state = "excavationdrill4"
	else if (tool_qualities[QUALITY_DIGGING] >= 20 && tool_qualities[QUALITY_DIGGING] < 24)
		icon_state = "excavationdrill5"
	else if (tool_qualities[QUALITY_DIGGING] >= 24 && tool_qualities[QUALITY_DIGGING] < 28)
		icon_state = "excavationdrill6"
	else
		icon_state = "excavationdrill7"

/obj/item/tool/pickaxe/xeno/excavationdrill/examine(mob/user)
	..()
	to_chat(user, "<span class='info'>It is currently set at [tool_qualities[QUALITY_DIGGING]]cm.</span>")

/obj/item/tool/pickaxe/xeno/excavationdrill/adv
	name = "diamond excavation drill"
	icon_state = "Dexcavationdrill0"
	item_state = "Dexcavationdrill"
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The diamond tip is adjustable from 1 to 100 cms."

/obj/item/tool/pickaxe/xeno/excavationdrill/adv/attack_self(mob/user)
	var/excavation_amount = input("Put the desired depth (1-100 centimeters).", "Set Depth", tool_qualities[QUALITY_DIGGING])
	if(excavation_amount > 100 || excavation_amount < 1)
		to_chat(user, "<span class='notice'>Invalid depth.</span>")
		return
	tool_qualities[QUALITY_DIGGING] = excavation_amount

	to_chat(user, "<span class='notice'>You set the depth to [tool_qualities[QUALITY_DIGGING]]cm.</span>")
	if (tool_qualities[QUALITY_DIGGING] < 12)
		icon_state = "Dexcavationdrill0"
	else if (tool_qualities[QUALITY_DIGGING] >= 12 && tool_qualities[QUALITY_DIGGING] < 24)
		icon_state = "Dexcavationdrill1"
	else if (tool_qualities[QUALITY_DIGGING] >= 24 && tool_qualities[QUALITY_DIGGING] < 36)
		icon_state = "Dexcavationdrill2"
	else if (tool_qualities[QUALITY_DIGGING] >= 36 && tool_qualities[QUALITY_DIGGING] < 48)
		icon_state = "Dexcavationdrill3"
	else if (tool_qualities[QUALITY_DIGGING] >= 48 && tool_qualities[QUALITY_DIGGING] < 60)
		icon_state = "Dexcavationdrill4"
	else if (tool_qualities[QUALITY_DIGGING] >= 60 && tool_qualities[QUALITY_DIGGING] < 72)
		icon_state = "Dexcavationdrill5"
	else if (tool_qualities[QUALITY_DIGGING] >= 72 && tool_qualities[QUALITY_DIGGING] < 84)
		icon_state = "Dexcavationdrill6"
	else
		icon_state = "Dexcavationdrill7"
