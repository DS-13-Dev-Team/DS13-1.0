//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
/mob/proc/update_Login_details()
	//Multikey checks and logging
	lastKnownIP	= client.address
	computer_id	= client.computer_id
	log_access("Login: [key_name(src)] from [lastKnownIP ? lastKnownIP : "localhost"]-[computer_id] || BYOND v[client.byond_version]")
	if(CONFIG_GET(flag/log_access))
		var/is_multikeying = 0
		for(var/mob/M in GLOB.player_list)
			if(M == src)	continue
			if( M.key && (M.key != key) )
				var/matches
				if( (M.lastKnownIP == client.address) )
					matches += "IP ([client.address])"
				if( (client.connection != "web") && (M.computer_id == client.computer_id) )
					if(matches)	matches += " and "
					matches += "ID ([client.computer_id])"
					is_multikeying = 1
				if(matches)
					if(M.client)
						message_mods("<font color='red'><B>Notice: </B></font><font color='blue'><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as <A href='?src=\ref[usr];priv_msg=\ref[M]'>[key_name_admin(M)]</A>.</font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)].")
					else
						message_mods("<font color='red'><B>Notice: </B></font><font color='blue'><A href='?src=\ref[usr];priv_msg=\ref[src]'>[key_name_admin(src)]</A> has the same [matches] as [key_name_admin(M)] (no longer logged in). </font>", 1)
						log_access("Notice: [key_name(src)] has the same [matches] as [key_name(M)] (no longer logged in).")
		if(is_multikeying && !client.warned_about_multikeying)
			client.warned_about_multikeying = 1
			spawn(1 SECOND)
				to_chat(src, "<b>WARNING:</b> It would seem that you are sharing connection or computer with another player. If you haven't done so already, please contact the staff via the Adminhelp verb to resolve this situation. Failure to do so may result in administrative action. You have been warned.")

	if(CONFIG_GET(string/login_export_addr))
		spawn(-1)
			var/list/params = new
			params["login"] = 1
			params["key"] = client.key
			if(isnum(client.player_age))
				params["server_age"] = client.player_age
			params["ip"] = client.address
			params["clientid"] = client.computer_id
			params["roundid"] = GLOB.round_id
			params["name"] = real_name || name
			world.Export("[CONFIG_GET(string/login_export_addr)]?[list2params(params)]", null, 1)

/mob/proc/maybe_send_staffwarns(var/action)
	if(client.staffwarn)
		for(var/client/C in GLOB.admins)
			send_staffwarn(C, action)

/mob/proc/send_staffwarn(var/client/C, var/action, var/noise = 1)
	if(check_rights((R_ADMIN|R_MOD),0,C))
		to_chat(C,
				type = MESSAGE_TYPE_ADMINCHAT,
				html = "<span class='staffwarn'>StaffWarn: [client.ckey] [action]</span><br><span class='notice'>[client.staffwarn]</span>")
		if(noise && C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR)
			SEND_SOUND(C, 'sound/effects/adminhelp.ogg')

/mob
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled

/mob/Login()
	if(!client)
		return FALSE //Byond bug

	if(client.byond_version < MIN_COMPILER_VERSION || client.byond_build < MIN_COMPILER_BUILD)
		to_chat(src, SPAN_WARNING("WARNING! Your version of BYOND is too out-of-date to play this project. Go to https://secure.byond.com/download and update. You need version [MIN_COMPILER_VERSION].[MIN_COMPILER_BUILD] to [MAX_COMPILER_VERSION].[MAX_COMPILER_BUILD]"))
	if(client.byond_version > MAX_COMPILER_VERSION || client.byond_build > MAX_COMPILER_BUILD)
		to_chat(src, SPAN_WARNING("WARNING! Your byond version is over the recommended [MAX_COMPILER_VERSION].[MAX_COMPILER_BUILD]! There may be unexpected byond bugs!"))

	player_login()


	update_Login_details()
	world.update_status()

	maybe_send_staffwarns("joined the round")

	client.images = null				//remove the images such as AIs being unable to see runes
	client.screen = list()				//remove hud items just in case

	if(!hud_used)
		create_mob_hud()
	if(hud_used)
		hud_used.show_hud(hud_used.hud_version)

	next_move = 1
	set_sight(sight|SEE_SELF)
	..()

	my_client = client

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE

	if(eyeobj)
		eyeobj.possess(src)

	refresh_client_images()

	add_click_catcher()
	update_action_buttons()
	GetClickHandlers()	//Just call this to create the default handler, prevents an unpleasant edge case where it never gets created a
	update_popup_menu()	//Update the existence of the rightclick menu, or lack thereof
	client.init_verbs()
	//set macro to normal incase it was overriden (like cyborg currently does)
	winset(src, null, "mainwindow.macro=hotkeymode hotkey_toggle.is-checked=true mapwindow.map.focus=true input.background-color=#d3b5b5")


/*
	This updates lighting, darkvision, and skybox
	Called on login and when switching species
*/
/mob/proc/refresh_lighting_overlays()
	if (!client)
		return

	if (l_plane)
		QDEL_NULL(l_plane)
	if (l_general)
		QDEL_NULL(l_general)

	l_plane = new(null, client)
	l_general = new(null, client)
	client.screen += l_plane
	client.screen += l_general
	client.update_skybox(TRUE)
