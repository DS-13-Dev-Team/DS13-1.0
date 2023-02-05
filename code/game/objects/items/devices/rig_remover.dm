/obj/item/rig_remover
	name = "RIG Retraction Device"
	desc = "A hand held device for getting people inside heavy RIG suits out. Retracts the target's RIG through the Safe Retraction API."
	icon = 'icons/obj/hacktool.dmi'
	icon_state = "hacktool-g"
	item_state = "analyzer"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEM_SIZE_SMALL

	throw_range = 10
	matter = list(MATERIAL_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)


/obj/item/rig_remover/afterattack(var/mob/living/carbon/human/target, mob/user, proximity)
	if (!is_valid_target(target,user))
		return

	var/obj/item/rig/R = target.wearing_rig

	if (R.active)
		to_chat("<span class='warning'>[user] begins to remove the [target]'s [R].</span>")
		if (do_after(user, 10, target))
			R.toggle_seals(user, FALSE)
	else
		user.visible_message("<span class='warning'>[target]'s RIG is not active.</span>")


/obj/item/rig_remover/proc/is_valid_target(var/mob/living/carbon/human/target, mob/user)
	if (!istype(target))
		return

	if (!target.wearing_rig)
		to_chat(user, SPAN_WARNING("[target] is not wearing a RIG."))
		return

	var/obj/item/rig/R = target.wearing_rig

	//In process already
	if (R.sealing)
		return

	return TRUE
