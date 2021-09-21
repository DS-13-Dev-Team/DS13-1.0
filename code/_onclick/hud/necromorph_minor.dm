/*
	Hud used for small non humanoid necromorphs. Divider component, swarmer, maybe others
	Things that come in one piece and are much simpler codewise
*/

/mob/living/simple_animal/necromorph
	hud_type = /datum/hud/necromorph_minor

/datum/hud/necromorph_minor/New(mob/owner)
	..()

	var/list/hud_elements = list()

	fire = new /obj/screen()
	fire.icon = ui_style
	fire.icon_state = "fire0"
	fire.SetName("fire")
	fire.screen_loc = ui_fire
	hud_elements |= fire

	pain = mymob.overlay_fullscreen("pain", /obj/screen/fullscreen/pain, INFINITY)//new /obj/screen/fullscreen/pain( null )

	if (istype(pain))
		hud_elements |= pain


	hud_elements |= new /obj/screen/meter/health(mymob.client)

	zone_sel = new /obj/screen/zone_sel( null )
	zone_sel.icon = ui_style
	zone_sel.color = ui_color
	zone_sel.alpha = ui_alpha
	zone_sel.overlays.Cut()
	zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[zone_sel.selecting]")
	hud_elements |= zone_sel

	pullin = new /obj/screen()
	pullin.icon = ui_style
	pullin.icon_state = "pull0"
	pullin.SetName("pull")
	pullin.screen_loc = ui_pull_resist
	src.hotkeybuttons += pullin
	hud_elements |= pullin


	mymob.client.screen = list()
	mymob.client.add_to_screen(hud_elements)