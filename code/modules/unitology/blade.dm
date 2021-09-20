/*
	The ritual blade is a reskinned knife that has the same damage, but a few special properties
*/
/obj/item/weapon/material/knife/unitologist
	name = "unitology ritual blade"
	desc = "A clean, pristine blade used for spiritual and religious purposes"
	icon = 'icons/obj/unitology32.dmi'
	icon_state = "unitology_ritual_blade"
	item_state = "unitology_ritual_blade"
	applies_material_colour = 0
	unbreakable = 1
	wielded_verbs = list(/mob/living/carbon/human/proc/sacrifice_verb)


/obj/item/weapon/material/knife/unitologist/get_antag_weight(var/category)
	if (category == CATEGORY_UNITOLOGY)
		return 0.15

	.=..()

/mob/living/carbon/human/proc/sacrifice_verb(var/mob/living/carbon/human/target)
	set name = "Sacrifice"
	set category = "Abilities"

	if (target == usr)
		to_chat(src, "You can't sacrifice yourself!")
		return

	mercer_execution(target)

/*--------------------------------
	Sacrifice
--------------------------------*/


/*
	The unitology execution move.
		-Approaches the target, step to infront or over them, depending on whether or not lying
		-Grabs target
		-Covers their mouth (mute)
		-Raises dagger
		-Stab victim in head (finisher)
		-Step back to admire handiwork
*/
/mob/living/carbon/human/proc/mercer_execution(var/mob/living/carbon/human/target)
	set name = "Sacrifice"
	set desc = "A ritual which prepares the subject for uplifting"
	set category = "Abilities"

	if (!istype(target) || target.stat == DEAD)
		to_chat(src, SPAN_DANGER("It is too late to sacrifice this one, they are lost"))
		return

	var/list/held = get_held_items()
	var/obj/item/weapon/material/knife/unitologist/blade = locate() in held
	if (!blade)
		to_chat(src, SPAN_DANGER("You must be holding your ritual blade"))
		return

	if (!has_free_hand())
		to_chat(src, SPAN_DANGER("You need a free hand"))
		return

	perform_execution(/datum/extension/execution/sacrifice, target, blade)






/datum/extension/execution/sacrifice
	name = "Sacrifice"
	base_type = /datum/extension/execution/sacrifice
	cooldown = 0

	reward_biomass = 0
	reward_energy = 150
	reward_heal = 0
	start_range = 7

	statmods = list(STATMOD_EVASION = -100, STATMOD_VIEW_RANGE = -2, STATMOD_INCOMING_DAMAGE_MULTIPLICATIVE	=	EXECUTION_DAMAGE_VULNERABILITY)

	all_stages = list(/datum/execution_stage/approach,
	/datum/execution_stage/cover_mouth,
	/datum/execution_stage/gaze,
	/datum/execution_stage/raise,
	/datum/execution_stage/finisher/headspike,
	/datum/execution_stage/retrieve_blade)

	require_grab = 2	//We require a grab from second stage onwards



/datum/extension/execution/sacrifice/distribute_rewards()
	.=..()
	victim.adjust_biomass(10)

/datum/extension/execution/sacrifice/safety_check()
	.=..()
	if (. == EXECUTION_CONTINUE)
		//Holding the blade is required up to the finisher stage. Retrieving it from the victim's skull is optional post-finisher stuff
		if (status < STATUS_POST_FINISH)
			var/list/held = user.get_held_items()
			var/obj/item/weapon/material/knife/unitologist/blade = locate() in held
			if (!blade)
				to_chat(user, SPAN_DANGER("You must be holding your ritual blade"))
				return EXECUTION_CANCEL


		var/obj/item/organ/external/head/H = victim.get_organ(BP_HEAD)
		if (!H)
			to_chat(user, SPAN_DANGER("The sacrifice has lost their head!"))
			return EXECUTION_CANCEL

/datum/extension/execution/sacrifice/can_start()
	//Lets check that we have what we need

	//The victim must be alive
	if (victim.stat == DEAD)
		return FALSE



	.=..()


