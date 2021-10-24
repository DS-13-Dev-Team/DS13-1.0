/mob/living/carbon/slime
	hud_type = /datum/hud/slime

/datum/hud/slime/New(mob/owner)
	..()

	action_intent = new /obj/screen/intent(owner)
	static_inventory += action_intent


/mob/living/simple_animal/construct
	hud_type = /datum/hud/construct

/datum/hud/construct/New(mob/owner)
	..()

	var/constructtype

	if(istype(mymob,/mob/living/simple_animal/construct/armoured) || istype(mymob,/mob/living/simple_animal/construct/behemoth))
		constructtype = "juggernaut"
	else if(istype(mymob,/mob/living/simple_animal/construct/builder))
		constructtype = "artificer"
	else if(istype(mymob,/mob/living/simple_animal/construct/wraith))
		constructtype = "wraith"
	else if(istype(mymob,/mob/living/simple_animal/construct/harvester))
		constructtype = "harvester"

	if(constructtype)
		fire = new /obj/screen()
		fire.icon = 'icons/hud/screen1_construct.dmi'
		fire.icon_state = "fire0"
		fire.SetName("fire")
		fire.screen_loc = ui_construct_fire
		infodisplay += fire

		healths = new /obj/screen()
		healths.icon = 'icons/hud/screen1_construct.dmi'
		healths.icon_state = "[constructtype]_health0"
		healths.SetName("health")
		healths.screen_loc = ui_construct_health
		infodisplay += healths

		pullin = new /obj/screen()
		pullin.icon = 'icons/hud/screen1_construct.dmi'
		pullin.icon_state = "pull0"
		pullin.SetName("pull")
		pullin.screen_loc = ui_construct_pull
		static_inventory += pullin

		zone_sel = new /obj/screen/zone_sel()
		zone_sel.icon = 'icons/hud/screen1_construct.dmi'
		zone_sel.overlays.len = 0
		zone_sel.overlays += image('icons/hud/zone_sel.dmi', "[zone_sel.selecting]")
		static_inventory += zone_sel

		purged = new /obj/screen()
		purged.icon = 'icons/hud/screen1_construct.dmi'
		purged.icon_state = "purge0"
		purged.SetName("purged")
		purged.screen_loc = ui_construct_purge
		static_inventory += purged
