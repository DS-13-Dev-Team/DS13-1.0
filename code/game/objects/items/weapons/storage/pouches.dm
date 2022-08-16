/obj/item/storage/pouch
	name = "pouch"
	desc = "Can hold various things."
	icon = 'icons/inventory/pockets/icon.dmi'
	icon_state = "pouch"
	item_state = "pouch"

	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_BELT //Pouches can be worn on belt
	storage_slots = 1
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_POUCH_MEDIUM
	matter = list(MATERIAL_BIOMATTER = 12)
	attack_verb = list("pouched")

	var/sliding_behavior = FALSE

/obj/item/storage/pouch/verb/toggle_slide()
	set name = "Toggle Slide"
	set desc = "Toggle the behavior of last item in [src] \"sliding\" into your hand."
	set category = "Object"

	sliding_behavior = !sliding_behavior
	to_chat(usr, SPAN_NOTICE("Items will now [sliding_behavior ? "" : "not"] slide out of [src]"))

/obj/item/storage/pouch/attack_hand(mob/living/carbon/human/user)
	if(src in user)
		if(!sliding_behavior)
			src.open(user)
			return
		else if(contents.len)
			var/obj/item/I = contents[contents.len]
			if(istype(I))
				hide_from(usr)
				var/turf/T = get_turf(user)
				remove_from_storage(I, T)
				usr.put_in_hands(I)
				add_fingerprint(user)
				return
	..()

/obj/item/storage/pouch/small_generic
	name = "small generic pouch"
	desc = "A small pouch which expands a pocket slot, allowing it to hold a couple of little things."
	icon_state = "small_generic"
	item_state = "small_generic"
	storage_slots = null //Uses generic capacity
	max_storage_space = DEFAULT_POUCH_SMALL
	max_w_class = ITEM_SIZE_SMALL

/obj/item/storage/pouch/medium_generic
	name = "medium generic pouch"
	desc = "A small pouch which expands a pocket slot, allowing it to hold several little things."
	icon_state = "medium_generic"
	item_state = "medium_generic"
	storage_slots = null //Uses generic capacity
	max_w_class = ITEM_SIZE_SMALL

/obj/item/storage/pouch/large_generic
	name = "large generic pouch"
	desc = "A mini satchel. Can hold a fair bit, worn around the waist."
	icon_state = "large_generic"
	item_state = "large_generic"
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT | SLOT_DENYPOCKET
	storage_slots = null //Uses generic capacity
	max_storage_space = DEFAULT_POUCH_LARGE
	max_w_class = ITEM_SIZE_NORMAL

/obj/item/storage/pouch/medical_supply
	name = "medical supply pouch"
	desc = "Can hold medical equipment. But only about three pieces of it."
	icon_state = "medical_supply"
	item_state = "medical_supply"

	storage_slots = 3
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/healthanalyzer,
		/obj/item/adv_health_analyzer,
		/obj/item/reagent_containers/dropper,
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
		/obj/item/reagent_containers/pill,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/pill_bottle,
		/obj/item/stack/medical,
		/obj/item/clothing/mask/surgical,
		/obj/item/clothing/head/surgery,
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/hypospray,
		/obj/item/clothing/glasses/hud/health,
		)

/obj/item/storage/pouch/engineering_tools
	name = "engineering tools pouch"
	desc = "Can hold small engineering tools. But only about three pieces of them."
	icon_state = "engineering_tool"
	item_state = "engineering_tool"

	storage_slots = 3
	max_w_class = ITEM_SIZE_SMALL

	can_hold = list(
		/obj/item/tool,
		/obj/item/flashlight,
		/obj/item/radio/headset,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/robotanalyzer,
		///obj/item/scanner/plant,
		/obj/item/extinguisher/mini,
		/obj/item/hand_labeler,
		/obj/item/clothing/gloves,
		/obj/item/clothing/glasses,
		/obj/item/flame/lighter,
		/obj/item/cell
		)

/obj/item/storage/pouch/engineering_supply
	name = "engineering supply pouch"
	desc = "Can hold engineering equipment. But only about two pieces of it."
	icon_state = "engineering_supply"
	item_state = "engineering_supply"

	storage_slots = 2
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/cell,
		/obj/item/circuitboard,
		/obj/item/tool,
		/obj/item/stack/material,
		/obj/item/material,
		/obj/item/flashlight,
		/obj/item/stack/cable_coil,
		/obj/item/t_scanner,
		/obj/item/analyzer,
		/obj/item/taperoll/engineering,
		/obj/item/robotanalyzer,
		/obj/item/extinguisher/mini
		)

/obj/item/storage/pouch/ammo
	name = "ammo pouch"
	desc = "Can hold ammo magazines and bullets, not the boxes though."
	icon_state = "ammo"
	item_state = "ammo"

	storage_slots = 3
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing
		)

//Basically for holding forcegun and contact beam ammo
/obj/item/storage/pouch/cell
	name = "energy cell pouch"
	desc = "Can hold two bulky power cells, whether for devices or the bulky ammunition cells for heavy weapons."
	icon_state = "energy"
	item_state = "energy"

	storage_slots = 2
	w_class = ITEM_SIZE_LARGE
	max_w_class = ITEM_SIZE_LARGE

	can_hold = list(
		/obj/item/cell
		)



/obj/item/storage/pouch/tubular
	name = "tubular pouch"
	desc = "Can hold five cylindrical and small items, including but not limiting to flares, glowsticks, syringes and even hatton tubes or rockets."
	icon_state = "flare"
	item_state = "flare"

	storage_slots = 5
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/glass/beaker/vial,
		/obj/item/reagent_containers/hypospray,
		/obj/item/pen,
		/obj/item/storage/pill_bottle,
		/obj/item/ammo_casing
		)

/obj/item/storage/pouch/tubular/vial
	name = "vial pouch"
	desc = "Can hold about five vials. Rebranding!"

/obj/item/storage/pouch/tubular/update_icon()
	..()
	overlays.Cut()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "flare_[contents.len]")

/obj/item/storage/pouch/pistol_holster
	name = "pistol holster"
	desc = "Can hold a handgun in."
	icon_state = "pistol_holster"
	item_state = "pistol_holster"

	storage_slots = 1
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_NORMAL

	can_hold = list(
		/obj/item/gun/projectile/divet,
		/obj/item/gun/energy/cutter,
		/obj/item/gun/projectile/shotgun/doublebarrel/sawn, //short enough to fit in
		)

	sliding_behavior = TRUE

/obj/item/storage/pouch/pistol_holster/update_icon()
	..()
	overlays.Cut()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "pistol_layer")

/obj/item/storage/pouch/baton_holster
	name = "baton sheath"
	desc = "Can hold a baton, or indeed most weapon shafts."
	icon_state = "baton_holster"
	item_state = "baton_holster"

	storage_slots = 1
	max_w_class = ITEM_SIZE_BULKY

	can_hold = list(
		/obj/item,
		/obj/item/tool/crowbar,
		/obj/item/tool/pickaxe
		)

	sliding_behavior = TRUE

/obj/item/storage/pouch/baton_holster/update_icon()
	..()
	overlays.Cut()
	if(contents.len)
		overlays += image('icons/inventory/pockets/icon.dmi', "baton_layer")