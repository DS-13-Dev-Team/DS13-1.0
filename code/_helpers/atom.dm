
/atom/proc/make_indestructible()
	//If it is already, we do nothing
	if (atom_flags & ATOM_FLAG_INDESTRUCTIBLE)
		return

	atom_flags |= ATOM_FLAG_INDESTRUCTIBLE

/atom/proc/remove_indestructible()
	atom_flags -= ATOM_FLAG_INDESTRUCTIBLE


/turf/make_indestructible()
	.=..()
	for (var/atom/A in contents)
		if (isairlock(A) || iswindow(A))
			A.make_indestructible()