/obj/structure/musician
	name = "Not A Piano"
	desc = "Something broke, contact coderbus."
	atom_flags = ATOM_FLAG_CLIMBABLE
	obj_flags = OBJ_FLAG_ANCHORABLE
	var/can_play_unanchored = FALSE
	var/list/allowed_instrument_ids = list("piano","r3grand","r3harpsi","crharpsi","crgrand1","crbright1", "crichugan", "crihamgan")
	var/datum/song/song

/obj/structure/musician/Initialize(mapload)
	. = ..()
	song = new(src, allowed_instrument_ids)
	allowed_instrument_ids = null

/obj/structure/musician/Destroy()
	QDEL_NULL(song)
	return ..()

/obj/structure/musician/proc/should_stop_playing(atom/music_player)
	if(!(anchored || can_play_unanchored) || !ismob(music_player))
		return STOP_PLAYING
	if(!CanUseTopic(music_player)) //can play with TK and while resting because fun.
		return STOP_PLAYING

/obj/structure/musician/attack_hand(mob/user)
	if(..() || !user.is_advanced_tool_user())
		return TRUE
	tgui_interact(user)

/obj/structure/musician/tgui_interact(mob/user)
	song.tgui_interact(user)

/obj/structure/musician/piano
	name = "space piano"
	desc = "This is a space piano, like a regular piano, but always in tune! Even if the musician isn't."
	icon = 'icons/obj/musician.dmi'
	icon_state = "piano"
	anchored = TRUE
	density = TRUE
	hitsound = 'sound/effects/piano_hit.ogg'

/obj/structure/musician/piano/unanchored
	anchored = FALSE

/obj/structure/musician/piano/minimoog
	name = "space minimoog"
	desc = "This is a minimoog, like a space piano, but more spacey!"
	icon_state = "minimoog"
