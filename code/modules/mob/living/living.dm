/mob/living/Initialize()
	. = ..()
	if(stat == DEAD)
		add_to_dead_mob_list()
	else
		add_to_living_mob_list()

//mob verbs are faster than object verbs. See above.
/mob/living/pointed(atom/A as mob|obj|turf in view())
	if(incapacitated())
		return 0
	if(src.status_flags & FAKEDEATH)
		return 0
	if(!..())
		return 0

	usr.visible_message("<b>[src]</b> points to [A]")
	return 1

/*one proc, four uses
swapping: if it's 1, the mobs are trying to switch, if 0, non-passive is pushing passive
default behaviour is:
 - non-passive mob passes the passive version
 - passive mob checks to see if its mob_bump_flag is in the non-passive's mob_bump_flags
 - if si, the proc returns
*/
/mob/living/proc/can_move_mob(var/mob/living/swapped, swapping = 0, passive = 0)
	if(!swapped)
		return 1
	if(!passive)
		return swapped.can_move_mob(src, swapping, 1)
	else
		var/context_flags = 0
		if(swapping)
			context_flags = swapped.mob_swap_flags
		else
			context_flags = swapped.mob_push_flags
		if(!mob_bump_flag) //nothing defined, go wild
			return 1
		if(mob_bump_flag & context_flags)
			return 1
		else
			return ((a_intent == I_HELP && swapped.a_intent == I_HELP) && swapped.can_move_mob(src, swapping, 1))

/mob/living/canface()
	if(stat)
		return 0
	return ..()

/mob/living/Bump(atom/movable/AM, yes)
	SEND_SIGNAL(src, COMSIG_MOVABLE_BUMP, AM)
	spawn(0)
		if ((!( yes ) || now_pushing) || !loc)
			return
		now_pushing = 1
		if (istype(AM, /mob/living))
			var/mob/living/tmob = AM

			for(var/mob/living/M in range(tmob, 1))
				if(tmob.pinned.len ||  ((M.pulling == tmob && ( tmob.restrained() && !( M.restrained() ) && M.stat == 0)) || locate(/obj/item/grab, tmob.grabbed_by.len)) )
					if ( !(world.time % 5) )
						to_chat(src, "<span class='warning'>[tmob] is restrained, you cannot push past</span>")
					now_pushing = 0
					return
				if( tmob.pulling == M && ( M.restrained() && !( tmob.restrained() ) && tmob.stat == 0) )
					if ( !(world.time % 5) )
						to_chat(src, "<span class='warning'>[tmob] is restraining [M], you cannot push past</span>")
					now_pushing = 0
					return

			//Leaping mobs just land on the tile, no pushing, no anything.
			if(status_flags & LEAPING)
				forceMove(tmob.loc)
				status_flags &= ~LEAPING
				now_pushing = 0
				return

			if(can_swap_with(tmob)) // mutual brohugs all around!
				var/turf/oldloc = loc
				forceMove(tmob.loc)
				tmob.forceMove(oldloc)
				now_pushing = 0
				for(var/mob/living/carbon/slime/slime in view(1,tmob))
					if(slime.Victim == tmob)
						slime.UpdateFeed()
				return

			if(!can_move_mob(tmob, 0, 0))
				now_pushing = 0
				return
			if(src.restrained())
				now_pushing = 0
				return
			if(tmob.a_intent != I_HELP)
				if(istype(tmob, /mob/living/carbon/human) && (FAT in tmob.mutations))
					if(prob(40) && !(FAT in src.mutations))
						to_chat(src, "<span class='danger'>You fail to push [tmob]'s fat ass out of the way.</span>")
						now_pushing = 0
						return
				if(tmob.r_hand && istype(tmob.r_hand, /obj/item/shield/riot))
					if(prob(99))
						now_pushing = 0
						return
				if(tmob.l_hand && istype(tmob.l_hand, /obj/item/shield/riot))
					if(prob(99))
						now_pushing = 0
						return
			if(!(tmob.status_flags & CANPUSH))
				now_pushing = 0
				return
			tmob.LAssailant = src
		if(isobj(AM) && !AM.anchored)
			var/obj/I = AM
			if(!can_pull_size || can_pull_size < I.w_class)
				to_chat(src, "<span class='warning'>It won't budge!</span>")
				now_pushing = 0
				return

		now_pushing = 0
		spawn(0)
			..()
			if (!istype(AM, /atom/movable) || AM.anchored)
				if(confused && prob(50) && !MOVING_DELIBERATELY(src))
					Weaken(2)
					playsound(loc, "punch", 25, 1, -1)
					visible_message("<span class='warning'>[src] [pick("ran", "slammed")] into \the [AM]!</span>")
					src.apply_damage(5, BRUTE)
				return
			if (!now_pushing)
				now_pushing = 1

				var/t = get_dir(src, AM)
				if (istype(AM, /obj/structure/window))
					for(var/obj/structure/window/win in get_step(AM,t))
						now_pushing = 0
						return
				step(AM, t)
				if (istype(AM, /mob/living))
					var/mob/living/tmob = AM
					if(istype(tmob.buckled, /obj/structure/bed))
						if(!tmob.buckled.anchored)
							step(tmob.buckled, t)
				if(ishuman(AM) && AM:grabbed_by)
					for(var/obj/item/grab/G in AM:grabbed_by)
						step(G:assailant, get_dir(G:assailant, AM))
						G.adjust_position()
				now_pushing = 0
			return
	return

