/obj/item/rig_module/mounted/stasis
	name = "Stasis Module"
	interface_name = "Stasis Module"
	desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time."
	interface_desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "module"

	selectable = 1
	usable = 0

	module_cooldown = 0
	suit_overlay = "mounted-stasis"

	gun = /obj/item/weapon/gun/energy/stasis
	suit_overlay_inactive = "stasisbar_100"
	suit_overlay_active = "stasisbar_100"
	suit_overlay_used = "stasisbar_100"
	suit_overlay = "stasisbar_100"

	suit_overlay_layer = EYE_GLOW_LAYER
	suit_overlay_plane = EFFECTS_ABOVE_LIGHTING_PLANE
	suit_overlay_flags = KEEP_APART

/obj/item/rig_module/mounted/stasis/Process()
	var/percentage

	for(var/obj/item/weapon/gun/energy/stasis/S in contents)
		percentage = S.get_remaining_percent()

	//Just in case
	percentage = clamp(percentage, 0, 100)

	suit_overlay = "stasisbar_[percentage]"
	suit_overlay_inactive = "stasisbar_[percentage]"
	suit_overlay_active = "stasisbar_[percentage]"
	suit_overlay_used = "stasisbar_[percentage]"
	holder.update_wear_icon()

/obj/item/rig_module/mounted/stasis/military
	name = "Regenerative Stasis Module"
	interface_name = "Regenerative Stasis Module"
	desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time. This version is capable of self rechargin."
	interface_desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time. This version is capable of self rechargin."
	gun = /obj/item/weapon/gun/energy/stasis/military

/obj/item/weapon/stasis_pack
	name = "stasis pack"
	desc = "Stasis pack used to recharge stasis module."
	origin_tech = list(TECH_POWER = 6, TECH_MAGNET = 4)
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "stasis_pack" //"potato_battery"
