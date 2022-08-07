GLOBAL_LIST_EMPTY(allfaxes)
GLOBAL_LIST_EMPTY(all_fax_departments)

GLOBAL_LIST_EMPTY(adminfaxes)	//cache for faxes that have been sent to admins

/obj/machinery/photocopier/faxmachine
	name = "fax machine"
	desc = "For secure document transmission. Somehow not obsolete yet."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "fax"
	insert_anim = "faxsend"
	req_one_access = list(access_security, access_bridge, access_armory, access_cargo)

	use_power = 1
	idle_power_usage = 30
	active_power_usage = 200

	var/obj/item/weapon/card/id/scan = null // identification
	var/authenticated = 0
	var/rank

	var/sendcooldown = 0 // to avoid spamming fax messages
	var/department = "Unknown" // our department
	var/destination = null // the department we're sending to

	var/static/list/admin_departments

/obj/machinery/photocopier/faxmachine/meddle()
	if (prob(50))
		flick("faxsend", src)
	else
		flick("faxreceive", src)

/obj/machinery/photocopier/faxmachine/Initialize()
	. = ..()

	if(!admin_departments)
		admin_departments = list("[GLOB.using_map.boss_name]", "Office of Civil Investigation and Enforcement", "[GLOB.using_map.boss_short] Supply") + GLOB.using_map.map_admin_faxes
	GLOB.allfaxes += src
	if(!destination) destination = "[GLOB.using_map.boss_name]"
	if( !(("[department]" in GLOB.all_fax_departments) || ("[department]" in admin_departments)))
		GLOB.all_fax_departments |= department

/obj/machinery/photocopier/faxmachine/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/machinery/photocopier/faxmachine/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Fax", name)
		ui.open()

/obj/machinery/photocopier/faxmachine/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()
	data["scan"] = scan ? scan.name : null
	data["authenticated"] = authenticated
	data["rank"] = rank
	data["isAI"] = isAI(user)
	data["isRobot"] = isrobot(user)

	data["bossName"] = GLOB.using_map.boss_name
	data["copyItem"] = copyitem
	data["cooldown"] = sendcooldown
	data["destination"] = destination

	return data

