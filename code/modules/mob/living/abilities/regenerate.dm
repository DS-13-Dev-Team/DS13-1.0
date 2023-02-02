/*

	Regenerate ability, used by Ubermorph

	Regrows one limb (with a cool animation), regrows all internal organs, and heals some overall damage.
	The user can't move while its happening

*/
/datum/extension/regenerate
	name = "Regenerate"
	var/verb_name = "regenerating"
	expected_type = /mob/living/carbon/human
	base_type = null
	flags = EXTENSION_FLAG_IMMEDIATE
	var/mob/living/carbon/human/user

	var/duration = 5 SECONDS
	var/max_limbs = 1
	var/cooldown = 0
	var/heal_amount = 40

	var/tick_interval = 0.2 SECONDS
	var/shake_interval = 0.5 SECONDS

	var/lasting_damage_heal = 999999
	var/limb_lasting_damage = 0	//When a limb is replaced, the mob suffers lasting damage equal to the limb's health * this value
	var/biomass_limb_cost = 0	//When a limb is replaced, the marker transfers biomass to the mob, equal to the limb's health * this value
	var/biomass_lasting_damage_cost = 0	//When lasting_damage is healed, the marker transfers biomass to the mob, equal to the damage healed * this value
	var/burn_heal_mult = 1	//When healing burn damage, each point of heal_amount can heal this many points of actual burn damage

	var/finish_time

	//Runtime stuff
	var/list/regenerating_organs = list()
	var/tick_timer
	var/tick_step

	var/started_at
	var/stopped_at

	var/ongoing_timer

	var/ubermorph = FALSE


/datum/extension/regenerate/New(var/datum/holder, var/duration, var/cooldown)
	..()
	user = holder
	if (duration)
		src.duration = duration
	if (cooldown)
		src.cooldown = cooldown

	start()

//Lets regrow limbs
/datum/extension/regenerate/proc/start()
	finish_time = world.time + duration
	tick_step = 1  / (duration / tick_interval)
	var/list/missing_limbs = list()

	//This loop counts and documents the damaged limbs, for the purpose of regrowing them and also for documenting how many there are for stun time
	for(var/limb_tag in user.species.has_limbs)

		//Certain limbs cannot be regrown once lost. Lets check if this is one of those
		var/organ_data = user.species.has_limbs[limb_tag]
		var/typepath = organ_data["path"]
		var/obj/item/organ/external/abstract_E = typepath
		if (initial(abstract_E.can_regrow) == FALSE)
			continue

		var/obj/item/organ/external/E = user.organs_by_name[limb_tag]

		if (E && E.is_usable() && !E.is_stump())
			//This organ is fine, skip it
			continue
		else if (!E || E.limb_flags & ORGAN_FLAG_CAN_AMPUTATE)
			missing_limbs |= limb_tag

		if (max_limbs <= 0)
			continue
		if(E)
			if (!(E.limb_flags & ORGAN_FLAG_CAN_AMPUTATE))
				continue	//We can't regrow something which can never be removed in the first place
			if (!E.is_usable() || E.is_stump())
				E.removed()
				qdel(E)
				E = null
		if(!E)
			regenerating_organs |= limb_tag
			max_limbs--



	//Special effect:
	//If the user is missing two or more limbs, rplays a special sound
	if (missing_limbs.len >= 2)
		user.play_species_audio(user, SOUND_REGEN, VOLUME_MID, 1)

	duration *= (1 + (missing_limbs.len * 0.25))	//more limbs lost, the longer it takes

	//Lets play the animations
	for(var/limb_type in regenerating_organs)
		user.species.regenerate_limb(user, limb_type, duration)

	user.shake_animation(30)
	user.Stun(Ceiling(duration/10), TRUE)
	user.Weaken(Ceiling(duration/10))

	//And lets start our timer
	tick_timer = addtimer(CALLBACK(src, .proc/tick), tick_interval, TIMER_STOPPABLE)

/datum/extension/regenerate/proc/tick()
	shake_interval -= tick_interval
	var/remaining_heal = user.heal_overall_damage(heal_amount * tick_step, BRUTE)
	if (remaining_heal)
		user.heal_overall_damage(heal_amount * tick_step * burn_heal_mult, BURN)
	if (shake_interval <= 0)
		shake_interval = initial(shake_interval)
		user.shake_animation(30)

	if (world.time < finish_time) //Queue next tick
		tick_timer = addtimer(CALLBACK(src, .proc/tick), tick_interval, TIMER_STOPPABLE)
	else
		finish()


