/spell/toggle_armor
	name = "Toggle Armor"
	spell_flags = 0
	charge_max = 10
	school = "Conjuration"
	var/list/armor_pieces
	var/equip = 0
	hud_state = "const_shell"

/spell/toggle_armor/New()
	if(armor_pieces)
		var/list/nlist = list()
		for(var/type in armor_pieces)
			var/obj/item/I = new type(null)
			nlist[I] = armor_pieces[type]
		armor_pieces = nlist
	return ..()

/spell/toggle_armor/proc/drop_piece(var/obj/I)
	if(istype(I.loc, /mob))
		var/mob/M = I.loc
		M.drop_from_inventory(I)

/spell/toggle_armor/choose_targets()
	return list(holder)

/spell/toggle_armor/cast(var/list/targets, var/mob/user)
	equip = !equip
	name = "[initial(name)] ([equip ? "off" : "on"])"
	if(equip)
		for(var/piece in armor_pieces)
			var/slot = armor_pieces[piece]
			drop_piece(piece)
			user.drop_from_inventory(user.get_equipped_item(slot))
			user.equip_to_slot_if_possible(piece,slot,0,1,1,1)
	else
		for(var/piece in armor_pieces)
			var/obj/item/I = piece
			drop_piece(piece)
			I.loc = null

/spell/toggle_armor/greytide_worldwide
	name = "Greytide Worldwide"
	invocation_type = SpI_EMOTE
	invocation = "screams incoherently!"
	armor_pieces = list(/obj/item/clothing/under/color/grey = slot_w_uniform,
						/obj/item/clothing/gloves/insulated/cheap = slot_gloves,
						/obj/item/clothing/mask/gas = slot_wear_mask,
						/obj/item/clothing/shoes/black = slot_shoes,
						/obj/item/weapon/storage/toolbox/mechanical = slot_r_hand,
						/obj/item/weapon/extinguisher = slot_l_hand)

/spell/toggle_armor/excalibur
	name = "Toggle Sword"
	invocation_type = SpI_EMOTE
	invocation = "thrusts /his hand forward, and it is enveloped in golden embers!"
	armor_pieces = list(/obj/item/weapon/excalibur = slot_r_hand)
	hud_state = "excalibur"

/spell/toggle_armor/infil_items
	name = "Toggle Counterfeit Kit"
	invocation_type = SpI_EMOTE
	invocation = "flicks /his wrists, one at a time"
	armor_pieces = list(/obj/item/weapon/stamp/chameleon = slot_l_hand,
						/obj/item/weapon/pen/chameleon = slot_r_hand)
	hud_state = "forgery"

/spell/toggle_armor/overseer
	name = "Toggle Armor (Overseer)"
	invocation_type = SpI_EMOTE
	invocation = " is enveloped in shadows, before /his form begins to shift rapidly"
	hud_state = "overseer"