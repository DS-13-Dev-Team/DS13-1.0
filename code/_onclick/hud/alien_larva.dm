/mob/living/carbon/alien
	hud_type = /datum/hud/larva

/datum/hud/larva/New(mob/owner)
	..()

	move_intent = new /obj/screen/movement()
	move_intent.SetName("movement method")
	move_intent.set_dir(SOUTHWEST)
	move_intent.icon = 'icons/hud/screen1_alien.dmi'
	move_intent.icon_state = mymob.move_intent.hud_icon_state
	move_intent.screen_loc = ui_acti
	static_inventory += move_intent

	healths = new /obj/screen()
	healths.icon = 'icons/hud/screen1_alien.dmi'
	healths.icon_state = "health0"
	healths.SetName("health")
	healths.screen_loc = ui_alien_health
	infodisplay += healths

	fire = new /obj/screen()
	fire.icon = 'icons/hud/screen1_alien.dmi'
	fire.icon_state = "fire0"
	fire.SetName("fire")
	fire.screen_loc = ui_fire
	infodisplay += fire
