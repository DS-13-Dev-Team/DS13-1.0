/*******
* /mob *
*******/
/datum/movement_handler/mob
	expected_host_type = /mob
	var/mob/mob

/datum/movement_handler/mob/New(host)
	..()
	src.mob = host

/datum/movement_handler/mob/Destroy()
	mob = null
	. = ..()