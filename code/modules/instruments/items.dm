GLOBAL_LIST_EMPTY(all_instruments_names)
GLOBAL_LIST_INIT(all_instrumets_radial, generate_list_of_instruments_for_radial_menu())

/proc/generate_list_of_instruments_for_radial_menu()
	. = list()
	for(var/obj/item/instrument/instrument as anything in subtypesof(/obj/item/instrument))
		.[initial(instrument.name)] = image(icon = initial(instrument.icon), icon_state = initial(instrument.icon_state))
		GLOB.all_instruments_names[initial(instrument.name)] = instrument

//copy pasta of the space piano, don't hurt me -Pete
/obj/item/instrument
	name = "generic instrument"
	force = 10
	max_health = 100
	icon = 'icons/obj/musician.dmi'
	/// Our song datum.
	var/datum/song/handheld/song
	/// Our allowed list of instrument ids. This is nulled on initialize.
	var/list/allowed_instrument_ids
	/// How far away our song datum can be heard.
	var/instrument_range = 15

/obj/item/instrument/Initialize(mapload)
	. = ..()
	song = new(src, allowed_instrument_ids, instrument_range)
	allowed_instrument_ids = null //We don't need this clogging memory after it's used.

/obj/item/instrument/Destroy()
	QDEL_NULL(song)
	return ..()

/obj/item/instrument/proc/should_stop_playing(atom/music_player)
	if(!ismob(music_player))
		return STOP_PLAYING
	var/mob/user = music_player
	if(user.incapacitated() || !((loc == user) || (isturf(loc) && Adjacent(user)))) // sorry, no more TK playing.
		return STOP_PLAYING

/obj/item/instrument/attack_self(mob/user)
	if(!user.is_advanced_tool_user())
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return TRUE
	interact(user)

/obj/item/instrument/interact(mob/user)
	ui_interact(user)

/obj/item/instrument/ui_interact(mob/living/user)
	if(!isliving(user) || user.stat != CONSCIOUS || !ispAI(user))
		return

	user.set_machine(src)
	song.ui_interact(user)

/obj/item/instrument/violin
	name = "space violin"
	desc = "A wooden musical instrument with four strings and a bow. \"The devil went down to space, he was looking for an assistant to grief.\""
	icon_state = "violin"
	item_state = "violin"
	hitsound = "swing_hit"
	allowed_instrument_ids = "violin"

/obj/item/instrument/violin/golden
	name = "golden violin"
	desc = "A golden musical instrument with four strings and a bow. \"The devil went down to space, he was looking for an assistant to grief.\""
	icon_state = "golden_violin"
	item_state = "golden_violin"

/obj/item/instrument/banjo
	name = "banjo"
	desc = "A 'Mura' brand banjo. It's pretty much just a drum with a neck and strings."
	icon_state = "banjo"
	item_state = "banjo"
	hitsound = 'sound/weapons/banjoslap.ogg'
	allowed_instrument_ids = "banjo"

/obj/item/instrument/guitar
	name = "guitar"
	desc = "It's made of wood and has bronze strings."
	icon_state = "guitar"
	item_state = "guitar"
	hitsound = 'sound/weapons/stringsmash.ogg'
	allowed_instrument_ids = list("guitar","csteelgt","cnylongt", "ccleangt", "cmutedgt")

/obj/item/instrument/eguitar
	name = "electric guitar"
	desc = "Makes all your shredding needs possible."
	icon_state = "eguitar"
	item_state = "eguitar"
	force = 12
	hitsound = 'sound/weapons/stringsmash.ogg'
	allowed_instrument_ids = "eguitar"

/obj/item/instrument/glockenspiel
	name = "glockenspiel"
	desc = "Smooth metal bars perfect for any marching band."
	icon_state = "glockenspiel"
	allowed_instrument_ids = list("glockenspiel","crvibr", "sgmmbox", "r3celeste")
	item_state = "glockenspiel"

