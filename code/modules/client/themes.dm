GLOBAL_LIST_INIT(skin_buttons, list("infob","discordb", "textb", "wikib", "forumb", "changelog", "rulesb", "hotkey_toggle", "codexb"))
/decl/theme
	var/name = "Theme"
	var/id = "theme"	//All lowercase, must be unique

	var/panel_color = "#FFFFFF"	//The flat, inner portions of panels
	var/border_color = "#FFFFFF"	//The outer portions of panels around the inner
	var/text_color = "#000000"

	var/fullscreen = FALSE

//Note, pressing tab used to turn the textbox this color
// input.background-color=#D3B5B5
//Future TODO: Reimplement this with theme-specific coloring

/decl/theme/proc/apply(var/player)
	winset(player, "infowindow", "background-color = [panel_color]; text-color = [text_color]")
	winset(player, "info", "background-color = [panel_color]; text-color = [text_color]; tab-background-color = [border_color]; tab-text-color = [text_color]")
	winset(player, "browseroutput", "background-color = [panel_color]")
	winset(player, "browseroutput", "text-color = [text_color]")
	winset(player, "outputwindow", "background-color = [panel_color]")
	winset(player, "outputwindow", "text-color = [text_color]")
	winset(player, "input", "background-color = [panel_color]; font-size = 8; text-color = [text_color];")
	winset(player, "mainwindow", "background-color = [panel_color]")
	winset(player, "split", "background-color = [border_color]")
	//Buttons
	for (var/button in GLOB.skin_buttons)
		winset(player, button, "background-color = [panel_color]; text-color = [text_color]")

	//Status and verb tabs
	winset(player, "output", "background-color = [panel_color]")
	winset(player, "output", "text-color = [text_color]")
	winset(player, "outputwindow", "background-color = [panel_color]")
	winset(player, "outputwindow", "text-color = [text_color]")
	winset(player, "statwindow", "background-color = [panel_color]; text-color = [text_color]")
	winset(player, "rpane", "background-color = [panel_color]; text-color = [text_color]")
	winset(player, "rpanewindow", "background-color = [panel_color]; text-color = [text_color]")

	winset(player, "stat", "background-color = [panel_color]")
	winset(player, "stat", "text-color = [text_color]")
	//Say, OOC, me Buttons etc.
	winset(player, "saybutton", "background-color = [panel_color]")
	winset(player, "saybutton", "text-color = [text_color]")
	winset(player, "oocbutton", "background-color = [panel_color]")
	winset(player, "oocbutton", "text-color = [text_color]")
	winset(player, "mebutton", "background-color = [panel_color]")
	winset(player, "mebutton", "text-color = [text_color]")
	winset(player, "asset_cache_browser", "background-color = [panel_color]")
	winset(player, "asset_cache_browser", "text-color = [text_color]")
	winset(player, "tooltip", "background-color = [panel_color]")
	winset(player, "tooltip", "text-color = [text_color]")

	if(fullscreen)
		winset(player, "mainwindow", "is-maximized=false;can-resize=false;titlebar=false")
		winset(player, "mainwindow", "menu=null;statusbar=false")
		winset(player, "mainwindow.split", "pos=0x0")
	else
		winset(player, "mainwindow", "is-maximized=false;can-resize=true;titlebar=true")
		winset(player, "mainwindow", "menu=menu;statusbar=true")
		winset(player, "mainwindow.split", "pos=3x0")
	winset(player, "mainwindow", "is-maximized=true")

	/*
		Statics
		These shouldn't change between skins
	*/
	winset(player, "mapwindow", "background-color = #000000;")
	winset(player, "map", "background-color = #000000;")

/decl/theme/light
	name = "Flashbang"
	id = "light"
	panel_color = "#FFFFFF"	//The flat, inner portions of panels
	border_color = "#FFFFFF"	//The outer portions of panels around the inner
	text_color = "#000000"


/decl/theme/dark
	name = "Half-light"
	id = "dark"
	text_color = "#99aab5"
	panel_color = "#272727"	//The flat, inner portions of panels
	border_color = "#2c2f33"	//The outer portions of panels around the inner


/decl/theme/dark/perfect
	name = "Perfect Dark"
	id = "realdark"
	fullscreen	=	TRUE



/*
	Helpers
*/
/client/proc/set_theme(var/theme_id, var/save = TRUE)
	var/decl/theme/T = GLOB.client_themes[theme_id]
	T.apply(src)
	if (prefs && save)
		prefs.client_theme = theme_id
		prefs.save_preferences()

//Returns a list of the client theme names
/proc/get_themes_list()
	var/list/names = list()
	for (var/id in GLOB.client_themes)
		var/decl/theme/T = GLOB.client_themes[id]
		names[T.name] = T.id

	return names

/client/verb/darkmode()
	set name = "Half-light"
	set category = "Themes"

	set_theme("dark")


/client/verb/darkmode_perfect()
	set name = "Perfect Dark"
	set category = "Themes"

	set_theme("realdark")

/client/verb/lightmode()
	set name = "Flashbang"
	set category = "Themes"

	set_theme("light")