/proc/swap_density_check(var/mob/swapper, var/mob/swapee)
	var/turf/T = get_turf(swapper)
	if(T.density)
		return 1
	for(var/atom/movable/A in T)
		if(A == swapper)
			continue
		if(!A.CanPass(swapee, T, 1))
			return 1

/mob/living/proc/can_swap_with(var/mob/living/tmob)
	if(tmob.buckled || buckled)
		return 0
	//BubbleWrap: people in handcuffs are always switched around as if they were on 'help' intent to prevent a person being pulled from being seperated from their puller
	if(!(tmob.mob_always_swap || (tmob.a_intent == I_HELP || tmob.restrained()) && (a_intent == I_HELP || src.restrained())))
		return 0
	if(!tmob.MayMove(src) || incapacitated())
		return 0

	if(swap_density_check(src, tmob))
		return 0

	if(swap_density_check(tmob, src))
		return 0

	return can_move_mob(tmob, 1, 0)

/mob/living/verb/succumb()
	set hidden = 1
	if ((src.health < src.max_health/2)) // Health below half of max_health.
		src.adjustBrainLoss(src.health + src.max_health * 2) // Deal 2x health in BrainLoss damage, as before but variable.
		updatehealth()
		to_chat(src, "<span class='notice'>You have given up life and succumbed to death.</span>")




//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(var/pressure)
	return


//sort of a legacy burn method for /electrocute, /shock, and the e_chair
/mob/living/proc/burn_skin(burn_amount)
	take_overall_damage(0, burn_amount)

/mob/living/proc/adjustBodyTemp(actual, desired, incrementboost)
	var/temperature = actual
	var/difference = abs(actual-desired)	//get difference
	var/increments = difference/10 //find how many increments apart they are
	var/change = increments*incrementboost	// Get the amount to change by (x per increment)

	// Too cold
	if(actual < desired)
		temperature += change
		if(actual > desired)
			temperature = desired
	// Too hot
	if(actual > desired)
		temperature -= change
		if(actual < desired)
			temperature = desired
//	if(istype(src, /mob/living/carbon/human))
//		log_debug("[src] ~ [src.bodytemperature] ~ [temperature]")

	return temperature



/mob/living/proc/get_max_health()
	return max_health

/mob/living/proc/set_max_health(var/newmax_health)
	max_health = newmax_health


/mob/living/is_injectable(allowmobs = TRUE)
	return (allowmobs && reagents && can_inject())

/mob/living/is_drawable(allowmobs = TRUE)
	return (allowmobs && reagents && can_inject())


