/mob/living/carbon/alien
	hud_type = /datum/hud/larva

/datum/hud/larva/FinalizeInstantiation()

	src.adding = list()
	src.other = list()

	var/obj/screen/using

	using = new /obj/screen/movement()
	using.SetName("movement method")
	using.set_dir(SOUTHWEST)
	using.icon = 'icons/mob/screen1_alien.dmi'
	using.icon_state = mymob.move_intent.hud_icon_state
	using.screen_loc = ui_acti
	src.adding += using
	move_intent = using

	healths = new /obj/screen()
	healths.icon = 'icons/mob/screen1_alien.dmi'
	healths.icon_state = "health0"
	healths.SetName("health")
	healths.screen_loc = ui_alien_health

	fire = new /obj/screen()
	fire.icon = 'icons/mob/screen1_alien.dmi'
	fire.icon_state = "fire0"
	fire.SetName("fire")
	fire.screen_loc = ui_fire

	mymob.client.screen = list()
	mymob.client.screen += list( healths, fire)
	mymob.client.screen += src.adding + src.other
