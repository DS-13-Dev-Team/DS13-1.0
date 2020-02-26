/datum/click_handler/rmb_aim
	var/obj/item/weapon/gun/gun	//What gun are they aiming

/datum/click_handler/rmb_aim/New(var/mob/user)
	.=..()
	user.client.show_popup_menus = FALSE

/datum/click_handler/rmb_aim/Destroy()
	if (user)
		user.client.show_popup_menus = TRUE
	if (gun)
		gun.disable_aiming_mode()
	.=..()

/datum/click_handler/rmb_aim/MouseDown(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		gun.enable_aiming_mode()
		return FALSE
	return TRUE

/datum/click_handler/rmb_aim/MouseUp(object,location,control,params)
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		gun.disable_aiming_mode()
		return FALSE
	return TRUE