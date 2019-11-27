/**
*
* Psychosis
* @author Kmc2000
* @version 11/11/2019
* A series of procs which model insanity. You will heal insanity damage slowly over time, but if youre exposed to traumatic events then expect to get a bit unhinged. Finally, the effects are capped on a cooldown, so that necros don't permanently debilitate you. This is meant to be a slippery slope, not a cliff you jump off of.
*
* Important methods:
* adjustPsychosisLoss(amount) - Use this to deal psychosis damage to a target.
*
*
*/


// Psychosis side effects:
// ========


/datum/medical_effect/irrational_laughter
	name = "Irrational laughter"
	triggers = list() //Triggered only by psychosis
	cures = list(/datum/reagent/synaptizine) //Cured with brain meds
	cure_message = "Life doesn't seem quite as absurd as it used to."

/datum/medical_effect/irrational_laughter/on_life(mob/living/carbon/human/H, strength)
	var/obj/item/organ/external/head/head = H.get_organ("head")
	if(istype(head))
		switch(strength)
			if(1 to 10)
				H.custom_pain("You suddenly feel an urge to laugh.",0, affecting = LOWER_TORSO)
			if(11 to 30)
				H.custom_pain("You burst out laughing!",1, affecting = LOWER_TORSO)
			if(31 to INFINITY)
				H.custom_pain("You burst out into an uncontrollable fit of laughter!",1, affecting = LOWER_TORSO)

/datum/medical_effect/irrational_laughter/manifest(mob/living/carbon/human/H) //Override to move away from a reagent based trigger to an event based one.
	for(var/R in cures) //If they have a cure inside of them, fail to manifest.
		if(!H.reagents || H.reagents.has_reagent(R))
			return FALSE
	return TRUE

// =======

/**
*
*
* A proc which handles fluff FX for people going mad.
* @Param stage : How severe the psychosis is. This is a scaling value based on the mob's current psychosis damage (which is increased via witnessing traumatic events, or being touched by necros).
*
*/

/mob/living/carbon/human/proc/set_psychosis(var/stage, var/override)
	if(!can_set_psychosis && !override) //Avoids patients being permanently debilitated by psychosis such that they can't move. EG: if youre on 0 sanity, you have a small window to get help before the effects manifest again.
		return
	switch(stage)
		if(1)
			add_side_effect("Irrational laughter")
		if(2)
			adjust_hallucination(10,10)
			to_chat(src, "<span class='warning'>You feel unhinged.</span>")
		if(3 to INFINITY)
			adjust_hallucination(20,20)
			to_chat(src, "<span class='warning'>You can see the walls dividing reality fall apart at your feet...</span>")
	can_set_psychosis = FALSE
	addtimer(CALLBACK(src, .proc/allow_psychosis), 10 SECONDS) ///This cooldown should be balanced around how debilitating psychosis damage actually turns out to be.

/mob/living/carbon/human/proc/allow_psychosis()
	can_set_psychosis = TRUE
	to_chat(src, "<span class='warning'>You feel like something's watching you,  creeping into your mind even...</span>") //Give them a warning to know they need to avoid traumae again.

/mob/living/carbon/human/proc/allow_psychosis_message()
	sanity_cooldown = FALSE


/**
*
*
* A series of procs to handle psychosis damage on mobs.
*
*/

/mob/living/carbon/human
	var/sanity = 100 //Flat value to represent how ""sane"" someone is. Losing sanity is not recommended.
	var/maxSanity = 100
	var/last_sanity = 100
	var/can_set_psychosis = TRUE //This variable means that mobs can't instant descend into total insanity just by getting sneezed on by a necromorph.
	var/psychosis_immune = FALSE //SET THIS TO TRUE FOR NECROMORPHS IF YOU MAKE THEM A HUMAN SUBTYPE, OR THEY WILL GO INSANE FROM MARKER STUFF
	var/sanity_cooldown = FALSE

