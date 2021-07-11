/obj/item/rig_module/mounted/stasis
	name = "Stasis Module"
	interface_name = "Stasis Module"
	desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time."
	interface_desc = "Stasis module is capable of producing a temporary time dilation, making objects move at an extremely slow rate for a period of time."
	icon = 'icons/obj/rig_modules.dmi'
	icon_state = "module"

	selectable = 1
	usable = 1
	loadout_tags = list(LOADOUT_TAG_RIG_STASIS)

	module_cooldown = 0
	suit_overlay = "mounted-stasis"

	module_tags = list(LOADOUT_TAG_RIG_STASIS = 1)
	gun = /obj/item/weapon/gun/energy/stasis