/mob/living/proc/check_contents_for(A)
	var/list/L = src.get_contents()

	for(var/obj/B in L)
		if(B.type == A)
			return 1
	return 0

/mob/living/proc/can_inject(var/mob/user, var/target_zone)
	return 1

/mob/living/proc/get_organ_target()
	var/mob/shooter = src
	var/t = shooter.hud_used.zone_sel.selecting
	if ((t in list( BP_EYES, BP_MOUTH )))
		t = BP_HEAD
	var/obj/item/organ/external/def_zone = ran_zone(t)
	return def_zone




/mob/living/proc/restore_all_organs()
	return

/mob/living/proc/revive()
	rejuvenate()
	if(buckled)
		buckled.unbuckle_mob()
	if(iscarbon(src))
		var/mob/living/carbon/C = src

		if (C.handcuffed && !initial(C.handcuffed))
			C.drop_from_inventory(C.handcuffed)
		C.handcuffed = initial(C.handcuffed)

		if(C.legcuffed && !initial(C.legcuffed))
			C.drop_from_inventory(C.legcuffed)
		C.legcuffed = initial(C.legcuffed)

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)
	ExtinguishMob()
	fire_stacks = 0
	// The signal is called after everything else so components can properly check the updated values
	SEND_SIGNAL(src, COMSIG_LIVING_REVIVE)

/mob/living/proc/rejuvenate()
	if(reagents)
		reagents.clear_reagents()

	// shut down various types of badness
	setToxLoss(0)
	setOxyLoss(0)
	setCloneLoss(0)
	setBrainLoss(0)
	SetParalysis(0)
	SetStunned(0)
	SetWeakened(0)

	// shut down ongoing problems
	radiation = 0
	bodytemperature = T20C
	sdisabilities = 0
	disabilities = 0

	// fix blindness and deafness
	blinded = 0
	eye_blind = 0
	eye_blurry = 0
	ear_deaf = 0
	ear_damage = 0
	heal_overall_damage(getBruteLoss(), getFireLoss())

	// fix all of our organs
	restore_all_organs()

	// remove the character from the list of the dead
	if(stat == DEAD)
		switch_from_dead_to_living_mob_list()
		timeofdeath = 0

	// restore us to conciousness
	set_stat(CONSCIOUS)

	// make the icons look correct
	regenerate_icons()

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	failed_last_breath = 0 //So mobs that died of oxyloss don't revive and have perpetual out of breath.
	reload_fullscreens()
	return

/mob/living/proc/UpdateDamageIcon()
	return


/mob/living/proc/Examine_OOC()
	set name = "Examine Meta-Info (OOC)"
	set category = "OOC"
	set src in view()

	if(CONFIG_GET(flag/allow_Metadata))
		if(client)
			to_chat(usr, "[src]'s Metainfo:<br>[client.prefs.metadata]")
		else
			to_chat(usr, "[src] does not have any stored infomation!")
	else
		to_chat(usr, "OOC Metadata is not supported by this server!")

	return

/mob/living/Move(a, b, flag)
	if (buckled)
		return


	var/turf/old_loc = get_turf(src)

	. = ..()

	if(. && pulling)
		handle_pulling_after_move(old_loc)

	if (s_active && !( s_active in contents ) && get_turf(s_active) != get_turf(src))	//check !( s_active in contents ) first so we hopefully don't have to call get_turf() so much.
		s_active.close(src)

	if(update_slimes)
		for(var/mob/living/carbon/slime/M in view(1,src))
			M.UpdateFeed()

	if(TICK_CHECK)
		CRASH("HELLO.")


/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"

	if(!incapacitated(INCAPACITATION_KNOCKOUT) && last_resist + 2 SECONDS <= world.time)
		last_resist = world.time
		resist_grab()
		if(!weakened)
			process_resist()

/mob/living/proc/process_resist()
	//Getting out of someone's inventory.
	if(istype(src.loc, /obj/item/holder))
		escape_inventory(src.loc)
		return

	//unbuckling yourself
	if(buckled)
		spawn() escape_buckle()
		return TRUE

	//Breaking out of a locker?
	if( src.loc && (istype(src.loc, /obj/structure/closet)) )
		var/obj/structure/closet/C = loc
		spawn() C.mob_breakout(src)
		return TRUE

