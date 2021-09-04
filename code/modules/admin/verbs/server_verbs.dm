/datum/admins/proc/end_round()
	set category = "Server"
	set name = "End Round"
	set desc = "Immediately ends the round, be very careful"

	if(!check_rights(R_SERVER))
		return

	if(!ticker?.mode)
		return

	if(alert("Are you sure you want to end the round?", "End Round", "Yes", "No") != "Yes")
		return

	var/winstate = input(usr, "What do you want the round end state to be?", "End Round") as null|anything in list("Custom", "Admin Intervention") + ticker.mode.round_end_states //TO DO Change declare complitation
	if(!winstate)
		return

	if(winstate == "Custom")
		winstate = input(usr, "Please enter a custom round end state.", "End Round") as null|text
		if(!winstate)
			return

	ticker.force_ending = TRUE
//	ticker.mode.round_finished = winstate TO DO

	log_admin("[key_name(usr)] has made the round end early - [winstate].")
	message_admins("[key_name(usr)] has made the round end early - [winstate].")

/client/proc/toggle_antagHUD_use()
	set category = "Server"
	set name = "Toggle antagHUD usage"
	set desc = "Toggles antagHUD usage for observers"

	if(!holder)
		to_chat(src, "Only administrators may use this command.")
	var/action=""
	if(CONFIG_GET(flag/antag_hud_allowed))
		for(var/mob/dead/observer/ghost/g in get_ghosts())
			if(!g.client.holder)						//Remove the verb from non-admin ghosts
				remove_verb(g, /mob/dead/observer/ghost/verb/toggle_antagHUD)
			if(g.antagHUD)
				g.antagHUD = 0						// Disable it on those that have it enabled
				g.has_enabled_antagHUD = 2				// We'll allow them to respawn
				to_chat(g, "<span class='danger'>The Administrator has disabled AntagHUD</span>")
		CONFIG_SET(flag/antag_hud_allowed, FALSE)
		to_chat(src, "<span class='danger'>AntagHUD usage has been disabled</span>")
		action = "disabled"
	else
		for(var/mob/dead/observer/ghost/g in get_ghosts())
			if(!g.client.holder)						// Add the verb back for all non-admin ghosts
				add_verb(g, /mob/dead/observer/ghost/verb/toggle_antagHUD)
				to_chat(g, "<span class='notice'><B>The Administrator has enabled AntagHUD </B></span>")// Notify all observers they can now use AntagHUD

		CONFIG_SET(flag/antag_hud_allowed, TRUE)
		action = "enabled"
		to_chat(src, "<span class='notice'><B>AntagHUD usage has been enabled</B></span>")


	log_admin("[key_name(usr)] has [action] antagHUD usage for observers")
	message_admins("Admin [key_name_admin(usr)] has [action] antagHUD usage for observers", 1)



/client/proc/toggle_antagHUD_restrictions()
	set category = "Server"
	set name = "Toggle antagHUD Restrictions"
	set desc = "Restricts players that have used antagHUD from being able to join this round."
	if(!holder)
		to_chat(src, "Only administrators may use this command.")
	var/action=""
	if(CONFIG_GET(flag/antag_hud_restricted))
		for(var/mob/dead/observer/ghost/g in get_ghosts())
			to_chat(g, "<span class='notice'><B>The administrator has lifted restrictions on joining the round if you use AntagHUD</B></span>")
		action = "lifted restrictions"
		CONFIG_SET(flag/antag_hud_restricted, FALSE)
		to_chat(src, "<span class='notice'><B>AntagHUD restrictions have been lifted</B></span>")
	else
		for(var/mob/dead/observer/ghost/g in get_ghosts())
			to_chat(g, "<span class='danger'>The administrator has placed restrictions on joining the round if you use AntagHUD</span>")
			to_chat(g, "<span class='danger'>Your AntagHUD has been disabled, you may choose to re-enabled it but will be under restrictions</span>")
			g.antagHUD = 0
			g.has_enabled_antagHUD = 0
		action = "placed restrictions"
		CONFIG_SET(flag/antag_hud_restricted, TRUE)
		to_chat(src, "<span class='danger'>AntagHUD restrictions have been enabled</span>")

	log_admin("[key_name(usr)] has [action] on joining the round if they use AntagHUD")
	message_admins("Admin [key_name_admin(usr)] has [action] on joining the round if they use AntagHUD", 1)

