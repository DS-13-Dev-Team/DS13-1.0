/obj/item/weapon/gun/energy/stasis
	name = "Stasis Gun"
	desc = "Wow! You've managed to obtain it!"
	icon = 'icons/obj/weapons/ds13guns48x32.dmi'
	icon_state = "contact"
	item_state = "stasis_gun"
	w_class = ITEM_SIZE_HUGE
	charge_cost = 5 //Doesn't matter, untobtainable gun
	cell_type = /obj/item/weapon/cell/potato //20 charge, joke time
	projectile_type = /obj/item/projectile/bullet/stasis

	removeable_cell = FALSE

	shot_volume = VOLUME_MAX

/obj/item/projectile/bullet/stasis
	name = "stasis blast"
	icon_state = "stasis_blast"
	step_delay = 2
	ricochet_chance	= 0
	damage = 0
	structure_damage_factor = 0
	nodamage = 1				//This dog doesn't bite, it hurts differently
	grippable = FALSE

/obj/item/projectile/bullet/stasis/on_impact(var/atom/A)
	var/impact_zone = trange(2, A)
	for(var/t in impact_zone)
		var/turf/T = t
		for(var/mob/L in T)
			L.stasis_act()
		for(var/obj/O in T)
			O.stasis_act()

/datum/extension/stasis_effect
	name = "Stasis Effect"
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	var/dm_filter/ripple
	var/attack_slowdown = -12.5
	var/slowdown = 0.5
	var/mob/M
	statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 0.5, STATMOD_ATTACK_SPEED = -12.5)

/datum/extension/stasis_effect/New(var/datum/holder)
	.=..()
	M = holder
	to_chat(M, SPAN_DANGER("It feels like something prevents you from moving fast!"))
	ripple = filter(type = "ripple", radius = 0, size = 8)
	M.filters.Add(ripple)
	ripple = M.filters[M.filters.len]
	animate(ripple, radius = 16, size = 1, time = 4, loop = -1, flags = ANIMATION_PARALLEL)
	statmods[STATMOD_ATTACK_SPEED] = attack_slowdown

	START_PROCESSING(SSprocessing, src)

/datum/extension/stasis_effect/get_statmod(var/modtype)
	if(modtype == STATMOD_MOVESPEED_MULTIPLICATIVE)
		return slowdown
	if(modtype == STATMOD_ATTACK_SPEED)
		return attack_slowdown

/datum/extension/stasis_effect/Process()
	spawn(50)
		remove_extension(holder, type)
		return PROCESS_KILL

/datum/extension/stasis_effect/Destroy()
	if(M)
		M.filters.Remove(ripple)
	.=..()

/datum/proc/stasis_act()
	return