/*
	Real simple stage, just changes target to cover mouth then waits a couple secs for it to take effect
	Requires a grapple but that is set in the parent execution
*/
/datum/execution_stage/cover_mouth
	duration = 5 SECONDS

/datum/execution_stage/cover_mouth/enter()
	host.user.face_atom(host.victim, TRUE)
	host.user.set_selected_zone(BP_MOUTH)
	.=..()

/datum/execution_stage/cover_mouth/can_advance()
	if (!host.user.is_grabbing(host.victim))
		return EXECUTION_CANCEL


	.=..()


//Literally just filler
/datum/execution_stage/gaze
	duration = 8 SECONDS


/datum/execution_stage/gaze/enter()
	host.user.visible_message(SPAN_EXECUTION("[host.user] gazes down into [host.victim]'s terrified eyes"))
	.=..()

/*
	Raise Dagger
*/
/datum/execution_stage/raise
	duration = 8 SECONDS

/datum/execution_stage/raise/enter()
	host.user.visible_message(SPAN_EXECUTION("[host.user] raises the [host.weapon] high, preparing to strike!"))
	//Rises up into the air then comes down upon the victim fast

	animate(host.user, pixel_y = host.user.pixel_y + 16, time = duration * 1)
	animate(pixel_y = host.user.pixel_y - 18, time = duration * 0.1, easing = BACK_EASING | EASE_OUT)

	.=..()





/*
	Headspike, death happens now
*/
/datum/execution_stage/finisher/headspike
	duration = 5 SECONDS

/datum/execution_stage/finisher/headspike/enter()
	.=..()
	var/armor = host.victim.getarmor(BP_HEAD, "melee")

	//If the victim is wearing a tough helmet you can't stab them
	if (prob(armor*2))
		//TODO: Audio
		host.user.visible_message(SPAN_EXECUTION("The [host.weapon] bounces harmlessly off [host.victim]'s armoured head!"))
		return FALSE

	host.user.visible_message(SPAN_EXECUTION("[host.user] drives the [host.weapon] into [host.victim]'s forehead, with a sickening crunch."))

	playsound(host.victim, "fracture", VOLUME_MID, TRUE)

	host.victim.shake_animation()

	var/obj/item/organ/external/head/H = host.victim.get_organ(BP_HEAD)

	//Deal heavy non-dismembering external damage to the head, this is mostly for the sake of blood graphics
	H.take_external_damage(9999, 0, DAM_SHARP, host.weapon, allow_dismemberment = FALSE)

	//Create a wound which we will use later
	var/datum/wound/W = H.createwound(type = PIERCE, damage = 9999, surgical = FALSE, forced_type = /datum/wound/puncture/massive/skullbore)
	host.victim.embed(host.weapon, BP_HEAD, supplied_wound = W)//The knife embeds in the victim's skull for a few secs. We'll pull it out though!

	//Create this extension, used for conversion
	set_extension(H, /datum/extension/skullbore)


	//Destroy the brain. This kills the man
	var/obj/item/organ/internal/brain/B = host.victim.get_organ(BP_BRAIN)
	if (B)
		B.take_internal_damage(9999)	//Victim is now ded

	//Lets just be sure because braindeath doesnt seem to kill instantly
	host.victim.death()


/*
	Yank out
	Get your knife back
*/
/datum/execution_stage/retrieve_blade
	duration = 6 SECONDS

/datum/execution_stage/retrieve_blade/enter()
	.=..()

	host.victim.yank_out_object(host.weapon, host.user)

/datum/execution_stage/retrieve_blade/exit()

	host.user.stop_grabbing(host.victim)
	.=..()


//Skullbore marker
/datum/extension/skullbore
	flags = EXTENSION_FLAG_IMMEDIATE
	statmods = list(STATMOD_CONVERSION_COMPATIBILITY = 1)	//Adds an extra 1 point to conversion compatibility