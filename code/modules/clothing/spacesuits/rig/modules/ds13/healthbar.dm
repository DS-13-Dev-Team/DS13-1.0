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