/mob/living/proc/escape_inventory(obj/item/holder/H)
	if(H != src.loc) return

	var/mob/M = H.loc //Get our mob holder (if any).

	if(istype(M))
		M.drop_from_inventory(H)
		to_chat(M, "<span class='warning'>\The [H] wriggles out of your grip!</span>")
		to_chat(src, "<span class='warning'>You wriggle out of \the [M]'s grip!</span>")

		// Update whether or not this mob needs to pass emotes to contents.
		for(var/obj/item/holder/A in M.contents)
			return
		M.status_flags &= ~PASSEMOTES
	else if(istype(H.loc,/obj/item/clothing/accessory/storage/holster) || istype(H.loc,/obj/item/storage/belt/holster))
		var/datum/extension/holster/holster = get_extension(src, /datum/extension/holster)
		if(holster.holstered == H)
			holster.clear_holster()
		to_chat(src, "<span class='warning'>You extricate yourself from \the [holster].</span>")
		H.forceMove(get_turf(H))
	else if(istype(H.loc,/obj))
		if(istype(H.loc, /obj/machinery/cooker))
			var/obj/machinery/cooker/C = H.loc
			C.cooking_obj = null
			C.check_cooking_obj()
		to_chat(src, "<span class='warning'>You struggle free of \the [H.loc].</span>")
		H.forceMove(get_turf(H))

	if(loc != H)
		qdel(H)



/mob/living/proc/resist_grab()
	var/resisting = 0
	for(var/obj/item/grab/G in grabbed_by)
		resisting++
		G.handle_resist()
	if(resisting)
		visible_message("<span class='danger'>[src] resists!</span>")

/mob/living/verb/lay_down()
	set name = "Rest"
	set category = "IC"

	resting = !resting
	to_chat(src, "<span class='notice'>You are now [resting ? "resting" : "getting up"]</span>")
	update_lying_buckled_and_verb_status()

//called when the mob receives a bright flash
/mob/living/flash_eyes(intensity = FLASH_PROTECTION_MODERATE, override_blindness_check = FALSE, affect_silicon = FALSE, visual = FALSE, type = /atom/movable/screen/fullscreen/flash)
	if(override_blindness_check || !(disabilities & BLIND))
		overlay_fullscreen("flash", type)
		spawn(25)
			if(src)
				clear_fullscreen("flash", 25)
		return 1

/mob/living/proc/cannot_use_vents()
	if(mob_size > MOB_SMALL)
		return "You can't fit into that vent."
	return null

/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/slip(var/slipped_on,stun_duration=8)
	return 0

/mob/living/carbon/human/canUnEquip(obj/item/I)
	if(!..())
		return
	if(I in internal_organs)
		return
	if(I in organs)
		return
	return 1

//Organs should not be removed via inventory procs.
/mob/living/carbon/drop_from_inventory(var/obj/item/W, var/atom/Target = null)
	if(W in internal_organs)
		return
	if(W in organs)
		return
	. = ..()

//damage/heal the mob ears and adjust the deaf amount
/mob/living/adjust_ear_damage(var/damage, var/deaf)

	ear_damage = max(0, ear_damage + damage)
	ear_deaf = max(0, ear_deaf + deaf)

//pass a negative argument to skip one of the variable
/mob/living/setEarDamage(var/damage = null, var/deaf = null)
	if(!isnull(damage))
		ear_damage = damage
	if(!isnull(deaf))
		ear_deaf = deaf

/mob/proc/can_be_possessed_by(var/mob/dead/observer/ghost/possessor)
	return istype(possessor) && possessor.client

