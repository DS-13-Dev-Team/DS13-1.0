#define HEALTH_DOLL_UPDATE_DELAY	20	//2 SECONDS

/*
	The doll code in this file is only for humans. There are several other unused mob types which utilise health dolls and are still on the old system:
		Brain
		Diona nymph
		Alien (xenomorph?)
		Cult Constructs
		Alien Larva
*/


//The health doll attempts to update whenever the host mob updates its health
/obj/screen/health_doll
	var/last_updated = 0
	var/updating = FALSE
	var/mob/living/carbon/human/H
	name = "health"
	//icon = ui_style
	icon_state = "health0"
	screen_loc = "EAST-1:28,CENTER:15"

/obj/screen/health_doll/Destroy()
	if (H && H.healths == src)
		H.healths = null
	H = null
	.=..()

/obj/screen/health_doll/New(var/mob/living/carbon/human/owner)
	H = owner
	.=..()

/obj/screen/health_doll/Initialize()
	.=..()
	if (istype(H))
		GLOB.updatehealth_event.register(H, src, /obj/screen/health_doll/proc/try_update)
		GLOB.death_event.register(H, src, /obj/screen/health_doll/proc/try_update)


		var/vector2/icon_size = H.get_icon_size()
		icon_size.x += 4 //Padding from screen edge
		var/tile_offset = Floor(icon_size.x / WORLD_ICON_SIZE) * -1
		var/pixel_offset = icon_size.x % WORLD_ICON_SIZE * -1
		pixel_offset += get_offset()
		var/newscreenloc = "EAST[tile_offset]:[pixel_offset],CENTER:15"
		screen_loc = newscreenloc
		update()

/obj/screen/health_doll/proc/get_offset()
	return 0


/obj/screen/health_doll/proc/try_update()
	//We'll have a minimum time between updates to save on performance
	if (updating)
		return
	updating = TRUE
	var/time_delta = world.time - last_updated

	//If its not been long enough, we schedule the next update
	if (time_delta < HEALTH_DOLL_UPDATE_DELAY)
		addtimer(CALLBACK(src, /obj/screen/health_doll/proc/update), HEALTH_DOLL_UPDATE_DELAY - time_delta)
	else
		update()


/obj/screen/health_doll/proc/update()
	return

/obj/screen/health_doll/human/update()

	if (QDELETED(H))
		updating = FALSE
		return


	if (H.stat == DEAD)
		overlays.Cut()
		if("health7" in icon_states(icon))
			icon_state = "health7"
		else
			icon_state = "health6"
		return

	if (H.chem_effects[CE_PAINKILLER] > 100)
		overlays.Cut()
		icon_state = "health_numb"
	else
		// Generate a by-limb health display.
		icon_state = "blank"
		overlays = null

		var/no_damage = 1
		var/trauma_val = 0 // Used in calculating softcrit/hardcrit indicators.
		if(H.can_feel_pain())
			trauma_val = max(H.shock_stage,H.get_shock())/(H.species.total_health-100)
		// Collect and apply the images all at once to avoid appearance churn.
		var/list/health_images = list()
		for(var/obj/item/organ/external/E in H.organs)
			if(no_damage && (E.brute_dam || E.burn_dam))
				no_damage = 0
			health_images += E.get_damage_hud_image()

		// Apply a fire overlay if we're burning.
		if(H.on_fire)
			health_images += image('icons/mob/screen1_health.dmi',"burning")

		// Show a general pain/crit indicator if needed.
		if(H.is_asystole())
			health_images += image('icons/mob/screen1_health.dmi',"hardcrit")
		else if(trauma_val)
			if(H.can_feel_pain())
				if(trauma_val > 0.7)
					health_images += image('icons/mob/screen1_health.dmi',"softcrit")
				if(trauma_val >= 1)
					health_images += image('icons/mob/screen1_health.dmi',"hardcrit")
		else if(no_damage)
			health_images += image('icons/mob/screen1_health.dmi',"fullhealth")

		overlays += health_images

	last_updated = world.time
	updating = FALSE

/obj/screen/health_doll/human/get_offset()
	return H.species.health_doll_offset


#undef HEALTH_DOLL_UPDATE_DELAY