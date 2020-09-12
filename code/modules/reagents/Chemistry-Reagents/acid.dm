/datum/reagent/acid
	name = "Sulphuric acid"
	description = "A very corrosive mineral acid with the molecular formula H2SO4."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#db5008"
	metabolism = REM * 2
	touch_met = 50 // It's acid!
	var/power = 2.5
	var/meltdose = 10 // How much is needed to melt

/datum/reagent/acid/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.take_organ_damage(0, removed * power)

/datum/reagent/acid/affect_touch(var/mob/living/carbon/M, var/alien, var/removed) // This is the most interesting
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head)
			if(H.head.unacidable)
				to_chat(H, "<span class='danger'>Your [H.head] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.head] melts away!</span>")
				qdel(H.head)
				H.update_inv_head(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.wear_mask)
			if(H.wear_mask.unacidable)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] protects you from the acid.</span>")
				remove_self(volume)
				return
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.wear_mask] melts away!</span>")
				qdel(H.wear_mask)
				H.update_inv_wear_mask(1)
				H.update_hair(1)
				removed -= meltdose
		if(removed <= 0)
			return

		if(H.glasses)
			if(H.glasses.unacidable)
				to_chat(H, "<span class='danger'>Your [H.glasses] partially protect you from the acid!</span>")
				removed /= 2
			else if(removed > meltdose)
				to_chat(H, "<span class='danger'>Your [H.glasses] melt away!</span>")
				qdel(H.glasses)
				H.update_inv_glasses(1)
				removed -= meltdose / 2
		if(removed <= 0)
			return

	if(M.unacidable)
		return

	if(volume < meltdose) // Not enough to melt anything
		M.take_organ_damage(0, removed * power) //burn damage, since it causes chemical burns. Acid doesn't make bones shatter, like brute trauma would.
	else
		M.take_organ_damage(0, removed * power)
		if(removed && ishuman(M) && prob(100 * removed / meltdose)) // Applies disfigurement
			var/mob/living/carbon/human/H = M
			var/screamed
			for(var/obj/item/organ/external/affecting in H.organs)
				if(!screamed && affecting.can_feel_pain())
					screamed = 1
					H.emote("scream")
				affecting.status |= ORGAN_DISFIGURED



/datum/reagent/acid/hydrochloric //Like sulfuric, but less toxic and more acidic.
	name = "Hydrochloric Acid"
	description = "A very corrosive mineral acid with the molecular formula HCl."
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#808080"
	power = 3
	meltdose = 8


/datum/reagent/acid/triflicacid
	name = "Triflic acid"
	description = "Triflic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#939c38"
	power = NECROMORPH_ACID_POWER * 1.5
	meltdose = 8


/datum/reagent/acid/necromorph
	name = "Biological acid"
	description = "A corrosive chemical of organic origin"
	taste_description = "acid"
	reagent_state = LIQUID
	color = NECROMORPH_ACID_COLOR
	metabolism = 0.5
	touch_met = 0.5	//Slow burn
	power = NECROMORPH_ACID_POWER
	meltdose = 30 // How much is needed to melt

/datum/reagent/acid/necromorph/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if (alien == IS_NECROMORPH)
		removed *= NECROMORPH_FRIENDLY_FIRE_FACTOR	//Necromorph acid deals reduced friendly fire, but not nothing
	.=..()


/datum/reagent/acid/touch_turf(var/turf/simulated/T, var/amount)
	var/obj/effect/decal/cleanable/acid_spill/AS = (locate(/obj/effect/decal/cleanable/acid_spill) in T)
	if (!AS)
		AS = new(T)

	AS.chemical = src.type
	AS.adjust_volume(amount, type)


/datum/reagent/acid/touch_obj(var/obj/O, var/amount)
	O.acid_act(src, amount)




/atom/proc/acid_act(var/datum/reagent/acid/acid, var/volume)
	return TRUE

/obj/acid_act(var/datum/reagent/acid/acid, var/volume)
	if (unacidable)
		return FALSE
	.=..()

/obj/item/acid_act(var/datum/reagent/acid/acid, var/volume)
	.=..()
	if (.)//The unacidable flag is checked in parent
		var/melt = FALSE
		var/turf/T = get_turf(src)
		var/ourname = "[src]"
		var/ourplane = src.plane
		var/ourlayer = src.layer


		//We'll make the item take damage from the acid.
		take_damage((acid.power*volume)/acid_resistance, BURN)

		//If taking damage caused it to be deleted, then we'll do the melting effect
		if ((health <= 0 || QDELETED(src)) && !acid_melted)
			melt = TRUE

		if (melt)
			var/obj/effect/decal/cleanable/molten_item/I = new/obj/effect/decal/cleanable/molten_item(T)
			I.desc = "Looks like this was \an [src] some time ago."
			I.plane = ourplane
			I.plane = ourlayer
			for(var/mob/M in viewers(5, T))
				to_chat(M, "<span class='warning'>\The [ourname] melts.</span>")
			if (!QDELETED(src))
				qdel(src)



/*****************
	Floor Decals
******************/
/obj/effect/decal/cleanable/acid_spill
	name = "Biological acid"
	desc = ""
	color = NECROMORPH_ACID_COLOR
	icon = 'icons/effects/effects.dmi'
	icon_state = "spill"
	layer = BLOOD_LAYER	//Its a liquid, close enough
	var/saturation_point = 13
	var/rotation = 0
	var/drying_tick = 0.10
	var/randpixel = 6
	var/chemical
	var/datum/reagents/R
	var/min_alpha = 50	//Its not fun to have an invisible patch of acid. It will only have harmful effects while alpha is above this value

