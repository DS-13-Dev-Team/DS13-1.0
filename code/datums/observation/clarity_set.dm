
/*******************
* Density Handling *
*******************/
/atom/set_density(new_density)
	var/old_density = density
	. = ..()
	if(density != old_density && isturf(loc))
		//We may have just changed our turf's clear status, set it to maybe
		if (isturf(loc))
			var/turf/T = loc
			T.content_density_set(density)

/turf/set_density(new_density)
	. = ..()
	content_density_set(density)


/turf/ChangeTurf()
	var/old_density = density
	. = ..()
	if(density != old_density)
		content_density_set(density)




/turf/Entered(var/atom/A)
	.=..()
	if (A.density)
		if (clear)	//If clear was previously true, null it
			clear = null

		//If this turf was not already dense, maybe it is now. notify everyone of that possibility
		if (!density && A.density)
			content_density_set(A.density)


/turf/Exited(var/atom/A, atom/newloc)
	.=..()
	if (A.density)
		if (!clear)	//If clear was previously true, null it
			clear = null

		//If this turf was not naturally dense, maybe this object was the only thing blocking it, lets fire off an event
		if (!density && A.density)
			content_density_set(A.density)

//Called when:
	//A dense object enters or leaves this turf
	//Any object already on this turf changes its density
	//This turf changes its density
/turf/proc/content_density_set(var/newdensity)
	//Set clear to null if its possibly changed. Don't recalculate its exact value, thats done on demand
	if (!isnull(clear))
		if (clear != newdensity)
			clear = null

	SEND_SIGNAL(src, COMSIG_TURF_CLARITY_SET)