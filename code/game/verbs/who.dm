#define DEFAULT_WHO_CELLS_PER_ROW 4

/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()
	var/columns_per_row = DEFAULT_WHO_CELLS_PER_ROW

	if(holder)
		if (check_rights(R_ADMIN,0) && isghost(src.mob))//If they have +ADMIN and are a ghost they can see players IC names and statuses.
			columns_per_row = 1
			var/mob/dead/observer/ghost/G = src.mob
			if(!G.started_as_observer)//If you aghost to do this, KorPhaeron will deadmin you in your sleep.
				log_admin("[key_name(usr)] checked advanced who in-round")
			for(var/client/C in GLOB.clients)
				var/entry = "\t[C.key]"
				if (isnewplayer(C.mob))
					entry += " - <font color='darkgray'><b>In Lobby</b></font>"
				else
					entry += " - Playing as [C.mob.real_name]"
					switch(C.mob.stat)
						if(UNCONSCIOUS)
							entry += " - <font color='darkgray'><b>Unconscious</b></font>"
						if(DEAD)
							if(isghost(C.mob))
								var/mob/dead/observer/ghost/O = C.mob
								if(O.started_as_observer)
									entry += " - <font color='gray'>Observing</font>"
								else
									entry += " - <font color='black'><b>DEAD</b></font>"
							else if(issignal(C.mob))
								entry += " - <font color='gray>Signal</font>"
							else
								entry += " - <font color='black'><b>DEAD</b></font>"
					if(is_special_character(C.mob))
						entry += " - <b><font color='red'>Antagonist</font></b>"
					if(C.is_afk())
						entry += " (AFK - [C.inactivity2text()])"
				entry += " [ADMIN_QUE(C.mob)]"
				entry += " ([round(C.avgping, 1)]ms)"
				Lines += entry
		else//If they don't have +ADMIN, only show hidden admins
			for(var/client/C in GLOB.clients)
				var/entry = "[C.key]"
				entry += " ([round(C.avgping, 1)]ms)"
				Lines += entry
	else
		for(var/client/C in GLOB.clients)
			if(!C.is_stealthed())
				Lines += "[C.key] ([round(C.avgping, 1)]ms)"

	var/num_lines = 0
	msg += "<table style='width: 100%; table-layout: fixed'><tr>"
	for(var/line in sortList(Lines))
		msg += "<td>[line]</td>"

		num_lines += 1
		if (num_lines == columns_per_row)
			num_lines = 0
			msg += "</tr><tr>"
	msg += "</tr></table>"

	msg += "<b>Total Players: [length(Lines)]</b>"
	to_chat(src, "<span class='infoplain'>[msg]</span>")


// Staffwho verb. Displays online staff. Hides stealthed or AFK staff members automatically.
/client/verb/staffwho()
	set category = "Admin"
	set name = "StaffWho"
	var/adminwho = ""
	var/modwho = ""
	var/mentwho = ""
	var/devwho = ""
	var/admin_count = 0
	var/mod_count = 0
	var/ment_count = 0
	var/dev_count = 0

	for(var/client in GLOB.admins)
		var/client/C = client
		if(C.is_stealthed() && !check_rights(R_MOD|R_ADMIN, 0, src)) // Normal players and mentors can't see stealthmins
			continue

		var/extra = ""
		if(holder)
			if(C.is_stealthed())
				extra += " (Stealthed)"
			if(isghost(C.mob))
				extra += " - Observing"
			else if(isnewplayer(C.mob))
				extra += " - Lobby"
			else
				extra += " - Playing"
			if(C.is_afk())
				extra += " (AFK)"

		if(R_ADMIN & C.holder.rights)
			adminwho += "\t[C] is a <b>[C.holder.rank]</b>[extra]\n"
			admin_count++
		else if (R_MOD & C.holder.rights)
			modwho += "\t[C] is a <i>[C.holder.rank]</i>[extra]\n"
			mod_count++
		else if (R_MENTOR & C.holder.rights)
			mentwho += "\t[C] is a [C.holder.rank][extra]\n"
			ment_count++
		else if (R_DEBUG & C.holder.rights)
			devwho += "\t[C] is a [C.holder.rank][extra]\n"
			dev_count++
	var/msg = ""
	if(!admin_count && !mod_count && !ment_count && !dev_count)
		msg += "<b><big>Online staff:</big></b>"
		if(!admin_count)
			msg += "<b>Current Admins ([admin_count]):</b><br>[adminwho]<br>"
		if(!mod_count)
			msg += "<b>Current Moderators ([mod_count]):</b><br>[modwho]<br>"
		if(!ment_count)
			msg += "<b>Current Mentors ([ment_count]):</b><br>[mentwho]<br>"
		if(!dev_count)
			msg += "<b>Current Developers ([dev_count]):</b><br>[devwho]<br>"
	if(!msg)
		to_chat(src, "<span class='infoplain'>[msg]</span>")

#undef DEFAULT_WHO_CELLS_PER_ROW
