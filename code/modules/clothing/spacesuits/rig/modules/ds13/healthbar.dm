/obj/item/rig_module/healthbar
	name = "healthbar"
	desc = "A hardsuit-mounted health scanner."
	icon_state = "healthbar"
	interface_name = "healthbar"
	interface_desc = "Shows an informative health readout on the user's spine."
	use_power_cost = 0
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ENGINEERING = 5)
	suit_overlay_inactive = "healthbar_100"
	suit_overlay_active = "healthbar_100"
	suit_overlay_used = "healthbar_100"
	suit_overlay = "healthbar_100"
	var/mob/living/carbon/human/user


/obj/item/rig_module/healthbar/proc/register_user(var/mob/newuser)
	user = newuser
	GLOB.updatehealth_event.register(user, src, /obj/item/rig_module/healthbar/proc/update)


/obj/item/rig_module/healthbar/proc/unregister_user()
	GLOB.updatehealth_event.unregister(user, src, /obj/item/rig_module/healthbar/proc/update)
	user = null

/obj/item/rig_module/healthbar/rig_equipped(var/mob/user, var/slot)
	register_user(user)

/obj/item/rig_module/healthbar/rig_unequipped(var/mob/user, var/slot)
	unregister_user()


/obj/item/rig_module/healthbar/proc/update()
	if (QDELETED(user) || QDELETED(holder) || holder.loc != user)
		//Something broked
		unregister_user()
		return

	var/percentage = user.healthpercent()

	//Just in case
	percentage = clamp(percentage, 0, 100)

	if (user.stat == DEAD)
		percentage = 0

	//95% health is good enough, lets not make people obsess about getting it to blue
	if (percentage > 95)
		percentage = 100
	else
		percentage = round(percentage, 10)

	suit_overlay = "healthbar_[percentage]"
	suit_overlay_inactive = "healthbar_[percentage]"
	suit_overlay_active = "healthbar_[percentage]"
	suit_overlay_used = "healthbar_[percentage]"
	holder.update_wear_icon()
