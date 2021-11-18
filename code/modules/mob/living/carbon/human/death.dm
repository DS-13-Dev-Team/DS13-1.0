/mob/living/carbon/human/gib()


	if(species.can_obliterate)
		..(species.gibbed_anim)

	for(var/obj/item/organ/external/E in src.organs)
		if (species.can_obliterate || (E.limb_flags & ORGAN_FLAG_CAN_AMPUTATE))
			for(var/obj/item/organ/I in E.internal_organs)
				I.removed()
				if(istype(loc,/turf))
					I.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)),rand(1,3),30)
			E.droplimb(0,DROPLIMB_EDGE,1)

	sleep(1)

	for(var/obj/item/I in src)
		if (istype(I, /obj/item/organ))
			continue	//Organs are already handled above
		drop_from_inventory(I)
		I.throw_at(get_edge_target_turf(src,pick(GLOB.alldirs)), rand(1,3), round(30/I.w_class))
	gibs(loc, dna, null, species.get_flesh_colour(src), species.get_blood_colour(src))

/mob/living/carbon/human/dust()
	if(species)
		..(species.dusted_anim, species.remains_type)
	else
		..()

/mob/living/carbon/human/death(gibbed,deathmessage="seizes up and falls limp...", show_dead_message = "You have died.")

	if(stat == DEAD) return

	BITSET(hud_updateflag, HEALTH_HUD)
	BITSET(hud_updateflag, STATUS_HUD)
	BITSET(hud_updateflag, LIFE_HUD)

	//backs up lace if available.
	var/obj/item/organ/internal/stack/s = get_organ(BP_STACK)
	if(s)
		s.do_backup()


	//Database update
	if (mind)
		mind.on_death()

	//Handle species-specific deaths.
	species.handle_death(src)
	animate_tail_stop()

	//Handle brain slugs.
	var/obj/item/organ/external/head = get_organ(BP_HEAD)
	var/mob/living/simple_animal/borer/B

	if(head)
		for(var/I in head.implants)
			if(istype(I,/mob/living/simple_animal/borer))
				B = I
		if(B)
			if(!B.ckey && ckey && B.controlling)
				B.ckey = ckey
				B.controlling = 0
			if(B.host_brain.ckey)
				ckey = B.host_brain.ckey
				B.host_brain.ckey = null
				B.host_brain.SetName("host brain")
				B.host_brain.real_name = "host brain"

			remove_verb(src, /mob/living/carbon/proc/release_control)

	callHook("death", list(src, gibbed))

	if(SSticker && SSticker.mode)
		sql_report_death(src)

		SSticker.mode.check_win()

	if(wearing_rig)
		wearing_rig.notify_ai("<span class='danger'>Warning: user death event. Mobility control passed to integrated intelligence system.</span>")

	. = ..(gibbed,"no message")
	if(!gibbed)
		handle_organs()
		play_species_audio(loc, SOUND_DEATH, 80, 1, 2)

	handle_hud_list()

	//TODO Future: Check if this was actually a crewmember
	SSticker.mode.on_crew_death(src)

/mob/living/carbon/human/proc/ChangeToHusk()
	if(HUSK in mutations)	return

	if(f_style)
		f_style = "Shaved"		//we only change the icon_state of the hair datum, so it doesn't mess up their UI/UE
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(HUSK)
	for(var/obj/item/organ/external/E in organs)
		E.status |= ORGAN_DISFIGURED
	update_body(1)
	return

/mob/living/carbon/human/proc/Drain()
	ChangeToHusk()
	mutations |= HUSK
	return

/mob/living/carbon/human/proc/ChangeToSkeleton()
	if(SKELETON in src.mutations)	return

	if(f_style)
		f_style = "Shaved"
	if(h_style)
		h_style = "Bald"
	update_hair(0)

	mutations.Add(SKELETON)
	for(var/obj/item/organ/external/E in organs)
		E.status |= ORGAN_DISFIGURED
	update_body(1)
	return



// Check if we should die.
/mob/living/carbon/human/handle_death_check()
	//Prevent potential loops
	if (stat == DEAD)
		return

	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/brain = internal_organs_by_name[BP_BRAIN]
		if(!brain || !brain.is_usable())
			.= TRUE
	if (!.)
		.=species.handle_death_check(src)

	if (.)
		//Time to die
		death()
		blinded = TRUE
		silent = FALSE
