



/datum/movement_handler
	var/expected_host_type = /atom/movable
	var/atom/movable/host

/datum/movement_handler/New(var/atom/movable/host)
	if(!istype(host, expected_host_type))
		CRASH("Invalid host type. Expected [expected_host_type], was [host ? host.type : "*null*"]")
	src.host = host

/datum/movement_handler/proc/remove()
	if (host)
		host.RemoveMovementHandlerDatum(src)

/datum/movement_handler/Destroy()
	host = null
	. = ..()

/datum/movement_handler/proc/DoMove(var/direction, var/mob/mover, var/is_external)
	return

// Asks the handlers if the mob may move, ignoring destination, if attempting a DoMove()
/datum/movement_handler/proc/MayMove(var/mob/mover, var/is_external)
	return MOVEMENT_PROCEED