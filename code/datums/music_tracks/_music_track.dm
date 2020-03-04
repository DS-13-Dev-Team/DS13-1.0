/music_track
	var/artist
	var/title
	var/album
	var/decl/license/license
	var/song
	var/url // Remember to include http:// or https:// or BYOND will be sad
	var/volume = 70
	var/duration

/music_track/New()
	if (license)
		license = decls_repository.get_decl(license)

/music_track/proc/play_to(var/listener, var/play_looped = TRUE)
	to_chat(listener, "<span class='good'>Now Playing:</span>")
	to_chat(listener, "<span class='good'>[title][artist ? " by [artist]" : ""][album ? " ([album])" : ""]</span>")
	if(url)
		to_chat(listener, url)

	if (license)
		to_chat(listener, "<span class='good'>License: <a href='[license.url]'>[license.name]</a></span>")
	sound_to(listener, sound(song, repeat = play_looped, wait = 0, volume = volume, channel = GLOB.lobby_sound_channel))

// No VV editing anything about music tracks
/music_track/VV_static()
	return ..() + vars


//This awkward proc attempts to find the duration of this music track
/music_track/proc/get_duration(var/client/C)
	//IF the duration has been found at least once before or set at authortime we'll just return that
	if (duration)
		return duration

	//Alright here, things get wierd. For the next step, we need a client which is already playing this track
	//We will attempt to fetch the length from that client's currently playing sounds
	if (C)
		var/possible_duration = C.get_audio_length(song)	//See client_helpers.dm for how this works

		if (possible_duration)
			duration = possible_duration
			return duration

	return 0