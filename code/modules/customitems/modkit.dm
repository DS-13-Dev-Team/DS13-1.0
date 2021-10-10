//Modkits
/obj/item/mod_kit

	var/list/valid_types
	var/result_path

	var/consumed = FALSE


	icon = 'icons/obj/device.dmi'
	icon_state = "modkit"

/obj/item/mod_kit/resolve_attackby(atom/A, mob/user, var/click_params)
	if (!consumed && is_valid_target(A))
		apply_to(A, user)
		return
	else
		to_chat(user, "Invalid target for modifying")
	. = ..()


/obj/item/mod_kit/proc/is_valid_target(var/atom/target)
	if (!isturf(target.loc))
		return FALSE

	var/valid_type = FALSE
	for (var/typepath in valid_types)
		if (istype(target, typepath))
			valid_type = TRUE
			break

	if (!valid_type)
		return FALSE

	return TRUE

/obj/item/mod_kit/proc/apply_to(var/atom/target, mob/user)
	if (consumed)
		return
	consumed = TRUE
	var/atom/A = new result_path(target.loc)

	target.pre_modkit_transform(A, src, user)




/*
	Base functionality, event proc
	Called when an item is about to be transformed into a new one with a modkit
*/
/atom/proc/pre_modkit_transform(var/atom/replacement, var/obj/item/mod_kit/transformer, var/mob/user)

/obj/item/weapon/rig/pre_modkit_transform(var/atom/replacement, var/obj/item/mod_kit/transformer, var/mob/user)
	transfer_rig(replacement, src)
/*
	Special gear subtype
*/
/datum/gear/modkit
	slot = GEAR_EQUIP_SPECIAL
	var/item_name
	var/list/valid_types
	var/list/valid_names



/datum/gear/modkit/Initialize()
	//This proc intentionally does not call parent
	log_debug("Modkit initialize [display_name]")
	var/obj/O = path
	item_name = display_name
	display_name = "Conversion Kit: ([item_name])"

	valid_names = list()
	for (var/typepath in valid_types)
		O = path
		valid_names += initial(O.name)

/datum/gear/modkit/spawn_special(var/mob/living/carbon/human/H,  var/metadata)
	var/obj/item/mod_kit/MK = new (H.loc)
	MK.name = display_name
	MK.desc = "This is a kit which can be applied to certain things to convert them into \a [item_name]. It will be consumed on use. Valid items to convert are:"
	MK.valid_types = src.valid_types
	for (var/thingname in valid_names)
		MK.desc += "\n	[thingname]"
	MK.result_path = path

	H.equip_to_storage(MK)
	return MK