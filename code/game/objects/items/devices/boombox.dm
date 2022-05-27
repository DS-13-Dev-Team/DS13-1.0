/obj/item/device/boombox
	name = "boombox"
	desc = "A device used to emit rhythmical sounds, colloquialy refered to as a 'boombox'."
	icon = 'icons/obj/boombox.dmi'
	icon_state = "off"
	item_state = "boombox"
	force = 5
	w_class = ITEM_SIZE_LARGE
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 1)
	var/active = 0
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

/obj/item/device/boombox/equipped()
	.=..()
	if(!isturf(loc))
		RegisterSignal(loc, COMSIG_MOVABLE_MOVED, .proc/on_holder_moved)

/obj/item/device/boombox/dropped(mob/user)
	.=..()
	UnegisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/device/boombox/proc/on_holder_moved(mob/user, OldLoc, NewLoc)
	SEND_SIGNAL(src, COMSIG_MOVABLE_MOVED, OldLoc, NewLoc)

/obj/item/device/boombox/update_icon()
	icon_state = active ? "on" : "off"

/obj/item/device/boombox/tgui_interact(mob/user, datum/tgui/ui = null)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "jukebox", "Your Media Library")
		ui.open()

/obj/item/device/boombox/ui_data()
	var/list/data = list()
	data["active"] = active
	data["songs"] = list()
	for(var/datum/track/S in tracks)
		var/list/track_data = list(
			name = S.title
		)
		data["songs"] += list(track_data)
	data["track_selected"] = null
	data["track_length"] = null
	data["track_beat"] = null
	if(current_track)
		data["track_selected"] = current_track.title
	data["volume"] = volume

	return data

/obj/item/device/boombox/ui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("toggle")
			if(QDELETED(src))
				return
			if(!active)
				if(!current_track)
					to_chat(usr, "No track selected.")
				else
					StartPlaying()
				active = TRUE
				return TRUE
			else
				active = FALSE
				StopPlaying()
				return TRUE
		if("select_track")
			if(active)
				to_chat(usr, "<span class='warning'>Error: You cannot change the song until the current one is over.</span>")
				return
			var/list/available = list()
			for(var/datum/track/S in tracks)
				available[S.title] = S
			var/selected = params["track"]
			if(QDELETED(src) || !selected || !istype(available[selected], /datum/track))
				return
			current_track = available[selected]
			return TRUE
		if("set_volume")
			var/new_volume = params["volume"]
			if(new_volume  == "reset")
				AdjustVolume(initial(volume))
				return TRUE
			else if(new_volume == "min")
				AdjustVolume(0)
				return TRUE
			else if(new_volume == "max")
				AdjustVolume(100)
				return TRUE
			else if(text2num(new_volume) != null)
				AdjustVolume(text2num(new_volume))
				return TRUE

/obj/item/device/boombox/attack_self(var/mob/user)
	tgui_interact(user)

/obj/item/device/boombox/proc/StopPlaying()
	active = 0
	update_icon()
	QDEL_NULL(sound_token)


/obj/item/device/boombox/proc/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	// Jukeboxes cheat massively and actually don't share id. This is only done because it's music rather than ambient noise.
	sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, current_track.GetTrack(), volume = volume, range = 7, falloff = 3, prefer_mute = TRUE)

	active = 1
	update_icon()

/obj/item/device/boombox/proc/AdjustVolume(var/new_volume)
	volume = Clamp(new_volume, 0, 50)
	if(sound_token)
		sound_token.SetVolume(volume)
