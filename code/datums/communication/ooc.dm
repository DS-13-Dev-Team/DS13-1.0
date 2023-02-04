/decl/communication_channel/ooc
	name = "OOC"
	config_setting = "ooc_allowed"
	expected_communicator_type = list(/client, /datum)
	flags = COMMUNICATION_NO_GUESTS
	log_proc = /proc/log_ooc
	mute_setting = MUTE_OOC
	message_type = MESSAGE_TYPE_OOC
	show_preference_setting = /datum/client_preference/show_ooc

/decl/communication_channel/ooc/can_communicate(var/A, var/message)
	. = ..()
	if(!.)
		return
	if (isclient(A))
		var/client/C = A
		if(!C.holder)
			if(!CONFIG_GET(flag/dooc_allowed) && (C.mob.stat == DEAD))
				to_chat(C, "<span class='danger'>[name] for dead mobs has been turned off.</span>")
				return FALSE
			if(findtext(message, "byond://"))
				to_chat(C, "<B>Advertising other servers is not allowed.</B>")
				log_and_message_admins("has attempted to advertise in [name]: [message]")
				return FALSE

/decl/communication_channel/ooc/do_communicate(var/A, var/message, var/sender_override)


	var/ooc_style = "everyone"
	var/ooc_color = COLOR_OOC
	var/can_badmin = FALSE
	var/client/C
	if (isclient(A))
		C = A
		var/datum/admins/holder = C.holder
		var/is_stealthed = C.is_stealthed()
		if(holder && !is_stealthed)
			ooc_style = "elevated"
			if(holder.rights & R_MOD)
				ooc_style = "moderator"
			if(holder.rights & R_DEBUG)
				ooc_style = "developer"
			if(holder.rights & R_ADMIN)
				ooc_style = "admin"

		can_badmin = !is_stealthed && can_select_ooc_color(C) && (C.prefs.ooccolor != initial(C.prefs.ooccolor))
		ooc_color = C.prefs.ooccolor

	for(var/client/target in GLOB.clients)
		if(C && target.is_key_ignored(C.key)) // If we're ignored by this person, then do nothing.
			continue
		var/datum/asset/spritesheet/sheet = get_asset_datum(/datum/asset/spritesheet/chat)
		var/sent_message = "[sheet.icon_tag("tags-ooc")] <EM>[sender_override ? sender_override : C.key]:</EM> <span class='message'>[message]</span>"
		if(can_badmin)
			receive_communication(A, target, "<span class='ooc'><font color='[ooc_color]'>[sent_message]</font></span>")
		else
			receive_communication(A, target, "<span class='ooc'><span class='[ooc_style]'>[sent_message]</span></span>")
