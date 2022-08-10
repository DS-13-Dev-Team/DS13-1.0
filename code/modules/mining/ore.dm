
/obj/item/stack/ore
	name = "small rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	max_amount = 30
	randpixel = 8
	w_class = ITEM_SIZE_NORMAL
	var/datum/geosample/geologic_data
	var/ore/ore = null // set to a type to find the right instance on init

/obj/item/stack/ore/Initialize()
	. = ..()
	if(ispath(ore))
		ensure_ore_data_initialised()
		ore = GLOB.ores_by_type[ore]
		if(ore.ore != type)
			log_debug("[src] ([src.type]) had ore type [ore.type] but that type does not have [src.type] set as its ore item!")
		update_ore()

/obj/item/stack/ore/proc/update_ore()
	SetName(ore.display_name)
	icon_state = "ore_[ore.icon_tag]"
	origin_tech = ore.origin_tech.Copy()

/obj/item/stack/ore/Value(var/base)
	. = ..()
	if(!ore)
		return
	return ore.Value(base)

/obj/item/stack/ore/slag
	name = "slag"
	desc = "Someone screwed up..."
	icon_state = "slag"

/obj/item/stack/ore/uranium
	ore = /ore/uranium

/obj/item/stack/ore/iron
	ore = /ore/hematite

/obj/item/stack/ore/coal
	ore = /ore/coal

/obj/item/stack/ore/glass
	ore = /ore/glass
	slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/stack/ore/glass/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.eye_blind += 5
		H.eye_blurry += 10
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)


/obj/item/stack/ore/phoron
	ore = /ore/phoron

/obj/item/stack/ore/silver
	ore = /ore/silver

/obj/item/stack/ore/gold
	ore = /ore/gold

/obj/item/stack/ore/diamond
	ore = /ore/diamond

/obj/item/stack/ore/osmium
	ore = /ore/platinum

/obj/item/stack/ore/hydrogen
	ore = /ore/hydrogen

/obj/item/stack/ore/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/core_sampler))
		var/obj/item/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()
