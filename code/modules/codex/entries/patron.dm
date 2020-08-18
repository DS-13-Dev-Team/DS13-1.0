/datum/codex_entry/concept/patron
	display_name = "Patron"
	category = CATEGORY_CONCEPTS
	associated_strings = list("patron", "patron", "supporter")
	lore_text = ""
	mechanics_text = "Lovely people who help support our work get access to special content! \
	Please visit our patreon to find out more!"

/datum/codex_entry/concept/patron/get_text(var/mob/user)
	var/string = "[mechanics_text]"
	string += "<a href='?src=\ref[user];open_url=patreon.com/user?u=31268725&fan_landing=true;prefix=[URL_HTTP_WWW];'>Clicky!</a>"
	return string