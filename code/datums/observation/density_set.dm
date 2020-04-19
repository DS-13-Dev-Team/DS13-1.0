//	Observer Pattern Implementation: Density Set
//		Registration type: /atom
//
//		Raised when: An /atom changes density using the set_density() proc.
//
//		Arguments that the called proc should expect:
//			/atom/density_changer: The instance that changed density.
//			/old_density: The density before the change.
//			/new_density: The density after the change.

GLOBAL_DATUM_INIT(density_set_event, /decl/observ/density_set, new)

/decl/observ/density_set
	name = "Density Set"
	expected_type = /atom

/*******************
* Density Handling *
*******************/
/atom/set_density(new_density)
	var/old_density = density
	. = ..()
	if(density != old_density)
		GLOB.density_set_event.raise_event(src, old_density, density)
		//We may have just changed our turf's clear status, set it to maybe
		if (isturf(loc))
			var/turf/T = loc
			GLOB.density_set_event.raise_event(T, old_density, density)	//Fire the event on the turf too
			T.clear = null

/turf/ChangeTurf()
	var/old_density = opacity
	. = ..()
	if(density != old_density)
		GLOB.density_set_event.raise_event(src, old_density, density)
		clear = null




/turf/Entered(var/atom/A)
	.=..()
	if (A.density)
		if (clear)	//If clear was previously true, null it
			clear = null

		//If this turf was not already dense, maybe it is now. notify everyone of that possibility
		if (!density)
			GLOB.density_set_event.raise_event(src, density, density)
