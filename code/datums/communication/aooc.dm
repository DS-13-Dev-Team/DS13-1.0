/decl/communication_channel/aooc
	name = "AOOC"
	config_setting = "aooc_allowed"
	expected_communicator_type = list(/client, /datum)
	flags = COMMUNICATION_LOG_CHANNEL_NAME|COMMUNICATION_ADMIN_FOLLOW
	log_proc = /proc/log_ooc
	mute_setting = MUTE_AOOC
	show_preference_setting = /datum/client_preference/show_aooc

/decl/communication_channel/aooc/can_communicate(var/A, var/message)
	. = ..()
	if(!.)
		return
	if (isclient(A))
		var/client/C = A
		if(!C.holder)
			if(isghost(C.mob))
				to_chat(src, "<span class='warning'>You cannot use [name] while ghosting/observing!</span>")
				return FALSE
			if(!(C.mob && C.mob.mind && C.mob.mind.special_role))
				to_chat(C, "<span class='danger'>You must be an antag to use [name].</span>")
				return FALSE

/decl/communication_channel/aooc/do_communicate(var/A, var/message, var/sender_override = null)
	var/datum/admins/holder

	var/player_display = ""
	if (sender_override)
		player_display = sender_override
	else
		if (isclient(A))
			var/client/C = A
			holder = C.holder
			var/display_name = C.key
			player_display = holder ? "[display_name]([usr.client.holder.rank])" : display_name

	for(var/client/target in GLOB.clients)
		if(target.holder)
			receive_communication(A, target, "<span class='ooc'><span class='aooc'>[create_text_tag("aooc", "Antag-OOC:", target)] <EM>[sender_override ? player_display : get_options_bar(A, 0, 1, 1)]:</EM> <span class='message'>[message]</span></span></span>")
		else if(target.mob && target.mob.mind && target.mob.mind.special_role)

			receive_communication(A, target, "<span class='ooc'><span class='aooc'>[create_text_tag("aooc", "Antag-OOC:", target)] <EM>[player_display]:</EM> <span class='message'>[message]</span></span></span>")