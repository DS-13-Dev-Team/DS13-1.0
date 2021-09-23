/*
	Hud used for small non humanoid necromorphs. Divider component, swarmer, maybe others
	Things that come in one piece and are much simpler codewise
*/

/mob/living/simple_animal/necromorph
	hud_type = /datum/hud/necromorph_minor

/datum/hud/necromorph_minor/New(mob/owner)
	..()

	fire = new /obj/screen()
	fire.icon = ui_style
	fire.icon_state = "fire0"
	fire.SetName("fire")
	fire.screen_loc = ui_fire
	infodisplay += fire

	hud_healthbar = new /obj/screen/meter/health(owner)
	hud_healthbar.L = owner
	infodisplay += hud_healthbar

	remaining_meter = new /obj/screen/meter_component/current(hud_healthbar)
	remaining_meter.color = hud_healthbar.remaining_color
	remaining_meter.screen_loc = hud_healthbar.screen_loc
	infodisplay += remaining_meter

	delta_meter = new /obj/screen/meter_component/delta(hud_healthbar)
	delta_meter.color = hud_healthbar.delta_color
	delta_meter.screen_loc = hud_healthbar.screen_loc
	infodisplay += delta_meter

	limit_meter = new /obj/screen/meter_component/limit(hud_healthbar)
	limit_meter.screen_loc = hud_healthbar.screen_loc
	infodisplay += limit_meter

	textholder = new /obj/screen/meter_component/text(hud_healthbar)
	textholder.screen_loc = hud_healthbar.screen_loc
	infodisplay += textholder

	hud_healthbar.remaining_meter = remaining_meter
	hud_healthbar.delta_meter = delta_meter
	hud_healthbar.limit_meter = limit_meter
	hud_healthbar.textholder = textholder

	hud_healthbar.update(TRUE)

	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.icon = ui_style
	zone_sel.color = ui_color
	zone_sel.alpha = ui_alpha
	zone_sel.overlays.Cut()
	zone_sel.overlays += image('icons/hud/zone_sel.dmi', "[zone_sel.selecting]")
	infodisplay += zone_sel

	pullin = new /obj/screen()
	pullin.icon = ui_style
	pullin.icon_state = "pull0"
	pullin.SetName("pull")
	pullin.screen_loc = ui_pull_resist
	src.hotkeybuttons += pullin
	static_inventory += pullin
