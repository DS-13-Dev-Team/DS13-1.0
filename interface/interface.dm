//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.

/client/verb/wiki()
	set name = "Wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if(CONFIG_GET(string/wikiurl))
		if(tgui_alert(src, "This will open the wiki in your browser. Are you sure?",,list("Yes","No"))!="Yes")
			return
		DIRECT_OUTPUT(src, link(CONFIG_GET(string/wikiurl)))
	else
		to_chat(src, "<span class='warning'>The wiki URL is not set in the server configuration.</span>")
	return

/client/verb/discord()
	set name ="Join the Discord"
	set desc = "Join our Discord server."
	set hidden = 1
	if(CONFIG_GET(string/discord_url))
		if(tgui_alert(src, "This will open the Dead Space 13 Discord invite in your Browser. Are you sure?",,list("Yes","No"))!="Yes")
			return
		DIRECT_OUTPUT(src, link(CONFIG_GET(string/discord_url)))
	else
		to_chat(src, "<span class='warning'>The Discord URL is not set in the server configuration. Please contact a developer.</span>")
	return

/client/verb/forum()
	set name = "Forum"
	set desc = "Visit the forum."
	set hidden = 1
	if(CONFIG_GET(string/forumurl))
		if(tgui_alert(src, "This will open the forum in your browser. Are you sure?",,list("Yes","No"))=="No")
			return
		DIRECT_OUTPUT(src, link(CONFIG_GET(string/forumurl)))
	else
		to_chat(src, "<span class='warning'>The forum URL is not set in the server configuration.</span>")
	return

/client/verb/github()
	set name = "github"
	set desc = "Visit Github"
	set hidden = TRUE
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		if(tgui_alert(src, "This will open the Github repository in your browser. Are you sure?",,list("Yes","No"))!="Yes")
			return
		DIRECT_OUTPUT(src, link(githuburl))
	else
		to_chat(src, "<span class='danger'>The Github URL is not set in the server configuration.</span>")
	return

/client/verb/reportissue()
	set name = "report-issue"
	set desc = "Report an issue"
	set hidden = TRUE
	var/githuburl = CONFIG_GET(string/githuburl)
	if(githuburl)
		var/message = "This will open the Github issue reporter in your browser. Are you sure?"
		if(GLOB.revdata.testmerge.len)
			message += "<br>The following experimental changes are active and are probably the cause of any new or sudden issues you may experience. If possible, please try to find a specific thread for your issue instead of posting to the general issue tracker:<br>"
			message += GLOB.revdata.GetTestMergeInfo(FALSE)
		// We still use tgalert here because some people were concerned that if someone wanted to report that tgui wasn't working
		// then the report issue button being tgui-based would be problematic.
		if(tgui_alert(src, message, "Report Issue", list("Yes","No"))!="Yes")
			return

		// Keep a static version of the template to avoid reading file
		var/static/issue_template = file2text(".github/ISSUE_TEMPLATE/bug_report.md")

		// Get a local copy of the template for modification
		var/local_template = issue_template

		// Remove comment header
		var/content_start = findtext(local_template, "<")
		if(content_start)
			local_template = copytext(local_template, content_start)

		// Insert round
		if(GLOB.round_id)
			local_template = replacetext(local_template, "## Round ID:\n", "## Round ID:\n[GLOB.round_id]")

		// Insert testmerges
		if(GLOB.revdata.testmerge.len)
			var/list/all_tms = list()
			for(var/entry in GLOB.revdata.testmerge)
				var/datum/tgs_revision_information/test_merge/tm = entry
				all_tms += "- \[[tm.title]\]([githuburl]/pull/[tm.number])"
			var/all_tms_joined = all_tms.Join("\n") // for some reason this can't go in the []
			local_template = replacetext(local_template, "## Testmerges:\n", "## Testmerges:\n[all_tms_joined]")

		var/url_params = "Reporting client version: [byond_version].[byond_build]\n\n[local_template]"
		DIRECT_OUTPUT(src, link("[githuburl]/issues/new?body=[url_encode(url_params)]"))
	else
		to_chat(src, "<span class='danger'>The Github URL is not set in the server configuration.</span>")
	return

#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1
	src << browse(file(RULES_FILE), "window=rules;size=720x640")
#undef RULES_FILE

#define LORE_FILE "config/lore.html"
/client/verb/lore_splash()
	set name = "Lore"
	set desc = "Links to the beginner Lore wiki."
	set hidden = 1
	show_browser(src, file(LORE_FILE), "window=lore;size=480x320")
#undef LORE_FILE

/client/verb/changelog()
	set name = "Changelog"
	set category = "OOC"
	if(!GLOB.changelog_tgui)
		GLOB.changelog_tgui = new /datum/changelog()

	GLOB.changelog_tgui.ui_interact(mob)
	if(prefs.lastchangelog != GLOB.changelog_hash)
		prefs.lastchangelog = GLOB.changelog_hash
		prefs.save_preferences()
		winset(src, "infowindow.changelog", "font-style=;")

/client/verb/hotkeys_help()
	set name = "Hotkeys Help"
	set category = "OOC"

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\t, = move-upwards
\t. = move-down
\tq = drop
\te = equip
\tr = throw
\tt = say
\t5 = emote
\tx = swap-hand
\tz = activate held object (or y)
\tj = toggle-aiming-mode
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x or Middle Mouse = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP or Middle Mouse = swap-hand
\tPGDN = activate held object
\tEND = throw
\tCtrl + Click = drag
\tShift + Click = examine
\tAlt + Click = show entities on turf
\tCtrl + Alt + Click = interact with certain items
</font>"}

	var/robot_hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = unequip active module
\tt = say
\tx = cycle active modules
\tz = activate held object (or y)
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = activate module 1
\t2 = activate module 2
\t3 = activate module 3
\t4 = toggle intents
\t5 = emote
</font>"}

	var/robot_other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = unequip active module
\tCtrl+x = cycle active modules
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = activate module 1
\tCtrl+2 = activate module 2
\tCtrl+3 = activate module 3
\tCtrl+4 = toggle intents
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = pull
\tINS = toggle intents
\tPGUP = cycle active modules
\tPGDN = activate held object
\tCtrl + Click = drag or bolt doors
\tShift + Click = examine or open doors
\tAlt + Click = show entities on turf
\tCtrl + Alt + Click = electrify doors
</font>"}

	if(isrobot(src.mob))
		to_chat(src, robot_hotkey_mode)
		to_chat(src, robot_other)
	else
		to_chat(src, hotkey_mode)
		to_chat(src, other)
	if(holder)
		to_chat(src, admin)
