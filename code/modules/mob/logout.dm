/mob/Logout()
	SEND_SIGNAL(src, COMSIG_MOB_LOGOUT, my_client)

	//Cache our last location on the player datum, incase this mob is deleted before we log in again
	if (ckey)
		var/datum/player/P = get_player_from_key(ckey)
		if (P)
			P.cache_location(src)
		GLOB.pcap_graceperiod[ckey] = world.time + 10 MINUTES

	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	SStgui.on_logout(src)
	GLOB.player_list -= src
	log_access("Logout: [key_name(src)]")
	handle_admin_logout()
	hide_client_images()

	if(!key && mind) //key and mind have become separated.
		mind.active = FALSE //This is to stop say, a mind.transfer_to call on a corpse causing a ghost to re-enter its body.

	..()

	my_client = null
	return 1

/mob/proc/handle_admin_logout()
	if(GLOB.admin_datums[ckey] && SSticker && SSticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
		var/datum/admins/holder = GLOB.admin_datums[ckey]
		message_staff("[holder.rank] logout: [key_name(src)]")
		if(!GLOB.admins.len) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
			send2adminirc("[key_name(src)] logged out - no more admins online.")
			if(CONFIG_GET(flag/delist_when_no_admins) && GLOB.visibility_pref)
				send2adminirc("Toggled hub visibility. The server is now invisible ([GLOB.visibility_pref]).")
