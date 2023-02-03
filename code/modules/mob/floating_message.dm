/// How long the chat message's spawn-in animation will occur for
#define CHAT_MESSAGE_SPAWN_TIME 3
/// How long a "Bump" animations takes
#define CHAT_MESSAGE_BUMP_TIME 4
/// How long the chat message will exist.
#define CHAT_MESSAGE_LIFESPAN 50
/// How long the chat message's end of life fading animation will occur for
#define CHAT_MESSAGE_EOL_FADE 2
/// Factor of how much the message index (number of messages) will account to exponential decay
#define CHAT_MESSAGE_EXP_DECAY 0.7
/// Factor of how much height will account to exponential decay
#define CHAT_MESSAGE_HEIGHT_DECAY 0.9
/// Approximate height in pixels of an 'average' line, used for height decay
#define CHAT_MESSAGE_APPROX_LHEIGHT 11
/// Max width of chat message in pixels
#define CHAT_MESSAGE_WIDTH 96
/// Max length of chat message in characters
#define CHAT_MESSAGE_MAX_LENGTH 110
/// The dimensions of the chat message icons
#define CHAT_MESSAGE_ICON_SIZE 9

///Base layer of chat elements
#define CHAT_LAYER 1
///Highest possible layer of chat elements
#define CHAT_LAYER_MAX 2
/// Maximum precision of float before rounding errors occur (in this context)
#define CHAT_LAYER_Z_STEP 0.0001
/// The number of z-layer 'slices' usable by the chat message layering
#define CHAT_LAYER_MAX_Z (CHAT_LAYER_MAX - CHAT_LAYER) / CHAT_LAYER_Z_STEP

GLOBAL_LIST_EMPTY(floating_chat_colors)

/client
	/// Messages currently seen by this client
	var/list/seen_messages
/*
/atom/movable/proc/animate_chat(message, datum/language/language, small, list/show_to, duration)
	set waitfor = FALSE

	var/style	//additional style params for the message
	var/fontsize = 6
	if(small)
		fontsize = 5
	var/limit = 50
	if(copytext(message, length(message) - 1) == "!!")
		fontsize = 8
		limit = 30
		style += "font-weight: bold;"


	if(!GLOB.floating_chat_colors[name])
		GLOB.floating_chat_colors[name] = get_random_colour(0,160,230)
	style += "color: [GLOB.floating_chat_colors[name]];"

	// create 2 messages, one that appears if you know the language, and one that appears when you don't know the language
	var/image/understood = generate_floating_text(src, capitalize(message), style, fontsize, duration, show_to)
	var/image/gibberish = language ? generate_floating_text(src, language.scramble(message), style, fontsize, duration, show_to) : understood

	for(var/client/C in show_to)
		if(C.get_preference_value(/datum/client_preference/floating_messages) == GLOB.PREF_SHOW)
			if(C.mob.say_understands(null, language))
				C.images += understood
			else
				C.images += gibberish
*/
/proc/create_chat_message(mob/owner, atom/speaker, datum/language/speaker_lang, message)
	set waitfor = FALSE

	new /datum/chatmessage(owner, speaker, speaker_lang, message)

/datum/chatmessage
	/// The visual element of the chat messsage
	var/image/message
	/// The location in which the message is appearing
	var/atom/message_loc
	/// The client who heard this message
	var/client/owned_by
	/// Contains the scheduled destruction time, used for scheduling EOL
	var/scheduled_destruction
	/// Contains the time that the EOL for the message will be complete, used for qdel scheduling
	var/eol_complete
	/// Contains the approximate amount of lines for height decay
	var/approx_lines
	/// The current index used for adjusting the layer of each sequential chat message such that recent messages will overlay older ones
	var/static/current_z_idx = 0

/datum/chatmessage/New(mob/owner, atom/target, datum/language/language, text, small)
	. = ..()
	if (!istype(target))
		CRASH("Invalid target given for chatmessage")
	if(QDELETED(owner) || !istype(owner) || !owner.client)
		crash_with("/datum/chatmessage created with [isnull(owner) ? "null" : "invalid"] mob owner")
		qdel(src)
		return
	INVOKE_ASYNC(src, .proc/generate_image, text, target, owner, language, small)

/datum/chatmessage/Destroy()
	if (owned_by)
		if (owned_by.seen_messages)
			LAZYREMOVEASSOC(owned_by.seen_messages, message_loc, src)
		owned_by.images.Remove(message)
	owned_by = null
	message_loc = null
	message = null
	return ..()

