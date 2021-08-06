

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

/obj/item/weapon/tool/pickaxe/xeno/excavationdrill
	name = "excavation drill"
	icon = 'icons/obj/xenoarchaeology.dmi'
	icon_state = "excavationdrill0"
	item_state = "excavationdrill"
	var/depth = 5
	tool_qualities = list(QUALITY_DIGGING = 5)
	desc = "Basic archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The tip is adjustable from 1 to 30 cms."
	worksound = 'sound/weapons/thudswoosh.ogg'
	hitsound = 'sound/weapons/circsawhit.ogg'
	force = 15.0
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("drills")

/obj/item/weapon/tool/pickaxe/xeno/excavationdrill/attack_self(mob/user)
	var/excavation_amount = input("Put the desired depth (1-30 centimeters).", "Set Depth", depth)
	if(excavation_amount > 30 || excavation_amount < 1)
		to_chat(user, "<span class='notice'>Invalid depth.</span>")
		return
	depth = excavation_amount
	tool_qualities[1] = depth

	to_chat(user, "<span class='notice'>You set the depth to [depth]cm.</span>")
	if (depth < 4)
		icon_state = "excavationdrill0"
	else if (depth >= 4 && depth < 8)
		icon_state = "excavationdrill1"
	else if (depth >= 8 && depth < 12)
		icon_state = "excavationdrill2"
	else if (depth >= 12 && depth < 16)
		icon_state = "excavationdrill3"
	else if (depth >= 16 && depth < 20)
		icon_state = "excavationdrill4"
	else if (depth >= 20 && depth < 24)
		icon_state = "excavationdrill5"
	else if (depth >= 24 && depth < 28)
		icon_state = "excavationdrill6"
	else
		icon_state = "excavationdrill7"

/obj/item/weapon/tool/pickaxe/xeno/excavationdrill/examine(mob/user)
	..()
	to_chat(user, "<span class='info'>It is currently set at [depth]cm.</span>")

/obj/item/weapon/tool/pickaxe/xeno/excavationdrill/adv
	name = "diamond excavation drill"
	icon_state = "Dexcavationdrill0"
	item_state = "Dexcavationdrill"
	depth = 3
	desc = "Advanced archaeological drill combining ultrasonic excitation and bluespace manipulation to provide extreme precision. The diamond tip is adjustable from 1 to 100 cms."

/obj/item/weapon/tool/pickaxe/xeno/excavationdrill/adv/attack_self(mob/user)
	var/excavation_amount = input("Put the desired depth (1-100 centimeters).", "Set Depth", depth)
	if(excavation_amount > 100 || excavation_amount < 1)
		to_chat(user, "<span class='notice'>Invalid depth.</span>")
		return
	depth = excavation_amount
	tool_qualities[1] = depth

	to_chat(user, "<span class='notice'>You set the depth to [depth]cm.</span>")
	if (depth < 12)
		icon_state = "Dexcavationdrill0"
	else if (depth >= 12 && depth < 24)
		icon_state = "Dexcavationdrill1"
	else if (depth >= 24 && depth < 36)
		icon_state = "Dexcavationdrill2"
	else if (depth >= 36 && depth < 48)
		icon_state = "Dexcavationdrill3"
	else if (depth >= 48 && depth < 60)
		icon_state = "Dexcavationdrill4"
	else if (depth >= 60 && depth < 72)
		icon_state = "Dexcavationdrill5"
	else if (depth >= 72 && depth < 84)
		icon_state = "Dexcavationdrill6"
	else
		icon_state = "Dexcavationdrill7"
