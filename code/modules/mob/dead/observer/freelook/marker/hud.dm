/datum/hud/marker
	var/atom/movable/screen/cameranet_static/cameranet_static

/datum/hud/marker/New(mob/dead/observer/signal/owner)
	cameranet_static = new(null, owner)
	..()

/datum/hud/marker/show_hud(version, mob/viewmob)
	if(!..())
		return FALSE
	var/mob/screenmob = viewmob || mymob
	var/view = screenmob.client.view || world.view
	cameranet_static.update_o(view)
	screenmob.client.screen += cameranet_static
