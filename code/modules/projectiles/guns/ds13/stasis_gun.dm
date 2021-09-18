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

/obj/item/weapon/gun/energy/stasis/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/weapon/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		on_shot_recharged()
		update_icon()
	return 1

/obj/item/weapon/gun/energy/stasis/proc/on_shot_recharged()
	if(istype(loc, /obj/item/rig_module/mounted/stasis))
		var/obj/item/rig_module/mounted/stasis/S = loc
		S.update_stasis_charge()

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
	new /obj/effect/effect/expanding_circle(A.loc, _expansion_rate = -0.9, 	_lifespan = 6, _color = "#505fff")
	var/impact_zone = range(1, A)
	for(var/atom/M in impact_zone)
		M.stasis_act()

/datum/proc/stasis_act()
	return

/datum/extension/stasis_effect
	var/dm_filter/ripple
	var/dm_filter/outline
	var/stasis_duration = 40

/datum/extension/stasis_effect/New()
	. = ..()
	add_stasis_visual(holder)
	addtimer(CALLBACK(src, /datum/extension/stasis_effect/proc/end_stasis), stasis_duration, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT)

/datum/extension/stasis_effect/proc/end_stasis()
	remove_extension(holder, type)

/datum/extension/stasis_effect/Destroy()
	remove_stasis_visual(holder)
	.=..()

/datum/extension/stasis_effect/mob
	name = "Stasis Effect"
	expected_type = /mob/living
	flags = EXTENSION_FLAG_IMMEDIATE

	var/mob/living/carbon/M
	statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 0.40, STATMOD_ATTACK_SPEED = -0.60)

/datum/extension/stasis_effect/mob/New()
	.=..()
	addtimer(CALLBACK(src, /datum/extension/stasis_effect/mob/proc/Initialize), 0)

/datum/extension/stasis_effect/mob/proc/Initialize()
	M = holder
	for(var/obj/item/I in M.contents)
		I.stasis_act()

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

	statmods = list(STATMOD_MOVESPEED_MULTIPLICATIVE = 0.40)