/mob/living/can_be_possessed_by(var/mob/dead/observer/ghost/possessor)
	if(!..())
		return 0
	if(!possession_candidate)
		to_chat(possessor, "<span class='warning'>That animal cannot be possessed.</span>")
		return 0
	if(jobban_isbanned(possessor, "Animal"))
		to_chat(possessor, "<span class='warning'>You are banned from animal roles.</span>")
		return 0
	if(!possessor.MayRespawn(1,ANIMAL_SPAWN_DELAY))
		return 0
	return 1

/mob/living/proc/do_possession(var/mob/dead/observer/ghost/possessor)

	if(!(istype(possessor) && possessor.ckey))
		return 0

	if(src.ckey || src.client)
		to_chat(possessor, "<span class='warning'>\The [src] already has a player.</span>")
		return 0

	message_admins("<span class='adminnotice'>[key_name_admin(possessor)] has taken control of \the [src].</span>")
	log_admin("[key_name(possessor)] took control of \the [src].")
	src.ckey = possessor.ckey
	qdel(possessor)

	if(round_is_spooky(6)) // Six or more active cultists.
		to_chat(src, "<span class='notice'>You reach out with tendrils of ectoplasm and invade the mind of \the [src]...</span>")
		to_chat(src, "<b>You have assumed direct control of \the [src].</b>")
		to_chat(src, "<span class='notice'>Due to the spookiness of the round, you have taken control of the poor animal as an invading, possessing spirit - roleplay accordingly.</span>")
		src.universal_speak = 1
		src.universal_understand = 1
		//src.cultify() // Maybe another time.
		return

	to_chat(src, "<b>You are now \the [src]!</b>")
	to_chat(src, "<span class='notice'>Remember to stay in character for a mob of this type!</span>")
	return 1

/mob/living/reset_layer()
	if(hiding)
		layer = HIDING_MOB_LAYER
	else
		..()

/mob/living/update_icons()
	if(auras)
		overlays |= auras

/mob/living/proc/add_aura(var/obj/aura/aura)
	LAZYOR(auras,aura)
	update_icons()
	return 1

/mob/living/proc/remove_aura(var/obj/aura/aura)
	LAZYREMOVE(auras,aura)
	update_icons()
	return 1

/mob/living/Destroy()
	if(auras)
		for(var/a in auras)
			remove_aura(a)
	return ..()

/mob/living/proc/melee_accuracy_mods()
	. = 0
	if(eye_blind)
		. -= 30
	if(eye_blurry)
		. -= 15
	if(confused)
		. -= 20
	if(CLUMSY in mutations)
		. -= 30

/mob/living/proc/ranged_accuracy_mods()
	. = 0
	if(jitteriness)
		. -= 10
	if(confused)
		. -= 10
	if(eye_blind)
		. -= 50
	if(eye_blurry)
		. -= 5
	if(CLUMSY in mutations)
		. -= 15
	.+=ranged_accuracy_modifier

/mob/living/is_organic()
	return TRUE

/**
 * A proc triggered by callback when someone gets slammed by the tram and lands somewhere.
 *
 * This proc is used to force people to fall through things like lattice and unplated flooring at the expense of some
 * extra damage, so jokers can't use half a stack of iron rods to make getting hit by the tram immediately lethal.
 */
/mob/living/proc/tram_slam_land()
	if(!isopenspace(loc) && !istype(loc, /turf/space))
		return

	if(istype(loc, /turf/simulated/floor/plating))
		var/turf/simulated/floor/smashed_plating = loc
		visible_message(SPAN_DANGER("[src] is thrown violently into [smashed_plating], smashing through it and punching straight through!"),
				SPAN_USERDANGER("You're thrown violently into [smashed_plating], smashing through it and punching straight through!"))
		apply_damage(rand(5,20), BRUTE, BP_CHEST)
		smashed_plating.make_plating()

	for(var/obj/structure/lattice/lattice in loc)
		visible_message(SPAN_DANGER("[src] is thrown violently into [lattice], smashing through it and punching straight through!"),
			SPAN_USERDANGER("You're thrown violently into [lattice], smashing through it and punching straight through!"))
		apply_damage(rand(5,10), BRUTE, BP_CHEST)
		qdel(lattice)