/obj/effect/decal/cleanable/acid_spill/examine(var/mob/user)

	if (alpha > min_alpha)
		desc = SPAN_WARNING("That looks dangerous to walk on.")
	else
		desc = "It's probably dried enough to be safe now,"
	.=..()
	var/stored_volume = R.total_volume
	var/time_remaining = ((stored_volume/drying_tick)*10)
	to_chat(user, SPAN_NOTICE("Will dry up in [time2text(time_remaining, "mm:ss")]"))

/obj/effect/decal/cleanable/acid_spill/Initialize()
	.=..()
	spawn()
		set_rotation()
		update_icon()

/obj/effect/decal/cleanable/acid_spill/Process()
	adjust_volume(-drying_tick, chemical)

/obj/effect/decal/cleanable/acid_spill/proc/set_rotation()
	rotation = rand_between(0, 360)
	icon_state = "spill_[pick("1","2","3")]"
	pixel_x = rand_between(-randpixel, randpixel)
	pixel_y = rand_between(-randpixel, randpixel)


/obj/effect/decal/cleanable/acid_spill/proc/adjust_volume(var/change, var/chemical)
	if (!R)
		R = new (99999, src)

	if (!src.chemical)
		src.chemical = chemical


	if (change > 0)
		R.add_reagent(chemical, change)
	else
		R.remove_reagent(chemical, -change)

	var/stored_volume = R.total_volume

	if (stored_volume <= 0)
		qdel(src)
	else
		if (change > 0)	//We only rotate it when acid is added, not as it dries
			set_rotation()
		update_icon()
		START_PROCESSING(SSobj, src)

/obj/effect/decal/cleanable/acid_spill/update_icon()
	var/stored_volume = R.total_volume
	var/matrix/M = matrix()
	var/scale_factor = 2.5
	if (stored_volume > saturation_point)
		scale_factor += 0.010 * (stored_volume - saturation_point)
	else
		alpha = (stored_volume / saturation_point) * 255
	M.Scale(scale_factor)
	M.Turn(rotation)
	transform = M



//Walking over the acid spill soaks some of it up.
//Crawling over it soaks up a lot more
/obj/effect/decal/cleanable/acid_spill/Crossed(var/atom/mover)
	.=..()
	if (iscarbon(mover) && !mover.is_necromorph() && alpha > min_alpha)
		var/sound = pick(list('sound/effects/footstep/footstep_wet_1.ogg',
		'sound/effects/footstep/footstep_wet_2.ogg',
		'sound/effects/footstep/footstep_wet_3.ogg'))
		playsound(src, sound, VOLUME_QUIET, TRUE)
		var/transfer_volume = 1
		var/mob/living/L = mover
		if (L.lying)
			transfer_volume = 3
		R.trans_to(mover, min(transfer_volume, R.total_volume))
		set_rotation()
		update_icon()


/*****************
	Slowing Effect
******************/

/datum/reagent/acid/necromorph/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	.=..()
	//Slowing effect
	if (!M.is_necromorph())
		var/datum/extension/acid_slow/AS = get_or_create_extension(M, /datum/extension/acid_slow)
		if (AS)
			AS.refresh()



/datum/extension/acid_slow
	var/speed_factor = 0.7
	var/duration	=	2.5 SECONDS

	var/removal_timer

/datum/extension/acid_slow/New(var/datum/holder)
	.=..()
	var/mob/living/carbon/L = holder
	//Does not affect necromorphs
	if (L.is_necromorph())
		remove_extension(holder, /datum/extension/acid_slow)
		return
	else
		to_chat(L, SPAN_DANGER("The acid underfoot is sticky and slows you down"))


	register_movemod(STATMOD_MOVESPEED_MULTIPLICATIVE)

	var/lifetime = duration
	if (L && L.touching)
		var/total_volume = L.touching.get_reagent_amount(/datum/reagent/acid/necromorph)
		lifetime =  duration + (total_volume SECONDS)
	removal_timer = addtimer(CALLBACK(src, /datum/extension/acid_slow/proc/stop),lifetime, flags = TIMER_STOPPABLE)

/datum/extension/acid_slow/proc/stop()
	var/mob/living/carbon/L = holder
	if (L.touching && L.touching.has_reagent(/datum/reagent/acid/necromorph))
		refresh()	//They still have acid, don't wear off yet
		return
	else
		remove_extension(holder, /datum/extension/acid_slow)


/datum/extension/acid_slow/proc/refresh()
	deltimer(removal_timer)
	var/mob/living/carbon/L = holder
	var/total_volume = 0
	if (L && L.touching)
		total_volume = L.touching.get_reagent_amount(/datum/reagent/acid/necromorph)
	removal_timer = addtimer(CALLBACK(src, /datum/extension/acid_slow/proc/stop), duration + (total_volume SECONDS), flags = TIMER_STOPPABLE)


/datum/extension/acid_slow/Destroy()
	unregister_movemod(STATMOD_MOVESPEED_MULTIPLICATIVE)
	deltimer(removal_timer)


	.=..()

/datum/extension/acid_slow/movespeed_mod()
	return speed_factor