/mob/living/carbon/human/Life()
	. = ..() //Override here to allow mobs to slowly heal from psychosis damage...SLOWLY.
	if(sanity < 100)
		adjustPsychosisLoss(-0.25) //From 0 sanity to 100 on this alone will take about 10 minutes. While you can't drug the symptoms away, you can remove the hallucinations with Synaptizine.

/mob/living/carbon/human/proc/getPsychosisLoss()
	return sanity

/mob/living/carbon/human/proc/adjustPsychosisLoss(var/amount)
	if (status_flags & GODMODE || psychosis_immune)
		return FALSE
	if(stat != CONSCIOUS) //Let's be realistic here.
		return FALSE
	sanity = Clamp(sanity - amount, 0, maxSanity)
	if(sanity < last_sanity) //If they're on the mend, there's no need to give them the effects of a psychotic episode. This prevents their healing from psychosis damage from actually harming them with hallucinations.
		switch(last_sanity)
			if(0 to 29) //You will get fucked up at this point.
				set_psychosis(3)
			if(30 to 59) //You're definitely not feeling OK.
				set_psychosis(2)
			if(60 to 80) //Feeling slightly off
				set_psychosis(1)
	else if(sanity >= 90) //You're back to normal, and the bad times have worn off.
		set_psychosis(0)
	last_sanity = sanity
	return TRUE

/mob/living/carbon/human/proc/setPsychosisLoss(var/amount)
	adjustPsychosisLoss((amount * 0.5)-getPsychosisLoss())

//Ghetto components until we get them here. This does the job, but isn't the most efficient solution.//


/**
*
*
*
* Trauma pseudo-components. These attach to an object and will process VERY slowly, applying psychosis damage to anyone who's unlucky enough to see them. This does mean you can
* blindfold yourself to avoid going insane.
*
*
*
*
*/

/atom/proc/set_traumatic_sight(var/isTrauma)
	if(isTrauma)
		SStrauma.try_add_trauma(src)
	else
		SStrauma.try_remove_trauma(src)

/datum/component //Placeholder for when we get components.

#define TRAUMA_POWER_WEAK 1.50
#define TRAUMA_POWER_MEDIUM 3
#define TRAUMA_POWER_STRONG 5

/datum/component/traumatic_sight
	var/name = "Traumatic sight handler"
	var/atom/source = null
	var/trauma_power = 1.50 //How traumatic is this sight? Dealt to them per traumatic object, per 10 seconds. A room full of necros would seriously fuck you up. A "STRONG" trauma would have a value of 5, and would give you just over a minute to cover your eyes before it started to affect you. Better bring that blindfold with you!

/datum/component/traumatic_sight/New()
	. = ..()
	START_PROCESSING(SStrauma, src)

/datum/component/traumatic_sight/Process() //This isn't terribly efficient, but it's also not the worst performance wise.
	for(var/mob/living/carbon/human/H in viewers(source, null))
		H.adjustPsychosisLoss(trauma_power)
		if(H.sanity_cooldown)
			return
		H.sanity_cooldown = TRUE
		switch(trauma_power)
			if(0 to TRAUMA_POWER_WEAK)
				to_chat(H, "<span class='warning'>The sight of [source] makes you a little uneasy...</span>")
			if(TRAUMA_POWER_WEAK+0.1 to TRAUMA_POWER_MEDIUM)
				to_chat(H, "<span class='warning'>The sight of [source] sends chills down your spine...</span>")
			if(TRAUMA_POWER_MEDIUM+0.1 to TRAUMA_POWER_STRONG)
				to_chat(H, "<span class='userdanger'>The mere sight of [source] makes you want to run away and hide!</span>")
			if(TRAUMA_POWER_STRONG+0.1 to INFINITY)
				to_chat(H, "<span class='userdanger'>You can feel [source] inside your head... RUN!.</span>")
		addtimer(CALLBACK(H, /mob/living/carbon/human/proc/allow_psychosis_message), 30 SECONDS)