/datum/extension/regenerate/proc/finish()
	var/obj/machinery/marker/M = get_marker()
	//Lets finish up. The limb regrowing animations should be done by now
	//Here we actually create the freshly grown limb
	for(var/limb_type in regenerating_organs)
		var/list/organ_data = user.species.has_limbs[limb_type]
		var/limb_path = organ_data["path"]
		var/obj/item/organ/O = new limb_path(user)
		O.max_damage *= user.species.limb_health_factor //TODO future: Factor this into organ creation?
		organ_data["descriptor"] = O.name

		if (limb_lasting_damage)
			user.adjustLastingDamage(O.max_damage*limb_lasting_damage)

		if (biomass_limb_cost)
			var/biomass_delta = O.max_damage*biomass_limb_cost
			if (biomass_delta)
				to_chat(user, "Regenerating [O] at a cost of [biomass_delta] kg biomass")

			if (M)
				if (M.playermob && biomass_delta)
					to_chat(M.playermob, "Regenerating [O] at a cost of [biomass_delta] kg biomass")
				M.pay_biomass("Limb Regrowth", biomass_delta, allow_negative = TRUE)
				user.adjust_biomass(biomass_delta)

	if (lasting_damage_heal)
		var/lasting_heal = min(lasting_damage_heal, user.getLastingDamage())
		user.adjustLastingDamage(lasting_heal*-1)
		if (biomass_lasting_damage_cost)
			if (M)
				var/lasting = user.getLastingDamage()
				var/biomass_delta = lasting*biomass_lasting_damage_cost
				if (biomass_delta)
					to_chat(user, "Regenerating [lasting] lasting damage at a cost of [biomass_delta] kg biomass")

				if (M.playermob && biomass_delta)
					to_chat(M.playermob, "Regenerating [lasting] lasting damage at a cost of [biomass_delta] kg biomass")

				M.pay_biomass("Necrotic Reconstruction", biomass_delta, allow_negative = TRUE)
				user.adjust_biomass(biomass_delta)



	//Once we're done regenerating limbs, lets also immediately regenerate all internal organs.
	//We're not gonna force these to be done one by one because there's nothing interesting to look at as it happens.
	for(var/organ_tag in user.species.has_organ)

		var/obj/item/organ/internal/I = user.internal_organs_by_name[organ_tag]
		if(I && I.is_usable())
			//The organ is there, skip it
			continue

		if (!I)
			//The organ isn't there, lets figure out first if we can add it
			var/obj/item/organ/external/E = user.organs_by_name[GLOB.organ_parents[organ_tag]]	//We attempt to retrieve the parent organ it should be inside
			if (!istype(E))
				//Parent organ isn't there, we can't do anything. Try next time once you grow your head back!
				continue

		if (I)
			I.removed()
			qdel(I)
			I = null

		//Once we get here, the specified internal organ doesn't exist, and we are clear to add it
		if(!I)
			var/organ_type = user.species.has_organ[organ_tag]
			var/obj/item/organ/O = new organ_type(user)
			user.internal_organs_by_name[organ_tag] = O

	//Lastly, lets get rid of any shrapnel and harmful objects in the user's body
	user.expel_shrapnel(0)	//Value of zero allows an infinite quantity

	user.update_body()
	stop()

/datum/extension/regenerate/proc/stop()
	stopped_at = world.time
	user.stunned = 0
	user.weakened = 0

	if (ubermorph && !has_extension(user, /datum/extension/regenerate_afterbuff))
		set_extension(user, /datum/extension/regenerate_afterbuff)

	//When we finish, we go on cooldown
	if (cooldown && cooldown > 0)
		addtimer(CALLBACK(src, .proc/finish_cooldown), cooldown)
	else
		finish_cooldown() //If there's no cooldown timer call it now

/datum/extension/regenerate/proc/finish_cooldown()
	remove_self()


/datum/extension/regenerate/proc/get_cooldown_time()
	var/elapsed = world.time - stopped_at
	return cooldown - elapsed



/mob/living/carbon/human/proc/regenerate_verb()
	set name = "Regenerate"
	set category = "Abilities"


	return regenerate_ability(subtype = /datum/extension/regenerate, _duration = 4 SECONDS, _cooldown = 0)


/mob/living/carbon/human/proc/can_regenerate(var/error_messages = TRUE, var/subtype = /datum/extension/regenerate)
	//Check for an existing extension.

	var/datum/extension/regenerate/E = get_extension(src,subtype)
	if(istype(E))
		if (error_messages)
			if (E.stopped_at)
				to_chat(src, SPAN_NOTICE("[E.name] is cooling down. You can use it again in [E.get_cooldown_time() /10] seconds"))
			else
				to_chat(src, SPAN_NOTICE("You're already regenerating"))
		return FALSE

	return TRUE


/mob/living/carbon/human/proc/regenerate_ability(var/subtype = /datum/extension/regenerate, var/_duration, var/_cooldown)

	if (!can_regenerate(TRUE, subtype))
		return FALSE


	//Ok we've passed all safety checks, let's commence charging!
	//We simply create the extension on the movable atom, and everything works from there
	set_extension(src, subtype, _duration, _cooldown)

	return TRUE

// Buffs a necromorph after regenerating
/datum/extension/regenerate_afterbuff

	var/duration = 8 SECONDS
	var/started_at
	var/stopped_at

	var/ongoing_timer

	expected_type = /mob/living/carbon/human
	base_type = null
	flags = EXTENSION_FLAG_IMMEDIATE
	var/mob/living/carbon/human/user

	statmods = list(
	STATMOD_ATTACK_SPEED = 1.1,
	STATMOD_MOVESPEED_MULTIPLICATIVE = 1.4,
	STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE = 0.6,)

	var/dm_filter/outline

/datum/extension/regenerate_afterbuff/New(var/datum/holder, var/duration)
	..()
	user = holder
	if (duration)
		src.duration = duration

	INVOKE_ASYNC(src, .proc/start)

/datum/extension/regenerate_afterbuff/proc/start()
	started_at	=	world.time
	user.Weaken(0.2) // sluggish to get going again, disinsentivises spamming

	if (!outline)
		var/newfilter = filter(type="outline", size = 1, color = rgb(255,0,0,128))
		user.filters.Add(newfilter)
		outline = user.filters[user.filters.len]

	ongoing_timer = addtimer(CALLBACK(src, /datum/extension/taunt/proc/stop), duration, TIMER_STOPPABLE)

/datum/extension/regenerate_afterbuff/proc/stop()
	deltimer(ongoing_timer)
	stopped_at = world.time
	if (outline)
		user.filters.Remove(outline)
		outline = null

	remove_self()