/datum/admins/proc/toggleaooc()
	set category = "Server"
	set desc="Globally Toggles AOOC"
	set name="Toggle AOOC"

	if(!check_rights(R_ADMIN|R_REJUVINATE))
		return

	CONFIG_SET(flag/aooc_allowed, !CONFIG_GET(flag/aooc_allowed))
	if (CONFIG_GET(flag/aooc_allowed))
		to_world("<B>The AOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The AOOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled AOOC.")
	feedback_add_details("admin_verb","TAOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglelooc()
	set category = "Server"
	set desc="Globally Toggles LOOC"
	set name="Toggle LOOC"

	if(!check_rights(R_ADMIN|R_REJUVINATE))
		return

	CONFIG_SET(flag/looc_allowed, !CONFIG_GET(flag/looc_allowed))
	if(CONFIG_GET(flag/looc_allowed))
		to_world("<B>The LOOC channel has been globally enabled!</B>")
	else
		to_world("<B>The LOOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled LOOC.")
	feedback_add_details("admin_verb","TLOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/toggledsay()
	set category = "Server"
	set desc="Globally Toggles DSAY"
	set name="Toggle DSAY"

	if(!check_rights(R_ADMIN|R_REJUVINATE))
		return

	CONFIG_SET(flag/dsay_allowed, !CONFIG_GET(flag/dsay_allowed))
	if (CONFIG_GET(flag/dsay_allowed))
		to_world("<B>Deadchat has been globally enabled!</B>")
	else
		to_world("<B>Deadchat has been globally disabled!</B>")
	log_and_message_admins("toggled deadchat.")
	feedback_add_details("admin_verb","TDSAY") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

/datum/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle Dead OOC."
	set name="Toggle Dead OOC"

	if(!check_rights(R_ADMIN|R_REJUVINATE))
		return

	CONFIG_SET(flag/dooc_allowed, !CONFIG_GET(flag/dooc_allowed))
	log_admin("[key_name(usr)] toggled Dead OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.", 1)
	feedback_add_details("admin_verb","TDOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/togglehubvisibility()
	set category = "Server"
	set desc="Globally Toggles Hub Visibility"
	set name="Toggle Hub Visibility"

	if(!check_rights(R_ADMIN))
		return

	//BYOND hates actually changing world.visibility at runtime, so let's just change if we give it the hub password.
	world.update_hub_visibility(!GLOB.visibility_pref) //proc defined in hub.dm
	var/long_message = "toggled hub visibility. The server is now [GLOB.visibility_pref ? "visible" : "invisible"] ([GLOB.visibility_pref])."
	if (GLOB.visibility_pref && !world.reachable)
		message_admins("WARNING: The server will not show up on the hub because byond is detecting that a firewall is blocking incoming connections.")

	send2adminirc("[key_name(src)]" + long_message)
	log_and_message_admins(long_message)
	feedback_add_details("admin_verb","THUB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc

/datum/admins/proc/toggletraitorscaling()
	set category = "Server"
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"
	CONFIG_SET(flag/traitor_scaling, !CONFIG_GET(flag/traitor_scaling))
	log_admin("[key_name(usr)] toggled Traitor Scaling to [CONFIG_GET(flag/traitor_scaling)].")
	message_admins("[key_name_admin(usr)] toggled Traitor Scaling [CONFIG_GET(flag/traitor_scaling) ? "on" : "off"].", 1)
	feedback_add_details("admin_verb","TTS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(!ticker)
		alert("Unable to start the game as it is not set up.")
		return
	if(ticker.current_state == GAME_STATE_PREGAME && !(initialization_stage & INITIALIZATION_NOW))
		log_admin("[usr.key] has started the game.")
		message_admins("<font color='blue'>[usr.key] has started the game.</font>")
		feedback_add_details("admin_verb","SN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		initialization_stage |= INITIALIZATION_NOW
		return 1
	else
		to_chat(usr, "<span class='warning'>Error: Start Now: Game has already started.</span>")
		return 0

/datum/admins/proc/toggleenter()
	set category = "Server"
	set desc="People can't enter"
	set name="Toggle Entering"
	CONFIG_SET(flag/enter_allowed, !CONFIG_GET(flag/enter_allowed))
	if (!CONFIG_GET(flag/enter_allowed))
		to_world("<B>New players may no longer enter the game.</B>")
	else
		to_world("<B>New players may now enter the game.</B>")
	log_and_message_admins("[key_name_admin(usr)] toggled new player game entering.")
	world.update_status()
	feedback_add_details("admin_verb","TE") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"
	CONFIG_SET(flag/allow_ai, !CONFIG_GET(flag/allow_ai))
	if (!CONFIG_GET(flag/allow_ai))
		to_world("<B>The AI job is no longer chooseable.</B>")
	else
		to_world("<B>The AI job is chooseable now.</B>")
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()
	feedback_add_details("admin_verb","TAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleaban()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	CONFIG_SET(flag/abandon_allowed, !CONFIG_GET(flag/abandon_allowed))
	if(CONFIG_GET(flag/abandon_allowed))
		to_world("<B>You may now respawn.</B>")
	else
		to_world("<B>You may no longer respawn :(</B>")
	log_and_message_admins("toggled respawn to [CONFIG_GET(flag/abandon_allowed) ? "On" : "Off"].")
	world.update_status()
	feedback_add_details("admin_verb","TR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_aliens()
	set category = "Server"
	set desc="Toggle alien mobs"
	set name="Toggle Aliens"
	if(!check_rights(R_ADMIN))
		return

	CONFIG_SET(flag/aliens_allowed, !CONFIG_GET(flag/aliens_allowed))
	log_admin("[key_name(usr)] toggled Aliens to [CONFIG_GET(flag/aliens_allowed)].")
	message_admins("[key_name_admin(usr)] toggled Aliens [CONFIG_GET(flag/aliens_allowed) ? "on" : "off"].", 1)
	feedback_add_details("admin_verb","TA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggle_alien_eggs()
	set category = "Server"
	set desc="Toggle xenomorph egg laying"
	set name="Toggle Alien Eggs"

	if(!check_rights(R_ADMIN))
		return
	CONFIG_SET(flag/alien_eggs_allowed, !CONFIG_GET(flag/alien_eggs_allowed))
	log_admin("[key_name(usr)] toggled Alien Egg Laying to [CONFIG_GET(flag/alien_eggs_allowed)].")
	message_admins("[key_name_admin(usr)] toggled Alien Egg Laying [CONFIG_GET(flag/alien_eggs_allowed) ? "on" : "off"].", 1)
	feedback_add_details("admin_verb","AEA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/datum/admins/proc/toggle_space_ninja()
	set category = "Server"
	set desc="Toggle space ninjas spawning."
	set name="Toggle Space Ninjas"
	if(!check_rights(R_ADMIN))
		return

	CONFIG_SET(flag/ninjas_allowed, !CONFIG_GET(flag/ninjas_allowed))
	log_and_message_admins("toggled Space Ninjas [CONFIG_GET(flag/ninjas_allowed) ? "on" : "off"].")
	feedback_add_details("admin_verb","TSN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start/end"
	set name="Delay"

	if(!check_rights(R_SERVER|R_REJUVINATE))	return
	if (!ticker || ticker.current_state != GAME_STATE_PREGAME)
		ticker.delay_end = !ticker.delay_end
		log_and_message_admins("[ticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		return //alert("Round end delayed", null, null, null, null, null)
	round_progressing = !round_progressing
	if (!round_progressing)
		to_world("<b>The game start has been delayed.</b>")
		log_admin("[key_name(usr)] delayed the game.")
	else
		to_world("<b>The game will start soon.</b>")
		log_admin("[key_name(usr)] removed the delay.")
	feedback_add_details("admin_verb","DELAY") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adjump()
	set category = "Server"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"
	CONFIG_SET(flag/allow_admin_jump, !CONFIG_GET(flag/allow_admin_jump))
	log_and_message_admins("Toggled admin jumping to [CONFIG_GET(flag/allow_admin_jump)].")
	feedback_add_details("admin_verb","TJ") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adspawn()
	set category = "Server"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	CONFIG_SET(flag/disable_admin_spawn, !CONFIG_GET(flag/disable_admin_spawn))
	log_and_message_admins("toggled admin item spawning to [CONFIG_GET(flag/disable_admin_spawn)].")
	feedback_add_details("admin_verb","TAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/adrev()
	set category = "Server"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	CONFIG_SET(flag/disable_admin_rev, !CONFIG_GET(flag/disable_admin_rev))
	log_and_message_admins("toggled reviving to [CONFIG_GET(flag/disable_admin_rev)].")
	feedback_add_details("admin_verb","TAR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/immreboot()
	set category = "Server"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if(!usr.client.holder)	return
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	to_world("<span class='danger'>Rebooting world!</span> <span class='notice'>Initiated by [usr.key]!</span>")
	log_admin("[key_name(usr)] initiated an immediate reboot.")

	feedback_set_details("end_error","immediate admin reboot - by [usr.key]")
	feedback_add_details("admin_verb","IR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(blackbox)
		blackbox.save_all_data_to_sql()

	world.Reboot(ping=TRUE)

/datum/admins/proc/restart()
	set category = "Server"
	set name = "Restart"
	set desc="Restarts the world"
	if (!usr.client.holder)
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		to_world("<span class='danger'>Restarting world!</span> <span class='notice'>Initiated by [usr.key]!</span>")
		log_admin("[key_name(usr)] initiated a reboot.")

		feedback_set_details("end_error","admin reboot - by [usr.key]")
		feedback_add_details("admin_verb","R") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		if(blackbox)
			blackbox.save_all_data_to_sql()

		sleep(50)
		world.Reboot(ping=TRUE)

/datum/admins/proc/toggleooc()
	set category = "Server"
	set desc="Globally Toggles OOC"
	set name="Toggle OOC"

	if(!check_rights(R_ADMIN|R_REJUVINATE))
		return

	CONFIG_SET(flag/ooc_allowed, !CONFIG_GET(flag/ooc_allowed))
	if (CONFIG_GET(flag/ooc_allowed))
		to_world("<B>The OOC channel has been globally enabled!</B>")
	else
		to_world("<B>The OOC channel has been globally disabled!</B>")
	log_and_message_admins("toggled OOC.")
	feedback_add_details("admin_verb","TOOC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	CONFIG_SET(flag/guests_allowed, !CONFIG_GET(flag/guests_allowed))
	if (!CONFIG_GET(flag/guests_allowed))
		to_world("<B>Guests may no longer enter the game.</B>")
	else
		to_world("<B>Guests may now enter the game.</B>")
	log_admin("[key_name(usr)] toggled guests game entering [CONFIG_GET(flag/guests_allowed)?"":"dis"]allowed.")
	log_and_message_admins("toggled guests game entering [CONFIG_GET(flag/guests_allowed)?"":"dis"]allowed.")
	feedback_add_details("admin_verb","TGU") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server"
	if(!holder)	return
	if(CONFIG_GET(flag/log_hrefs))
		CONFIG_SET(flag/log_hrefs, 0)
		to_chat(src, "<b>Stopped logging hrefs</b>")
	else
		CONFIG_SET(flag/log_hrefs, 1)
		to_chat(src, "<b>Started logging hrefs</b>")

/client/proc/toggleghostwriters()
	set name = "Toggle ghost writers"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(CONFIG_GET(flag/cult_ghostwriter))
			CONFIG_SET(flag/cult_ghostwriter, FALSE)
			to_chat(src, "<b>Disallowed ghost writers.</b>")
			message_admins("Admin [key_name_admin(usr)] has disabled ghost writers.", 1)
		else
			CONFIG_SET(flag/cult_ghostwriter, TRUE)
			to_chat(src, "<b>Enabled ghost writers.</b>")
			message_admins("Admin [key_name_admin(usr)] has enabled ghost writers.", 1)

/client/proc/toggledrones()
	set name = "Toggle maintenance drones"
	set category = "Server"
	if(!holder)	return
	if(config)
		if(CONFIG_GET(flag/allow_drone_spawn))
			CONFIG_SET(flag/allow_drone_spawn, FALSE)
			to_chat(src, "<b>Disallowed maint drones.</b>")
			message_admins("Admin [key_name_admin(usr)] has disabled maint drones.", 1)
		else
			CONFIG_SET(flag/allow_drone_spawn, TRUE)
			to_chat(src, "<b>Enabled maint drones.</b>")
			message_admins("Admin [key_name_admin(usr)] has enabled maint drones.", 1)