/datum/chatmessage/proc/generate_image(text, atom/target, mob/owner, datum/language/language, small)
	owned_by = owner.client
	RegisterSignal(owned_by, COMSIG_PARENT_QDELETING, .proc/on_parent_del)

	if(ismob(target) && !owner.say_understands(target, language))
		text = language.scramble(text)

	if (length_char(text) > CHAT_MESSAGE_MAX_LENGTH)
		text = copytext_char(text, 1, CHAT_MESSAGE_MAX_LENGTH + 1) + "..." // BYOND index moment

	var/list/extra_classes = list()
	if(small)
		extra_classes += "small"

	if(copytext(message, length(message) - 1) == "!!")
		extra_classes += "bold"

	if(!GLOB.floating_chat_colors[target.name])
		GLOB.floating_chat_colors[target.name] = colorize_string(target.name)

	var/color = GLOB.floating_chat_colors[target.name]

	// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	text = replacetext(text, url_scheme, "")

	// Reject whitespace
	var/static/regex/whitespace = new(@"^\s*$")
	if (whitespace.Find(text))
		qdel(src)
		return


	// Approximate text height
	var/complete_text = "<span class='center [extra_classes.Join(" ")]' style='color: [color]'>[text]</span>"
	var/mheight = WXH_TO_HEIGHT(owned_by.MeasureText(complete_text, null, 160))

	message_loc = isturf(target) ? target : get_atom_on_turf(target)

	// Build message image
	message = new /image{
		plane = RUNECHAT_PLANE;
		appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART;
		alpha = 0;
		maptext_width = 160;
		maptext_height = 48;
		maptext_x = -64;
		maptext_y = 28
	}

	message.layer = CHAT_LAYER + CHAT_LAYER_Z_STEP * current_z_idx++
	message.maptext = MAPTEXT(complete_text)

	animate(message, maptext_y = 28, time = 0.01)

	//var/mheight = (1 + round(length(message.maptext_width) / 32))
	approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)

	// Translate any existing messages upwards, apply exponential decay factors to timers
	if (owned_by.seen_messages)
		var/datum/chatmessage/old_message = owned_by.seen_messages?[message_loc]?[length(owned_by.seen_messages?[message_loc])]
		if(old_message?.message.maptext == message.maptext)
			old_message.message.transform *= 1.1
			return

		for(var/datum/chatmessage/m as anything in owned_by.seen_messages[message_loc])
			animate(m.message, maptext_y = m.message.maptext_y + mheight, time = CHAT_MESSAGE_BUMP_TIME)

		//if(ismob(message_loc)) // If this proc starts getting $$$, re-add this check
		var/turf/message_turf = get_turf(message_loc)
		var/list/turfs2check = block(locate(max(message_turf.x-4, 1), message_turf.y, message_turf.z), locate(min(message_turf.x+4, world.maxx), message_turf.y, message_turf.z)) - message_turf
		for(var/turf/T as anything in turfs2check)
			var/mob/living/L = locate() in T
			if(!isnull(L))
				for(var/datum/chatmessage/m as anything in owned_by.seen_messages[L])
					animate(m.message, maptext_y = m.message.maptext_y + mheight, time = CHAT_MESSAGE_BUMP_TIME)

	// Reset z index if relevant
	if (current_z_idx >= CHAT_LAYER_MAX_Z)
		current_z_idx = 0

	// View the message
	LAZYADDASSOCLIST(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message

	message.loc = message_loc
	animate(message, alpha = 255, maptext_y = 34, time = CHAT_MESSAGE_SPAWN_TIME, ANIMATION_END_NOW)

	var/duration = CHAT_MESSAGE_LIFESPAN - CHAT_MESSAGE_EOL_FADE
	fade_out(duration)

/datum/chatmessage/proc/fade_out(timer, fade_len = CHAT_MESSAGE_EOL_FADE)
	set waitfor = FALSE
	sleep(timer)
	animate(message, alpha = 0, maptext_y = message.maptext_y + (8 * (1 + round(length(message.maptext_width) / 32))), time = fade_len)
	sleep(fade_len)
	qdel(src)

/datum/chatmessage/proc/on_parent_del()
	SIGNAL_HANDLER
	qdel(src)

// Tweak these defines to change the available color ranges
#define CM_COLOR_SAT_MIN 0.6
#define CM_COLOR_SAT_MAX 0.7
#define CM_COLOR_LUM_MIN 0.65
#define CM_COLOR_LUM_MAX 0.75

/**
 * Gets a color for a name, will return the same color for a given string consistently within a round.atom
 *
 * Note that this proc aims to produce pastel-ish colors using the HSL colorspace. These seem to be favorable for displaying on the map.
 *
 * Arguments:
 * * name - The name to generate a color for
 * * sat_shift - A value between 0 and 1 that will be multiplied against the saturation
 * * lum_shift - A value between 0 and 1 that will be multiplied against the luminescence
 */
/datum/chatmessage/proc/colorize_string(name, sat_shift = 1, lum_shift = 1)
	// seed to help randomness
	var/static/rseed = rand(1,26)

	// get hsl using the selected 6 characters of the md5 hash
	var/hash = copytext(md5(name + GLOB.round_id), rseed, rseed + 6)
	var/h = hex2num(copytext(hash, 1, 3)) * (360 / 255)
	var/s = (hex2num(copytext(hash, 3, 5)) >> 2) * ((CM_COLOR_SAT_MAX - CM_COLOR_SAT_MIN) / 63) + CM_COLOR_SAT_MIN
	var/l = (hex2num(copytext(hash, 5, 7)) >> 2) * ((CM_COLOR_LUM_MAX - CM_COLOR_LUM_MIN) / 63) + CM_COLOR_LUM_MIN

	// adjust for shifts
	s *= clamp(sat_shift, 0, 1)
	l *= clamp(lum_shift, 0, 1)

	// convert to rgb
	var/h_int = round(h/60) // mapping each section of H to 60 degree sections
	var/c = (1 - abs(2 * l - 1)) * s
	var/x = c * (1 - abs((h / 60) % 2 - 1))
	var/m = l - c * 0.5
	x = (x + m) * 255
	c = (c + m) * 255
	m *= 255
	switch(h_int)
		if(0)
			return "#[num2hex(c, 2)][num2hex(x, 2)][num2hex(m, 2)]"
		if(1)
			return "#[num2hex(x, 2)][num2hex(c, 2)][num2hex(m, 2)]"
		if(2)
			return "#[num2hex(m, 2)][num2hex(c, 2)][num2hex(x, 2)]"
		if(3)
			return "#[num2hex(m, 2)][num2hex(x, 2)][num2hex(c, 2)]"
		if(4)
			return "#[num2hex(x, 2)][num2hex(m, 2)][num2hex(c, 2)]"
		if(5)
			return "#[num2hex(c, 2)][num2hex(m, 2)][num2hex(x, 2)]"