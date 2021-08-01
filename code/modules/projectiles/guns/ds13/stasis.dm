/obj/item/weapon/gun/energy/stasis
	name = "Stasis Gun"
	desc = "Wow! You've managed to obtain it!"
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "forcegun"
	item_state = "forcegun"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "stasis blast"
	w_class = ITEM_SIZE_HUGE
	charge_cost = 5
	cell_type = /obj/item/weapon/cell/potato //20 charge, joke time
	projectile_type = /obj/item/projectile/bullet/stasis
	removeable_cell = FALSE
	safety_state = FALSE
	shot_volume = VOLUME_QUIET

/obj/item/weapon/gun/energy/stasis/military
	recharge_time = 12
	self_recharge = 1

/obj/item/weapon/gun/energy/stasis/on_shot_recharged()
	loc.update_stas_charge()

/obj/item/projectile/bullet/stasis
	name = "stasis blast"
	icon_state = "stasis_blast"
	fire_sound = 'sound/weapons/Taser.ogg'
	step_delay = 2.5
	ricochet_chance	= 0
	damage = 0
	structure_damage_factor = 0
	nodamage = 1				//This dog doesn't bite, it hurts differently
	grippable = FALSE
	projectile_type = /obj/item/projectile/bullet/stasis
	muzzle_type = ""

/obj/item/projectile/bullet/stasis/on_impact(var/atom/A)
	var/impact_zone = trange(2, A)
	for(var/t in impact_zone)
		var/turf/T = t
		for(var/atom/M in T)
			M.stasis_act()

/datum/extension/stasis_effect
	name = "Stasis Effect"
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	var/dm_filter/ripple
	var/dm_filter/outline

	var/attack_slowdown = -0.5
	var/slowdown = 0.5
	var/mob/living/carbon/M
	var/stasis_duration = 5 //1 = 1 second
	statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 0.5, STATMOD_ATTACK_SPEED = -0.5)

/datum/extension/stasis_effect/New(var/datum/holder)
	.=..()
	M = holder
	stasis_duration = 5
	var/twitcher = get_extension(M, /datum/extension/twitch)
	var/stasis = get_extension(M, /datum/extension/stasis_effect)
	if(twitcher)
		if(!stasis)
			to_chat(M, SPAN_DANGER("You feel like an easy target!"))
	else if(!stasis)
		to_chat(M, SPAN_DANGER("It feels like something prevents you from moving fast!"))
	statmods[STATMOD_ATTACK_SPEED] = attack_slowdown

	ripple = filter(type = "ripple", radius = 0, size = 8)
	M.filters.Add(ripple)
	ripple = M.filters[M.filters.len]
	animate(ripple, radius = 16, size = 1, time = 5, loop = -1, flags = ANIMATION_PARALLEL)

	outline = filter(type = "outline", size = 2, color = "#cdfdff", alpha = 128)
	M.filters.Add(outline)
	outline = M.filters[M.filters.len]

	START_PROCESSING(SSprocessing, src)

/datum/extension/stasis_effect/get_statmod(var/modtype)
	if(modtype == STATMOD_MOVESPEED_MULTIPLICATIVE)
		return slowdown
	if(modtype == STATMOD_ATTACK_SPEED)
		return attack_slowdown

/datum/extension/stasis_effect/Process()
	while(stasis_duration)
		stasis_duration--
		return

	remove_extension(holder, type)
	return PROCESS_KILL

/datum/extension/stasis_effect/Destroy()
	M.filters.Remove(ripple)
	M.filters.Remove(outline)
	.=..()

/datum/proc/stasis_act()
	return
