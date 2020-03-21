/datum/species/necromorph/slasher/spitter
	total_health = 55
	biomass = 50
	mass = 45


	inherent_verbs = list(/atom/movable/proc/spitter_snapshot, /atom/movable/proc/spitter_longshot, /mob/proc/shout)
	modifier_verbs = list(KEY_MIDDLE = list(/atom/movable/proc/spitter_snapshot),
	KEY_ALT = list(/atom/movable/proc/spitter_longshot))



/atom/movable/proc/spitter_snapshot