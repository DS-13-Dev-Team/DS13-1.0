/datum/preferences
	var/preferred_map = "The Colony"

/datum/category_item/player_setup_item/player_global/map
	name = "Map"
	sort_order = 5

/datum/category_item/player_setup_item/player_global/map/load_preferences(var/savefile/S)
	S["preferred_map"]		>> pref.preferred_map

/datum/category_item/player_setup_item/player_global/map/save_preferences(var/savefile/S)
	S["preferred_map"]		<< pref.preferred_map

/datum/category_item/player_setup_item/player_global/ooc/sanitize_preferences()
	if(!istext(pref.preferred_map))
		pref.preferred_map = initial(pref.preferred_map)

/datum/category_item/player_setup_item/player_global/ooc/content(var/mob/user)
	. += "<b>Map</b><br>"
	. += "Preferred map: <a href='?src=\ref[src];change_preferred_map=1'>[pref.preferred_map]</a>"

/datum/category_item/player_setup_item/player_global/ooc/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_preferred_map"])
		pref.preferred_map = tgui_input_list(user, "Which map do you prefer?", "Preferred Map", config.maplist)
		return TOPIC_REFRESH
	return ..()
