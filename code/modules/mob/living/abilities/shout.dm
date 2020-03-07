//Simple ability that makes a loud screaming noise, causes screenshake in everyone nearby.
/mob/proc/shout()
	set name = "Shout"
	set category = "Abilities"
	if (check_audio_cooldown(SOUND_SHOUT))
		if (play_species_audio(src, SOUND_SHOUT, VOLUME_HIGH, 1, 2))
			src.Stun(2)
			src.shake_animation(40)
			set_audio_cooldown(SOUND_SHOUT, 8 SECONDS)
			new /obj/effect/effect/expanding_circle(loc, 2, 2 SECOND)	//Visual effect
			for (var/mob/M in range(7, src))
				var/distance = get_dist(src, M)
				var/intensity = 4 - (distance * 0.4)
				var/duration = (6 - (distance * 0.6)) SECONDS
				shake_camera(M, duration, intensity)
				//TODO in future: Add psychosis damage here for non-necros who hear the shout


//Simple ability that makes a louder screaming noise, causes more screenshake in everyone nearby.
/mob/proc/shout_long()
	set name = "Scream"
	set category = "Abilities"
	if (check_audio_cooldown(SOUND_SHOUT_LONG))
		if (play_species_audio(src, SOUND_SHOUT_LONG, VOLUME_HIGH, 1, 2))
			src.Stun(2)
			src.shake_animation(40)
			set_audio_cooldown(SOUND_SHOUT_LONG, 8 SECONDS)
			new /obj/effect/effect/expanding_circle(loc, 2, 3 SECOND)	//Visual effect
			for (var/mob/M in range(8, src))
				var/distance = get_dist(src, M)
				var/intensity = 5 - (distance * 0.3)
				var/duration = (7 - (distance * 0.5)) SECONDS
				shake_camera(M, duration, intensity)
				//TODO in future: Add psychosis damage here for non-necros who hear the scream