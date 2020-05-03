/client/proc/resolve_drag(var/atom/A, var/params)
	var/list/L = params2list(params)
	var/dragged = L["drag"]
	if(dragged && !L[dragged])
		return last_click_atom

	last_click_atom = A
	return A


/datum/proc/get_client()
	return null

/client/get_client()
	return src

/mob/get_client()
	return client

/mob/observer/eye/get_client()
	. = client || (owner && owner.get_client())

/mob/observer/virtual/get_client()
	return host.get_client()


/client/var/temp_view = 7
/client/proc/set_view_range(var/radius, var/force_update = FALSE)

	if ((force_update || view != radius) && isnum(radius))
		//If radius has changed, we'll return true
		.=TRUE

		temp_view = radius

		remake_click_catcher()

		if (mob)
			mob.reload_fullscreen()
			if (mob.l_general)//It may not exist during login
				mob.l_general.resize(src)
			if (isliving(mob))
				var/mob/living/L = mob
				L.handle_regular_hud_updates(FALSE)//Pass false here to not call update vision and avoid an infinite loop


		spawn()
			view = temp_view


//Returns the total distance infront of the mob that this client can see, taking into account view radius and offset
/client/proc/get_view_length()
	return temp_view + (view_offset_magnitude / WORLD_ICON_SIZE)


/client/proc/set_view_offset(var/direction, var/magnitude, var/force_update = FALSE)
	view_offset_magnitude = magnitude //Cache this
	var/vector2/offset = (Vector2.FromDir(direction))*magnitude
	if (pixel_x != offset.x || pixel_y != offset.y) //If the values already match the target, don't interrupt the animation by repeating it
		.=TRUE //Offset has changed, return true
		var/saccade_time = SACCADE_BASE_SPEED / text2num(get_preference_value(/datum/client_preference/saccade_speed))
		var/saccade_distance = sqrt((get_view_length()**2)*2)	//Pythagoras helps us find the distance of the saccade. Hypotenuse = square root of A squared + B squared
		saccade_time *= saccade_distance
		animate(src, pixel_x = offset.x, pixel_y = offset.y, time = saccade_time, easing = SINE_EASING)


/client/proc/setup_click_catcher()
	if(!void)
		void = create_click_catcher(temp_view)
	if(!screen)
		screen = list()
	screen |= void

/client/proc/remove_click_catcher()
	screen -= void
	void = null

/client/proc/remake_click_catcher()
	remove_click_catcher()
	setup_click_catcher()



//Plays lobby music in sequence
/client/proc/playtitlemusic()
	if (QDELETED(src))
		return

	if(!(get_preference_value(/datum/client_preference/play_lobby_music) == GLOB.PREF_YES))
		return

	if (!istype(mob, /mob/new_player))	//Don't play it if we aren't in the lobby
		return

	//First of all, stop any previous lobby track we were playing
	sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))

	var/tracktype = GLOB.using_map.get_lobby_track(played_lobby_tracks)
	var/music_track/MT = decls_repository.get_decl(tracktype)
	LAZYDISTINCTADD(played_lobby_tracks,tracktype)

	MT.play_to(src, play_looped = FALSE)



	//Queue up the next song
	deltimer(lobby_trackchange_timer)
	var/delay = MT.get_duration(src) + MUSIC_INTERVAL_DURATION
	lobby_trackchange_timer = addtimer(CALLBACK(src, /client/proc/playtitlemusic), delay, TIMER_STOPPABLE)


//This is an awkward proc working within byond limitations.
//This client proc attempts to find the length of a specified audio file
//It will only work if that audio file is already being played by this client
/client/proc/get_audio_length(var/filepath)
	var/list/playing_sounds = SoundQuery()
	for (var/sound/S in playing_sounds)
		if (S.file == filepath)
			//We found it!
			if (S.len)
				return S.len*10	//Convert to deciseconds

	return 0	//Return zero if we failed to get it


/*
	Tells us whether a specified atom is on a this client's screen.
	Specifically, if its inside their view window. doesn't check invisibility or blocked line of sight
*/
/client/proc/is_on_screen(var/atom/A)
	.=FALSE
	if (!A)
		return FALSE

	if (!isturf(A.loc))
		A = get_turf(A) //If its hidden inside an object, we move to its tile

	//Ok, now lets see if the target is onscreen,
	//First we've got to figure out what onscreen is
	var/atom/origin = get_view_centre()

	//Lets get how far the screen extends around the origin
	var/list/bound_offsets = get_tile_bounds(FALSE) //Cut off partial tiles or they might stretch the screen
	var/vector2/delta = new /vector2(A.x - origin.x, A.y - origin.y)	//Lets get the position delta from origin to target
	//Now check whether or not that would put it onscreen
	//Bottomleft first
	var/vector2/BL = bound_offsets["BL"]
	if (delta.x < BL.x || delta.y < BL.y)
		//Its offscreen
		return


	//Then topright
	var/vector2/TR = bound_offsets["TR"]
	if (delta.x > TR.x || delta.y > TR.y)
		//Its offscreen
		return


	//If we get here, the target is on our screen!
	return TRUE

