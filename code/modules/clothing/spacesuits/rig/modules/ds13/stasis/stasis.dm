/obj/item/rig_module/mounted/stasis
	name = "Stasis Module"
	interface_name = "Stasis Module"
	desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time."
	interface_desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "module"

	base_type = /obj/item/rig_module/mounted/stasis

	selectable = 1
	usable = 0

	module_cooldown = 0

	gun = /obj/item/weapon/gun/energy/stasis
	suit_overlay_inactive = "stasisbar_100"
	suit_overlay_active = "stasisbar_100"
	suit_overlay_used = "stasisbar_100"
	suit_overlay = "stasisbar_100"

/datum/proc/update_stas_charge()
	return

/obj/item/rig_module/mounted/stasis/update_stas_charge()
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

/obj/item/rig_module/mounted/stasis/on_shot()
	update_stas_charge()

/obj/item/rig_module/mounted/stasis/military
	name = "Regenerative Stasis Module"
	interface_name = "Regenerative Stasis Module"
	desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time. This version is capable of self recharging."
	interface_desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time. This version is capable of self recharging."
	gun = /obj/item/weapon/gun/energy/stasis/military

/obj/item/rig_module/mounted/stasis/proc/try_use_pack(obj/item/I as obj, mob/user as mob)
	for(var/obj/item/weapon/gun/energy/stasis/G in contents)
		for(var/obj/item/weapon/cell/C in G.contents)
			if(C.percent() != 100)
				I.use(1)
				C.insta_recharge()
				to_chat(user, "Stasis Module was recharged")
				return TRUE
			else
				to_chat(user, "Stasis Module is already fully charged")
				return

	to_chat(user, "Something wen't wrong. Please report to your local Blue Space Techincan")
