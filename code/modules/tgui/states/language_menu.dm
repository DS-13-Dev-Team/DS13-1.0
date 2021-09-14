/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: language_menu_state
 */

GLOBAL_DATUM_INIT(tgui_language_menu_state, /datum/ui_state/language_menu, new)

/datum/ui_state/language_menu/can_use_topic(src_object, mob/user)
	. = UI_CLOSE
	if(check_rights( R_ADMIN, user.client))
		. = UI_INTERACTIVE
/*	else if(istype(src_object, /datum/language_menu))
		var/datum/language_menu/LM = src_object
		if(LM.language_holder.get_atom() == user)
			. = UI_INTERACTIVE*/ //We don't have advanced languages.
