/datum/extension/craft_lockout
	/datum/extension/charge
	name = "Craft"
	base_type = /datum/extension/craft_lockout
	expected_type = /mob/living
	flags = 1	// This is EXTENSION_FLAG_IMMEDIATE. The defines don't reach this folder
	var/duration
	var/ongoing_timer

/datum/extension/craft_lockout/New(var/atom/_holder, var/lock_time)
	.=..()
	duration = lock_time
	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/craft_lockout/proc/stop), duration)

/datum/extension/craft_lockout/proc/stop()
	remove_extension(holder, /datum/extension/craft_lockout)

/proc/apply_craft_lockout(var/mob/user, var/time)
	set_extension(user, /datum/extension/craft_lockout, time)

/proc/release_craft_lockout(var/mob/user)
	remove_extension(user, /datum/extension/craft_lockout)