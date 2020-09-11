/obj/item/clothing/head/soft
	name = "cargo cap"
	desc = "It's a peaked cap in a tasteless yellow color."
	icon_state = "cargosoft"
	item_state_slots = list(
		slot_l_hand_str = "helmet", //probably a placeholder
		slot_r_hand_str = "helmet",
		)
	var/flipped = 0
	siemens_coefficient = 0.9
	body_parts_covered = 0

/obj/item/clothing/head/soft/New()
	..()
	set_extension(src, /datum/extension/base_icon_state, icon_state)
	update_icon()

/obj/item/clothing/head/soft/update_icon()
	var/datum/extension/base_icon_state/bis = get_extension(src, /datum/extension/base_icon_state)
	if(flipped)
		icon_state = "[bis.base_icon_state]_flipped"
	else
		icon_state = bis.base_icon_state

/obj/item/clothing/head/soft/dropped()
	src.flipped=0
	update_icon()
	..()

/obj/item/clothing/head/soft/attack_self(mob/user)
	src.flipped = !src.flipped
	if(src.flipped)
		to_chat(user, "You flip the hat backwards.")
	else
		to_chat(user, "You flip the hat back in normal position.")
	update_icon()
	update_clothing_icon()	//so our mob-overlays update

/obj/item/clothing/head/soft/green
	name = "green cap"
	desc = "It's a peaked cap in a tasteless green color."
	icon_state = "greensoft"

/obj/item/clothing/head/soft/grey
	name = "grey cap"
	desc = "It's a peaked cap in a tasteful grey color."
	icon_state = "greysoft"

/obj/item/clothing/head/soft/orange
	name = "orange cap"
	desc = "It's a peaked cap in a tasteless orange color."
	icon_state = "orangesoft"

/obj/item/clothing/head/soft/black
	name = "black cap"
	desc = "It's a peaked cap in a tasteful black color."
	icon_state = "blacksoft"

/obj/item/clothing/head/soft/sec_corp
	name = "corporate security cap"
	desc = "It's field cap in corporate colors."
	icon_state = "corpsoft"

/obj/item/clothing/head/soft/sec_corp/guard
	name = "\improper NanoTrasen security cap"
	desc = "It's field cap in NanoTrasen colors."
	icon_state = "ntwhitesoft"