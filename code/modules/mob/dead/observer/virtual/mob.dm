/mob/dead/observer/virtual/mob
	host_type = /mob

/mob/dead/observer/virtual/mob/New(location, mob/host)
	.=..()
	RegisterSignal(host, list(COMSIG_MOB_SIGHT_SET, COMSIG_MOB_SEE_IN_DARK_SET, COMSIG_MOB_SEE_INVISIBLE_SET), .proc/sync_sight)
	sync_sight(host)

/mob/dead/observer/virtual/mob/proc/sync_sight(mob/mob_host)
	SIGNAL_HANDLER
	sight = mob_host.sight
	see_invisible = mob_host.see_invisible
	see_in_dark = mob_host.see_in_dark

