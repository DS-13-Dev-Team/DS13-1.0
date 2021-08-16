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
	cell_type = /obj/item/weapon/cell/potato //Potato cell is underrated
	projectile_type = /obj/item/projectile/bullet/stasis
	removeable_cell = FALSE
	safety_state = FALSE
	shot_volume = VOLUME_QUIET

/obj/item/weapon/gun/energy/stasis/military
	recharge_time = 120
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
	var/impact_zone = trange(1, A)
	for(var/t in impact_zone)
		var/turf/T = t
		for(var/atom/M in T)
			M.stasis_act()

/datum/proc/stasis_act()
	return

/datum/extension/stasis_effect
	var/ripple
	var/outline
	var/base_stasis_duration = 4 //1 = 1 second
	var/stasis_duration


/datum/extension/stasis_effect/Process()
	while(stasis_duration)
		stasis_duration--
		return

	remove_extension(holder, type)
	return PROCESS_KILL

/datum/extension/stasis_effect/mob
	name = "Stasis Effect"
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	var/attack_slowdown = -0.60
	var/slowdown = 0.40
	var/mob/living/carbon/M
	statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 0.40, STATMOD_ATTACK_SPEED = -0.60)

/datum/extension/stasis_effect/mob/New()
	.=..()
	M = holder
	stasis_duration = base_stasis_duration
	var/stasis = get_extension(M, /datum/extension/stasis_effect/mob)
	statmods[STATMOD_ATTACK_SPEED] = attack_slowdown

	add_stasis_visual(M)

	for(var/obj/item/I in M.contents)
		I.stasis_act()

	var/obj/item/weapon/rig/R = M.back

	START_PROCESSING(SSprocessing, src)

/datum/extension/stasis_effect/mob/get_statmod(var/modtype)
	if(modtype == STATMOD_MOVESPEED_MULTIPLICATIVE)
		return slowdown
	if(modtype == STATMOD_ATTACK_SPEED)
		return attack_slowdown

/datum/extension/stasis_effect/mob/Destroy()
	remove_stasis_visual(M)
	.=..()

/datum/extension/stasis_effect/proc/add_stasis_visual(var/atom/thing)
	ripple = filter(type = "ripple", radius = 0, size = 8)
	thing.filters.Add(ripple)
	ripple = thing.filters[thing.filters.len]
	animate(ripple, radius = 16, size = 1, time = 5, loop = -1, flags = ANIMATION_PARALLEL)

	outline = filter(type = "outline", size = 2, color = "#cdfdff", alpha = 128)
	thing.filters.Add(outline)
	outline = thing.filters[thing.filters.len]

/datum/extension/stasis_effect/proc/remove_stasis_visual(var/atom/thing)
	thing.filters.Remove(ripple)
	thing.filters.Remove(outline)

/datum/extension/stasis_effect/item
	name = "Stasis Effect"
	expected_type = /obj/item
	flags = EXTENSION_FLAG_IMMEDIATE

	var/throw_mod = 0.25

/datum/extension/stasis_effect/item/New()
	.=..()
	stasis_duration = base_stasis_duration
	add_stasis_visual(holder)
	START_PROCESSING(SSprocessing, src)

/datum/extension/stasis_effect/item/Destroy()
	remove_stasis_visual(holder)
	.=..()
