GLOBAL_VAR_CONST(HIGHEST_CONNECTABLE_ZLEVEL_INDEX, 0)

/proc/HasAbove(z)
	return FALSE
/proc/HasBelow(z)
	return FALSE
// These give either the turf or null.
/proc/GetAbove(turf/T)
	return null
/proc/GetBelow(turf/T)
	return null