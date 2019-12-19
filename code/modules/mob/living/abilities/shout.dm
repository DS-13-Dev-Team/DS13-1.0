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