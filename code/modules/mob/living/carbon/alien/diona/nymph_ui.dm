/atom/movable/screen/intent/diona_nymph
	icon = 'icons/mob/gestalt.dmi'
	icon_state = "intent_devour"
	screen_loc = DIONA_SCREEN_LOC_INTENT

/atom/movable/screen/intent/diona_nymph/update_icon()
	if(intent == I_HURT || intent == I_GRAB)
		icon_state = "intent_expel"
	else
		icon_state = "intent_devour"

/atom/movable/screen/diona
	icon = 'icons/mob/gestalt.dmi'

/atom/movable/screen/diona/hat
	name = "equipped hat"
	screen_loc = DIONA_SCREEN_LOC_HAT
	icon_state = "hat"

/atom/movable/screen/diona/hat/Click()
	var/mob/living/carbon/alien/diona/chirp = usr
	if(istype(chirp) && chirp.hat)
		chirp.unEquip(chirp.hat)

/atom/movable/screen/diona/held
	name = "held item"
	screen_loc =  DIONA_SCREEN_LOC_HELD
	icon_state = "held"

/atom/movable/screen/diona/held/Click()
	var/mob/living/carbon/alien/diona/chirp = usr
	if(istype(chirp) && chirp.holding_item) chirp.unEquip(chirp.holding_item)

/datum/hud/diona_nymph
	var/atom/movable/screen/diona/hat/hat
	var/atom/movable/screen/diona/held/held

/datum/hud/diona_nymph/New(mob/owner)
	..()

	hat = new
	toggleable_inventory += hat

	held = new
	toggleable_inventory += held

	action_intent = new /atom/movable/screen/intent/diona_nymph(owner)
	static_inventory += action_intent

	//This is deprecated, see health_doll.dm
	//If these are ever re-activated a new version will be needed
	healths = new /atom/movable/screen()
	healths.icon = 'icons/mob/gestalt.dmi'
	healths.icon_state = "health0"
	healths.SetName("health")
	healths.screen_loc = DIONA_SCREEN_LOC_HEALTH
	infodisplay += healths
