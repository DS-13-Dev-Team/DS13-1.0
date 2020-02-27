#define PSYCHOSIS_EFFECT_LAUGHTER 1
#define PSYCHOSIS_EFFECT_HITSELF 2
#define PSYCHOSIS_EFFECT_TRIPPY 3
#define PSYCHOSIS_EFFECT_WEIRDSCREEN 4

/datum/extension/psychosis
	name = "Psychotic trauma"
	expected_type = /mob/living/carbon/human
	flags = EXTENSION_FLAG_IMMEDIATE
	var/mob/living/carbon/human/user
	var/duration = 10 SECONDS
	var/intensity = 1 //Field to represent the maximum level of trauma that a mob can receive.
	var/max_intensity = PSYCHOSIS_EFFECT_WEIRDSCREEN //Update this as you code more psychosis effects. Used by the random number generator.
	var/countdown
	var/psychosis_timer

/datum/extension/psychosis/New(var/datum/holder, var/_duration, var/_intensity)
	. = ..()
	duration = _duration SECONDS
	intensity = (_intensity <= max_intensity) ? _intensity : max_intensity //Strip off over-intensities that may break things.
	user = holder
	start_psychosis()

/**

Method to begin psychosis effects, and start the countdown timer

*/

/datum/extension/psychosis/proc/start_psychosis()
	if(countdown)
		deltimer(countdown)
	to_chat(user, SPAN_WARNING("You start to feel a little bit unhinged..."))
	countdown = addtimer(CALLBACK(src, /datum/extension/psychosis/proc/finish), duration, TIMER_STOPPABLE) //Countdown to release them from their psychosis.
	apply_psychosis_effects()

/**

Method to cripple the victim with insanity effects. Calls recursively via timers until finishing.

*/

/datum/extension/psychosis/proc/apply_psychosis_effects()
	var/effect = rand(PSYCHOSIS_EFFECT_LAUGHTER, intensity) //Update this as required. Only coded in a few as of now
	switch(effect)
		if(PSYCHOSIS_EFFECT_LAUGHTER)
			var/obj/item/organ/external/head/head = user.get_organ("head")
			if(!istype(head) || !head)
				return
			switch(intensity)
				if(1)
					user.custom_pain("You suddenly feel an urge to laugh.",0, affecting = LOWER_TORSO)
				if(2)
					user.custom_pain("You burst out laughing!",1, affecting = LOWER_TORSO)
				if(3 to max_intensity)
					user.custom_pain("You burst out into an uncontrollable fit of laughter!",1, affecting = LOWER_TORSO)
					user.emote("laugh")
		if(PSYCHOSIS_EFFECT_HITSELF)
			playsound(user.loc, 'sound/weapons/thudswoosh.ogg', 100, 1)
			user.visible_message("<span class='warning'><b>[user]</b> slaps themselves!</span>","<span class='warning'>You slap yourself!</span>")
			user.custom_pain("Your face stings",2, affecting = HEAD)
		if(PSYCHOSIS_EFFECT_TRIPPY)
			user.visible_message("<span class='warning'><b>[user]</b> looks around wildly!</span>","<span class='warning'>You feel your eyes darting around to faraway places...</span>")
			user.adjust_hallucination(20,20)
		if(PSYCHOSIS_EFFECT_WEIRDSCREEN)
			user.overlay_fullscreen("insane", /obj/screen/fullscreen/insane)
	psychosis_timer = addtimer(CALLBACK(src, /datum/extension/psychosis/proc/apply_psychosis_effects), rand(0, duration/2), TIMER_STOPPABLE) //Call recursively. Delay from 0 seconds to half the duration, so that theyre always guaranteed to get one psychosis effect.

/**

Method to finish up the psychosis effects, clear any screen effects we put on them, and stop the timer for new psychosis effects.

*/

/datum/extension/psychosis/proc/finish()
	to_chat(user, SPAN_NOTICE("You start to feel a little bit less panicked"))
	remove_extension(holder, /datum/extension/psychosis)
	user.clear_fullscreen("insane")
	if(psychosis_timer)
		deltimer(psychosis_timer) //Stops the timer calling on a null object (src)

/datum/extension/psychosis/Destroy()
	.=..()

/obj/screen/fullscreen/insane
	icon_state = "insane"
	layer = DAMAGE_LAYER
	alpha = 180

/**

Method to apply the psychosis extension to a mob. Should be called by necromorphs attacking or some such behaviour.
@param intensity -> the intensity of the psychosis effect. This can stack.
@param duration -> the duration (seconds) of the psychosis effect.

*/

/mob/living/carbon/human/proc/apply_psychosis(intensity, duration)
	duration = duration SECONDS //Convert deciseconds to seconds automagically.
	var/datum/extension/psychosis/psy = get_extension(src, /datum/extension/psychosis)
	if(psy)//No need to add multiple psychosis components. Let's just intensify the existing one.
		duration += psy.duration
		intensity += psy.intensity
		psy.start_psychosis() //Restart the psychosis effects, or else we'd have cases where it'd just fizzle out.
		return
	set_extension(src, /datum/extension/psychosis, duration, intensity)