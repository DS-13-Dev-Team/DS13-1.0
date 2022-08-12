#define HEALTHBAR_PIXEL_WIDTH 181
#define HEALTHBAR_PIXEL_HEIGHT 24

/datum/component/health_meter
	var/atom/movable/screen/health_meter/background/background
	var/atom/movable/screen/health_meter/health/health
	var/atom/movable/screen/health_meter/foreground/foreground

/datum/component/health_meter/Initialize()
	if(!istype(parent, /mob/living))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/holder = parent

	background = new

	//WHY THE FUCK I HAVE TO USE THIS INSTEAD OF SINGLE VAR!? NANAKO!!!!!!!!!!!!!!!!!
	var/list/data = holder.get_health_report()
	var/mob_max_health = data["max"]
	var/mob_health = round(mob_max_health - data["damage"])

	health = new
	health.filters += filter(type = "alpha", icon = icon('icons/hud/healthbar.dmi', "alpha_mask"), x = clamp(HEALTHBAR_PIXEL_WIDTH*(mob_health/mob_max_health), 0, HEALTHBAR_PIXEL_WIDTH), flags = MASK_INVERSE)

	foreground = new
	foreground.maptext = MAPTEXT("[max(0, mob_health)]/[mob_max_health]")

	if(holder.hud_used)
		holder.hud_used.infodisplay += background
		holder.hud_used.infodisplay += health
		holder.hud_used.infodisplay += foreground
		if(holder.client)
			holder.client.screen += background
			holder.client.screen += health
			holder.client.screen += foreground
	else
		RegisterSignal(holder, COMSIG_MOB_HUD_CREATED, .proc/on_hud_created)

	RegisterSignal(holder, COMSIG_MOB_HEALTH_CHANGED, .proc/on_health_update)

/datum/component/health_meter/Destroy(force, silent)
	var/mob/living/holder = parent
	if(holder.hud_used)
		holder.hud_used.infodisplay -= background
		holder.hud_used.infodisplay -= health
		holder.hud_used.infodisplay -= foreground
		if(holder.client)
			holder.client.screen -= background
			holder.client.screen -= health
			holder.client.screen -= foreground
	QDEL_NULL(background)
	QDEL_NULL(health)
	QDEL_NULL(foreground)
	.=..()

/datum/component/health_meter/proc/on_hud_created(mob/living/source)
	source.hud_used.infodisplay += background
	source.hud_used.infodisplay += health
	source.hud_used.infodisplay += foreground
	if(source.client)
		source.client.screen += background
		source.client.screen += health
		source.client.screen += foreground
	UnregisterSignal(source, COMSIG_MOB_HUD_CREATED)

/datum/component/health_meter/proc/on_health_update(mob/living/source)
	SIGNAL_HANDLER
	//WHY THE FUCK I HAVE TO USE THIS INSTEAD OF SINGLE VAR!? NANAKO!!!!!!!!!!!!!!!!!
	var/list/data = source.get_health_report()
	var/mob_max_health = data["max"]
	var/mob_health = round(mob_max_health - data["damage"])
	animate(health.filters[1], x = clamp(HEALTHBAR_PIXEL_WIDTH*(mob_health/mob_max_health), 0, HEALTHBAR_PIXEL_WIDTH), time = 0.5 SECONDS)
	foreground.maptext = MAPTEXT("[max(0, mob_health)]/[mob_max_health]")

//Screen objects
/atom/movable/screen/health_meter
	icon = 'icons/hud/healthbar.dmi'
	icon_state = "backdrop"
	screen_loc = "TOP,CENTER-2:-8"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/atom/movable/screen/health_meter/background
	icon_state = "backdrop"

/atom/movable/screen/health_meter/health
	icon_state  = "health_grayscale"
	color = COLOR_CULT_RED

/atom/movable/screen/health_meter/foreground
	icon_state = "graphic"
	maptext_x = 73
	maptext_y = 8
	maptext_width = HEALTHBAR_PIXEL_WIDTH

#undef HEALTHBAR_PIXEL_WIDTH
#undef HEALTHBAR_PIXEL_HEIGHT