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
	icon_state = "potato_cell" //"potato_battery"
