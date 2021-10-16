/obj/screen/intent/diona_nymph
	icon = 'icons/mob/gestalt.dmi'
	icon_state = "intent_devour"
	screen_loc = DIONA_SCREEN_LOC_INTENT

/obj/screen/intent/diona_nymph/update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		icon_state = "intent_expel"
	else
		icon_state = "intent_devour"

/obj/screen/diona
	icon = 'icons/mob/gestalt.dmi'

/obj/screen/diona/hat
	name = "equipped hat"
	screen_loc = DIONA_SCREEN_LOC_HAT
	icon_state = "hat"

/obj/screen/diona/hat/Click()
	var/mob/living/carbon/alien/diona/chirp = usr
	if(istype(chirp) && chirp.hat)
		chirp.unEquip(chirp.hat)

/obj/screen/diona/held
	name = "held item"
	screen_loc =  DIONA_SCREEN_LOC_HELD
	icon_state = "held"

/obj/screen/diona/held/Click()
	var/mob/living/carbon/alien/diona/chirp = usr
	if(istype(chirp) && chirp.holding_item) chirp.unEquip(chirp.holding_item)

/datum/hud/diona_nymph
	var/obj/screen/diona/hat/hat
	var/obj/screen/diona/held/held

/datum/hud/diona_nymph/New(mob/owner)
	..()

	hat = new
	toggleable_inventory += hat

	held = new
	toggleable_inventory += held

	action_intent = new /obj/screen/intent/diona_nymph(owner)
	static_inventory += action_intent

	//This is deprecated, see health_doll.dm
	//If these are ever re-activated a new version will be needed
	healths = new /obj/screen()
	healths.icon = 'icons/mob/gestalt.dmi'
	healths.icon_state = "health0"
	healths.SetName("health")
	healths.screen_loc = DIONA_SCREEN_LOC_HEALTH
	infodisplay += healths