/obj/item/instrument/accordion
	name = "accordion"
	desc = "Pun-Pun not included."
	icon_state = "accordion"
	allowed_instrument_ids = list("crack", "crtango", "accordion")
	item_state = "accordion"

/obj/item/instrument/trumpet
	name = "trumpet"
	desc = "To announce the arrival of the king!"
	icon_state = "trumpet"
	allowed_instrument_ids = "crtrumpet"
	item_state = "trumpet"

/obj/item/instrument/saxophone
	name = "saxophone"
	desc = "This soothing sound will be sure to leave your audience in tears."
	icon_state = "saxophone"
	allowed_instrument_ids = "saxophone"
	item_state = "saxophone"

/obj/item/instrument/trombone
	name = "trombone"
	desc = "How can any pool table ever hope to compete?"
	icon_state = "trombone"
	allowed_instrument_ids = list("crtrombone", "crbrass", "trombone")
	item_state = "trombone"

/obj/item/instrument/recorder
	name = "recorder"
	desc = "Just like in school, playing ability and all."
	force = 5
	icon_state = "recorder"
	allowed_instrument_ids = "recorder"
	item_state = "recorder"

/obj/item/instrument/harmonica
	name = "harmonica"
	desc = "For when you get a bad case of the space blues."
	icon_state = "harmonica"
	allowed_instrument_ids = list("crharmony", "harmonica")
	item_state = "harmonica"
	slot_flags = SLOT_MASK
	force = 5
	w_class = ITEM_SIZE_SMALL
	default_action_type = /datum/action/item_action/instrument

/obj/item/instrument/harmonica/proc/handle_speech(datum/source, list/speech_args)
	SIGNAL_HANDLER
	if(song.playing && ismob(loc))
		to_chat(loc, SPAN_WARNING("You stop playing the harmonica to talk..."))
		song.playing = FALSE

/obj/item/instrument/harmonica/equipped(mob/M, slot)
	. = ..()
	RegisterSignal(M, COMSIG_MOB_SAY, .proc/handle_speech)

/obj/item/instrument/harmonica/dropped(mob/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_SAY)

/datum/action/item_action/instrument
	name = "Use Instrument"

/datum/action/item_action/instrument/Trigger(trigger_flags)
	if(istype(target, /obj/item/instrument))
		var/obj/item/instrument/I = target
		I.interact(usr)
		return
	return ..()

/obj/item/instrument/bikehorn
	name = "gilded bike horn"
	desc = "An exquisitely decorated bike horn, capable of honking in a variety of notes."
	icon_state = "bike_horn"
	item_state = "bike_horn"
	allowed_instrument_ids = list("bikehorn", "honk")
	w_class = ITEM_SIZE_TINY
	force = 0
	throw_speed = 3
	throw_range = 15
	hitsound = 'sound/items/bikehorn.ogg'

/obj/structure/instrument_choice
	name = "instrument delivery beacon"
	desc = "Summon your tool of art."
	icon_state = "gangtool-red"
	anchored = TRUE
	opacity = FALSE
	density = TRUE

/obj/structure/instrument_choice/attack_hand(mob/user)
	if(..())
		return TRUE

	var/result = show_radial_menu(user, src, GLOB.all_instrumets_radial, custom_check = CALLBACK(src, .proc/check_menu, user), tooltips = TRUE)
	var/path = GLOB.all_instruments_names[result]
	if(path)
		qdel(src)
		var/obj/item/instrument/instrument = new path(get_turf(user))
		user.put_in_hands(instrument)

/**
 * Checks if we are allowed to interact with a radial menu
 *
 * Arguments:
 * * user The living mob interacting with the menu
 * * remote_anchor The remote anchor for the menu
 */
/obj/structure/instrument_choice/proc/check_menu(mob/living/user)
	if(!istype(user))
		return FALSE
	if(user.incapacitated())
		return FALSE
	if(QDELING(src))
		return FALSE
	return TRUE
