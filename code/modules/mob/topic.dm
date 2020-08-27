/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		unset_machine()
		src << browse(null, t1)

	if(href_list["flavor_more"])
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", name, replacetext_char(flavor_text, "\n", "<BR>")), text("window=[];size=500x200", name))
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
	if(href_list["jump_to"])
		var/canjump = FALSE
		if (can_jump_to_link())
			canjump = TRUE
		else if (client && check_rights(R_ADMIN|R_MOD|R_DEBUG))
			//Possible todo: notify admins here?
			canjump = TRUE
		if (canjump)
			var/x = text2num(href_list["X"])
			var/y = text2num(href_list["Y"])
			var/z = text2num(href_list["Z"])
			var/turf/T = locate(x,y,z)
			if (istype(T))
				jumpTo(T)

	if(href_list["open_url"])
		var/url = "[GLOB.url_prefixes[href_list["prefix"]]][href_list["open_url"]]"
		src << link(url)