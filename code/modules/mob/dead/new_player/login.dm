
/mob/dead/new_player/Login()
	if(!client)
		return

	register_client_and_player()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying

	//Here, before anything else, we'll handle signal continuance.
	//If this player is already marked as part of the necromorph team, it can mean only one thing: They disconnected while playing as a signal or master signal.
	//In that case we want to put them straight back into that body
	var/datum/player/P = get_player()
	if (P && P.is_necromorph)
		var/mob/dead/observer/signal/S = create_signal()

		var/turf/last_location = P.get_last_location()
		if (istype(S) && istype(last_location))
			S.forceMove(last_location)

		qdel(src)
		return


	if(GLOB.motd)
		to_chat(src, "<div class='motd'>[GLOB.motd]</div>")
	to_chat(src, "<div class='info'>Round ID: <div class='danger'>[GLOB.round_id]</div></div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	forceMove(null)
	ShowTitleScreen()
	my_client = client
	set_sight(sight|SEE_TURFS)
	GLOB.player_list |= src

	new_player_panel()

	if(!SScharacter_setup.initialized)
		SScharacter_setup.newplayers_requiring_init += src
	else
		deferred_login()

// This is called when the charcter setup system has been sufficiently initialized and prefs are available.
// Do not make any calls in mob/Login which may require prefs having been loaded.
// It is safe to assume that any UI or sound related calls will fall into that category.
/mob/dead/new_player/proc/deferred_login()
	if(client)
		client.playtitlemusic()
		maybe_send_staffwarns("connected as new player")

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	var/decl/security_level/SL = security_state.current_security_level
	var/alert_desc = ""
	if(SL.up_description)
		alert_desc = SL.up_description
	to_chat(src, SPAN_NOTICE("The alert level on the [station_name()] is currently: <font color=[SL.light_color_alarm]><B>[SL.name]</B></font>. [alert_desc]"))
