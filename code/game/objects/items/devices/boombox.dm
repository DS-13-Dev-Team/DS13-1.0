/obj/item/device/boombox
	name = "boombox"
	desc = "A device used to emit rhythmical sounds, colloquialy refered to as a 'boombox'."
	icon = 'icons/obj/boombox.dmi'
	icon_state = "off"
	item_state = "boombox"
	force = 5
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)
	var/playing = 0
	var/track_num = 1
	var/volume = 40
	var/frequency = 1
	var/datum/sound_token/sound_token
	var/datum/track/current_track
	var/list/datum/track/tracks
	var/sound_id

/obj/item/device/boombox/Initialize()
	. = ..()
	sound_id = "[/obj/item/device/boombox]_[sequential_id(/obj/item/device/boombox)]"
	tracks = setup_music_tracks(tracks)

/obj/item/device/boombox/Destroy()
	StopPlaying()
	QDEL_NULL_LIST(tracks)
	current_track = null
	. = ..()

/obj/item/device/boombox/update_icon()
	icon_state = playing ? "on" : "off"

/obj/item/device/boombox/interact(mob/user)
	tgui_interact(user)

/obj/item/device/boombox/tgui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = GLOB.tgui_default_state)
	ui = SStgui.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "jukebox", "Your Media Library", 340, 440, master_ui, state)
		ui.open()

/obj/item/device/boombox/ui_data()
	var/list/boom_tracks = new
	for(var/datum/track/T in tracks)
		boom_tracks.Add(T.title)

	var/list/data = list(
		"current_track" = current_track != null ? current_track.title : "No track selected",
		"playing" = playing,
		"tracks" = boom_tracks,
		"volume" = volume
	)

	return data

/obj/item/device/boombox/ui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("change_track")
			for(var/datum/track/T in tracks)
				if(T.title == params["title"])
					current_track = T
					StartPlaying()
					break
			. = TRUE
		if("stop")
			StopPlaying()
			. = TRUE
		if("play")
			if(!current_track)
				to_chat(usr, "No track selected.")
			else
				StartPlaying()
			. = TRUE
		if("volume")
			AdjustVolume(text2num(params["level"]))
			. = TRUE

/obj/item/device/boombox/attack_self(var/mob/user)
	interact(user)

/obj/item/device/boombox/proc/StopPlaying()
	playing = 0
	update_icon()
	QDEL_NULL(sound_token)


/obj/item/device/boombox/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	// Jukeboxes cheat massively and actually don't share id. This is only done because it's music rather than ambient noise.
	sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, current_track.GetTrack(), volume = volume, range = 7, falloff = 3, prefer_mute = TRUE)

	playing = 1
	update_icon()

/obj/item/device/boombox/proc/AdjustVolume(var/new_volume)
	volume = Clamp(new_volume, 0, 50)
	if(sound_token)
		sound_token.SetVolume(volume)
