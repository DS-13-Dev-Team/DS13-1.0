/*

	Regenerate ability, used by Ubermorph

	Regrows one limb (with a cool animation) and heals some overall damage.
	The user can't move while its happening

*/
/datum/extension/regenerate
	name = "Regenerate"
	var/verb_name = "regenerating"
	expected_type = /mob/living/carbon/human
	flags = EXTENSION_FLAG_IMMEDIATE
	var/mob/living/carbon/human/user

	var/duration = 5 SECONDS
	var/max_organs = 1
	var/cooldown = 0
	var/heal_amount = 40
	var/tick_interval = 0.2 SECONDS
	var/shake_interval = 1 SECONDS

	//Runtime stuff
	var/list/regenerating_organs = list()
	var/tick_timer
	var/tick_step


/datum/extension/regenerate/New(var/datum/holder, var/_heal_amount, var/_duration, var/_max_organs, var/_cooldown)
	..()
	user = holder
	max_organs = _max_organs
	duration = _duration
	cooldown = _cooldown
	heal_amount = _heal_amount

	start()

//Lets regrow limbs
/datum/extension/regenerate/proc/start()
	tick_step = duration / tick_interval
	for(var/limb_type in user.species.has_limbs)
		if (max_organs <= 0)
			break
		var/obj/item/organ/external/E = user.organs_by_name[limb_type]
		if(E && !E.is_usable())
			E.removed()
			qdel(E)
			E = null
		if(!E)
			regenerating_organs |= limb_type
			max_organs--


	//Lets play the animations
	for(var/limb_type in regenerating_organs)
		user.species.regenerate_limb(user, limb_type, duration)

	user.shake_animation(30)
	user.Stun(Ceiling(duration/10), TRUE)

	//And lets start our timer
	tick_timer = addtimer(CALLBACK(src, .proc/tick), tick_interval, TIMER_STOPPABLE)

/datum/extension/regenerate/proc/tick()
	duration -= tick_interval
	shake_interval -= tick_interval
	user.heal_overall_damage(heal_amount * tick_step)
	if (shake_interval <= 0)
		shake_interval = initial(shake_interval)
		user.shake_animation(30)

	if (duration > 0) //Queue next tick
		tick_timer = addtimer(CALLBACK(src, .proc/tick), tick_interval, TIMER_STOPPABLE)
	else
		finish()


/datum/extension/regenerate/proc/finish()
	//Lets finish up. The limb regrowing animations should be done by now
	for(var/limb_type in regenerating_organs)
		var/list/organ_data = user.species.has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/O = new limb_path(user)
		organ_data["descriptor"] = O.name
		user << "<span class='notice'>You feel a slithering sensation as your [O.name] reforms.</span>"
	user.update_body()
	stop()

/datum/extension/regenerate/proc/stop()
	user.stunned = 0

	//When we finish, we go on cooldown
	if (cooldown && cooldown > 0)
		addtimer(CALLBACK(src, .proc/finish_cooldown), cooldown)
	else
		finish_cooldown() //If there's no cooldown timer call it now


/datum/extension/regenerate/proc/finish_cooldown()
	remove_extension(holder, /datum/extension/regenerate)


/mob/living/carbon/human/proc/regenerate_verb()
	set name = "Regenerate"
	set category = "Abilities"


	return regenerate_ability(heal_amount = 40, _duration = 4 SECONDS, _max_organs = 1, _cooldown = 0)


/mob/living/carbon/human/proc/can_regenerate(var/error_messages = TRUE)
	//Check for an existing extension.
	var/datum/extension/regenerate/EC = get_extension(src, /datum/extension/regenerate)
	if(istype(EC))
		if(error_messages) to_chat(src, "You're already [EC.verb_name]!")
		return FALSE
	return TRUE


/mob/living/carbon/human/proc/regenerate_ability(var/_heal_amount, var/_duration, var/_max_organs, var/_cooldown)

	if (!can_regenerate(TRUE))
		return FALSE


	//Ok we've passed all safety checks, let's commence charging!
	//We simply create the extension on the movable atom, and everything works from there
	set_extension(src, /datum/extension/regenerate, /datum/extension/regenerate, _heal_amount, _duration, _max_organs, _cooldown)

	return TRUE