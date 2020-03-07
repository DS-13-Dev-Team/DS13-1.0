/*
	Quick-hack necromorph comms:

	This is not an ideal implementation.
	This would be better implemented as:
	1. A communication channel, using the same system as dsay, asay, ooc, etc
		or
	2. A hivemind IC language, being the only one necromorphs know
*/
/mob/observer/eye/signal/say(var/message)
	message = sanitize(message)
	message_necromorphs("<span class='cult'>[usr]: [message]</span>")


/mob/living/carbon/human/necromorph/say(var/message)
	message = sanitize(message)
	message_necromorphs("<span class='cult'>[usr]: [message]</span>")

	if(prob(species.speech_chance) && check_audio_cooldown(SOUND_SPEECH))
		set_audio_cooldown(SOUND_SPEECH, 5 SECONDS)
		play_species_audio(src, SOUND_SPEECH, VOLUME_LOW, TRUE)



//Global Necromorph Procs
//-------------------------
/proc/message_necromorphs(var/message)
	//Message all the necromorphs
	for (var/key in SSnecromorph.necromorph_players)
		var/mob/M = SSnecromorph.necromorph_players[key]
		to_chat(M, message)
	//Message all the unitologists too
	/*
	for(var/atom/M in GLOB.unitologists_list)
		to_chat(M, "<span class='cult'>[src]: [message]</span>")
		*/