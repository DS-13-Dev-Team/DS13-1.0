/obj/item/stack/stasis_pack
	name = "stasis pack"
	desc = "Stasis pack used to recharge stasis module."
	origin_tech = list(TECH_POWER = 6, TECH_MAGNET = 4)
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "stasis_pack" //"potato_battery"
	max_amount = 3
	item_flags = ITEM_FLAG_NO_BLUDGEON

/obj/item/stack/stasis_pack/attack_self(mob/user)
	for(var/obj/item/weapon/rig/R in user.contents)
		for(var/obj/item/rig_module/mounted/stasis/S in R.installed_modules)
			S.try_use_pack(src, user)
			return

	to_chat(user, "You don't have Stasis Module installed")
