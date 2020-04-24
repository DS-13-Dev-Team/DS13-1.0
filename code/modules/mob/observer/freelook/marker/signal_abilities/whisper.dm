/datum/signal_ability/whisper
	name = "Whisper"
	id = "whisper"
	desc = "Allows you to broadcast a subliminal message into the mind of a receptive target. Can be used on anyone visible, or on unitologists remotely.<br>\
	<br>\
	Please remember that subliminal messages are in-character communication. You are a spooky voice in their head that they might just be imagining. Roleplay appropriately, no memes. Admins are watching"
	target_string = "a unitologist or similarly mentally open target"
	energy_cost = 30
	require_corruption = FALSE
	autotarget_range = 1
	target_types = list(/mob/living)


//This is kinda inefficient, but it shouldnt be used too often
/datum/signal_ability/whisper/proc/get_possible_targets()
	var/list/possible = list()
	for (var/mob/M in GLOB.unitologists_list)
		if (M.stat == DEAD)
			continue

		possible += M

	//TODO in future: Allow speaking to people with enough psychosis
	//TODO in future: Allow speaking to people who are near the marker or a shard

	return possible


/datum/signal_ability/whisper/select_target(var/mob/user, var/candidate,  var/list/data)
	.=..()
	if (!.)
		//If the parent returned false, then we didn't click a valid mob. We'll continue anyway with a null target
		finish_casting(user, null, list())

		return TRUE


/datum/signal_ability/whisper/on_cast(var/mob/user, var/mob/living/target, var/list/data)
	if (!target || !isliving(target) || !target.client)
		var/list/possible_targets = get_possible_targets()
		if (!possible_targets.len)
			to_chat(user, "<span class='warning'>No target selected and no valid targets to choose from. Cancelling</span>")
			refund(user)
			return

		target = input(user, "Who do you wish to speak to?", "Subliminal Message", "") as null|mob in get_possible_targets()
		if (!target || !target.client)
			to_chat(user, "<span class='warning'>No target selected or target is disconnected. Cancelling.</span>")
			refund(user)
			return

	var/message = sanitize(input(user, "Write a message to send to [target.name]", "Subliminal Message", ""))

	to_chat(target, "<span class='necromorph'>[message]</span>")

