/*
	A simple extension that takes a duration
*/
/datum/extension/effect
	auto_register_statmods = TRUE
	flags = EXTENSION_FLAG_IMMEDIATE
	var/duration = 0

/datum/extension/effect/New(var/atom/holder, var/list/params)
	.=..()
	if (duration)
		addtimer(CALLBACK(src, .proc/remove_self), duration)