/*
	//The master signal is the player who controls the marker. Essentially the leader of the necromorphs
*/
/mob/dead/observer/signal/master
	name = "Marker"
	icon = 'icons/mob/necromorph/mastersignal.dmi'
	icon_state = "mastersignal"
	atom_flags = ATOM_FLAG_INTANGIBLE
	pixel_x = -7
	pixel_y = -7
	energy_extension_type = /datum/extension/psi_energy/marker	//Stores and accumulates energy for abilities

/mob/dead/observer/signal/master/Initialize()
	.=..()
	icon_state = "mastersignal"
	//Lets remove some verbs that don't make sense here, you get these back if you downgrade to signal
	remove_verb(src, list(/mob/dead/observer/signal/verb/become_master_signal_verb, /mob/dead/observer/signal/verb/leave_marker_verb))

/mob/dead/observer/signal/master/apply_customisation(datum/preferences/prefs)
	return

/mob/dead/observer/signal/verb/become_master_signal_verb()
	set name = "Become Master Signal"
	set category = SPECIES_NECROMORPH

	if (!SSnecromorph.marker)
		to_chat(src, "ERROR: No marker found")
		return

	if (SSnecromorph.marker.player)
		if(SSnecromorph.marker.playermob.client && !SSnecromorph.marker.playermob.client.is_afk(5 MINUTES))
			to_chat(src, "[SSnecromorph.marker.player] is already controlling the marker.")
			return

	if(CONFIG_GET(flag/use_exp_tracking) && client.exp[EXP_TYPE_SIGNAL] < 1.5 HOURS)
		for(var/mob/dead/observer/signal/signal as anything in SSnecromorph.signals-SSnecromorph.marker.playermob)
			if(signal.client?.exp[EXP_TYPE_SIGNAL] < 1.5 HOURS || signal.client.is_afk(5 MINUTES))
				continue
			to_chat(src, SPAN_WARNING("The role is timelocked! You need to play [round((1.5 HOURS - client.exp[EXP_TYPE_SIGNAL])/600)] minutes more as a signal!"))
			return

	if(SSnecromorph.marker.player)
		to_chat(SSnecromorph.marker.playermob, SPAN_WARNING("You were AFK for too long and were replaced by another player!"))
		SSnecromorph.marker.playermob.leave_master_signal_verb()

	//For now, just succeed
	SSnecromorph.marker.become_master_signal(src)

/mob/dead/observer/signal/master/verb/leave_master_signal_verb()
	set name = "Downgrade to normal signal"
	set category = SPECIES_NECROMORPH

	SSnecromorph.marker.vacate_master_signal()

	//Something must have gone wrong, we aren't deleted yet!
	//Turn ourselves into a signal as a fallback
	if (!QDELETED(src))
		new /mob/dead/observer/signal(src)
		qdel(src)

/mob/dead/observer/signal/master/verb/shop_verb()
	set name = "Spawning Menu"
	set category = SPECIES_NECROMORPH

	SSnecromorph.marker.open_shop(src)

/*
/mob/dead/observer/signal/master/verb/message_servants()
	set name = "Contact servants"
	set src = usr
	set category = SPECIES_NECROMORPH
	usr.message_unitologists()
*/

//Finds out if the passed thing is the marker player.
//The thing can be a mob, client, or ckey. They will all work
/proc/is_marker_master(var/check)
	if (!istype(SSnecromorph.marker) || !SSnecromorph.marker.player)
		return FALSE	//If theres no marker there cant be a master

	if (istype(check, /mob/dead/observer/signal/master))
		return TRUE	//If it is the master mob then it is the master mob. We only need to do farther checks in the case of master inhabiting a necromorph

	//This all works on key checking anyways, so lets start by finding the key
	var/check_key
	if (ismob(check))
		var/mob/M = check
		if (!M.key)
			//If theres no key its not the master
			return FALSE
		check_key = ckey(M.key)
	else if (isclient(check))
		var/client/C = check
		check_key = C.ckey
	else
		check_key = ckey(check)

	if (!check_key)
		return FALSE

	//Okay we have a key, lets see if it matches
	//Possible future todo: Support for multiple markers here. For now, just one
	if (SSnecromorph.marker.player == check_key)
		//It matches! At last,
		return TRUE

	else
		return FALSE