/obj/machinery/photocopier/faxmachine/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("scan")
			if(scan)
				scan.forceMove(loc)
				if(ishuman(usr) && !usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			else
				var/obj/item/I = usr.get_active_hand()
				if(istype(I, /obj/item/weapon/card/id))
					usr.drop_item()
					I.forceMove(src)
					scan = I
			return TRUE
		if("login")
			if(istype(scan))
				if(check_access(scan))
					authenticated = scan.registered_name
					rank = scan.assignment
			else if(isAI(usr))
				authenticated = usr.name
				rank = "AI"
			else if(isrobot(usr))
				authenticated = usr.name
				var/mob/living/silicon/robot/R = usr
				rank = "[R.modtype] [R.braintype]"
			return TRUE
		if("logout")
			if(scan)
				scan.forceMove(loc)
				if(ishuman(usr) && !usr.get_active_hand())
					usr.put_in_hands(scan)
				scan = null
			authenticated = null
			return TRUE
		if("remove")
			if(copyitem)
				if(get_dist(usr, src) >= 2)
					to_chat(usr, "\The [copyitem] is too far away for you to remove it.")
					return
				copyitem.forceMove(loc)
				usr.put_in_hands(copyitem)
				to_chat(usr, "<span class='notice'>You take \the [copyitem] out of \the [src].</span>")
				copyitem = null

	if(!authenticated)
		return

	switch(action)
		if("send")
			if(copyitem)
				if (destination in admin_departments)
					send_admin_fax(usr, destination)
				else
					sendfax(destination)

				if (sendcooldown)
					spawn(sendcooldown) // cooldown time
						sendcooldown = 0

		if("dept")
			var/lastdestination = destination
			destination = tgui_input_list(usr, "Which department?", "Choose a department", (GLOB.all_fax_departments + admin_departments))
			if(!destination)
				destination = lastdestination

	return TRUE

/obj/machinery/photocopier/faxmachine/attackby(obj/item/O as obj, mob/user as mob)
	if(isMultitool(O) && panel_open)
		var/input = tgui_input_text(usr, "What Department ID would you like to give this fax machine?", "Multitool-Fax Machine Interface", department)
		if(!input)
			to_chat(usr, "No input found. Please hang up and try your call again.")
			return
		department = input
		if( !(("[department]" in GLOB.all_fax_departments) || ("[department]" in admin_departments)) && !(department == "Unknown"))
			GLOB.all_fax_departments |= department

	return ..()

/obj/machinery/photocopier/faxmachine/proc/sendfax(destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	var/success = 0
	for(var/obj/machinery/photocopier/faxmachine/F in GLOB.allfaxes)
		if( F.department == destination )
			success = F.receivefax(copyitem)

	if (success)
		visible_message("[src] beeps, \"Message transmitted successfully.\"")
		//sendcooldown = 600
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")

/obj/machinery/photocopier/faxmachine/proc/receivefax(obj/item/incoming)
	if(stat & (BROKEN|NOPOWER))
		return 0

	if(department == "Unknown")
		return 0	//You can't send faxes to "Unknown"

	flick("faxreceive", src)
	playsound(src, "sound/machines/printer.ogg", 50, 1)


	// give the sprite some time to flick
	sleep(20)

	if (istype(incoming, /obj/item/weapon/paper))
		copy(incoming)
	else if (istype(incoming, /obj/item/weapon/photo))
		photocopy(incoming)
	else if (istype(incoming, /obj/item/weapon/paper_bundle))
		bundlecopy(incoming)
	else
		return 0

	use_power(active_power_usage)
	return 1

/obj/machinery/photocopier/faxmachine/proc/send_admin_fax(mob/sender, destination)
	if(stat & (BROKEN|NOPOWER))
		return

	use_power(200)

	//received copies should not use toner since it's being used by admins only.
	var/obj/item/rcvdcopy
	if (istype(copyitem, /obj/item/weapon/paper))
		rcvdcopy = copy(copyitem, 0)
	else if (istype(copyitem, /obj/item/weapon/photo))
		rcvdcopy = photocopy(copyitem, 0)
	else if (istype(copyitem, /obj/item/weapon/paper_bundle))
		rcvdcopy = bundlecopy(copyitem, 0)
	else
		visible_message("[src] beeps, \"Error transmitting message.\"")
		return

	rcvdcopy.loc = null //hopefully this shouldn't cause trouble
	GLOB.adminfaxes += rcvdcopy

	var/mob/intercepted = check_for_interception()

	//message badmins that a fax has arrived
	if (destination == GLOB.using_map.boss_name)
		message_admins(sender, "[uppertext(destination)] FAX[intercepted ? "(Intercepted by [intercepted])" : null]", rcvdcopy, destination, "#006100")
	else if (destination == "Office of Civil Investigation and Enforcement")
		message_admins(sender, "[uppertext(destination)] FAX[intercepted ? "(Intercepted by [intercepted])" : null]", rcvdcopy, destination, "#1f66a0")
	else if (destination == "[GLOB.using_map.boss_short] Supply")
		message_admins(sender, "[uppertext(destination)] FAX[intercepted ? "(Intercepted by [intercepted])" : null]", rcvdcopy, destination, "#5f4519")
	else if (destination in GLOB.using_map.map_admin_faxes)
		message_admins(sender, "[uppertext(destination)] FAX[intercepted ? "(Intercepted by [intercepted])" : null]", rcvdcopy, destination, "#510b74")
	else
		message_admins(sender, "[uppertext(destination)] FAX[intercepted ? "(Intercepted by [intercepted])" : null]", rcvdcopy, "UNKNOWN")

	sendcooldown = 1800
	sleep(50)
	visible_message("[src] beeps, \"Message transmitted successfully.\"")

// Turns objects into just text.
/obj/machinery/photocopier/faxmachine/proc/make_summary(obj/item/sent)
	if(istype(sent, /obj/item/weapon/paper))
		var/obj/item/weapon/paper/P = sent
		return P.info
	if(istype(sent, /obj/item/weapon/paper_bundle))
		. = ""
		var/obj/item/weapon/paper_bundle/B = sent
		for(var/i in 1 to B.pages.len)
			var/obj/item/weapon/paper/P = B.pages[i]
			if(istype(P)) // Photos can show up here too.
				if(.) // Space out different pages.
					. += "<br>"
				. += "PAGE [i] - [P.name]<br>"
				. += P.info

/obj/machinery/photocopier/faxmachine/proc/message_admins(mob/sender, faxname, obj/item/sent, reply_type, font_colour="#006100")
	var/msg = "<span class='notice'><b><font color='[font_colour]'>[faxname]: </font>[get_options_bar(sender, 2,1,1)]"
	msg += "(<A HREF='?_src_=holder;take_ic=\ref[sender]'>TAKE</a>) (<a href='?_src_=holder;FaxReply=\ref[sender];originfax=\ref[src];replyorigin=[reply_type]'>REPLY</a>)</b>: "
	msg += "Receiving '[sent.name]' via secure connection ... <a href='?_src_=holder;AdminFaxView=\ref[sent]'>view message</a></span>"

	for(var/client/C in GLOB.admins)
		if(check_rights((R_ADMIN|R_MOD),0,C))
			to_chat(C,
					type = MESSAGE_TYPE_ADMINCHAT,
					html = msg)
			SEND_SOUND(C, 'sound/machines/dotprinter.ogg')
